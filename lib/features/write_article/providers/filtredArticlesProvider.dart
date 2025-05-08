import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/models/article.dart';
import 'package:isamm_news/features/write_article/providers/articleRepoProvider.dart';
import 'package:isamm_news/features/write_article/services/articleService.dart';


class FiltredArticleNotifier extends StateNotifier<Future<List<Article>>> {
  final ArticleService _articleService;


 FiltredArticleNotifier(this._articleService) : super(_initializeArticles(_articleService)) ;
   // Initialize with all articles
  static Future<List<Article>> _initializeArticles(ArticleService articleService) async {
    return articleService.getAllArticles();
  }


  // Future<void> _initializeArticles() async {
  //   // Initialize with all articles
  //   state =  _articleService.getAllArticles();
  // }

  Future<void> filterArticles(String tag) async {
    if (tag == "All") {
      // If no tag, return all articles
      state =  _articleService.getAllArticles();
    } else {
      // Filter by tag
      state =  _articleService.getFilterArticles(tag);
    }
  }
}

final  articleServiceProvider = Provider<ArticleService>((ref) {
  return ArticleService(repository: ref.watch(articleRepositoryProvider));
});

final filtredArticleProvider =
    StateNotifierProvider< FiltredArticleNotifier, Future<List<Article>>>((ref) {
  final repository = ref.watch(articleServiceProvider);
  return FiltredArticleNotifier(repository);
});