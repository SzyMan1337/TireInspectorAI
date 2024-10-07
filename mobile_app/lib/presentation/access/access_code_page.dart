import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tireinspectorai_app/common/routing/route_names.dart';
import 'package:tireinspectorai_app/common/routing/router.dart';
import 'package:tireinspectorai_app/common/widgets/page_scaffold.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:tireinspectorai_app/presentation/utils/screen_utils.dart';

class AccessCodePage extends ConsumerStatefulWidget {
  const AccessCodePage({super.key});

  @override
  ConsumerState<AccessCodePage> createState() => _AccessCodePageState();
}

class _AccessCodePageState extends ConsumerState<AccessCodePage> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);
    final String? correctPassword = dotenv.env['APP_UNLOCK_CODE'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = ScreenUtils.isSmallScreen(constraints);

        return CommonPageScaffold(
          title: l10n.enterAccessCode,
          centerTitle: true,
          withPadding: true,
          isScrollable: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isSmallScreen ? 32 : 128),
              Image.asset(
                'assets/images/icons/app-icon.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: isSmallScreen ? 32 : 64),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.accessCode,
                ),
              ),
              const SizedBox(height: 20),
              // Full-width button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text == correctPassword) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isAppUnlocked', true);

                      if (context.mounted) {
                        AppRouter.goAndReplace(
                          context,
                          RouterNames.authPage,
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.incorrectCode)),
                        );
                      }
                    }
                  },
                  child: Text(l10n.unlock),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                l10n.accessCodeDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
