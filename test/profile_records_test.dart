import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrms_ys/app/data/models/current_user.dart';
import 'package:hrms_ys/app/data/network/api_client.dart';
import 'package:hrms_ys/app/data/network/api_endpoints.dart';
import 'package:hrms_ys/app/modules/profile/controllers/education_controller.dart';
import 'package:hrms_ys/app/modules/profile/controllers/profile_records_save.dart';
import 'package:hrms_ys/app/modules/profile/controllers/project_details_controller.dart';
import 'package:hrms_ys/app/modules/profile/controllers/work_experience_controller.dart';
import 'package:hrms_ys/app/modules/profile/data/repositories/education_repository.dart';
import 'package:hrms_ys/app/modules/profile/data/repositories/project_details_repository.dart';
import 'package:hrms_ys/app/modules/profile/data/repositories/work_experience_repository.dart';

class _ProfileApiAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool rejectCreate = true;
  late String rejectedField;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    await requestStream?.drain<void>();
    final rejected = options.method == 'POST' && rejectCreate;
    return ResponseBody.fromString(
      jsonEncode(
        rejected
            ? {
                'errors': {
                  rejectedField: ['Choose another value.'],
                },
              }
            : {'success': true},
      ),
      rejected ? 422 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _EducationController extends EducationDetailsController {
  _EducationController(ApiClient api, this.onRefresh)
    : super(repository: EducationRepository(apiClient: api));

  final Future<void> Function() onRefresh;

  @override
  Future<void> refreshCurrentUser() => onRefresh();
}

class _WorkController extends WorkExperienceController {
  _WorkController(ApiClient api, this.onRefresh)
    : super(repository: WorkExperienceRepository(apiClient: api));

  final Future<void> Function() onRefresh;

  @override
  Future<void> refreshCurrentUser() => onRefresh();
}

class _ProjectController extends ProjectDetailsController {
  _ProjectController(ApiClient api, this.onRefresh)
    : super(repository: ProjectDetailsRepository(apiClient: api));

  final Future<void> Function() onRefresh;

  @override
  Future<void> refreshCurrentUser() => onRefresh();
}

typedef _Form = ({
  ProfileRecordsSave controller,
  VoidCallback enableEdit,
  VoidCallback addRow,
  Future<void> Function() save,
  List<TextEditingController> Function(int index) fields,
  void Function(CurrentUser user) setUser,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void verifyForm({
    required String name,
    required String collection,
    required List<String> keys,
    required List<String> values,
    required String addEndpoint,
    required String editEndpoint,
    required _Form Function(ApiClient api, Future<void> Function() refresh)
    create,
  }) {
    test(
      '$name validates dates, adds, edits and retries partial saves',
      () async {
        final adapter = _ProfileApiAdapter()..rejectedField = keys.first;
        final dio = Dio()..httpClientAdapter = adapter;
        addTearDown(dio.close);
        var refreshCount = 0;
        var failRefresh = true;
        final form = create(ApiClient.withDio(dio), () async {
          refreshCount++;
          if (failRefresh) throw StateError('Mock refresh failure');
        });
        addTearDown(form.controller.onClose);

        form.setUser(
          CurrentUser.fromJson({
            'data': [
              {'userid': 42},
            ],
          }),
        );
        form.enableEdit();
        form.addRow();
        void fill(int index, String name) {
          final fields = form.fields(index);
          for (final (position, value) in values.indexed) {
            fields[position].text = position == 0 ? name : value;
          }
          fields[values.length].text = '01 Jan 2024';
          fields[values.length + 1].text = '01 Feb 2024';
        }

        fill(0, values.first);
        form.setUser(
          CurrentUser.fromJson({
            'data': [
              {'userid': 42},
            ],
            collection: [
              {
                'id': 9,
                for (final (index, key) in keys.indexed) key: values[index],
                'start_date': '2024-01-01',
                'end_date': '2024-02-01',
              },
            ],
          }),
        );

        form.fields(0).last.text = '31 Feb 2024';
        await form.save();
        expect(adapter.requests, isEmpty);
        expect(
          form.controller.recordFieldError(form.fields(0).first, 'end_date'),
          'Choose a valid end date.',
        );
        form.fields(0).last.text = '01 Jan 2023';
        await form.save();
        expect(adapter.requests, isEmpty);
        expect(
          form.controller.recordFieldError(form.fields(0).first, 'end_date'),
          'End date must be on or after the start date.',
        );

        fill(0, 'Edited record');
        form.addRow();
        fill(1, 'New record');
        await form.save();

        expect(adapter.requests.map((request) => request.method), [
          'PUT',
          'POST',
        ]);
        expect(adapter.requests.map((request) => request.path), [
          editEndpoint,
          addEndpoint,
        ]);
        final edited = jsonDecode(adapter.requests.first.data as String) as Map;
        expect(edited['id'], 9);
        expect(edited['userid'], '42');
        expect(edited['start_date'], '2024-01-01');
        expect(edited[keys.first], 'Edited record');
        expect(
          form.controller.recordFieldError(form.fields(1).first, keys.first),
          'Choose another value.',
        );
        expect(
          form.controller.recordSaveMessage,
          contains('Earlier changes were saved.'),
        );
        expect(form.fields(1).first.text, 'New record');
        expect(form.controller.recordIsLocked(form.fields(0).first), isTrue);

        adapter.rejectCreate = false;
        await form.save();
        expect(adapter.requests.map((request) => request.method), [
          'PUT',
          'POST',
          'POST',
        ]);
        final added = jsonDecode(adapter.requests.last.data as String) as Map;
        expect(added.containsKey('id'), isFalse);
        expect(added[keys.first], 'New record');
        expect(
          form.controller.recordSaveMessage,
          contains('list could not refresh'),
        );
        expect(refreshCount, 1);

        failRefresh = false;
        await form.save();
        expect(adapter.requests, hasLength(3));
        expect(refreshCount, 2);
        expect(form.controller.recordSaveSucceeded, isTrue);
      },
    );
  }

  verifyForm(
    name: 'Education',
    collection: 'education',
    keys: ['course_name', 'university_name', 'grade'],
    values: ['Computer Science', 'Example University', 'A'],
    addEndpoint: APIEndpoints.addEducation,
    editEndpoint: APIEndpoints.editEducation,
    create: (api, refresh) {
      final controller = _EducationController(api, refresh);
      return (
        controller: controller,
        enableEdit: controller.enableEdit,
        addRow: controller.newEducation,
        save: controller.saveEducation,
        setUser: (user) => controller.currentUser = user,
        fields: (i) => [
          controller.courseControllers[i],
          controller.universityControllers[i],
          controller.gradeControllers[i],
          controller.startDateControllers[i],
          controller.endDateControllers[i],
        ],
      );
    },
  );

  verifyForm(
    name: 'Work Experience',
    collection: 'workExperience',
    keys: ['compony_name', 'designation', 'exp'],
    values: ['Example Company', 'Developer', '2 years'],
    addEndpoint: APIEndpoints.addWork,
    editEndpoint: APIEndpoints.editWork,
    create: (api, refresh) {
      final controller = _WorkController(api, refresh);
      return (
        controller: controller,
        enableEdit: controller.enableEdit,
        addRow: controller.newWorkExperience,
        save: controller.saveWorkExperience,
        setUser: (user) => controller.currentUser = user,
        fields: (i) => [
          controller.companyControllers[i],
          controller.designationControllers[i],
          controller.expControllers[i],
          controller.startDateControllers[i],
          controller.endDateControllers[i],
        ],
      );
    },
  );

  verifyForm(
    name: 'Projects',
    collection: 'projects',
    keys: ['title', 'description'],
    values: ['Example project', 'Example description'],
    addEndpoint: APIEndpoints.addProject,
    editEndpoint: APIEndpoints.editProject,
    create: (api, refresh) {
      final controller = _ProjectController(api, refresh);
      return (
        controller: controller,
        enableEdit: controller.enableEdit,
        addRow: controller.newProject,
        save: controller.saveProjects,
        setUser: (user) => controller.currentUser = user,
        fields: (i) => [
          controller.titleControllers[i],
          controller.descriptionControllers[i],
          controller.startDateControllers[i],
          controller.endDateControllers[i],
        ],
      );
    },
  );
}
