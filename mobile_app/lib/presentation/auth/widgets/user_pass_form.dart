import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/logics/email_pass_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPassForm extends StatelessWidget with EmailPassValidators {
  UserPassForm({
    super.key,
    required this.buttonLabel,
    required this.onFormSubmit,
  });

  final String buttonLabel;
  final Function(String, String) onFormSubmit;

  // create a global key that will uniquely identify the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // create controllers for the form fields
    final userNameController = TextEditingController();
    // create controllers for the form fields
    final passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          AppTextFormField(
            fieldController: userNameController,
            fieldValidator: (value) => validateEmail(context, value),
            label: AppLocalizations.of(context)!.emailLabel,
          ),
          GapWidgets.h8,
          AppTextFormField(
            fieldController: passwordController,
            fieldValidator: (value) => validatePassword(context, value),
            obscureText: true,
            label: AppLocalizations.of(context)!.passwordLabel,
          ),
          GapWidgets.h24,
          HighlightButton(
            text: buttonLabel,
            onPressed: () {
              // make sure the form is valid
              // before submitting
              if (_formKey.currentState!.validate()) {
                onFormSubmit(
                  userNameController.text,
                  passwordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
