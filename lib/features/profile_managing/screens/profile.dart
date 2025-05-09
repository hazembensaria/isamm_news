import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/userProvider.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';
import 'package:isamm_news/features/home/widgets/welcomeBar.dart';
import 'package:isamm_news/features/profile_managing/screens/addTags.dart';
import 'package:isamm_news/features/profile_managing/screens/settings.dart';
import 'package:isamm_news/features/profile_managing/widgets/profileMenuWidget.dart';
import 'package:isamm_news/features/write_article/screens/articleEditorScreen.dart';

import '../../authentication/models/user.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CurrentUser user = ref.watch(userProvider)!;
    print(user.toJson());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
          child: Column(
            children: [
              const WelcomeBar(),
              SizedBox(
                height: 10,
              ),
              Container(
                // color: Color(0xFF1A998E),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: const Color(0xFF48ada5),
                    borderRadius: BorderRadiusDirectional.circular(100)),
                child: Center(
                  child: Text(
                    user.name[0],
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "urbanist",
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user.name,
                style: const TextStyle(
                    // fontFamily: "urbanist",
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              // Text(user.phone),
              // Text(user.job),
              // Text(user.interests[0]),
              ProviderButton(
                  load: false,
                  function: () {},
                  title: "Edit Profile",
                  textColor: Colors.white,
                  bgColor: Color(0xFF1A998E),
                  bwidth: 200,
                  borderWidth: 0),
              SizedBox(
                height: 20,
              ),
              ProfileMenuWidget(
                title: 'settings',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (cnt) => const SettingsScreen()));
                },
                icon: Icons.settings,
              ),
             if(user.role == "admin") ProfileMenuWidget(
                title: 'add tags',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (cnt) => const AddTagsScreen()));
                },
                icon: Icons.settings,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: user.role == "user" ? ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            shadowColor: Color(0XFFbae0dd),
            backgroundColor: Color(0xFF1A998E),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20)),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 26,
        ),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (cnt) => ArticleEditorScreen()))
        },
      ) : null ,
    );
  }

  profileMenuWidget(
      {required String title,
      required Null Function() onPress,
      required icon}) {}
}
