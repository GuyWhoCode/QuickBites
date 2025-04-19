import './restaurant.dart';

class MainUser {
  final String id;
  final String name;
  List<Restaurant> favoriteRestaurants = [];
  final int restaurantReminderDuration;

  MainUser({
    required this.id,
    required this.name,
    required this.restaurantReminderDuration,
    this.favoriteRestaurants = const [],
  });

  void addFavoriteRestaurant(Restaurant restaurant) {
    favoriteRestaurants.add(restaurant);
  }
}
