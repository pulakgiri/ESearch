import 'package:esearch/pages/spalshpage.dart';
import 'package:esearch/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ESearch',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: SplashPage(),
        );
      },
    );
  }
}
