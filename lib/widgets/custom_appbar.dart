import 'package:enhancia/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  const CustomAppbar({
    super.key,
    required this.title,
    this.showBackButton,
    this.centerTitle = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: 7 ),
          backgroundColor: provider.appBarColor,
          title: title,
          leading: showBackButton,
          centerTitle: centerTitle,
          actions: actions,
          shadowColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
