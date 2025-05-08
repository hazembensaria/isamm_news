
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/models/article.dart';

/// Notifier class to manage the state of the Article
class ArticleNotifier extends StateNotifier<Article> {
  ArticleNotifier()
      : super(Article(id: '', title: '', content: [], timestamp: DateTime.now(), tags: [] ,imageUrl: null, likesCount: 0  ,commentsCount: 0));

  /// Method to update the article's title
  void updateTitle(String newTitle) {
    state = state.copyWith(title: newTitle);
  }

  /// Method to update the article's content
  void updateContent(List<Map<String, dynamic>> newContent) {
    state = state.copyWith(content: newContent);
  }

  /// Method to update the article's tags
  void updateTags(List<String> newTags) { 
    state = state.copyWith(tags: newTags);
  }
 /// Method to update the article's tags
  void updateImage(String newImage) {
    state = state.copyWith(imageUrl: newImage);
  }
  /// Method to reset the article
  void resetArticle() {
    state = Article(id: '', title: '', content: [], timestamp: DateTime.now(), tags: [] , imageUrl: null, commentsCount: 0 , likesCount: 0);
  }
}

/// Riverpod provider to access the ArticleNotifier
final articleProvider = StateNotifierProvider<ArticleNotifier, Article>((ref) {
  return ArticleNotifier();
});