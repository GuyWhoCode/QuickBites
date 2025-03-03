import 'package:flutter/material.dart';
import './pages/notification/page.dart';
import './pages/home/page.dart';
import './pages/account/page.dart';
import './pages/search/page.dart';

void main() => runApp(const App());

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
