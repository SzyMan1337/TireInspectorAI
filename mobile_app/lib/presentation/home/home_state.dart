import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

final signOutStateProvider = Provider<Future<void>>(
  (ref) {
    return ref.watch(userUseCaseProvider).signOut();
  },
);

final currentUserStateProvider = StreamProvider.autoDispose<AppUser>(
  (ref) {
    return ref
        .watch(
          userUseCaseProvider,
        )
        .getCurrentUserInfo();
  },
);
