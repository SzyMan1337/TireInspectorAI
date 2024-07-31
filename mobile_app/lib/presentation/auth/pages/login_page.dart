import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../state/login_state.dart';
import '../widgets/social_login.dart';
import '../widgets/user_pass_form.dart';
import '../widgets/welcome_text.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);

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
                    : AppLocalizations.of(context)!.somethingWentWrong,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
    );

    return CommonPageScaffold(
      title: AppLocalizations.of(context)!.loginTitle,
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
                  buttonLabel: AppLocalizations.of(context)!.login,
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
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                      onPressed: () {
                        AppRouter.go(
                          context,
                          RouterNames.registerPage,
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.signUp),
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
                      child: Text(AppLocalizations.of(context)!.forgotPassword),
                    ),
                  ],
                ),
                GapWidgets.h8,
                Text(AppLocalizations.of(context)!.orLoginWith),
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
