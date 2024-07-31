import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

final registerStateProvider = AsyncNotifierProvider<RegisterState, bool>(
  () {
    return RegisterState();
  },
);

class RegisterState extends AsyncNotifier<bool> {
  get _registerUseCase => ref.read(registerUseCaseProvider);

  @override
  bool build() => false;

  registerWithEmailPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return _registerUseCase.registerWithEmailPassword(
        email: email,
        password: password,
      );
    });
  }
}
