import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'screens/welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const HsellApp());
}

class HsellApp extends StatelessWidget {
  const HsellApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HSELL',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: const WelcomeScreen(),
      );
}
