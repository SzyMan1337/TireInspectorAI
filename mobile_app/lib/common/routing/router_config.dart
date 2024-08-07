import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tireinspectorai_app/presentation/presentation.dart';

import 'auth_change_provider.dart';
import 'route_names.dart';

final routerConfig = Provider<GoRouter>(
  (ref) => GoRouter(
    redirect: (context, state) {
      final userState = ref.watch(routerAuthStateProvider);

      final isAuthenticated = userState.value != null && userState.value!;

      final isAuthPath = state.fullPath?.startsWith('/auth') ?? false;

      if (!isAuthenticated && !isAuthPath) {
        return '/auth';
      }

      return null;
    },
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        name: RouterNames.authPage.name,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            name: RouterNames.registerPage.name,
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: RouterNames.forgotPasswordPage.name,
            builder: (context, state) => ForgotPasswordPage(),
          ),
        ],
      ),
    ],
  ),
);
