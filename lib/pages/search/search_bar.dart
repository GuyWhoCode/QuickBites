import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

restaurantAutoCompleteSearch(String queryValue, double latitude, double longitude) async {
  var headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': '',
  };
  var request = http.Request(
    'POST',
    Uri.parse('https://places.googleapis.com/v1/places:autocomplete'),
  );
  request.body = json.encode({
    "input": queryValue,
    "locationBias": {
      "circle": {
        "center": {"latitude": latitude, "longitude": longitude},
        "radius": 5000.0,
      },
    },
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String result = await response.stream.bytesToString();
    print(result);
    // Parse the JSON response
    var jsonResponse = json.decode(result);
    // Do something with the parsed data
    print(jsonResponse);

    // do something with the result
  } else {
    print(response.reasonPhrase);
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class RestaurantSearchBar extends StatefulWidget {
  const RestaurantSearchBar({super.key});

  @override
  State<RestaurantSearchBar> createState() => _RestaurantSearchBarState();
}

class _RestaurantSearchBarState extends State<RestaurantSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search_rounded),
      ),
      onSubmitted: (String value) async {
        determinePosition()
            .then((Position position) {
              restaurantAutoCompleteSearch(value, position.latitude, position.longitude);
              // print(position == null ? 'Unknown' : '${position.latitude}, ${position.longitude}');
            })
            .catchError((e) {
              print(e);
            });
        // Show a dialog with the input value and its length

        

        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thanks!'),
              content: Text(
                'You typed "$value", which has length ${value.characters.length}.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
