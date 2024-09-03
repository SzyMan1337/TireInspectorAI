import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tireinspectorai_app/common/common.dart';

class InspectionImageSection extends StatelessWidget {
  final String imageUrl;

  const InspectionImageSection({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isFile = !imageUrl.startsWith('http');
    return Center(
      child: GestureDetector(
        onTap: () {
          AppRouter.go(
            context,
            RouterNames
                .fullScreenImagePage,
            queryParameters: {
              'imageUrl': imageUrl,
            },
          );
        },
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
                      File(imageUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.0,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.0,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
