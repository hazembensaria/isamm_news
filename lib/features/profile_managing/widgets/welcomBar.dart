import 'package:flutter/material.dart';

class WelcomeBar extends StatelessWidget {
  const WelcomeBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Space between main elements
      children: [
        Image.asset(
          'assets/logos/logo.png', // Replace with your logo image asset
          width: 40, // Adjust the size as needed
          height: 40,
        ),
        const SizedBox(width: 10),
        const Text(
          'Profile',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "urbanist"),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Add share functionality here
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Add settings functionality here
              },
            ),
          ],
        ),
      ],
    );
  }
}
