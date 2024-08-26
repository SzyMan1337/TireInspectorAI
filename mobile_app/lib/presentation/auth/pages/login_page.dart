import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

import '../state/login_state.dart';
import '../widgets/social_login.dart';
import '../widgets/user_pass_form.dart';
import '../widgets/welcome_text.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);
    final l10n = ref.watch(localizationProvider);

    // in case of error show a snackbar
    ref.listen(
      loginStateProvider,
      (prev, next) {
        if (next.hasError) {
          final error = next.error;
          debugPrint('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error is AppFirebaseException
                    ? error.message
                    : l10n.somethingWentWrong,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
    );

    return CommonPageScaffold(
      title: l10n.loginTitle,
      child: loginState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const WelcomeText(),
                GapWidgets.h16,
                UserPassForm(
                  buttonLabel: l10n.login,
                  onFormSubmit: (
                    String email,
                    String password,
                  ) async {
                    ref
                        .read(
                          loginStateProvider.notifier,
                        )
                        .loginWithEmailPassword(
                          email,
                          password,
                        );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(l10n.dontHaveAccount),
                    TextButton(
                      onPressed: () {
                        AppRouter.go(
                          context,
                          RouterNames.registerPage,
                        );
                      },
                      child: Text(l10n.signUp),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        AppRouter.go(
                          context,
                          RouterNames.forgotPasswordPage,
                        );
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),
                GapWidgets.h8,
                Text(l10n.orLoginWith),
                SocialLogin(
                  onGooglePressed: () {
                    ref
                        .read(
                          loginStateProvider.notifier,
                        )
                        .signInGoogle();
                  },
                  onApplePressed: () {
                    ref
                        .read(
                          loginStateProvider.notifier,
                        )
                        .signInApple();
                  },
                ),
              ],
            ),
    );
  }
}
