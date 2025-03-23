import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: const Center(
          child: Card(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Image(
                  image: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Jersey_Mike's_logo.svg/1200px-Jersey_Mike's_logo.svg.png",
                  ),
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.contain,
                ),
                Text("Jersey Mike's Subs"),
                Text("4.9 miles away"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
