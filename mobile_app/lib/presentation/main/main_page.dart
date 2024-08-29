import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/main/states/user_state.dart';
import 'package:tireinspectorai_app/domain/domain.dart';
import 'package:tireinspectorai_app/presentation/presentation.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.loading),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!currentUser.hasValue || currentUser.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.errorTitle),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(signOutStateProvider);
            },
            child: Text(l10n.notLoggedInMessage),
          ),
        ),
      );
    }

    final List<Widget> pages = [
      const HomeContent(),
      CollectionsContent(userId: currentUser.value!.uid),
      ProfileContent(userId: currentUser.value!.uid),
    ];

    return Scaffold(
      appBar: _buildAppBar(context, l10n),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
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
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      title: Text(
        _currentIndex == 0
            ? l10n.homeTitle
            : _currentIndex == 1
                ? l10n.recordsTitle
                : l10n.profileTitle,
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuSelection(value, context),
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
    );
  }

  void _handleMenuSelection(String value, BuildContext context) {
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
  }
}
