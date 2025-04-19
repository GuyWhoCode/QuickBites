import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quickbites/models/restaurant.dart';
import '../models/user.dart';

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

      _currentUser = MainUser(
        id: userID,
        name: userName,
        restaurantReminderDuration: userData["restaurantReminderDuration"],
        favoriteRestaurants:
            (userData["savedRestaurants"] as List)
                .map((restaurant) => Restaurant.fromMap(restaurant))
                .whereType<Restaurant>()
                .toList(),
      );
      _currentUser = MainUser(
        id: userID,
        name: userName,
        restaurantReminderDuration: 604800000, // 7 days in milliseconds
      );
      notifyListeners();
      return true;
    } catch (e) {
      print("Error logging in: $e");
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
      print("Error creating account: $e");
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
