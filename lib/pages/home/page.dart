import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbites/image_cache.dart';
import 'package:quickbites/main.dart';
import 'package:quickbites/pages/home/restaurant_info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('userData')
                  .doc(authProvider.currentUser!.id)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No restaurants added yet!'));
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Quick Bites",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "Favorite Restaurants",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  // ...existing code...
                  SizedBox(
                    height: 300,
                    child:
                        (data['savedRestaurants'] as List?)?.isEmpty ?? true
                            ? const Center(
                              child: Text('No restaurants added yet!'),
                            )
                            : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  (data['savedRestaurants'] as List?)?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final restaurant =
                                    (data['savedRestaurants'] as List)[index]
                                        as Map<String, dynamic>;
                                final photoID =
                                    restaurant['photoID'] as String? ?? '';

                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: FutureBuilder<File?>(
                                    future: RestaurantImageCache.getImage(
                                      photoID,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return RestaurantInfoCard(
                                        restaurantName:
                                            restaurant['name'] as String? ??
                                            'Unknown',
                                        address:
                                            restaurant['address'] as String? ??
                                            'No address',
                                        imageFile:
                                            snapshot
                                                .data, // Use the file path from the File object
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
