import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/screens/loginWithPassword.dart';
import 'package:isamm_news/features/authentication/screens/signUp.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
   

  void _logInWithGoogle() async {
  
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (BuildContext context) {
        return const Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
             
                Center(child: CircularProgressIndicator(color : Color(0xFF1A998E),)),
              
              ],
            ),
          ),
        );
      },
    );

    try {
      print("i entred the gooooooooooooooooooooooooooooogle function");
      await ref.read(authServiceProvider).signInWithGoogle(context, ref);
    } finally {
     
    }
  }
  @override
  Widget build(BuildContext context ) {
  
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/logos/logo.png",
                width: 150,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "isamm news",
                style: TextStyle(
                    fontFamily: "playfair",
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "welcome let's dive into your account!",
                style: TextStyle(fontFamily: "urbanist", fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              ProviderButton(
                  load: false,

                function: () {
                  _logInWithGoogle();
                },
                title: "continue with Google",
                image: "assets/logos/google.png",
                textColor: Colors.black,
                bgColor: Colors.white,
                borderWidth: 1.5,
              ),
              const SizedBox(
                height: 15,
              ),
              
             
              ProviderButton(
                  load: false,

                function: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const LoginWithPassword()));
                },
                title: "Sign in with password",
                textColor: Colors.white,
                bgColor: Color(0xFF1A998E),
                borderWidth: 0,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(fontFamily: "urbanist"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontFamily: "urbanist",
                        color: Color(0xFF1A998E),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
