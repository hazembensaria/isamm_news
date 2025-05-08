import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/providers/filtredArticlesProvider.dart';

class ShipsList extends ConsumerStatefulWidget {
  const ShipsList({super.key});

  @override
  ConsumerState<ShipsList> createState() => _ShipsListState();
}

class _ShipsListState extends ConsumerState<ShipsList> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tags')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading tags.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No tags available.'));
        }


        return Container(
          height: 60.0, // Height of the scrollable list
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Make the list horizontal
            itemCount: snapshot.data!.docs.length, // Number of ships
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: _selectedIndex == index
                          ? Colors.transparent // Selected background color
                          : Colors.grey[300]!,
                    ),
                    backgroundColor: _selectedIndex == index
                        ? Color(0xFF1A998E) // Selected background color
                        : Colors.white, // Default background color
                    // Default text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    print('this is filtereeeedddd functoion' + snapshot.data!.docs[index].id);
                    ref
                        .read(filtredArticleProvider.notifier)
                        .filterArticles(snapshot.data!.docs[index]["name"]);
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Text(
                    snapshot.data!.docs[index]['name'],
                    style: TextStyle(
                      fontFamily: "urbanist",
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _selectedIndex == index
                          ? Colors.white // Selected text color
                          : Colors.black, // ),),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
