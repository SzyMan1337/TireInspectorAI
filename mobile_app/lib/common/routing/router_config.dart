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
      GoRoute(
        path: '/',
        name: RouterNames.homePage.name,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile/:userId',
            name: RouterNames.profilePage.name,
            builder: (context, state) => ProfilePage(
              userId: state.pathParameters['userId']!,
            ),
          ),
          GoRoute(
            path: 'collections/:userId',
            name: RouterNames.collectionsPage.name,
            builder: (context, state) => CollectionsPage(
              userId: state.pathParameters['userId']!,
            ),
          ),
          GoRoute(
            path: 'about',
            name: RouterNames.aboutPage.name,
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: 'settings',
            name: RouterNames.settingsPage.name,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  ),
);
