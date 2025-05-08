import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/NavigationMenu.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/providers/userProvider.dart';
import 'package:isamm_news/features/authentication/screens/interests.dart';
import 'package:isamm_news/features/authentication/widgets/providerButton.dart';


class CustomizeIntersstsScreen extends ConsumerStatefulWidget {
  const CustomizeIntersstsScreen({super.key, required this.isFirstTime});
  final bool isFirstTime;

  @override
  ConsumerState<CustomizeIntersstsScreen> createState() =>
      _CustomizeIntersstsScreenState();
}

class _CustomizeIntersstsScreenState
    extends ConsumerState<CustomizeIntersstsScreen> {
  late Set<String> _selectedItems;

  List<GridItem> items = [
     // 🎓 Academic
  GridItem(icon: Icons.menu_book, title: 'Lectures'),
  GridItem(icon: Icons.assignment, title: 'Exams'),
  GridItem(icon: Icons.grade, title: 'Results'),
  GridItem(icon: Icons.schedule, title: 'Timetable'),
  GridItem(icon: Icons.card_giftcard, title: 'Scholarships'),
  GridItem(icon: Icons.work_outline, title: 'Internships'),
  GridItem(icon: Icons.science, title: 'Research'),
  GridItem(icon: Icons.build, title: 'Projects'),
  GridItem(icon: Icons.school, title: 'Graduation'),

  // 🏢 Administration
  GridItem(icon: Icons.campaign, title: 'Announcements'),
  GridItem(icon: Icons.policy, title: 'Rules & Policies'),
  GridItem(icon: Icons.attach_money, title: 'Fee Updates'),
  GridItem(icon: Icons.event_available, title: 'Holiday Notices'),
  GridItem(icon: Icons.how_to_reg, title: 'Admissions'),
  GridItem(icon: Icons.people_alt, title: 'Staff'),

  // 👥 Student Life
  GridItem(icon: Icons.group, title: 'Clubs'),
  GridItem(icon: Icons.event, title: 'Events'),
  GridItem(icon: Icons.emoji_events, title: 'Competitions'),
  GridItem(icon: Icons.hiking, title: 'Trips'),
  GridItem(icon: Icons.handyman, title: 'Workshops'),
  GridItem(icon: Icons.volunteer_activism, title: 'Volunteering'),
  GridItem(icon: Icons.star_outline, title: 'Freshers'),
  GridItem(icon: Icons.history_edu, title: 'Alumni'),

  // 📰 Campus News
  GridItem(icon: Icons.new_releases, title: 'Breaking News'),
  GridItem(icon: Icons.update, title: 'Updates'),
  GridItem(icon: Icons.mic, title: 'Interviews'),
  GridItem(icon: Icons.person_pin, title: 'Faculty News'),
  GridItem(icon: Icons.apartment, title: 'Infrastructure'),

  // ⚽ Sports
  GridItem(icon: Icons.sports_soccer, title: 'Matches'),
  GridItem(icon: Icons.emoji_events, title: 'Tournaments'),
  GridItem(icon: Icons.leaderboard, title: 'Results'),
  GridItem(icon: Icons.run_circle, title: 'Tryouts'),
  GridItem(icon: Icons.workspace_premium, title: 'Achievements'),

  // 💡 Tech & Innovation
  GridItem(icon: Icons.terminal, title: 'Hackathons'),
  GridItem(icon: Icons.devices_other, title: 'Tech Fests'),
  GridItem(icon: Icons.trending_up, title: 'Startups'),
  GridItem(icon: Icons.record_voice_over, title: 'Seminars'),

  // ❤️ Well-being
  GridItem(icon: Icons.psychology, title: 'Mental Health'),
  GridItem(icon: Icons.support_agent, title: 'Counseling'),
  GridItem(icon: Icons.local_hospital, title: 'Health Camp'),
  GridItem(icon: Icons.coronavirus, title: 'COVID-19 Updates'),

  // ✊ Social
  GridItem(icon: Icons.campaign_outlined, title: 'Protests'),
  GridItem(icon: Icons.lightbulb, title: 'Initiatives'),
  GridItem(icon: Icons.visibility, title: 'Awareness'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedItems = ref.watch(userProvider)!.interests.toSet();
  }

  bool load = false;
  _saveSelectedItems() async {
    setState(() {
      load = true;
    });
    await ref.read(authServiceProvider).saveSelectedItems(_selectedItems);
    ref.read(userProvider.notifier).setInterests(_selectedItems.toList());
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Customize Interests",
          style: TextStyle(
              fontFamily: "urbanist",
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row
                  crossAxisSpacing: 12.0, // Spacing between columns
                  mainAxisSpacing: 12.0, // Spacing between rows
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedItems.contains(items[index].title);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.remove(items[index].title);
                        } else {
                          _selectedItems.add(items[index].title);
                        }
                      });
                      // Handle item tap
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFF1A998E)
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(items[index].icon, size: 48.0),
                          const SizedBox(height: 8.0),
                          Text(
                            items[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: isSelected
                                  ? const Color(0xFF1A998E)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                widget.isFirstTime
                    ? Expanded(
                        child: ProviderButton(
                            load: false,
                            function: () {
                              _saveSelectedItems();
                              ref
                                  .read(userProvider.notifier)
                                  .saveUser(ref.watch(userProvider)!);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const NavigationMenu()));
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
                              _saveSelectedItems();
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
    );
  }
}
