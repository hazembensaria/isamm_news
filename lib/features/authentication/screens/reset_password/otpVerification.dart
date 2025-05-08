import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isamm_news/NavigationMenu.dart';
import 'package:isamm_news/features/authentication/screens/reset_password/createNewPassword.dart';
import 'package:isamm_news/features/authentication/widgets/timer.dart';


class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.otpId});
  final String otpId;
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  @override
  void initState() {
    super.initState();
    _focusNodes.asMap().forEach((index, focusNode) {
      focusNode.addListener(() {});
    });

    // Set up listeners for each text field to auto-focus the next one
    _controllers.asMap().forEach((index, controller) {
      controller.addListener(() {
        if (controller.text.length == 1) {
          _onTextChanged(index);
        }
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  final _phoneController = TextEditingController();
  void _showSuccessSnackBar() async {
    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: widget.otpId, smsCode: _phoneController.text);
      await FirebaseAuth.instance.signInWithCredential(cred);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()));
    } catch (e) {
      print(e);
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('You have entered all OTP digits.'),
    //     duration: Duration(seconds: 2),
    //     behavior: SnackBarBehavior.floating, // Allows custom positioning
    //     margin: EdgeInsets.fromLTRB( 
    //         20, 50, 20, 0), // Margin to position the SnackBar
    //     padding: EdgeInsets.symmetric(
    //         horizontal: 16, vertical: 10), // Padding inside the SnackBar
    //   ),
    // );

    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const CreateNewPassword()));
  }

  void _onTextChanged(int index) {
    if (index < _controllers.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      setState(() {
        index += 1;
      });
    } else if (_controllers
        .every((controller) => controller.text.length == 1)) {
      _showSuccessSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "OTP code verification 🔐",
                style: TextStyle(
                    fontFamily: "playfair",
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "We have sent an OTP code to your email and********ley@yourdomain.com. Enter the OTP code below to verify.",
                style: TextStyle(fontFamily: "urbanist", letterSpacing: 1),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _focusNodes[index].hasFocus
                            ? Color(0xFFedf7f6)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            // fillColor: _focusNodes[index].hasFocus ? const Color.fromARGB(255, 14, 97, 165) : Colors.grey[200],
                            counterText: '', // Hide the counter text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 33, 243, 110),
                                  width: 6),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 1) {
                              _onTextChanged(index);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 14.0),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              Text(
                "Didn't receive email?",
                textAlign: TextAlign.center,
              ),
              const TimerElement(),
            ],
          ),
        ),
      ),
    );
  }
}
