import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// Logger provider using Riverpod
final loggerProvider = Provider<Logger>((ref) {
  return Logger(
    printer: PrettyPrinter(),
  );
});
