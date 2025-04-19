import 'package:flutter/material.dart';
import 'package:quickbites/pages/home/restaurant_info_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 0.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "Quick Bites",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Favorite Restaurants",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
              ],
            ),
          ),
          const SizedBox(height: 100.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Nearby Restaurants",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
                RestaurantInfoCard(
                  restaurantName: "Jersey Mike's Subs",
                  distance: 4.9,
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
