import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

final forgotPassStateProvider = AsyncNotifierProvider<ForgotPassState, void>(
  () {
    return ForgotPassState();
  },
);

class ForgotPassState extends AsyncNotifier<void> {
  @override
  bool build() => false;

  forgotPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref
          .watch(
            forgotPasswordUseCaseProvider,
          )
          .forgotPassword(email);
    });
  }
}
