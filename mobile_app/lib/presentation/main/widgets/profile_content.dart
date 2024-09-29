import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/user_state.dart';

class ProfileContent extends ConsumerWidget {
  const ProfileContent({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final user = ref.watch(currentUserStateProvider);

    if (user.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (user.hasError || !user.hasValue) {
      return Center(
        child: Text(
          l10n.errorTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    final appUser = user.value!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GapWidgets.h24,
            _buildProfileHeader(context, appUser),
            GapWidgets.h24,
            _buildStatisticsSection(context, l10n, ref),
            const SizedBox(height: 24.0),
            _buildEditProfileButton(context, l10n),
            GapWidgets.h24,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 80.0,
            backgroundImage: NetworkImage(user.avatar),
          ),
        ),
        GapWidgets.h16,
        Center(
          child: Text(
            user.displayName ?? 'Anonymous User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GapWidgets.h8,
        Center(
          child: Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(
      BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    final userStatistics = ref.watch(userStatisticsProvider(userId));

    return userStatistics.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statisticsTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          GapWidgets.h16,
          _buildStatisticRow(
              context, l10n.inspectedTiresLabel, stats.inspectedTires),
          GapWidgets.h8,
          _buildStatisticRow(context, l10n.validTiresLabel, stats.validTires),
          GapWidgets.h8,
          _buildStatisticRow(
              context, l10n.defectiveTiresLabel, stats.defectiveTires),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }

  Widget _buildStatisticRow(BuildContext context, String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: HighlightButton(
        text: l10n.editProfileButton,
        onPressed: () {
          AppRouter.go(
            context,
            RouterNames.editProfilePage,
            pathParameters: {
              'userId': userId,
            },
          );
        },
      ),
    );
  }
}
