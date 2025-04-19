class Restaurant {
  final String name;
  final String address;
  final double reminderDuration;
  final String photoID;

  Restaurant({
    required this.name,
    required this.address,
    required this.reminderDuration,
    required this.photoID,
  });

  static Future<Restaurant?> fromMap(restaurant) async {
    try {
      return Restaurant(
        name: restaurant["name"],
        address: restaurant["address"],
        reminderDuration: restaurant["reminderDuration"]?.toDouble() ?? 0.0,
        photoID: restaurant["photoID"] ?? "",
      );
    } catch (e) {
      return null;
    }
  }
}
