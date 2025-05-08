import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isamm_news/features/write_article/models/article.dart';

class ArticleRepository {
  final FirebaseFirestore _firestore;

  ArticleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Save a new article to Firestore
  Future<void> saveArticle(Article article) async {
    await _firestore.collection('articles').add(article.toFirestore());
  }

  // Update an existing article in Firestore
  Future<void> updateArticle(Article article) async {
    await _firestore.collection('articles').doc(article.id).update(article.toFirestore());
  }

  // Delete an article from Firestore
  Future<void> deleteArticle(String articleId) async {
    await _firestore.collection('articles').doc(articleId).delete();
  }

  // Fetch an article by its ID
  Future<Article?> fetchArticleById(String articleId) async {
    final docSnapshot = await _firestore.collection('articles').doc(articleId).get();

    if (docSnapshot.exists) {
      return Article.fromFirestore(docSnapshot.data()!, docSnapshot.id , );
    }
    return null;
  }

  // Fetch all articles
  Future<List<Article>> fetchAllArticles() async {
    final querySnapshot = await _firestore.collection('articles').orderBy("likeCount" , descending: true).get();
    return querySnapshot.docs
        .map((doc) => Article.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Article>> fetchAllArticlesbyDate() async {
    final querySnapshot = await _firestore.collection('articles').orderBy("timestamp" , descending: true).get();
    return querySnapshot.docs
        .map((doc) => Article.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Article>?> getBreakingNewsArticle() async {
  // Get the current date
  // DateTime now = DateTime.now();
  // DateTime startOfDay = DateTime(now.year, now.month, now.day); // Start of today

  // Convert the start of the day to a Firestore Timestamp
  // Timestamp startOfDayTimestamp = Timestamp.fromDate(startOfDay);

  // Query the Firestore collection for articles
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('articles')
      .where('tags', arrayContains: 'breaking news') // Check if 'tags' array contains 'breaking news'
      // .where('timestamp', isGreaterThanOrEqualTo: startOfDayTimestamp) // Check if 'timestamp' is from today
      .get();

  // Return the first matching article if it exists
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => Article.fromFirestore(doc.data()  as Map<String, dynamic>, doc.id))
        .toList();
  } else {
    return null; // No article found
  }
}

Future<List<Article>?> getFiltredArticles(String tag) async {
  // Get the current date
  // DateTime now = DateTime.now();
  // DateTime startOfDay = DateTime(now.year, now.month, now.day); // Start of today

  // Convert the start of the day to a Firestore Timestamp
  // Timestamp startOfDayTimestamp = Timestamp.fromDate(startOfDay);

  // Query the Firestore collection for articles
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('articles')
      .where('tags', arrayContains: tag) // Check if 'tags' array contains 'breaking news'
      // .where('timestamp', isGreaterThanOrEqualTo: startOfDayTimestamp) // Check if 'timestamp' is from today
      .get();

  // Return the first matching article if it exists
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => Article.fromFirestore(doc.data()  as Map<String, dynamic>, doc.id))
        .toList();
  } else {
    return null; // No article found
  }
}
}