import 'package:flutter/material.dart';

class TrendBar extends StatelessWidget {
  const TrendBar({super.key, required this.title , required this.screen});
  final String title ;
  final Widget screen ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:const TextStyle(
              fontFamily: 'urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1),
        ),
        InkWell(
          onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => screen ,
                    ),
                  );
          },
          child: const Row(
            children: [
               Text(
              "View All",
              style: TextStyle(
                color:  Color(0xFF1A998E),
                  fontFamily: 'urbanist',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded , color:  Color(0xFF1A998E) ,)
            ],
          ),
        )
      ],
    );
  }
}
