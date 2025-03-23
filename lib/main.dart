import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './pages/notification/page.dart';
import './pages/home/page.dart';
import './pages/account/page.dart';
import './pages/search/page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const NavBar(),
    );
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
    // final ThemeData theme = Theme.of(context);
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
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: const Badge(child: Icon(Icons.inbox_rounded)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_2_outlined),
            label: 'Account',
          ),
        ],
      ),
      body:
          <Widget>[
            HomePage(),
            SearchPage(),
            NotificationPage(),
            AccountPage(),
          ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var db = FirebaseFirestore.instance;
          // Create a new user with a first and last name
          final user = <String, dynamic>{
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815,
          };

          // Add a new document with a generated ID
          db
              .collection("users")
              .add(user)
              .then(
                (DocumentReference doc) =>
                    print('DocumentSnapshot added with ID: ${doc.id}'),
              );

          print("Hello world");
        },
        child: const Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
