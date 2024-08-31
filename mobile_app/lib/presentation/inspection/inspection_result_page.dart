import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/inspection/inspection_result_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/inspection_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/user_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';

class InspectionResultPage extends ConsumerStatefulWidget {
  final String imageUrl;
  final double probabilityScore;
  final InspectionModel modelUsed;
  final DateTime evaluationDate;

  const InspectionResultPage({
    super.key,
    required this.imageUrl,
    required this.probabilityScore,
    required this.modelUsed,
    required this.evaluationDate,
  });

  @override
  InspectionResultPageState createState() => InspectionResultPageState();
}

class InspectionResultPageState extends ConsumerState<InspectionResultPage> {
  late TextEditingController notesController;
  String? selectedCollection;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.loading),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!currentUser.hasValue || currentUser.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.errorTitle),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(signOutStateProvider);
                },
                child: Text(l10n.notLoggedInMessage),
              ),
            ],
          ),
        ),
      );
    }

    final userId = currentUser.value!.id;
    final collectionsAsyncValue = ref.watch(userCollectionsProvider(userId));

    return CommonPageScaffold(
      title: l10n.inspectionResultTitle,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GapWidgets.h24,
              _buildImageSection(context, l10n),
              GapWidgets.h24,
              _buildInspectionDetails(context, l10n),
              GapWidgets.h24,
              _buildAdditionalNotesSection(context, l10n),
              GapWidgets.h16,
              collectionsAsyncValue.when(
                data: (collections) =>
                    _buildCollectionDropdown(context, l10n, collections),
                loading: () => SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    strokeWidth: 4.0,
                  ),
                ),
                error: (error, stackTrace) => Text(
                  '${l10n.errorMessage}: $error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const Spacer(),
              _buildActionButtons(context, l10n, userId),
              GapWidgets.h24,
            ],
          ),
          if (isSaving)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  strokeWidth: 4.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, AppLocalizations l10n) {
    final isFile = !widget.imageUrl.startsWith('http');
    return Center(
      child: Container(
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: isFile
                ? Image.file(
                    File(widget.imageUrl),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  )
                : Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionDetails(BuildContext context, AppLocalizations l10n) {
    final isDefective = widget.probabilityScore < 0.5;
    final statusText = isDefective ? l10n.defectiveStatus : l10n.goodStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '${l10n.statusLabel}: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: statusText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDefective ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        GapWidgets.h4,
        RichText(
          text: TextSpan(
            text: '${l10n.modelUsedLabel}: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: Helpers.getModelName(widget.modelUsed, l10n),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
        GapWidgets.h4,
        RichText(
          text: TextSpan(
            text: '${l10n.probabilityScoreDescription}: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: widget.probabilityScore.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalNotesSection(
      BuildContext context, AppLocalizations l10n) {
    return AppTextFormField(
      fieldController: notesController,
      fieldValidator: (value) => null,
      label: '',
      maxLines: 3,
      decoration: InputDecoration(
        labelText: l10n.additionalNotesLabel,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: l10n.additionalNotesPlaceholder,
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildCollectionDropdown(BuildContext context, AppLocalizations l10n,
      List<TireCollection> collections) {
    return DropdownButtonFormField<String>(
      value: selectedCollection,
      items: collections.map((collection) {
        return DropdownMenuItem(
          value: collection.id,
          child: Text(collection.collectionName),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCollection = value;
        });
      },
      decoration: InputDecoration(
        labelText: l10n.selectCollectionLabel,
        hintText: l10n.selectCollectionPlaceholder,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, AppLocalizations l10n, String userId) {
    return Row(
      children: [
        Expanded(
          child: HighlightButton(
            text: l10n.deleteButtonLabel,
            onPressed: () {
              AppRouter.pop(context);
              _clearFormStateOnPreviousPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: HighlightButton(
            text: l10n.saveButtonLabel,
            onPressed: () {
              if (selectedCollection == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.selectCollectionWarning)),
                );
                return;
              }

              _saveInspection(context, l10n, userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveInspection(
      BuildContext context, AppLocalizations l10n, String userId) async {
    setState(() {
      isSaving = true;
    });

    final inspection = Inspection(
      id: '',
      imageUrl: widget.imageUrl,
      probabilityScore: widget.probabilityScore,
      modelUsed: widget.modelUsed.name,
      addedAt: widget.evaluationDate,
      additionalNotes: notesController.text,
    );

    final saveData = SaveInspectionData(
      userId: userId,
      collectionId: selectedCollection!,
      inspection: inspection,
    );

    try {
      final inspectionId =
          await ref.read(saveInspectionStateProvider(saveData).future);

      if (context.mounted) {
        AppRouter.pop(context);
        _clearFormStateOnPreviousPage();

        AppRouter.go(
          context,
          RouterNames.inspectionDetailsPage,
          pathParameters: {
            'userId': userId,
            'collectionId': selectedCollection!,
            'inspectionId': inspectionId,
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveErrorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _clearFormStateOnPreviousPage() {
    ref.read(uploadedImagePathProvider.notifier).state = null;
    ref.read(selectedModelProvider.notifier).state = null;
  }
}
