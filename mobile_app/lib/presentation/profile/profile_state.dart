import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

class EditProfileData {
  EditProfileData({
    required this.uid,
    required this.displayName,
  });
  final String uid;
  final String displayName;
}

final editProfileStateProvider =
    FutureProvider.autoDispose.family<void, EditProfileData>(
  (ref, update) {
    return ref
        .watch(
          editProfileUseCaseProvider,
        )
        .editProfile(
          uid: update.uid,
          displayName: update.displayName,
        );
  },
);

class UploadImageMetadata {
  UploadImageMetadata({
    required this.uid,
    required this.filePath,
  });

  final String uid;
  final String filePath;
}

final updateImageStateProvider =
    FutureProvider.autoDispose.family<void, UploadImageMetadata>(
  (ref, metadata) {
    return ref
        .watch(editProfileUseCaseProvider)
        .updateProfileImage(uid: metadata.uid, filePath: metadata.filePath);
  },
);

final uploadProgressProvider =
    StreamProvider.autoDispose.family<double, UploadImageMetadata>(
  (ref, metadata) {
    return ref
        .watch(editProfileUseCaseProvider)
        .getUploadProgress(uid: metadata.uid, filePath: metadata.filePath);
  },
);

class DeleteImageMetadata {
  DeleteImageMetadata({
    required this.uid,
    required this.imageUrl,
  });

  final String uid;
  final String imageUrl;
}

final deleteImageStateProvider =
    FutureProvider.autoDispose.family<void, DeleteImageMetadata>(
  (ref, metadata) {
    return ref.watch(editProfileUseCaseProvider).deleteProfileImage(
          uid: metadata.uid,
          imageUrl: metadata.imageUrl,
        );
  },
);
