import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/home/home_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationProvider);
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser.isLoading) {
      return CommonPageScaffold(
        title: l10n.loading,
        child: const CircularProgressIndicator(),
      );
    }

    if (!currentUser.hasValue || currentUser.hasError) {
      return CommonPageScaffold(
        title: l10n.errorTitle,
        child: ElevatedButton(
          onPressed: () {
            ref.read(signOutStateProvider);
          },
          child: Text(l10n.notLoggedInMessage),
        ),
      );
    }

    return CommonPageScaffold(
      title: l10n.homeTitle,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'about':
                AppRouter.go(context, RouterNames.aboutPage);
                break;
              case 'settings':
                AppRouter.go(context, RouterNames.settingsPage);
                break;
              case 'logout':
                ref.read(userUseCaseProvider).signOut();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'about',
              child: Text(l10n.about),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Text(l10n.settingsTitle),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text(l10n.logoutButton),
            ),
          ],
        ),
      ],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(context),
        onTap: (int index) {
          if (index == 0) {
            AppRouter.go(context, RouterNames.homePage);
          } else if (index == 1) {
            AppRouter.go(
              context,
              RouterNames.collectionsPage,
              pathParameters: {
                'userId': currentUser.value!.uid,
              },
            );
          } else if (index == 2) {
            AppRouter.go(
              context,
              RouterNames.profilePage,
              pathParameters: {
                'userId': currentUser.value!.uid,
              },
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.collections),
            label: l10n.recordsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profileTab,
          ),
        ],
      ),
      child: Center(
        child: Text(l10n.welcomeMessage),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = AppRouter.getCurrentLocation(context);

    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/collections')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }
}
