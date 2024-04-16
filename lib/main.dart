import 'package:beam/app.dart';
import 'package:beam/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() {
  initializeApp(); // Call the initializeApp() function
}

Future<void> initializeApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.initializeTheme();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const BeamApp(),
    ),
  );
}
