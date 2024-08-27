import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    return CommonPageScaffold(
      title: l10n.about,
      withPadding: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderImage(),
              GapWidgets.h8,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildAboutText(context, l10n),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildVersionInfo(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/images/about/about_page_main_image.png',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildAboutText(BuildContext context, AppLocalizations l10n) {
    return Text(
      l10n.aboutContent,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildVersionInfo(BuildContext context, AppLocalizations l10n) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final version = snapshot.data?.version ?? 'Unknown';
          return Center(
            child: Text(
              '${l10n.appVersionLabel} $version',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
