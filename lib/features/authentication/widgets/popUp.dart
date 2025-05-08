import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  const PopUp({
    super.key,
    required this.description,
    required this.image,
    required this.title,
  });
  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFF1A998E),
                fontFamily: "urbanist",
                fontSize: 30,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          const CircularProgressIndicator(
            color: Color(0xFF1A998E),
          ),
        ],
      ),
      // content: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     CircularProgressIndicator(),
      //     SizedBox(width: 16.0),
      //     Text('Logging in...'),
      //   ],
      // ),
    );
  }
}
