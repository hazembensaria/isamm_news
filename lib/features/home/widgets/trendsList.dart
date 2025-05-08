import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/home/widgets/trendListSkeleton.dart';
import 'package:isamm_news/features/write_article/providers/articleServiceProvider.dart';
import 'package:isamm_news/features/write_article/screens/realArticle.dart';


class TrendList extends ConsumerWidget {
  const TrendList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> isPostLiked(String postId) async {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('articles').doc(postId);
      DocumentReference likeRef = postRef
          .collection('likes')
          .doc(ref.read(authServiceProvider).getCurrentUser()!.uid);

      DocumentSnapshot likeSnapshot = await likeRef.get();
      return likeSnapshot.exists;
    }

    final articles = ref.read(articleServiceProvider).getAllArticles();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 310.0, // Set height for the list to accommodate image and text
      child: FutureBuilder(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const TrendListSkeleton();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('nod data for now');
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal, // Make the list horizontal
            itemCount: snapshot.data!.length, // Number of items
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RealArticle(
                          article: snapshot.data![index],
                          isliked: isPostLiked(snapshot.data![index].id)),
                    ),
                  );
                },
                child: Container(
                  // color: Color(0xFF6b6b6b),
                  width: 280.0, // Set width for each item
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  decoration: BoxDecoration(
                    // color: Color(0xFF6b6b6b)[100],
                    borderRadius: BorderRadius.circular(10.0),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0xFF6b6b6b).withOpacity(0.5),
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: Offset(0, 3), // changes position of shadow
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Container(
                        height: 180.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0),
                              bottom: Radius.circular(10.0)),
                          image: DecorationImage(
                            image: NetworkImage(snapshot
                                .data![index].imageUrl!), // Your image here
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Title
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        snapshot.data![index].title,
                        style: const TextStyle(
                          fontFamily: "urbanist",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        // overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),

                      // Row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format(snapshot.data![index].timestamp),
                            style: const TextStyle(
                                fontSize: 14.0, color: Color(0xFF6b6b6b)),
                          ),
                          FutureBuilder(
                              future: isPostLiked(snapshot.data![index].id),
                              builder: (cnt, likeSnapshot) {
                                if (likeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Row(
                                    children: [
                                      const Icon(Icons.favorite,
                                          size: 16.0, color: Color(0xFF6b6b6b)),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        snapshot.data![index].likesCount
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFF6b6b6b)),
                                      ),
                                    ],
                                  );
                                } else if (likeSnapshot.hasData &&
                                    likeSnapshot.data == true) {
                                  return Row(
                                    children: [
                                      const Icon(Icons.favorite,
                                          size: 16.0, color: Colors.red),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        snapshot.data![index].likesCount
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFF6b6b6b)),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      const Icon(Icons.favorite,
                                          size: 16.0, color: Color(0xFF6b6b6b)),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        snapshot.data![index].likesCount
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFF6b6b6b)),
                                      ),
                                    ],
                                  );
                                }
                              }),
                          Row(
                            children: [
                              const Icon(Icons.comment,
                                  size: 16.0, color: Color(0xFF6b6b6b)),
                              const SizedBox(width: 4.0),
                              Text(
                                snapshot.data![index].commentsCount.toString(),
                                style: const TextStyle(
                                    fontSize: 14.0, color: Color(0xFF6b6b6b)),
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            color: Colors.white,
                            elevation: 0.5,
                            
                            onSelected: (int result) {
                              // Handle menu item selection
                              if (result == 0) {
                                // Action for first item
                                print("Add to bookMark");
                              } else if (result == 1) {
                                // Action for second item
                                print("Report this");
                              } else if (result == 2) {
                                // Action for third item
                                print("send feedback");
                              }
                            },
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => <PopupMenuEntry<int>>[
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('Add to BookMark'),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text('report this'),
                              ),
                              const PopupMenuItem<int>(
                                value: 2,
                                child: Text('send feedback'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
