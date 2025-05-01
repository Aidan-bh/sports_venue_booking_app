import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spod_app/modules/root/root_view.dart';
import 'package:spod_app/modules/onboarding_view.dart';
import 'package:spod_app/theme.dart';

late bool isDarkMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final skipOnBoarding = prefs.getBool("skipOnBoarding") ?? false;
  isDarkMode = prefs.getBool("isDarkMode") ?? false;

  runApp(MyApp(skipOnBoarding: skipOnBoarding));
}

class MyApp extends StatefulWidget {
  final bool skipOnBoarding;

  const MyApp({Key? key, required this.skipOnBoarding}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setTheme(BuildContext context, bool darkMode) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setTheme(darkMode);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', darkMode);
  }
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = isDarkMode;
  }

  void setTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spod',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primaryColor: primaryColor500,
        useMaterial3: false,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: primaryColor500,
        useMaterial3: false,
        brightness: Brightness.dark,
      ),
      home: widget.skipOnBoarding
          ? RootView(currentScreen: 0)
          : OnboardingView(),
    );
  }
}
