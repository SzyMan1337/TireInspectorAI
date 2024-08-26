import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    return CommonPageScaffold(
      title: l10n.profileTitle,
      child: const Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
