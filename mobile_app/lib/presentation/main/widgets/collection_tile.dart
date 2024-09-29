import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/common/common.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile({
    super.key,
    required this.id,
    required this.name,
    required this.count,
    required this.userId,
    required this.onDelete,
  });

  final String id;
  final String name;
  final int count;
  final String userId;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        AppRouter.go(
          context,
          RouterNames.collectionPage,
          pathParameters: {
            'collectionId': id,
            'userId': userId,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder,
                      size: 48.0,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 8.0),
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '$count ${l10n.items}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 18.0,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
