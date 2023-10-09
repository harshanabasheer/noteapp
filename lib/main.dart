import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/login.dart';
import 'package:noteapp/provider/provider_page.dart';
import 'package:provider/provider.dart';

final darkTheme = ThemeData.dark();
final lightTheme = ThemeData.light();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkMode ? darkTheme : lightTheme,
          home: Login(),
        );
      },
    );
  }
}
