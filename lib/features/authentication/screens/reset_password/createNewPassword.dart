import 'package:flutter/material.dart';
import 'package:isamm_news/features/authentication/widgets/popUp.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';


class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return const PopUp(
              image: "assets/logos/newPassword.png",
              title: "Reset Password Successful!",
              description: "You will be directed to the homepage.",
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: SingleChildScrollView(
          
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create new password 🔒",
                    style: TextStyle(
                        fontFamily: "playfair",
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Create your new password. If you forget it, then you have to do forgot password.",
                    style: TextStyle(fontFamily: "urbanist", letterSpacing: 1),
                  ),
                  SizedBox(height: 30,),
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
                        hintText: 'New Password',

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
                    SizedBox(height: 12,),
                    const Text(
                      "Confirm New Password",
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
                    const Spacer(),
                ProviderButton(
                  load: false,
                    function: () {
                      showLoadingDialog(context);
                      (context: context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => const OtpVerificationScreen()));
                    },
                    title: "Continue",
                    textColor: Colors.white,
                    bgColor: Color(0xFF1A998E),
                    borderWidth: 0)
              ],
                        ),
            ),
        ),
      ),
    );
  }
}