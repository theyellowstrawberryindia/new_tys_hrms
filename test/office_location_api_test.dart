import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrms_ys/app/data/network/api_client.dart';
import 'package:hrms_ys/app/data/network/api_endpoints.dart';
import 'package:hrms_ys/app/modules/home/data/models/office_location.dart';
import 'package:hrms_ys/app/modules/home/data/repositories/home_repository.dart';

class _ConnectedApiClient extends ApiClient {
  _ConnectedApiClient(super.dio) : super.withDio();

  @override
  Future<bool> isConnected() async => true;
}

void main() {
  const office = {'id': 1, 'latitude': 19.0667374, 'longitude': 73.0082586};

  test('GET /get-office supplies the office coordinates', () async {
    final dio = Dio();
    addTearDown(dio.close);
    final requests = <RequestOptions>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'status_code': 200,
                'data': [office],
              },
            ),
          );
        },
      ),
    );

    final location = await HomeRepository(
      apiClient: _ConnectedApiClient(dio),
    ).getOffice();

    expect(requests.single.method, 'GET');
    expect(requests.single.path, APIEndpoints.getOffice);
    expect(requests.single.uri.path, '/api/v1/get-office');
    expect(location.latitude, office['latitude']);
    expect(location.longitude, office['longitude']);
  });

  test('accepts coordinates serialized as numeric strings', () {
    final location = OfficeLocation.fromResponse({
      'success': true,
      'data': [
        {'latitude': '19.0667374', 'longitude': '73.0082586'},
      ],
    });
    expect(location.latitude, 19.0667374);
    expect(location.longitude, 73.0082586);
  });

  test('rejects missing, failed, and invalid office responses', () {
    for (final response in [
      {
        'success': false,
        'data': [office],
      },
      {'success': true, 'data': []},
      {
        'success': true,
        'data': [
          <String, Object?>{'longitude': 73},
        ],
      },
      {
        'success': true,
        'data': [
          {'latitude': 91, 'longitude': 73},
        ],
      },
      {
        'success': true,
        'data': [
          {'latitude': 19, 'longitude': 'NaN'},
        ],
      },
    ]) {
      expect(
        () => OfficeLocation.fromResponse(response),
        throwsFormatException,
      );
    }
  });
}
