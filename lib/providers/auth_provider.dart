import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quickbites/models/restaurant.dart';
import 'package:quickbites/models/user.dart';

class AuthStateProvider with ChangeNotifier {
  MainUser? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  MainUser? get currentUser => _currentUser;

  Future<bool> login(String userName, String userID) async {
    try {
      var db = FirebaseFirestore.instance;
      var userDoc = await db.collection("userData").doc(userID).get();
      if (!userDoc.exists) {
        return false; // User does not exist
      }
      var userData = userDoc.data()!;

      // Convert restaurants synchronously
      List<Restaurant> restaurants = [];
      final savedRestaurants = userData["savedRestaurants"] as List?;
      if (savedRestaurants != null) {
        for (var restaurant in savedRestaurants) {
          try {
            final restaurantData = restaurant as Map<String, dynamic>;
            final convertedRestaurant = Restaurant.fromMap(restaurantData);
            if (convertedRestaurant != null) {
              restaurants.add(convertedRestaurant);
            }
          } catch (e) {
            print("Error converting restaurant data: $e");
          }
        }
      }

      _currentUser = MainUser(
        id: userID,
        name: userName,
        restaurantReminderDuration: userData["restaurantReminderDuration"],
        favoriteRestaurants: restaurants,
      );

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createAccount(String userName, String userID) async {
    try {
      var db = FirebaseFirestore.instance;
      db.collection("userData").doc(userID).set({
        "email": userName,
        "savedRestaurants": [],
        "restaurantReminderDuration": 604800000, // 7 days in milliseconds
      });

      _currentUser = MainUser(
        id: userID,
        name: userName,
        restaurantReminderDuration: 604800000,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> addFavoriteRestaurant(Restaurant restaurant) async {
    if (_currentUser == null) return;
    _currentUser!.addFavoriteRestaurant(restaurant);
    notifyListeners();

    var db = FirebaseFirestore.instance;
    var userDoc = db.collection("userData").doc(_currentUser!.id);
    await userDoc.update({
      "savedRestaurants": FieldValue.arrayUnion([
        {
          "name": restaurant.name,
          "address": restaurant.address,
          "addedAt": restaurant.addedAt,
          "photoID": restaurant.photoID,
        },
      ]),
    });
  }

  Future<void> removeFavoriteRestaurant(Restaurant restaurant) async {
    if (_currentUser == null) return;
    _currentUser!.favoriteRestaurants.remove(restaurant);
    notifyListeners();

    var db = FirebaseFirestore.instance;
    var userDoc = db.collection("userData").doc(_currentUser!.id);
    await userDoc.update({
      "savedRestaurants": FieldValue.arrayRemove([
        {
          "name": restaurant.name,
          "address": restaurant.address,
          "addedAt": restaurant.addedAt,
          "photoID": restaurant.photoID,
        },
      ]),
    });
  }

  bool checkExistingRestaurant(Restaurant restaurant) {
    if (_currentUser == null) return false;
    return _currentUser!.favoriteRestaurants.any(
      (existingRestaurant) =>
          existingRestaurant.name == restaurant.name &&
          existingRestaurant.address == restaurant.address,
    );
  }

  Future<void> updateReminderDuration(int duration) async {
    if (_currentUser == null) return;

    _currentUser!.restaurantReminderDuration = duration;
    notifyListeners();

    var db = FirebaseFirestore.instance;
    var userDoc = db.collection("userData").doc(_currentUser!.id);
    await userDoc.update({"restaurantReminderDuration": duration});
  }

  Future<void> updateRestaurantTimestamp(Restaurant restaurant) async {
    if (_currentUser == null) return;

    final index = _currentUser!.favoriteRestaurants.indexWhere(
      (r) => r.name == restaurant.name && r.address == restaurant.address,
    );

    if (index != -1) {
      _currentUser!.favoriteRestaurants[index] = restaurant;
      notifyListeners();

      var db = FirebaseFirestore.instance;
      await db.collection("userData").doc(_currentUser!.id).update({
        "savedRestaurants":
            _currentUser!.favoriteRestaurants
                .map(
                  (r) => {
                    "name": r.name,
                    "address": r.address,
                    "addedAt": r.addedAt,
                    "photoID": r.photoID,
                  },
                )
                .toList(),
      });
    }
  }
}
