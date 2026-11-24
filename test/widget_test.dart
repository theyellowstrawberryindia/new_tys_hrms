import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get_storage/get_storage.dart';
import 'package:hrms_ys/app/core/configs/app_configs.dart';
import 'package:hrms_ys/app/core/utils/app_storage.dart';
import 'package:hrms_ys/app/data/models/current_user.dart';
import 'package:hrms_ys/app/data/network/api_client.dart';
import 'package:hrms_ys/app/data/network/api_endpoints.dart';
import 'package:hrms_ys/app/data/network/header_interceptor.dart';
import 'package:hrms_ys/app/modules/auth/controllers/auth_controller.dart';
import 'package:hrms_ys/app/modules/auth/views/auth_screen.dart';
import 'package:hrms_ys/app/modules/profile/controllers/education_controller.dart';
import 'package:hrms_ys/app/modules/profile/controllers/profile_controller.dart';
import 'package:hrms_ys/app/modules/profile/data/repositories/profile_repository.dart';
import 'package:hrms_ys/app/modules/profile/views/bank_screen.dart';
import 'package:hrms_ys/app/modules/profile/views/education_screen.dart';
import 'package:hrms_ys/app/modules/splash/views/splash_screen.dart';

import 'support/montserrat_fixture.dart';

class _TestAuthController extends AuthController {
  @override
  Future<void> loadAppVersion() async {}

  @override
  void onReady() {}
}

class _TestProfileController extends ProfileController {
  _TestProfileController(ProfileRepository repository)
    : super(repository: repository);

  @override
  Future<void> loadAppVersion() async {}
}

