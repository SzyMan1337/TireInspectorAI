import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.enterEmail;
    }
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return AppLocalizations.of(context)!.validEmail;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.enterPassword;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)!.passwordLength;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppLocalizations.of(context)!.uppercaseLetter;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppLocalizations.of(context)!.lowercaseLetter;
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return AppLocalizations.of(context)!.oneNumber;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppLocalizations.of(context)!.specialCharacter;
    }
    return null;
  }
}
