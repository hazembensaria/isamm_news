import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/write_article/models/article.dart';
import 'package:isamm_news/features/write_article/screens/comments.dart';


class RealArticle extends ConsumerStatefulWidget {
  const RealArticle({super.key, required this.article, required this.isliked});

  final Article article;
  final Future<bool> isliked;

  @override
  ConsumerState<RealArticle> createState() => _RealArticleState();
}

class _RealArticleState extends ConsumerState<RealArticle> {
  Future<void> toggleLike() async {
    // Reference to the article document
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id);

    // Reference to the specific user's like document in the subcollection
    DocumentReference likeRef = postRef
        .collection('likes')
        .doc(ref.read(authServiceProvider).getCurrentUser()!.uid);

    DocumentSnapshot likeSnapshot = await likeRef.get();

    if (likeSnapshot.exists) {
      // If the document exists, it means the user has already liked the post
      // Dislike the post by deleting the document
      await likeRef.delete();
      await postRef.update({'likeCount': FieldValue.increment(-1)});
    } else {
      // If the document doesn't exist, like the post by creating the document
      await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
      await postRef.update({'likeCount': FieldValue.increment(1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> _extractDominantColor() async {
    //   print(article.imageUrl);
    //   final color = await _getDominantColor(NetworkImage(article.imageUrl!));
    //   setState(() {
    //     buttonColor = color;
    //   });
    // }

    final quillController = QuillController(
      readOnly: true,
      document: widget.article.content.isNotEmpty
          ? Document.fromJson(widget.article.content)
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  background: AspectRatio(
                     aspectRatio: 4 / 3, 
                    child: Image.network(
                      widget.article.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    widget.article.title,
                    // textAlign: TextAlign.leftf,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "playfair",
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      // backgroundColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Time
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 20, color: Color(0xFF6b6b6b)),
                          const SizedBox(width: 4),
                          Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(widget.article.timestamp),
                              style: const TextStyle(color: Color(0xFF6b6b6b))),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // Views

                      FutureBuilder(
                          future: widget.isliked,
                          builder: (cnt, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return TextButton(
                                onPressed: null,
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        size: 20, color: Color(0xFF6b6b6b)),
                                    const SizedBox(width: 4),
                                    Text(widget.article.likesCount.toString(),
                                        style: const TextStyle(
                                            color: Color(0xFF6b6b6b))),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data == true) {
                              return TextButton(
                                onPressed: () {
                                  toggleLike();
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        size: 20, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text(widget.article.likesCount.toString(),
                                        style: const TextStyle(
                                            color: Color(0xFF6b6b6b))),
                                  ],
                                ),
                              );
                            } else {
                              return TextButton(
                                onPressed: () {
                                  toggleLike();
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        size: 20, color: Color(0xFF6b6b6b)),
                                    const SizedBox(width: 4),
                                    Text(widget.article.likesCount.toString(),
                                        style: const TextStyle(
                                            color: Color(0xFF6b6b6b))),
                                  ],
                                ),
                              );
                            }
                          }),

                      const SizedBox(
                        width: 20,
                      ),

                      // Comments
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentsScreen(id: widget.article.id)),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.comment,
                                size: 20, color: Color(0xFF6b6b6b)),
                            const SizedBox(width: 4),
                            Text(widget.article.commentsCount.toString(),
                                style:
                                    const TextStyle(color: Color(0xFF6b6b6b))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0),
                Container(
                  // color: Color(0xFF6b6b6b)[200],
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: QuillEditor(
                    configurations: QuillEditorConfigurations(
                        controller: quillController, showCursor: false),
                    scrollController: ScrollController(),
                    focusNode: FocusNode(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  height: 300,
                  child: Wrap(
                    spacing: 10,
                    children: widget.article.tags.map((tag) {
                      return TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 189, 189, 189),
                            side: BorderSide(color: Colors.grey)),
                        child: Text(tag),
                        onPressed: () async {
                          // Function to delete the tag
                        },
                      );
                    }).toList(),
                  ),
                )
                // Add more content here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
