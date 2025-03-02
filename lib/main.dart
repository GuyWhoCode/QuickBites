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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
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
        indicatorColor: Colors.cyanAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.inbox_rounded)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
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
    );
  }
}
