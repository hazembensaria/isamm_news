import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';


class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final _emailController = TextEditingController();

  _sendResetPassword(){
      ref.read(authServiceProvider).sendResetPasswordEmail(_emailController.text.trim() , context);
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
                children: [
                  const Text(
                    "Reset your password 🔑",
                    style: TextStyle(
                        fontFamily: "playfair",
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Please enter your email and we will send an OTP code in the next step to reset your password.",
                    style: TextStyle(fontFamily: "urbanist", letterSpacing: 1),
                  ),
                  SizedBox(height: 30,),
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
                    const Spacer(),
                ProviderButton(
                  load: false,

                    function: () {
                   
                      _sendResetPassword() ;
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