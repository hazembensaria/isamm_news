import 'package:flutter/material.dart';
import 'package:isamm_news/features/home/widgets/recentList.dart';

class AllArticlesScreen extends StatelessWidget {
  const AllArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white   ,
      appBar: AppBar(title: const Text("All Articles"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RecentList(callpage: "all",),
      ),
    );
  }
}