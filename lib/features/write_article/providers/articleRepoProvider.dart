// Provider for AuthRepository
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/repository/ArticleRepository.dart';

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => ArticleRepository( ),
);