import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/restaurant.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    try {
      _currentUser = User(
        id: 'user_123',
        name: 'John Doe',
        favoriteRestaurants: [] as Restaurant,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout method
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
