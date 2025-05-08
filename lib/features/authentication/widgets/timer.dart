import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';

class TimerElement extends StatefulWidget {
  const TimerElement({super.key});

  @override
  State<TimerElement> createState() => _TimerElementState();
}

class _TimerElementState extends State<TimerElement> {
  int _start = 55;
  Timer? _timer;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _showResendButton = false;
      _start = 55;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _showResendButton = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_showResendButton
        ? RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "urbanist",
                  letterSpacing: 1,
                  color: Colors.black),
              children: [
                TextSpan(text: "You can resend code in "),
                TextSpan(
                  text: "$_start ",
                  style: TextStyle(
                    color: Color(0xFF1A998E),
                  ), // Change the color of the number here
                ),
                TextSpan(text: "s"),
              ],
            ),
          )
        : Padding(
          padding: const EdgeInsets.fromLTRB(0,30,0,0),
          child: ProviderButton(
                  load: false,

              function: () {startTimer();},
              title: "Resend",
              textColor: Colors.white,
              bgColor: Color(0xFF1A998E),
              borderWidth: 0),
        );
  }
}
