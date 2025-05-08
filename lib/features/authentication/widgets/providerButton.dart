import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProviderButton extends StatelessWidget {
  ProviderButton({
    super.key,
    required this.title,
    required this.textColor,
    required this.bgColor,
    required this.borderWidth,
    required this.function,
    this.image,
    this.bwidth,
    required this.load,
  });
  final String title;
  final String? image;
  final double? bwidth;
  final Color textColor;
  final Color bgColor;
  final double borderWidth;
  final bool load;
  Function function = () {};
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: bwidth,
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(
              color: const Color.fromARGB(255, 229, 229, 229),
              width: borderWidth),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded edges
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 15.0, horizontal: 20.0), // Padding
        ),
        onPressed: load ? null : () {
          function();
        },
        child: Row(
          // Center the content
          children: [
            if (image != null)
              Image.asset(
                image!,
                width: 25,
              ),
            // Space between icon and text
            Expanded(
              child: Center(
                child: load ? const CircularProgressIndicator() :  Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                      fontFamily: "urbanist",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
