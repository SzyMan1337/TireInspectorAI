import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tireinspectorai_app/common/routing/route_names.dart';
import 'package:tireinspectorai_app/common/routing/router_config.dart';

class AppRouter {
  static Future<T?> go<T>(
    context,
    RouterNames routerName, {
    Map<String, String> pathParameters = const {},
    Map<String, String>? queryParameters,
  }) {
    return GoRouter.of(context).pushNamed<T>(
      routerName.name,
      pathParameters: pathParameters,
      queryParameters: queryParameters ?? {},
    );
  }

  static pop(context) => GoRouter.of(context).pop();

  static String getCurrentLocation(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  static Provider<GoRouter> config = routerConfig;
}
