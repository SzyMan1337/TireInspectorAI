import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/inspection/states/inspection_details_state.dart';
import 'package:tireinspectorai_app/presentation/inspection/widgets/inspection_details_section.dart';
import 'package:tireinspectorai_app/presentation/inspection/widgets/inspection_image_section.dart';
import 'package:tireinspectorai_app/common/common.dart';

class InspectionDetailsPage extends ConsumerWidget {
  const InspectionDetailsPage({
    super.key,
    required this.userId,
    required this.collectionId,
    required this.inspectionId,
  });

  final String userId;
  final String collectionId;
  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final inspectionParams = InspectionParams(
      userId: userId,
      collectionId: collectionId,
      inspectionId: inspectionId,
    );
    final inspectionFuture =
        ref.watch(inspectionProvider(inspectionParams).future);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Inspection>(
          future: inspectionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(l10n.inspectionTitle);
            } else if (snapshot.hasData) {
              final inspection = snapshot.data!;
              final formattedDate =
                  DateFormat.yMMMMd().format(inspection.addedAt);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(l10n.inspectionTitle),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.96),
                          fontSize: 11.0,
                        ),
                  ),
                ],
              );
            } else {
              return const Text('Inspection');
            }
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Inspection>(
        future: inspectionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${l10n.errorMessage}: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final inspection = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InspectionImageSection(imageUrl: inspection.imageUrl),
                  GapWidgets.h24,
                  InspectionDetailsSection(
                    probabilityScore: inspection.probabilityScore,
                    modelUsed:
                        Helpers.parseInspectionModel(inspection.modelUsed),
                    isDefective: inspection.isDefective,
                  ),
                  GapWidgets.h24,
                  if (inspection.additionalNotes != null &&
                      inspection.additionalNotes!.isNotEmpty)
                    Text(
                      '${l10n.additionalNotesLabel}: ${inspection.additionalNotes}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            );
          } else {
            return Center(child: Text(l10n.errorMessage));
          }
        },
      ),
    );
  }
}
