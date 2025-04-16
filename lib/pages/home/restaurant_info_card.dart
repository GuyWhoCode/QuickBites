import 'package:flutter/material.dart';

class RestaurantInfoCard extends StatelessWidget {
  final String restaurantName;
  final double distance;
  final String imageUrl;
  RestaurantInfoCard({
    super.key,
    required this.restaurantName,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: Column(
        children: <Widget>[
          Image(
            image: NetworkImage(imageUrl),
            height: 200.0,
            width: 200.0,
            fit: BoxFit.contain,
          ),
          Text(restaurantName),
          Text("$distance miles away"),
        ],
      ),
    );
  }
}
