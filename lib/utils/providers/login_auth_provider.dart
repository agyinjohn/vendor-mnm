import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/utils/login_auth.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
