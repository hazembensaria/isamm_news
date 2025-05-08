import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/providers/userProvider.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';
import 'package:isamm_news/features/profile_managing/screens/customizeInterests.dart';


class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key, required this.isFirstTime});
  final bool isFirstTime;

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.watch(userProvider)!;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    _addressController.text = user.address;
    _ageController.text = user.age.toString();
    _professionController.text = user.job;
  }

  _updatePersonalInfo() {
    // Data to be updated in the document
    Map<String, dynamic> data = {
      'phone': _phoneController.text,
      'age': int.parse(_ageController.text),
      'job': _professionController.text,
      'address': _addressController.text,
    };
    ref.read(authServiceProvider).updateUserPersonalInfo(data, context);
    ref.read(userProvider.notifier).setPersonalInfo(
        data['age'], data["phone"], data["job"], data["address"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle the form submission
      print('Name: ${_nameController.text}');
      print('Birthday: ${_ageController.text}');
      print('Profession: ${_professionController.text}');
      print('Phone: ${_phoneController.text}');
      print('Address: ${_addressController.text}');
      print('Email: ${_emailController.text}');
      print('Tel: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Info",
          style: TextStyle(
              fontFamily: "urbanist",
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.0),

              // Email field
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
                enabled: false,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
              ),

              SizedBox(height: 16.0),

              //a row of birthday and phone number
              Row(
                children: [
                  // Phone field
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phone",
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
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Icon(Icons.phone),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
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
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Birthday field with date picker
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Age",
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
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Restrict input to digits
                            LengthLimitingTextInputFormatter(
                                3), // Limit to 3 digits for age
                          ],
                          decoration: InputDecoration(
                            labelText: 'Age',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Icon(Icons.cake),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),
              const Text(
                "Profession",
                style: TextStyle(
                    fontFamily: "urbanist",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1),
              ),
              const SizedBox(
                height: 10,
              ),
              // Profession field
              TextFormField(
                controller: _professionController,
                decoration: InputDecoration(
                  labelText: 'Profession',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.work),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              const Text(
                "Address",
                style: TextStyle(
                    fontFamily: "urbanist",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1),
              ),
              const SizedBox(
                height: 10,
              ),
              // Address field
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.home),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),

              Row(
                children: [
                  widget.isFirstTime
                      ? Expanded(
                          child: ProviderButton(
                              load: false,
                              function: () {
                                _updatePersonalInfo();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const CustomizeIntersstsScreen(
                                              isFirstTime: true,
                                            )));
                              },
                              title: "Next",
                              textColor: Colors.white,
                              bgColor: Color(0xFF1A998E),
                              borderWidth: 0),
                        )
                      : Expanded(
                          child: ProviderButton(
                              load: false,
                              function: () {
                                _updatePersonalInfo();
                              },
                              title: "Update",
                              textColor: Colors.white,
                              bgColor: Color(0xFF1A998E),
                              borderWidth: 0),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
