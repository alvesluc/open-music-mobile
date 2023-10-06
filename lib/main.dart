import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/home/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => HomeController(),
      child: MaterialApp(
        title: 'open music',
        theme: _buildTheme(),
        darkTheme: _buildTheme(brightness: Brightness.dark),
        home: const HomePage(),
      ),
    );
  }

  ThemeData _buildTheme({Brightness? brightness = Brightness.light}) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      colorScheme: brightness == Brightness.light
          ? ColorScheme.fromSeed(seedColor: Colors.deepPurple)
          : const ColorScheme.dark(),
      useMaterial3: true,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
