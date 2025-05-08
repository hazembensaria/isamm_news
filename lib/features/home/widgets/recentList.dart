import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/write_article/providers/filtredArticlesProvider.dart';
import 'package:isamm_news/features/write_article/screens/realArticle.dart';


class RecentList extends ConsumerWidget {
  RecentList({super.key , required this.callpage});
  final String callpage ; 

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
    final articles = ref.watch(filtredArticleProvider) ;

    return FutureBuilder(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('nod data for now');
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: callpage == "home"? NeverScrollableScrollPhysics() : null,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RealArticle(
                        article: snapshot.data![index], isliked:  isPostLiked(snapshot.data![index].id)
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First Row: Title and Image
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data![index].title,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        snapshot.data![index].content[0]
                                            ["insert"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0x1AFF6b6b6b),
                                          fontSize: 16,
                                          fontFamily: "urbanist",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                // Image
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Image.network(
                                      snapshot.data![index].imageUrl!,
                                      fit: BoxFit.cover,
                                      height: 70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                
                            // Second Row: Date, Views, Comments, More
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Date
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16.0, color: Color(0xFF6b6b6b)),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      DateFormat('yyyy-MM-dd').format(snapshot.data![index].timestamp),
                                      style: const TextStyle(
                                          fontSize: 12.0, color: Color(0xFF6b6b6b)),
                                    ),
                                  ],
                                ),
                                // Views
                                Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        size: 16.0, color: Color(0xFF6b6b6b)),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      snapshot.data![index].likesCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 12.0, color: Color(0xFF6b6b6b)),
                                    ),
                                  ],
                                ),
                                // Comments
                                Row(
                                  children: [
                                    const Icon(Icons.comment,
                                        size: 16.0, color: Color(0xFF6b6b6b)),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      snapshot.data![index].commentsCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 12.0, color: Color(0xFF6b6b6b)),
                                    ),
                                  ],
                                ),
                                // More Icon
                                const Icon(Icons.more_vert,
                                    size: 16.0, color: Color(0xFF6b6b6b)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFf2f2f2),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
