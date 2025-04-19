import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbites/models/restaurant.dart';
import 'package:quickbites/providers/auth_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Restaurant> getRestaurantsToRemind(
    List<Restaurant> restaurants,
    int reminderDuration,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return restaurants.where((restaurant) {
      final timeSinceAdded = now - restaurant.addedAt;
      print(
        'Restaurant: ${restaurant.name}, Time since added: $timeSinceAdded, Reminder duration: $reminderDuration',
      );
      return timeSinceAdded >= reminderDuration;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();
    final restaurants = authProvider.currentUser?.favoriteRestaurants ?? [];
    final reminderDuration =
        authProvider.currentUser?.restaurantReminderDuration ?? 604800000;

    final restaurantsToRemind = getRestaurantsToRemind(
      restaurants,
      reminderDuration,
    );

    if (restaurantsToRemind.isEmpty) {
      return const Center(child: Text('No restaurant reminders yet!'));
    }

    return ListView.builder(
      itemCount: restaurantsToRemind.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (BuildContext context, int index) {
        final restaurant = restaurantsToRemind[index];
        return Dismissible(
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Icon(Icons.delete), Icon(Icons.delete)],
            ),
          ),
          key: ValueKey<String>('${restaurant.name}-${restaurant.address}'),
          onDismissed: (DismissDirection direction) {
            setState(() {
              restaurantsToRemind.removeAt(index);
            });
            // Reset the restaurant's addedAt time when dismissed
            final updatedRestaurant = Restaurant(
              name: restaurant.name,
              address: restaurant.address,
              photoID: restaurant.photoID,
              addedAt: DateTime.now().millisecondsSinceEpoch,
            );
            authProvider.updateRestaurantTimestamp(updatedRestaurant);
          },
          child: ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text(restaurant.name),
            subtitle: Text('Time to revisit this restaurant!'),
          ),
        );
      },
    );
  }
}
