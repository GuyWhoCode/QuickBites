import 'dart:math';
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
  final List<String> reminderPhases = [
    "Don't forget to visit us again soon!",
    "Remember to come back for another memorable meal.",
    "Just a reminder that your table will be waiting for your return.",
    "We hope you'll remember to stop by again soon.",
    "Don't miss out on something new to try on your next visit.",
    "Remember us for your next celebration.",
    "Just a friendly reminder that the chef is planning your next culinary adventure.",
    "Don't forget to return for a new flavor experience.",
    "Remember we're keeping your favorite table warm for next time.",
    "Be sure to return for the flavors you loved and new ones to discover.",
    "Remember our doors are always open for your return.",
    "Don't forget your culinary journey with us is just beginning.",
    "Remember that every visit tells a new delicious story.",
    "Just a reminder that we'll be cooking up something special for your return.",
    "Don't forget to make us your regular spot for extraordinary dining.",
    "Remember to explore another corner of our menu next time.",
    "Just a reminder that we're saving room for your return.",
    "Don't forget that the second visit is even better than the first.",
    "Remember to become part of our regular family of food lovers.",
    "Just a reminder that your next meal with us awaits.",
    "Don't forget our team looks forward to welcoming you back.",
    "Remember to return for the taste you can't stop thinking about.",
    "Don't forget your culinary home away from home awaits your return.",
    "Remember to join us again to create more memorable moments.",
    "Just a reminder that we're just getting started on your flavor journey.",
    "Don't forget your taste buds will thank you for coming back.",
    "Remember to return soon to experience our seasonal specialties.",
    "Just a reminder that you're always welcome at our table.",
    "Don't forget to bring friends to share the experience next time.",
    "Remember we miss you already - come back soon!",
    "Just a reminder that the perfect meal deserves a perfect sequel.",
    "Don't forget your second visit is on its way to becoming a tradition.",
    "Remember our chef can't wait to cook for you again.",
    "Just a reminder to return for the comfort of familiar flavors.",
    "Don't forget your next dining experience is just a reservation away.",
    "Remember we're saving your favorite dish for your return.",
    "Just a reminder to come back to try what you missed the first time.",
    "Don't forget to return soon and become a regular.",
    "Remember your culinary adventure continues with your next visit.",
    "Just a reminder that we're cooking up new reasons for you to return.",
    "Don't forget that good taste deserves a second serving.",
    "Remember to make us your new favorite dining destination.",
    "Just a reminder that your return would make our day.",
    "Don't forget to join us again for food that feels like coming home.",
    "Remember to return to explore more of our menu's hidden gems.",
    "Just a reminder that we've been hoping you'd come back for more.",
    "Don't forget your next memorable meal is waiting to happen.",
    "Remember: same great taste, new great experiences on your return.",
    "Just a reminder to come back soon - we're keeping your spot warm.",
    "Don't forget your journey through our menu has just begun.",
  ];
  final Random _random = Random();

  String getRandomReminderMessage() {
    return reminderPhases[_random.nextInt(reminderPhases.length)];
  }

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
            subtitle: Text(getRandomReminderMessage()),
          ),
        );
      },
    );
  }
}
