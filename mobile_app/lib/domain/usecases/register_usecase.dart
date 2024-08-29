import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';

abstract interface class RegisterUserCase {
  Future<bool> registerWithEmailPassword({
    required String email,
    required String password,
  });
}

class _RegisterUserCase implements RegisterUserCase {
  _RegisterUserCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  registerWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _authRepository
        .registerWithEmailPassword(
          email: email,
          password: password,
        )
        .then((value) => value.email != null);
  }
}

final registerUseCaseProvider = Provider<RegisterUserCase>(
  (ref) => _RegisterUserCase(ref.watch(authRepositoryProvider)),
);
