import 'package:flutter/material.dart';

class Bording extends StatelessWidget {
  const Bording({
    required this.image,
    required this.title,
    required this.subTitle,
    super.key,
  });

  final String image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Image.asset(
            image,
            width: 300,
            height: 300,
          ),
          SizedBox(height: 15,),
          Text(
            title,
            style: const TextStyle(
                fontFamily: "playfair", fontWeight: FontWeight.w800 , fontSize: 30 , ),
          ),
          SizedBox(height: 15,),

          Text(subTitle , style: TextStyle(fontFamily: "urbanist" , height: 1.8 , fontSize : 15),)
        ],
      ),
    );
  }
}
