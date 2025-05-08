import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/profile_managing/screens/customizeInterests.dart';
import 'package:isamm_news/features/profile_managing/screens/personalInfo.dart';
import 'package:isamm_news/features/profile_managing/widgets/profileMenuWidget.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
              fontFamily: "urbanist",
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "General",
                    style: TextStyle(
                        color: Color(
                          0xFF9e9e9e,
                        ),
                        fontFamily: "urbanist"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Divider(
                    color: Color.fromARGB(255, 221, 221, 221),
                    thickness: 1,
                  )),
                ],
              ),
              ProfileMenuWidget(
                title: 'Customize Intersts',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (cnt) => const CustomizeIntersstsScreen(isFirstTime: false,)));
                },
                icon: Icons.favorite,
              ),
              ProfileMenuWidget(
                title: 'Personal Info',
                onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (cnt) => const PersonalInfoScreen(isFirstTime: false,)));
                },
                icon: Icons.person,
              ),
              ProfileMenuWidget(
                title: 'Notification',
                onPress: () {},
                icon: Icons.notifications,
              ),
              ProfileMenuWidget(
                title: 'Security',
                onPress: () {},
                icon: Icons.security,
              ),
              ProfileMenuWidget(
                title: 'Language',
                onPress: () {},
                icon: Icons.language,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "General",
                    style: TextStyle(
                        color: Color(
                          0xFF9e9e9e,
                        ),
                        fontFamily: "urbanist"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Divider(
                    color: Color.fromARGB(255, 221, 221, 221),
                    thickness: 1,
                  )),
                ],
              ),
              ProfileMenuWidget(
                title: 'Follow Us On Social Media',
                onPress: () {},
                icon: Icons.navigation,
              ),
              ProfileMenuWidget(
                title: 'Help Center',
                onPress: () {},
                icon: Icons.help,
              ),
              ProfileMenuWidget(
                title: 'Private Policy',
                onPress: () {},
                icon: Icons.privacy_tip,
              ),
              ProfileMenuWidget(
                title: 'About newsLine',
                onPress: () {},
                icon: Icons.info,
              ),
              ProfileMenuWidget(
                title: 'Log Out',
                onPress: () {
                  ref.read(authServiceProvider).signOut(context);
                },
                icon: Icons.logout_rounded,
                endIcon: false,
                textColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
