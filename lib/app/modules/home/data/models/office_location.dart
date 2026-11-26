class OfficeLocation {
  const OfficeLocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  factory OfficeLocation.fromResponse(Object? response) {
    if (response is! Map || response['success'] != true) {
      throw const FormatException('Office location request was unsuccessful');
    }
    final offices = response['data'];
    if (offices is! List || offices.isEmpty || offices.first is! Map) {
      throw const FormatException('Office location is missing');
    }

    final office = offices.first as Map;
    return OfficeLocation(
      latitude: _coordinate(office['latitude'], 90),
      longitude: _coordinate(office['longitude'], 180),
    );
  }

  static double _coordinate(Object? value, double limit) {
    final number = switch (value) {
      num number => number.toDouble(),
      String text => double.tryParse(text),
      _ => null,
    };
    if (number == null || !number.isFinite || number.abs() > limit) {
      throw const FormatException('Invalid office coordinates');
    }
    return number;
  }
}
