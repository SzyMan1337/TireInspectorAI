import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/utils/logger_provider.dart';

class ModelService {
  final Logger logger;
  FirebaseCustomModel? _cachedModel;

  ModelService(this.logger);

  Future<FirebaseCustomModel> getModel() async {
    try {
      if (_cachedModel != null) {
        logger.i("Using cached model. Path: ${_cachedModel!.file.path}");
        return _cachedModel!;
      }

      logger.i("Fetching model from Firebase ML Kit...");
      FirebaseCustomModel model =
          await FirebaseModelDownloader.instance.getModel(
        "local_model",
        FirebaseModelDownloadType.localModelUpdateInBackground,
        FirebaseModelDownloadConditions(
          iosAllowsCellularAccess: false,
          iosAllowsBackgroundDownloading: true,
          androidWifiRequired: false,
          androidChargingRequired: false,
          androidDeviceIdleRequired: false,
        ),
      );

      // Cache the model for future use
      _cachedModel = model;
      logger
          .i("Model fetched and cached successfully. Path: ${model.file.path}");
      return model;
    } catch (e) {
      logger.e("Error fetching the model: $e");
      rethrow;
    }
  }
}

final modelServiceProvider = Provider<ModelService>((ref) {
  final logger = ref.read(loggerProvider);
  return ModelService(logger);
});
