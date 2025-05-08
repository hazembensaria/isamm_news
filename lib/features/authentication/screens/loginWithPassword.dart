import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/screens/reset_password/resetPassword.dart';
import 'package:isamm_news/features/authentication/screens/signUp.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';


// ignore: must_be_immutable
class LoginWithPassword extends ConsumerStatefulWidget {
  const LoginWithPassword({super.key});

  @override
  ConsumerState<LoginWithPassword> createState() => _LoginWithPasswordState();
}

class _LoginWithPasswordState extends ConsumerState<LoginWithPassword> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
   _login() async {
    if (_formKey.currentState?.validate() ?? false) {
       ref.read(authServiceProvider).signIn(
          _emailController.text, _passwordController.text, context, ref);
         
    }
  }

  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome back 👋",
                      style: TextStyle(
                          fontFamily: "playfair",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "please enter your email and password to signe in",
                      style: TextStyle(
                          fontFamily: "urbanist", color: Color(0xFF707070)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontFamily: "urbanist",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email,
                            color: Colors.grey), // Icon before the placeholder
                        filled: true,
                        fillColor: Colors.grey[200], // Grey background
                        hintText: 'Email',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ), // No border
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0), // Padding
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      cursorColor: const Color(0xFF1A998E),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontFamily: "urbanist",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ), // Icon before the placeholder
                        filled: true,
                        fillColor: const Color.fromRGBO(
                            238, 238, 238, 1), // Grey background
                        hintText: 'password',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ), // No border
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0), // Padding
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      cursorColor: const Color(0xFF1A998E),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: const Color(0xFF1A998E),
                              side: const BorderSide(
                                  color: Color(0xFF1A998E), width: 2),
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "urbanist"),
                            ),
                          ],
                        ),
                        // Clickable text with InkWell
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const ResetPassword()));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF1A998E),
                              fontFamily: "urbanist",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(),
                    const SizedBox(
                      height: 10,
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
                            "Signe up",
                            style: TextStyle(
                              fontFamily: "urbanist",
                              color: Color(0xFF1A998E),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ProviderButton(
                  load: false,

                  function: () {
                    _login();
                  },
                  title: "Sign in",
                  textColor: Colors.white,
                  bgColor: const Color(0xFF1A998E),
                  borderWidth: 0),
             
            ],
          ),
        ),
      ),
    );
  }
}
