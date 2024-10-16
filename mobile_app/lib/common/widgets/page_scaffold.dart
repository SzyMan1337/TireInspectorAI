import 'package:flutter/material.dart';

class CommonPageScaffold extends StatelessWidget {
  const CommonPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.withPadding = true,
    this.bottomNavigationBar,
    this.actions,
    this.leading,
    this.isLoading = false,
    this.loadingOverlayColor = Colors.black54,
    this.isScrollable = false,
  });

  final String title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool withPadding;
  final Widget child;
  final Widget? leading;
  final List<Widget>? actions;
  final BottomNavigationBar? bottomNavigationBar;
  final bool isLoading;
  final Color loadingOverlayColor;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    Widget content = withPadding
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: child,
          )
        : child;

    if (isScrollable) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    return Stack(
      children: [
        Scaffold(
          key: key,
          appBar: AppBar(
            leading: leading,
            centerTitle: centerTitle,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: Text(title),
            actions: actions,
          ),
          body: SafeArea(
            child: content,
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
        if (isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                Container(
                  color: loadingOverlayColor,
                ),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 4.0,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
