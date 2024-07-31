import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart'; // Import the localization provider

import '../state/forgot_password_state.dart';

class ForgotPasswordPage extends ConsumerWidget with EmailPassValidators {
  ForgotPasswordPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final forgotPassState = ref.watch(forgotPassStateProvider);
    ref.listen(
      forgotPassStateProvider,
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
          return;
        }
      },
    );
    return CommonPageScaffold(
      title: l10n.forgotPassword,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(l10n.resetYourPassword),
            GapWidgets.h8,
            AppTextFormField(
              fieldController: emailController,
              fieldValidator: (value) => validateEmail(context, value),
              label: 'Email',
            ),
            GapWidgets.h8,
            forgotPassState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : HighlightButton(
                    text: l10n.sendMeAnEmail,
                    onPressed: () {
                      ref
                          .read(
                            forgotPassStateProvider.notifier,
                          )
                          .forgotPassword(
                            emailController.text,
                          );
                    },
                  ),
            GapWidgets.h48,
          ],
        ),
      ),
    );
  }
}
