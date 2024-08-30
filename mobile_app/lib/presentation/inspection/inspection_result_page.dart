import 'package:flutter/material.dart';

class InspectionResultPage extends StatelessWidget {
  final String imageUrl;
  final double probabilityScore;
  final String modelUsed;
  final DateTime evaluationDate;

  const InspectionResultPage({
    super.key,
    required this.imageUrl,
    required this.probabilityScore,
    required this.modelUsed,
    required this.evaluationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Result'),
      ),
      body: const Center(
        child: Text('This is the inspection result page.'),
      ),
    );
  }
}
