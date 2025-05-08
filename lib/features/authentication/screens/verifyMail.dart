import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/screens/interests.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';

class VerifyMailScreen extends ConsumerWidget {
  const VerifyMailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logos/check.png",
                    width: 150,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    "Please Verify your Email!",
                    style: TextStyle(
                        fontFamily: "playfair",
                        fontSize: 35,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    "Start exploring, discovering, and engaging with the news.",
                    style: TextStyle(fontFamily: "urbanist", letterSpacing: 1),
                  )
                ],
              ),
            ),
            ProviderButton(
                  load: false,

                function: ()async {
                  bool isVerified = await ref.read(authServiceProvider).isEmailVerified();
                  if (!isVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('please verify your email first')));
                  } else {
                    print("trueee");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const InterstsScreen()));
                  }
                },
                title: "One More Step",
                textColor: Colors.white,
                bgColor: Color(0xFF1A998E),
                borderWidth: 0),
            ProviderButton(
                  load: false,

                function: () {
                  ref.read(authServiceProvider).signOut(context);
                },
                title: "Logout",
                textColor: Colors.white,
                bgColor: Color(0xFF1A998E),
                borderWidth: 0)
          ],
        ),
      ),
    );
  }
}
