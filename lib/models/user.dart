import './restaurant.dart';

class MainUser {
  final String id;
  final String name;
  List<Restaurant> favoriteRestaurants = [];

  MainUser({required this.id, required this.name});

  void addFavoriteRestaurant(Restaurant restaurant) {
    favoriteRestaurants.add(restaurant);
  }
}
