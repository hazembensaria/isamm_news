



import 'package:isamm_news/features/write_article/models/article.dart';
import 'package:isamm_news/features/write_article/repository/ArticleRepository.dart';

class ArticleService {
  final ArticleRepository _repository;

  ArticleService({required ArticleRepository repository}) : _repository = repository;

  Future<void> createArticle(Article article) async {
    await _repository.saveArticle(article);
  }

  Future<void> updateArticle(Article article) async {
    await _repository.updateArticle(article);
  }

  Future<void> deleteArticle(String articleId) async {
    await _repository.deleteArticle(articleId);
  }

  Future<Article?> getArticleById(String articleId) async {
    return await _repository.fetchArticleById(articleId);
  }

  Future<List<Article>> getAllArticles() async {
    return await _repository.fetchAllArticles();
  }
   Future<List<Article>> getAllRecentArticles() async {
    return await _repository.fetchAllArticlesbyDate();
  }

    Future<List<Article>?> getBreakingNewsArticle() async {
    return await _repository.getBreakingNewsArticle();
  }
     Future<List<Article>> getFilterArticles(String tag) async {
    return await _repository.getFiltredArticles(tag) ?? [];
  }
}