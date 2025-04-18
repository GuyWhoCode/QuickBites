// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/notification/page.dart';
import './pages/home/page.dart';
import './pages/account/page.dart';
import './pages/search/page.dart';
import './pages/login/page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthStateProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();

    // You can perform authentication check on startup in the AuthProvider itself
    return authProvider.isLoggedIn ? const NavBar() : const AuthPage();
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: ''),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.inbox_rounded)),
            label: '',
          ),
          NavigationDestination(icon: Icon(Icons.person_2_outlined), label: ''),
        ],
      ),
      body:
          <Widget>[
            HomePage(),
            SearchPage(),
            NotificationPage(),
            authProvider.isLoggedIn ? AccountPage() : const AuthPage(),
            // AccountPage(),
          ][currentPageIndex],
    );
  }
}

// var db = FirebaseFirestore.instance;
          // // Create a new user with a first and last name
          // final user = <String, dynamic>{
          //   "first": "Ada",
          //   "last": "Lovelace",
          //   "born": 1815,
          // };

          // // Add a new document with a generated ID
          // db
          //     .collection("users")
          //     .add(user)
          //     .then(
          //       (DocumentReference doc) =>
          //           print('DocumentSnapshot added with ID: ${doc.id}'),
          //     );
