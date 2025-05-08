import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTagsScreen extends StatefulWidget {
  const AddTagsScreen({super.key});

  @override
  State<AddTagsScreen> createState() => _AddTagsScreenState();
}

class _AddTagsScreenState extends State<AddTagsScreen> {
   final TextEditingController _tagController = TextEditingController();

  // Function to add a new tag
  Future<void> _addTag() async {
    if (_tagController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('tags').add({
        'name': _tagController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      _tagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tags'),
      ),
      body: Column(
        children: [
          // StreamBuilder to display tags as chips
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
                    return Chip(
                      label: Text(tag['name']),
                      onDeleted: () async {
                        // Function to delete the tag
                        await FirebaseFirestore.instance
                            .collection('tags')
                            .doc(tag.id)
                            .delete();
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      labelText: 'Add a new tag',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTag,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}