import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';

class InspectionDetailsSection extends ConsumerStatefulWidget {
  final double probabilityScore;
  final InspectionModel modelUsed;
  final bool isDefective;

  const InspectionDetailsSection({
    super.key,
    required this.probabilityScore,
    required this.modelUsed,
    required this.isDefective,
  });

  @override
  ConsumerState<InspectionDetailsSection> createState() =>
      _InspectionDetailsSectionState();
}

class _InspectionDetailsSectionState
    extends ConsumerState<InspectionDetailsSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);
    final statusText =
        widget.isDefective ? l10n.defectiveStatus : l10n.goodStatus;

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
                      color: widget.isDefective ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const WidgetSpan(child: GapWidgets.w8),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(l10n.statusExplanationTitle),
                          content: Text(widget.isDefective
                              ? l10n.defectiveStatusExplanation
                              : l10n.goodStatusExplanation),
                          actions: [
                            TextButton(
                              child: Text(l10n.closeButtonLabel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
                text: '${(widget.probabilityScore * 100).toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
        GapWidgets.h4,
        _buildProbabilityScoreDescription(
            context, widget.probabilityScore, l10n),
      ],
    );
  }

  Widget _buildProbabilityScoreDescription(
      BuildContext context, double probabilityScore, AppLocalizations l10n) {
    String description;

    if (probabilityScore <= 0.2) {
      description = l10n.probabilityScoreDescriptionLow;
    } else if (probabilityScore <= 0.4) {
      description = l10n.probabilityScoreDescriptionModerateLow;
    } else if (probabilityScore <= 0.6) {
      description = l10n.probabilityScoreDescriptionModerate;
    } else if (probabilityScore <= 0.8) {
      description = l10n.probabilityScoreDescriptionHigh;
    } else {
      description = l10n.probabilityScoreDescriptionVeryHigh;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
