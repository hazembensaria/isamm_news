import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isamm_news/NavigationMenu.dart';
import 'package:isamm_news/features/authentication/models/user.dart';
import 'package:isamm_news/features/authentication/providers/userProvider.dart';
import 'package:isamm_news/features/authentication/screens/verifyMail.dart';
import 'package:isamm_news/features/profile_managing/screens/customizeInterests.dart';
import 'package:isamm_news/features/profile_managing/screens/personalInfo.dart';
import 'package:isamm_news/widgets/alertSnackBar.dart';
import 'package:isamm_news/widgets/successSnackBar.dart';


class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  createUser(String email, String password, int age, String name, String job,
      String phone, String address, context) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "name": name,
        'age': age,
        "role": "user",
        "email": email,
        "job": job,
        "phone": phone,
        "address": address,
        // Add more fields as needed
      });

      // return userCredential.user;
      await sendEmailVerification();
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const VerifyMailScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          myAlertSnackBar("email already used"),
        );
      } else if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('weak password , please change it!'),
          duration: Duration(seconds: 2),
        ));
      }

      // Handle Firebase-specific errors
    } catch (e) {
      // Handle other errors
      print('An error occurred while creating the user.');
    }
  }

  signInWithEmailAndPassword(
      String email, String password, context, WidgetRef ref) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      bool isVerified = await isEmailVerified();
      if (!isVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          // message: 'Your email address is not verified.',
        );
        // return 'The email address is not verified';
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("mail is not verified")));
      }

      final uid = credentials.user!.uid;
      final userDetails = await getUserDetails(uid);
      final userDetailsData = userDetails.data();

      if (userDetailsData == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("user not found")));
      }

      final currentUser = CurrentUser(
          name: userDetailsData["name"],
          age: userDetailsData["age"],
          role: userDetailsData["role"],
          email: userDetailsData['email'],
          phone: userDetailsData['phone'],
          job: userDetailsData['job'],
          address: userDetailsData['address'],
          interests: List<String>.from(userDetailsData['interests']));

      // Ensure the widget is still mounted before performing actions that depend on it

      await ref.read(userProvider.notifier).setCurrentUser(currentUser);
      await ref.read(userProvider.notifier).saveUser(currentUser);
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => const NavigationMenu()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        ScaffoldMessenger.of(context).showSnackBar(
          myAlertSnackBar("user not found"),
        );
      } else if (e.code == "email-not-verified") {
        ScaffoldMessenger.of(context).showSnackBar(
          myAlertSnackBar("email not verified"),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("an error accured!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  sendResetPasswordEmail(String email, context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context)
          .showSnackBar(mySuccessSnackBar("We Sent you an email!"));
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload(); // Reload the user to get updated info
      user = _firebaseAuth.currentUser;
      return user!.emailVerified;
    }
    return false;
  }

  Future<void> reloadUser() async {
    User? user = _firebaseAuth.currentUser;
    await user?.reload();
  }

  signInWithGoogle(ctx, WidgetRef ref) async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the Google Authentication Credential
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a Firebase credential from the Google credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign-in the user with the credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        return null;
      }

      // Check if this is a new user by checking if the document exists
      final userRef =
          _firestore.collection('users').doc(userCredential.user!.uid);
      final doc = await userRef.get();
          print("++++++++++++++++++++++++++++++++++++++++++++++++++");
          print(doc.data());
      ref.read(userProvider.notifier).setMailAndName(
            userCredential.user!.displayName!,
            userCredential.user!.email!,
          );
      // await ref.read(userProvider.notifier).saveUser(currentUser);
      // Navigator.pushReplacement(
      if (!doc.exists) {
        // If user document does not exist, create it with additional info
        await userRef.set({
          "name": userCredential.user!.displayName, // Add last name here
          "email": userCredential.user!.email,
        });

        Navigator.pushReplacement(ctx,
            MaterialPageRoute(builder: (ctx) => const PersonalInfoScreen(isFirstTime: true,)));
      } else {
        if (!doc.data()!.containsKey("age")) {
          print(" emptyyyyy age s");
          Navigator.pushReplacement(ctx,
              MaterialPageRoute(builder: (ctx) => const PersonalInfoScreen(isFirstTime: true,)));
        } else if (!doc.data()!.containsKey("interests")) {
          print(" emptyyyyy intersts !!");
          Navigator.pushReplacement(
              ctx,
              MaterialPageRoute(
                  builder: (ctx) => const CustomizeIntersstsScreen(isFirstTime: true,)));
        } else {
          final data = doc.data();
          ref.read(userProvider.notifier).setCurrentUser(CurrentUser(
              name: data!["name"],
              age: data["age"],
              role: data["role"],
              email: data["email"],
              address: data["address"],
              job: data["job"],
              phone: data["phone"],
              interests: List<String>.from(data["interests"])));
          Navigator.pushReplacement(
              ctx, MaterialPageRoute(builder: (ctx) => const NavigationMenu()));
        }
      }

      // Return the User object from Firebase Auth
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  getUserDetails(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> saveSelectedItems(Set<String> selectedItems) async {
    try {
      // Convert Set to List
      List<String> selectedItemsList = selectedItems.toList();
      final uid = getCurrentUser()!.uid;
      await _firestore.collection('users').doc(uid).update({
        'interests': selectedItemsList,
      });
    } catch (e) {
      print('Error saving selected items: $e');
    }
  }

  Future<void> updateUserPersonalInfo(
      Map<String, dynamic> data, context) async {
    // Reference to the user's document in Firestore
    final uid = getCurrentUser()!.uid;

    DocumentReference userRef = _firestore.collection('users').doc(uid);

    // Data to be updated in the document
    // Map<String, dynamic> data = {
    //   'phone': phone,
    //   'age': age,
    //   'job': job,
    //   'address': address,
    // };

    try {
      // Update the document with the new fields
      await userRef.update(data);
      print('User information updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
          mySuccessSnackBar('User information updated successfully.'));
    } catch (e) {
      print('Error updating user information: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(myAlertSnackBar("Error updating user information"));
    }
  }
}
