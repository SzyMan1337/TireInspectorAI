import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/inspection/states/inspection_result_state.dart';
import 'package:tireinspectorai_app/presentation/inspection/widgets/inspection_details_section.dart';
import 'package:tireinspectorai_app/presentation/inspection/widgets/inspection_image_section.dart';
import 'package:tireinspectorai_app/presentation/main/states/inspection_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';
import 'package:tireinspectorai_app/presentation/main/states/user_state.dart';

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
  late final InspectionResult inspectionResult;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();

    inspectionResult = InspectionResult(
      imageUrl: widget.imageUrl,
      probabilityScore: widget.probabilityScore,
      modelUsed: widget.modelUsed,
      evaluationDate: widget.evaluationDate,
    );
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
      isLoading: isSaving,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   GapWidgets.h24,
                  InspectionImageSection(imageUrl: inspectionResult.imageUrl),
                  GapWidgets.h24,
                  InspectionDetailsSection(
                    probabilityScore: inspectionResult.probabilityScore,
                    modelUsed: inspectionResult.modelUsed,
                    isDefective: inspectionResult.isDefective,
                  ),
                   GapWidgets.h24,
                  _buildAdditionalNotesSection(context, l10n),
                   GapWidgets.h16,
                  collectionsAsyncValue.when(
                    data: (collections) =>
                        _buildCollectionDropdown(context, l10n, collections),
                    loading: () => const CommonLoadingIndicator(),
                    error: (error, stackTrace) => Text(
                      '${l10n.errorMessage}: $error',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                   GapWidgets.h24,
                ],
              ),
            ),
          ),
          _buildActionButtons(context, l10n, userId),
          GapWidgets.h24,
        ],
      ),
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
      isExpanded: true,
      items: collections.map((collection) {
        return DropdownMenuItem(
          value: collection.id,
          child: Text(
            collection.collectionName,
            overflow: TextOverflow.ellipsis,
          ),
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
      imageUrl: inspectionResult.imageUrl,
      probabilityScore: inspectionResult.probabilityScore,
      modelUsed: inspectionResult.modelUsed.name,
      addedAt: inspectionResult.evaluationDate,
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
        ref.invalidate(userCollectionsProvider(userId));
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
