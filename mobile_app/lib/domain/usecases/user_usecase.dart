import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';

abstract interface class UserUseCase {
  Future<void> signOut();
}

class _UserUseCase implements UserUseCase {
  _UserUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> signOut() {
    return authRepository.signOut();
  }
}

final userUseCaseProvider = Provider<_UserUseCase>(
  (ref) => _UserUseCase(
    ref.watch(authRepositoryProvider),
  ),
);
