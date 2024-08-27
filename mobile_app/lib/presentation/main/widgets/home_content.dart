import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/main/states/inspection_state.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final uploadedImagePath = ref.watch(uploadedImagePathProvider);
    String? selectedModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          _buildImageUploadSection(context, l10n, uploadedImagePath),
          const SizedBox(height: 24.0),
          _buildModelSelectionDropdown(context, l10n, selectedModel),
          const Spacer(),
          _buildRunInspectionButton(context, l10n),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(
      BuildContext context, AppLocalizations l10n, String? uploadedImagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.uploadImageLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            // TODO: Implement image upload functionality
          },
          child: Container(
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: uploadedImagePath != null
                ? Image.asset(uploadedImagePath, fit: BoxFit.cover)
                : Center(
                    child: Text(
                      l10n.uploadImagePrompt,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildModelSelectionDropdown(
      BuildContext context, AppLocalizations l10n, String? selectedModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectModelLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        DropdownButton<String>(
          value: selectedModel,
          hint: Text(l10n.selectModelPrompt),
          items: [
            DropdownMenuItem(value: 'model1', child: Text(l10n.model1)),
            DropdownMenuItem(value: 'model2', child: Text(l10n.model2)),
          ],
          onChanged: (value) {
            // TODO: Implement model selection logic
          },
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildRunInspectionButton(
      BuildContext context, AppLocalizations l10n) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement inspection logic
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48.0),
        ),
        child: Text(l10n.inspectButtonLabel),
      ),
    );
  }
}
