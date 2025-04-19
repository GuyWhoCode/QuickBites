import 'package:quickbites/models/restaurant.dart';

class MainUser {
  final String id;
  final String name;
  List<Restaurant> favoriteRestaurants;
  int restaurantReminderDuration;

  MainUser({
    required this.id,
    required this.name,
    required this.restaurantReminderDuration,
    List<Restaurant>? favoriteRestaurants,
  }) : favoriteRestaurants = favoriteRestaurants ?? [];

  void addFavoriteRestaurant(Restaurant restaurant) {
    favoriteRestaurants.add(restaurant);
  }
}
