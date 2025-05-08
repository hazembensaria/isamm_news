import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isamm_news/NavigationMenu.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/screens/login.dart';
import 'package:isamm_news/features/authentication/screens/onBording.dart';
import 'package:isamm_news/features/authentication/screens/verifyMail.dart';
import 'package:isamm_news/firebase_options.dart';

void main() async {
   await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  // LocalNotificationService.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    bool isFirstTime() {
      return authService.isFirstTime();
    }

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: authService.authStateChanges(),
          builder: (ctx, snapshot) {
            // if (snapshot.hasData && ref.watch(userProvider)!.age == 0) {
            //     return const PersonalInfoScreen();
            //   }
            if (snapshot.hasData) {
              return const NavigationMenu();
            }
            if (ref.read(authServiceProvider).getCurrentUser() == null) {
              if (isFirstTime()) {
                return const OnBordingScreen();
              }
            } else {
              if (!ref
                  .read(authServiceProvider)
                  .getCurrentUser()!
                  .emailVerified) {
                return const VerifyMailScreen();
              }
            }
            return const LoginScreen();
          },
        ));
  }
}

