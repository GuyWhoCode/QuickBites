import './restaurant.dart';

class User {
  final String id;
  final String name;
  Restaurant favoriteRestaurants = [] as Restaurant;

  User({
    required this.id,
    required this.name,
    required this.favoriteRestaurants,
  });
}
