import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/db_helper.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/theme_manager.dart';
import 'widgets/app_snackbar.dart';

// Глобальный ключ навигатора
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DBHelper();
  await dbHelper.database;

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
    required this.dbHelper,
    required this.themeManager,
    required this.initialTheme,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  bool _licenseAccepted = false;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialTheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLicense();
    });
  }

  Future<void> _checkLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final isAccepted = prefs.getBool('license_accepted') ?? false;

    if (!isAccepted) {
      await AppSnackBar.showLicenseAgreement(
        context: navigatorKey.currentContext!,
        onAccept: () async {
          await prefs.setBool('license_accepted', true);
          setState(() => _licenseAccepted = true);
        },
      );
    } else {
      setState(() => _licenseAccepted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MyLawyer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _licenseAccepted
          ? MainScreen(
        dbHelper: widget.dbHelper,
        toggleTheme: (isDark) {
          setState(() {
            _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
          });
          widget.themeManager.saveThemeMode(_themeMode);
        },
        isDarkTheme: _themeMode == ThemeMode.dark,
      )
          : const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}