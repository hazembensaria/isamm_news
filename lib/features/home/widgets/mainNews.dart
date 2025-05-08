import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/home/widgets/mainImageSkeleton.dart';
import 'package:isamm_news/features/write_article/providers/articleServiceProvider.dart';
import 'package:isamm_news/features/write_article/screens/realArticle.dart';


class MainNews extends ConsumerWidget {
  const MainNews({
    super.key,
  });

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
    final articles = ref.read(articleServiceProvider).getBreakingNewsArticle();

    return FutureBuilder(
        future: articles,
        builder: (cxt, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MainImageSkeletonz();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("ther is no data !");
          } else {
            return InkWell(
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RealArticle(
                        article: snapshot.data!.first, isliked:  isPostLiked(snapshot.data!.first.id)
                      ),
                    ),
                  );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.network(
                    snapshot.data!.first.imageUrl! ,
                    fit: BoxFit.cover,
                  ),

                  // Text button (bottom left, fades with the image)
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Opacity(
                      opacity: 1.0, // Adjust the opacity as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shadowColor: Colors.red,
                            elevation: 15,
                            backgroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red)),
                        onPressed: () {
                          // Handle text button press
                        },
                        child: const Text(
                          "Breaking News",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
