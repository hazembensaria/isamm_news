// Provider for AuthRepository
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/authRepository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository( firebaseAuth:  FirebaseAuth.instance),
);