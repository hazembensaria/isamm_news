  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/providers/navigationMenuProvider.dart';

  class NavigationMenu extends ConsumerWidget {
    const NavigationMenu({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      var indes = ref.read(navigationMenuProvider.notifier);
      // var role = ref.watch(userProvider)!.role;
      return Scaffold(
        body: indes.setScreen(),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(color: Color(0xFF1A998E),);
              }
              return null;
              //  return TextStyle(color: Colors.grey); // Color for unselected lab
            }),
          ),
          child: NavigationBar(
            indicatorColor: Colors.white,
            height: 55,
            elevation: 0,
            selectedIndex: ref.watch(navigationMenuProvider),
            onDestinationSelected: (value) => {indes.setIndex(value)},
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(
                  Icons.home,
                  color: Color(0xFF1A998E),
                ),
                label: "home",
              ),
              NavigationDestination(
                icon: Icon(Icons.explore),
                selectedIcon: Icon(
                  Icons.explore,
                  color: Color(0xFF1A998E),
                ),
                label: "find isamm",
              ),
              // NavigationDestination(
              //   icon: Icon(Icons.bookmark),
              //   label: "favorite",
              //   selectedIcon: Icon(
              //     Icons.bookmark,
              //     color: Color(0xFF1A998E),
              //   ),
              // ),
              NavigationDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(
                    Icons.person,
                    color: Color(0xFF1A998E),
                  ),
                  label: "profile"),
              // if (role == "admin")
              //   const NavigationDestination(
              //       selectedIcon: Icon(
              //         Iconsax.setting_3,
              //         color: Color(0xFF1A998E),
              //       ),
              //       icon: Icon(Iconsax.setting),
              //       label: "admin")
            ],
          ),
        ),
      );
    }
  }