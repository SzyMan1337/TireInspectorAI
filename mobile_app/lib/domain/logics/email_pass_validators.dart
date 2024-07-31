import 'package:flutter/material.dart';
import 'validators.dart';

mixin EmailPassValidators {
  String? validateEmail(BuildContext context, String? email) {
    return Validators.validateEmail(context, email);
  }

  String? validatePassword(BuildContext context, String? password) {
    return Validators.validatePassword(context, password);
  }
}
