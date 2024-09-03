import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';

class InspectionDetailsSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                text: Helpers.getModelName(modelUsed, l10n),
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
                text: probabilityScore.toStringAsFixed(2),
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
}
