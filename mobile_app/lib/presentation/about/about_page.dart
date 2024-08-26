import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);

    return CommonPageScaffold(
      title: l10n.about,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(),
          GapWidgets.h16,
          _buildAboutText(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        'assets/images/about/about_page_main_image.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAboutText(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        l10n.aboutContent,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}