enum OfficeLocationStatus { inside, outside, uncertain }

OfficeLocationStatus assessOfficeLocation({
  required double distance,
  required double horizontalAccuracy,
  required double radius,
}) {
  if (!distance.isFinite ||
      distance < 0 ||
      !horizontalAccuracy.isFinite ||
      horizontalAccuracy <= 0 ||
      horizontalAccuracy > radius) {
    return OfficeLocationStatus.uncertain;
  }

  if (distance + horizontalAccuracy <= radius) {
    return OfficeLocationStatus.inside;
  }
  if (distance - horizontalAccuracy > radius) {
    return OfficeLocationStatus.outside;
  }

  return OfficeLocationStatus.uncertain;
}
