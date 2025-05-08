// Provider for AuthService

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/providers/articleRepoProvider.dart';
import 'package:isamm_news/features/write_article/repository/ArticleRepository.dart';
import 'package:isamm_news/features/write_article/services/articleService.dart';

late final  ArticleRepository articleRepo ;
final articleServiceProvider = Provider<ArticleService>(
  (ref) => ArticleService( repository: ref.read(articleRepositoryProvider) ),
);
