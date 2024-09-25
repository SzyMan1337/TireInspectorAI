import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/data/data.dart';
import 'package:tireinspectorai_app/presentation/main/states/collections_state.dart';

abstract interface class UserStatisticsUseCase {
  Future<UserStatistics> fetchUserStatistics(String userId);
}

class _UserStatisticsUseCase implements UserStatisticsUseCase {
  const _UserStatisticsUseCase(
    this._inspectionRepository,
    this._collectionRepository,
  );

  final InspectionRepository _inspectionRepository;
  final TireCollectionRepository _collectionRepository;

  @override
  Future<UserStatistics> fetchUserStatistics(String userId) async {
    final collections =
        await _collectionRepository.getUserCollections(userId).first;
    int inspectedTires = 0;
    int validTires = 0;
    int defectiveTires = 0;

    for (final collection in collections) {
      final inspections = await _inspectionRepository
          .getCollectionInspections(userId, collection.id)
          .first;
      inspectedTires += inspections.length;
      validTires +=
          inspections.where((insp) => insp.probabilityScore < 0.5).length;
      defectiveTires +=
          inspections.where((insp) => insp.probabilityScore >= 0.5).length;
    }

    return UserStatistics(
      inspectedTires: inspectedTires,
      validTires: validTires,
      defectiveTires: defectiveTires,
    );
  }
}

final userStatisticsUseCaseProvider = Provider<UserStatisticsUseCase>((ref) {
  return _UserStatisticsUseCase(
    ref.watch(inspectionRepositoryProvider),
    ref.watch(tireCollectionRepositoryProvider),
  );
});
