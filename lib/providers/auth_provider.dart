import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthStateProvider with ChangeNotifier {
  MainUser? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  MainUser? get currentUser => _currentUser;

  Future<bool> login(String userName, String userID) async {
    try {
      _currentUser = MainUser(id: userID, name: userName);
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
}
