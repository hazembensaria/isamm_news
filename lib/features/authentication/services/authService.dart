import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isamm_news/features/authentication/repository/authRepository.dart';
import 'package:isamm_news/features/authentication/screens/login.dart';


class AuthService {
  final AuthRepository _authRepository;
  final GetStorage _box;

  AuthService({required AuthRepository authRepository})
      : _authRepository = authRepository,
        _box = GetStorage(); // Initialize GetStorage
//  _emailController.text,
//           _passwordController.text,
//           _nameController.text,
//           _ageController.text,
//           _professionController.text,
//           _phoneController.text,
//           _addressController.text,
  Future<void> createUser(String email, String password,name , int age , job , phone , address , context) async {
    await _authRepository.createUser(
        email, password, age, name , job , phone , address ,  context);

    // await sendEmailVerification();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (ctx) => const VerifyMailScreen()));
  }

  Future<void> signOut(context) async {
    await _authRepository.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  }

  updateUserPersonalInfo(Map<String , dynamic> data , context){
    _authRepository.updateUserPersonalInfo(data , context);
  }

  Stream<User?> authStateChanges() {
    return _authRepository.authStateChanges();
  }

  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  setOnboardingComplete() {
    _box.write('isFirstTime', false);

    print(_box.read('isFirstTime'));
  }

  setOnboarding() {
    _box.write('isFirstTime', true);

    print(_box.read('isFirstTime'));
  }

  bool isFirstTime() {
    return _box.read('isFirstTime') ?? true;
  }

  signIn(String email, String password, BuildContext context,
      WidgetRef ref) async {
    _authRepository.signInWithEmailAndPassword(email, password, context, ref);
  }

  Future<void> sendEmailVerification() async {
    await _authRepository.sendEmailVerification();
  }

  sendResetPasswordEmail(String email , context){
    _authRepository.sendResetPasswordEmail(email , context);
  }

  isEmailVerified() {
    return _authRepository.isEmailVerified();
  }

  Future<void> reloadUser() async {
    await _authRepository.reloadUser();
  }

  signInWithGoogle(ctx, WidgetRef ref) async {
    await _authRepository.signInWithGoogle(ctx , ref);
    print("======================= credentials");
   
  }

  saveSelectedItems(Set<String> selectedItems){
    _authRepository.saveSelectedItems( selectedItems) ;
  }
}

