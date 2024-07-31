import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

final loginStateProvider = AsyncNotifierProvider<LoginState, bool>(
  () {
    return LoginState();
  },
);

class LoginState extends AsyncNotifier<bool> {
  @override
  bool build() => false;

  loginWithEmailPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref
          .watch(
            loginUseCaseProvider,
          )
          .loginWithEmailPassword(
            email: email,
            password: password,
          );
    });
  }

  signInGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref
          .watch(
            loginUseCaseProvider,
          )
          .loginWithGoogle();
    });
  }

  signInApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref
          .watch(
            loginUseCaseProvider,
          )
          .loginWithApple();
    });
  }
}
