import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isamm_news/features/write_article/widgets/CommentsSkeleton.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.id});
  final String id;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Stream<QuerySnapshot> loadReplies(String articleId, ) {
    print("entred");
    print(commentId + "hazem");
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
     
        .snapshots();
  }

  Stream<QuerySnapshot> loadCommentsWithStream(String articleId) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addReply(
      String commentId, Map<String, dynamic> replyData) async {
    final commentRef = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.id)
        .collection('comments')
        .doc(commentId);

    // Add the reply
    await commentRef.collection('replies').add(replyData);

    // Increment the reply count
    await commentRef.update({
      'replyCount': FieldValue.increment(1),
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _focusTextField(String id) {
    isReply = true;

    commentId = id;

    _focusNode.requestFocus();
  }

  var isReply = false;
  var commentId = "";
    var showReplys = false ; 


  final TextEditingController _commentController = TextEditingController();
  Future<void> _addComment() async {

      if (_commentController.text.isEmpty) {
        return;
      }

      // Get the current timestamp
      final timestamp = Timestamp.now();

      // Prepare the comment data
      final commentData = {
        'author': 'User A', // Replace with actual user data
        'content': _commentController.text,
        'timestamp': timestamp,
        'likesCount': 0, // Initial likes count
        "replyCount": 0,
      };

      try {
        // Add the comment to the Firestore
        await FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.id)
            .collection('comments')
            .add(commentData);

        await FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.id)
            .update({"commentsCount": FieldValue.increment(1)});

        // Clear the comment field
        _commentController.clear();

        // Optionally, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully!')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   comments = fetchComments(widget.id);
  // }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("comment"),
      ),
      body: StreamBuilder(
          stream: loadCommentsWithStream(widget.id),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const CommentsSkeleton(); // Initial loading of stream
            } else if (streamSnapshot.hasError) {
              return Text('Stream Error: ${streamSnapshot.error}');
            } else if (!streamSnapshot.hasData) {
              return Center(child: const Text('no data here'));
            }
            final comments = streamSnapshot.data!.docs.map((document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              data["id"] = document.id;
              data["isOpen"] = false  ; 
              return data;
            }).toList();
            return Stack(
              children: [
                // CustomScrollView to handle comments list
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = comments[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: Text(
                                      comment["author"][0],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  "User Name",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "urbanist",
                                      letterSpacing: 1),
                                ),
                                subtitle: Text(
                                  comment["content"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFF6b6b6b),
                                      fontFamily: "urbanist",
                                      letterSpacing: 1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    // Like button
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Icon(Icons.favorite,
                                              color: Colors.red),
                                          SizedBox(width: 5),
                                          Text(
                                              comment["likesCount"].toString()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 16.0), // Space between buttons
                                    // Reply button
                                    InkWell(
                                      onTap: () {
                                        // showReplys = !showReplys ; 
                                        comment["isOpen"] = !comment["isOpen"] ;
                                        commentId = comment["id"] ;
                                        setState(() {
                                          
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.comment),
                                          SizedBox(width: 5),
                                          Text(
                                            comment["replyCount"].toString() +
                                                " Reply",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(), // Space between buttons
                                    TextButton(
                                      onPressed: () {
                                        // Handle reply button press
                                      },
                                      child: TextButton(
                                        onPressed: () {
                                          _focusTextField(comment["id"]);
                                        },
                                        child: const Text(
                                          'Reply',
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                        childCount: comments.length,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                          height:
                              100), // Placeholder space for the TextField and button
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        TextField(
                          focusNode: _focusNode,
                          controller: _commentController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.comment,
                                color: Color(0xFF1a998e)),
                            filled: true,
                            fillColor: const Color(0xFFedf7f6),
                            hintText: 'Reply...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFF1a998e),
                                  width:
                                      2.0), // Change border color and width here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  width:
                                      2.0), // Change border color and width here
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          cursorColor: const Color(0xFF1A998E),
                        ),
                        Positioned(
                          right: -20,
                          top: -20,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1a998e),
                              foregroundColor: Colors.white,
                              shape: const CircleBorder(),
                              shadowColor: Colors.green[100],
                            ),
                            onPressed: _addComment,
                            child: const Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
