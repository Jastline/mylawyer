import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/theme_provider.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      color: Colors.white,
      onPressed: () async {
        await context.read<ThemeProvider>().toggleTheme();
      },
    );
  }
}
