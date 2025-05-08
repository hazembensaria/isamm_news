// Provider for AuthService

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authRepositoryProvider.dart';

import '../services/authService.dart';


final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(authRepository: ref.read(authRepositoryProvider)),
);
