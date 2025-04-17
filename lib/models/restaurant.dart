class Restaurant {
  final String name;
  final String address;
  final double? distance;
  final double reminderDuration;

  Restaurant({
    required this.name,
    required this.address,
    this.distance,
    required this.reminderDuration,
  });
}
