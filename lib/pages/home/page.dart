import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbites/image_cache.dart';
import 'package:quickbites/main.dart';
import 'package:quickbites/pages/home/restaurant_info_card.dart';
import 'package:quickbites/providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();

    if (authProvider.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 0.0),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Quick Bites",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Favorite Restaurants",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child:
                    authProvider.currentUser?.favoriteRestaurants.isEmpty ??
                            true
                        ? const Center(child: Text('No restaurants added yet!'))
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              authProvider
                                  .currentUser
                                  ?.favoriteRestaurants
                                  .length ??
                              0,
                          itemBuilder: (context, index) {
                            final restaurant =
                                authProvider
                                    .currentUser!
                                    .favoriteRestaurants[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: FutureBuilder<File?>(
                                future: RestaurantImageCache.getImage(
                                  restaurant.photoID,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return RestaurantInfoCard(
                                    restaurantName: restaurant.name,
                                    address: restaurant.address,
                                    imageFile: snapshot.data,
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
