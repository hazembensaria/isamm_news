import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/providers/articleProvider.dart';
import 'package:isamm_news/features/write_article/screens/article.dart';


class Ship {
  final String id;
  final String title;

  Ship({required this.id, required this.title});
}

class TagScreen extends ConsumerStatefulWidget {
  const TagScreen({super.key});

  @override
  ConsumerState<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends ConsumerState<TagScreen> {
  List<String> allShips = [
    'Ship 1',
    'Ship 2',
    'Ship 3',
    'Ship 4',
    'Ship 5'
  ]; // Example ship titles
  List<String> displayedShips = [];
  List<String> selectedShips = [];

  @override
  void initState() {
    super.initState();
    displayedShips = List.from(allShips);

    // Initialize with all ships displayed
  }

  void toggleSelection(String ship) {
    setState(() {
      if (selectedShips.contains(ship)) {
        selectedShips.remove(ship);
      } else {
        selectedShips.add(ship);
      }
    });
  }

  void filterShips(String query) {
    setState(() {
      displayedShips = allShips
          .where((ship) => ship.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(articleProvider);
    print(article.imageUrl);
    print(article.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Ships'),
        actions: [
          TextButton(
            child: Text("next"),
            onPressed: () {
              ref.read(articleProvider.notifier).updateTags(selectedShips);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArticleScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Ships',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                onChanged: filterShips,
              ),
            ),
            // Ship selection area
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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

                  final tags = snapshot.data!.docs;

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: tags.map((tag) {
                      return InkWell(
                        onTap: () {
                          toggleSelection(tag['name']);
                        },
                        child: Chip(
                          label: Text(tag['name']),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            // Container to show selected ships
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Wrap(
                spacing: 8.0, // Gap between items
                runSpacing: 8.0, // Gap between rows
                children: selectedShips.map((ship) {
                  return GestureDetector(
                      onTap: () => toggleSelection(ship),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: Wrap(
                          spacing: 10.0, // Space between the text and icon
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              ship,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            const Icon(
                              Icons.cancel,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
