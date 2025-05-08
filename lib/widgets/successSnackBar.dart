import 'package:flutter/material.dart';

SnackBar mySuccessSnackBar(String text) {

    return SnackBar(
      content:  Row(
        children: [
          const Icon(
            Icons.warning_rounded, // Use an appropriate icon
            color: Color(0xFF12d18e), // Icon color
          ),
         const SizedBox(width: 10), // Add some space between the icon and the text
          Expanded(
            child: Text(
              text,
              style:const TextStyle(color: Color(0xFF12d18e)),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFFecfbf6),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
    );
  
}