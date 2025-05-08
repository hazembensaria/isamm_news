import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:isamm_news/features/home/screens/allArticles.dart';
import 'package:isamm_news/features/home/widgets/mainNews.dart';
import 'package:isamm_news/features/home/widgets/recentList.dart';

import '../widgets/shipsList.dart';
import '../widgets/trendBar.dart';
import '../widgets/trendsList.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void setUpNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic("news");
  }

  @override
  void initState() {
    super.initState();
    setUpNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              // foregroundColor: Colors.black,
              expandedHeight: 250.0, // Adjust as needed
              pinned: false,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                // title:WelcomeBar(),
                background: MainNews(),
              ),
              // Optionally, you can add a `bottom` property if needed
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const TrendBar(
                            title: "Trending",
                            screen: AllArticlesScreen(),
                          ),
                          const TrendList(),
                          const TrendBar(
                            screen: AllArticlesScreen(),
                            title: "Recent Stories",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const ShipsList(),
                          const SizedBox(
                            height: 10,
                          ),
                          RecentList(callpage: "home",),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text('Pinned Header',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
