import 'dart:io';

import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Helpers {
  static String getStoragePath(String uid, File file) {
    final name = file.path.split('/').last;
    return 'avatars/$uid/$name';
  }

  static String getInspectionImagePath(
    String userId,
    String collId,
    File file,
  ) {
    final name = file.path.split('/').last;
    return 'inspections/$userId/$collId/$name';
  }

  static String getModelName(InspectionModel model, AppLocalizations l10n) {
    switch (model) {
      case InspectionModel.localModel:
        return l10n.localModel;
      case InspectionModel.cloudModel:
        return l10n.cloudModel;
      default:
        return '';
    }
  }

  static InspectionModel parseInspectionModel(String modelName) {
    switch (modelName) {
      case 'localModel':
        return InspectionModel.localModel;
      case 'cloudModel':
        return InspectionModel.cloudModel;
      default:
        throw ArgumentError('Invalid model name: $modelName');
    }
  }
}
