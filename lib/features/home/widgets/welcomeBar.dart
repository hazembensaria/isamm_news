import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/models/user.dart';
import 'package:isamm_news/features/authentication/providers/userProvider.dart';


class WelcomeBar extends ConsumerStatefulWidget {
  const WelcomeBar({super.key});

  @override
  ConsumerState<WelcomeBar> createState() => _WelcomeBarState();
}

class _WelcomeBarState extends ConsumerState<WelcomeBar> {
  @override
  Widget build(BuildContext context) {
  CurrentUser user = ref.watch(userProvider)! ;

    return Row(
      children: [
         Expanded(
            child: Text(
              textAlign: TextAlign.center ,
          user.name,
          style: const TextStyle(fontFamily: "playfair" , fontSize: 20 , fontWeight: FontWeight.w600 , color: Colors.black),
        )),
        TextButton(
          style: TextButton.styleFrom(side: BorderSide(color: Colors.grey[400]!) , shape:const CircleBorder()),
          onPressed: () {},
          child: const Padding(
            padding:  EdgeInsets.all(5.0),
            child:  Icon(Icons.notification_important_outlined ,color: Colors.black,),
          ),
        ),
      ],
    );
  }
}
