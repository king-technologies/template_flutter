import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class ThemeUtils extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  // Future<void> updateTheme({required bool isDark}) async {
  //   themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  //   final preferences = await SharedPreferences.getInstance();
  //   await preferences.setInt(SE.theme.name, isDark ? 1 : 2);
  //   notifyListeners();
  // }

  // Future<void> updateThemeBySP() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   final x = preferences.getInt(SE.theme.name) ?? 0;
  //   await updateTheme(isDark: x == 1);
  // }
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(),
  dividerTheme: const DividerThemeData(),
  primaryColor: primaryColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: primaryColor,
    error: Colors.redAccent,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  switchTheme: const SwitchThemeData(),
  textTheme: const TextTheme(),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  primaryIconTheme: const IconThemeData(color: Colors.black),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    isDense: true,
  ),
  listTileTheme: const ListTileThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
);
