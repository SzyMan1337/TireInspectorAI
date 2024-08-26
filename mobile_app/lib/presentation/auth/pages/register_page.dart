import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

import '../state/register_state.dart';
import '../widgets/user_pass_form.dart';
import '../widgets/welcome_text.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerStateProvider);
    final l10n = ref.watch(localizationProvider);

    ref.listen(
      registerStateProvider,
      (prev, next) {
        if (next.hasError) {
          final error = next.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error is AppException ? error.message : l10n.anErrorOccurred,
              ),
            ),
          );
        }
      },
    );

    return CommonPageScaffold(
      title: l10n.signUpTitle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const WelcomeText(),
          GapWidgets.h48,
          registerState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : UserPassForm(
                  buttonLabel: l10n.signUp,
                  onFormSubmit: (String email, String password) {
                    ref
                        .read(
                          registerStateProvider.notifier,
                        )
                        .registerWithEmailPassword(
                          email,
                          password,
                        );
                  },
                ),
          GapWidgets.h48,
        ],
      ),
    );
  }
}
