import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api/api_provider.dart';

// possible authentication states
enum AuthState { unknown, authenticated, unauthenticated }

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref; // refers to the apiServiceProvider which is the ApiService class
  final _secureStorage = const FlutterSecureStorage();

  AuthController(this._ref) : super(AuthState.unknown) {
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token != null) {
      final isValid = await _ref.read(apiServiceProvider).checkTokenValidity();
      if (isValid) {
        state = AuthState.authenticated;
      } else {
        await logout();
      }
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _ref.read(apiServiceProvider).login(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    state = AuthState.unauthenticated;
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});