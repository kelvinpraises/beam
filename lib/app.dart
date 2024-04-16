import 'package:beam/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/beam_webview.dart';

class BeamApp extends StatelessWidget {
  const BeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        debugPrint(themeProvider.getThemeMode().toString());

        final isSystemDark =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        themeProvider.updateSystemTheme(isSystemDark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.getThemeMode(),
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: const BeamWebview(),
        );
      },
    );
  }
}