class _BankApiAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  int status = 200;
  Map<String, Object?> response = {'success': true};
  DioExceptionType? error;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (error case final type?) {
      throw DioException(requestOptions: options, type: type);
    }
    await requestStream?.drain<void>();
    return ResponseBody.fromString(
      jsonEncode(response),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory storageDirectory;

  setUpAll(() async {
    storageDirectory = await Directory.systemTemp.createTemp('hrms_test_');
    final storageFile = File(
      '${storageDirectory.path}/${AppConfig.appStorageName}.gs',
    );
    await storageFile.writeAsString('{}');
    messenger.setMockMethodCallHandler(
      pathProvider,
      (_) async => storageDirectory.path,
    );
    await GetStorage(
      AppConfig.appStorageName,
      storageDirectory.path,
    ).initStorage;

    await mockMontserrat(messenger);
  });

  tearDownAll(() async {
    Get.reset();
    messenger.setMockMethodCallHandler(pathProvider, null);
    clearMockMontserrat(messenger);
    await storageDirectory.delete(recursive: true);
  });

  testWidgets('signed-out startup opens the login screen', (tester) async {
    Get.put<AuthController>(_TestAuthController());

    await tester.pumpWidget(const GetMaterialApp(home: SplashScreen()));
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    final login = find.text('Login');
    await tester.ensureVisible(login);
    await tester.tap(login);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your Username/Work Email'), findsOneWidget);
    expect(find.text('Please enter your Password'), findsOneWidget);
  });

  test('login rejects invalid email and passwords under eight characters', () {
    final controller = AuthController();
    addTearDown(controller.onClose);

    expect(controller.validateEmail('invalid-email'), isNotNull);
    expect(controller.validateEmail(' employee@example.com '), isNull);
    expect(controller.validatePassword('1234567'), isNotNull);
    expect(controller.validatePassword(' 1234567 '), isNotNull);
    expect(controller.validatePassword('12345678'), isNull);
  });

  testWidgets('Bank validates, adds, edits, and preserves failed changes', (
    tester,
  ) async {
    final adapter = _BankApiAdapter();
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(HeaderInterceptor());
    addTearDown(dio.close);
    final controller = Get.put<ProfileController>(
      _TestProfileController(
        ProfileRepository(apiClient: ApiClient.withDio(dio)),
      ),
    );
    controller.currentUser = CurrentUser.fromJson({
      'data': [
        {'userid': 42},
      ],
    });
    await tester.pumpWidget(const GetMaterialApp(home: BankScreen()));
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter the account holder name.'), findsOneWidget);
    expect(adapter.requests, isEmpty);

    controller.accountHolderController.text = 'Example Employee';
    controller.bankNameController.text = 'Example Bank';
    controller.accountNumberController.text = '00ABC';
    controller.ifscController.text = 'wrong';
    controller.branchController.text = 'Main';
    controller.panController.text = 'wrong';
    controller.aadharController.text = '123';
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      controller.bankFieldErrors.keys,
      containsAll(['account_no', 'ifsc_code', 'pan_card', 'aadhar_card']),
    );
    expect(adapter.requests, isEmpty);

    controller.accountNumberController.text = '001234567890';
    controller.ifscController.text = 'abcd0123456';
    controller.panController.text = 'abcde1234f';
    controller.aadharController.clear();
    adapter.response = {
      'success': true,
      'data': {'id': 9},
    };
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();

    final request = adapter.requests.single;
    expect(request.path, APIEndpoints.editBank);
    expect(request.method, 'POST');
    expect(request.contentType, contains('multipart/form-data; boundary='));
    final fields = Map.fromEntries((request.data as FormData).fields);
    expect(fields['_method'], 'PUT');
    expect(fields['userid'], '42');
    expect(fields['account_no'], '001234567890');
    expect(fields['ifsc_code'], 'ABCD0123456');
    expect(fields['pan_card'], 'ABCDE1234F');
    expect(controller.currentUser!.bankDetails.single.id, 9);
    expect(AppStorage.instance.getUserData().bankDetails.single.id, 9);
    expect(find.text('Bank details saved.'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    controller.branchController.text = 'Updated Branch';
    adapter.status = 422;
    adapter.response = {
      'errors': {
        'branch_name': ['Choose a registered branch.'],
      },
    };
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();
    expect(find.text('Choose a registered branch.'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(controller.currentUser!.bankDetails.single.branchName, 'Main');
    expect(controller.branchController.text, 'Updated Branch');

    adapter.error = DioExceptionType.connectionError;
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();
    expect(find.textContaining('Couldn’t connect'), findsOneWidget);
    expect(controller.isSavingBank, isFalse);

    adapter.error = null;
    adapter.status = 200;
    adapter.response = {'success': false, 'message': 'Update was rejected.'};
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();
    expect(find.text('Update was rejected.'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    adapter.status = 500;
    adapter.response = {'message': 'Internal server details'};
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();
    expect(find.text('Couldn’t save bank details. Try again.'), findsOneWidget);
    expect(find.text('Internal server details'), findsNothing);

    adapter.status = 200;
    adapter.response = {'success': true};
    await tester.runAsync(controller.updateBank);
    await tester.pumpAndSettle();
    final updated = controller.currentUser!.bankDetails.single;
    expect(updated.id, 9);
    expect(updated.branchName, 'Updated Branch');
    expect(
      AppStorage.instance.getUserData().bankDetails.single.branchName,
      'Updated Branch',
    );
    expect(find.text('Edit'), findsOneWidget);
  });

  test(
    'Bank API sends optional documents under their multipart field names',
    () async {
      final adapter = _BankApiAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      addTearDown(dio.close);
      final repository = ProfileRepository(apiClient: ApiClient.withDio(dio));
      final fixture = File('${storageDirectory.path}/test-document.jpg');
      await fixture.writeAsBytes([1, 2, 3]);

      await repository.updateBank(
        {'userid': '42'},
        panCardImageFile: fixture,
        aadharCardImageFile: fixture,
      );

      final form = adapter.requests.single.data as FormData;
      expect(form.files.map((entry) => entry.key), ['pan_img', 'aadhar_img']);
      expect(
        form.files.map((entry) => entry.value.filename),
        everyElement('test-document.jpg'),
      );
      expect(adapter.requests.single.extra['sensitive'], isTrue);
    },
  );

  testWidgets('Education opens an empty draft and shows inline validation', (
    tester,
  ) async {
    await tester.runAsync(
      () => AppStorage.instance.setUserData(
        CurrentUser.fromJson({
          'data': [
            {'userid': 42},
          ],
        }),
      ),
    );
    final controller = Get.put(EducationDetailsController());
    await tester.pumpWidget(
      const GetMaterialApp(home: EducationDetailsScreen()),
    );

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('New Education'), findsOneWidget);

    final save = find.text('Save Education');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Entry 1: Enter the course name.'), findsOneWidget);
    expect(find.text('Enter the course name.'), findsOneWidget);
    expect(find.text('Choose a valid start date.'), findsOneWidget);
    expect(controller.isSavingRecords, isFalse);
  });
}
