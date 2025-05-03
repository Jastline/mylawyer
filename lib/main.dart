// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/db_helper.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/theme_manager.dart';
import 'widgets/app_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных
  final dbHelper = DBHelper();
  await dbHelper.database;

  // Инициализация менеджера тем
  final themeManager = ThemeManager();
  final initialTheme = await themeManager.getThemeMode();

  runApp(
    MyApp(
      dbHelper: dbHelper,
      themeManager: themeManager,
      initialTheme: initialTheme,
    ),
  );
}

class MyApp extends StatefulWidget {
  final DBHelper dbHelper;
  final ThemeManager themeManager;
  final ThemeMode initialTheme;

  const MyApp({
    super.key,
    required this.dbHelper,
    required this.themeManager,
    required this.initialTheme,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  bool _licenseShown = false;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialTheme;
    _checkAndShowLicense();
  }

  Future<void> _checkAndShowLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final isLicenseAccepted = prefs.getBool('license_accepted') ?? false;
    if (!isLicenseAccepted) {
      _licenseShown = true;
      await prefs.setBool('license_accepted', true);
    }
  }

  Future<void> _acceptLicense() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('license_accepted', true);
    setState(() {
      _licenseShown = true;
    });
  }

  void _showLicenseIfNeeded(BuildContext context) {
    if (!_licenseShown) {
      _licenseShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppSnackBar.showLicenseAgreement(context, onAccept: _acceptLicense);
        }
      });
    }
  }

  void _toggleTheme(bool isDark) async {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await widget.themeManager.saveThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyLawyer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          _showLicenseIfNeeded(context);
          return MainScreen(
            dbHelper: widget.dbHelper,
            toggleTheme: _toggleTheme,
            isDarkTheme: _themeMode == ThemeMode.dark,
          );
        },
      ),
    );
  }
}