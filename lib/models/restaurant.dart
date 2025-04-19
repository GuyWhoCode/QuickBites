class Restaurant {
  final String name;
  final String address;
  final int addedAt;
  final String photoID;

  Restaurant({
    required this.name,
    required this.address,
    required this.addedAt,
    required this.photoID,
  });

  static Restaurant? fromMap(Map<String, dynamic> restaurant) {
    try {
      return Restaurant(
        name: restaurant["name"],
        address: restaurant["address"],
        addedAt: restaurant["addedAt"] ?? 0,
        photoID: restaurant["photoID"] ?? "",
      );
    } catch (e) {
      return null;
    }
  }
}
