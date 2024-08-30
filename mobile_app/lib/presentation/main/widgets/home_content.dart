import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/main/states/inspection_state.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final uploadedImagePath = ref.watch(uploadedImagePathProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          _buildImageUploadSection(context, l10n, uploadedImagePath, ref),
          const SizedBox(height: 24.0),
          _buildModelSelectionDropdown(context, l10n, selectedModel, ref),
          const Spacer(),
          _buildRunInspectionButton(context, l10n, ref),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context, AppLocalizations l10n,
      String? uploadedImagePath, WidgetRef ref) {
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
            if (uploadedImagePath == null) {
              _pickImage(ref, ImageSource.gallery);
            } else {
              _showImageOptions(ref, context, l10n);
            }
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: uploadedImagePath != null
                        ? Stack(
                            children: [
                              Image.file(
                                File(uploadedImagePath),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Center(
                                    child: Text(
                                      l10n.clickToEditLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              l10n.uploadImagePrompt,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageOptions(
      WidgetRef ref, BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.changeImageButtonLabel),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ref, ImageSource.gallery);
                },
              ),
              if (ref.read(uploadedImagePathProvider) != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(l10n.deleteImageButtonLabel),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(uploadedImagePathProvider.notifier).state = null;
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      ref.read(uploadedImagePathProvider.notifier).state = pickedFile.path;
    }
  }

  Widget _buildModelSelectionDropdown(BuildContext context,
      AppLocalizations l10n, InspectionModel? selectedModel, WidgetRef ref) {
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
        DropdownButton<InspectionModel>(
          value: selectedModel,
          hint: Text(l10n.selectModelPrompt),
          items: InspectionModel.values.map((InspectionModel model) {
            return DropdownMenuItem<InspectionModel>(
              value: model,
              child: Text(_getModelName(model, l10n)),
            );
          }).toList(),
          onChanged: (model) {
            ref.read(selectedModelProvider.notifier).state = model;
          },
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildRunInspectionButton(
      BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final model = ref.read(selectedModelProvider);
          final imagePath = ref.read(uploadedImagePathProvider);

          if (model != null && imagePath != null) {
            try {
              final inspectionResultAsyncValue = ref.read(
                runInspectionStateProvider(RunInspectionData(
                  model: model,
                  imagePath: imagePath,
                )).future,
              );

              inspectionResultAsyncValue.then(
                (inspectionResult) {
                  if (context.mounted) {
                    AppRouter.go(
                      context,
                      RouterNames.inspectionResultPage,
                      queryParameters: {
                        'imageUrl': inspectionResult.imageUrl,
                        'probabilityScore':
                            inspectionResult.probabilityScore.toString(),
                        'modelUsed': inspectionResult.modelUsed.name,
                        'evaluationDate':
                            inspectionResult.evaluationDate.toIso8601String(),
                      },
                    );
                  }
                },
              ).catchError((error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.inspectionErrorMessage)),
                  );
                }
              });
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.inspectionErrorMessage)),
                );
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.selectModelAndImagePrompt)),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48.0),
        ),
        child: Text(l10n.inspectButtonLabel),
      ),
    );
  }

  String _getModelName(InspectionModel model, AppLocalizations l10n) {
    switch (model) {
      case InspectionModel.localModel:
        return l10n.localModel;
      case InspectionModel.cloudModel:
        return l10n.cloudModel;
    }
  }
}
