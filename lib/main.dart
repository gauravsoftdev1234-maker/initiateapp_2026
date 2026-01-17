import 'package:flutter/material.dart';
import 'package:initiate/view/complete_profile/complete_profile.dart';
import 'package:initiate/view/rootscreen/rootscreen.dart';
import 'package:initiate/view/starting_screens/login/login.dart';
import 'package:initiate/view/starting_screens/onboarding/obardingscreen.dart';
import 'package:initiate/view/starting_screens/splash/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initiate',
      debugShowCheckedModeBanner: false,
      //   theme: ThemeData(
      //     useMaterial3: true,
      //     scaffoldBackgroundColor: Colors.white,
      //     theme: ThemeData(
      //       textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
      //         bodyMedium: GoogleFonts.oswald(textStyle: textTheme.bodyMedium),
      //       ),
      //     // Color Scheme
      //     colorScheme: ColorScheme.light(
      //       primary: const Color(0xFFFE9072), // #FE9072 - Orange/Pink
      //       secondary: const Color(0xFFFF4F46), // #FF4F46 - Red
      //       surface: Colors.white,
      //       background: Colors.white,
      //       error: const Color(0xFFB00020),
      //       onPrimary: Colors.white,
      //       onSecondary: Colors.white,
      //       onSurface: const Color(0xFF373737), // #373737 - Dark Grey
      //       onBackground: const Color(0xFF373737), // #373737 - Dark Grey
      //       onError: Colors.white,
      //       brightness: Brightness.light,
      //     ),
      //
      //     // Font Family - Lufga (Note: Screenshot mein "Lugfa" hai but aapka font "Lufga" hai)
      //     fontFamily: 'Lufga',
      //
      //
      //     // AppBar Theme
      //     appBarTheme: const AppBarTheme(
      //       backgroundColor: Colors.white,
      //       foregroundColor: Color(0xFF373737),
      //       elevation: 0,
      //       titleTextStyle: TextStyle(
      //         fontFamily: 'Lufga',
      //         fontSize: 20.0,
      //         fontWeight: FontWeight.w600, // SemiBold
      //         color: Color(0xFF373737),
      //       ),
      //       iconTheme: IconThemeData(color: Color(0xFF373737), size: 24.0),
      //       actionsIconTheme: IconThemeData(color: Color(0xFF373737), size: 24.0),
      //     ),
      //
      //     // Elevated Button Theme
      //     elevatedButtonTheme: ElevatedButtonThemeData(
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: const Color(0xFFFF4F46), // #FF4F46 Red
      //         foregroundColor: Colors.white,
      //         textStyle: const TextStyle(
      //           fontFamily: 'Lufga',
      //           fontSize: 16.0,
      //           fontWeight: FontWeight.w600, // SemiBold
      //         ),
      //         minimumSize: const Size(88, 48),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8.0),
      //         ),
      //         elevation: 0,
      //       ),
      //     ),
      //
      //     // Text Button Theme
      //     textButtonTheme: TextButtonThemeData(
      //       style: TextButton.styleFrom(
      //         foregroundColor: const Color(0xFFFE9072), // #FE9072 Orange
      //         textStyle: const TextStyle(
      //           fontFamily: 'Lufga',
      //           fontSize: 16.0,
      //           fontWeight: FontWeight.w600, // SemiBold
      //         ),
      //       ),
      //     ),
      //
      //     // Outlined Button Theme
      //     outlinedButtonTheme: OutlinedButtonThemeData(
      //       style: OutlinedButton.styleFrom(
      //         foregroundColor: const Color(0xFF373737),
      //         side: const BorderSide(color: Color(0xFF373737)),
      //         textStyle: const TextStyle(
      //           fontFamily: 'Lufga',
      //           fontSize: 16.0,
      //           fontWeight: FontWeight.w600, // SemiBold
      //         ),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8.0),
      //         ),
      //         minimumSize: const Size(88, 48),
      //       ),
      //     ),
      //
      //     // Input Decoration Theme
      //     inputDecorationTheme: InputDecorationTheme(
      //       filled: true,
      //       fillColor: Colors.grey[50],
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(8.0),
      //         borderSide: BorderSide.none,
      //       ),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(8.0),
      //         borderSide: BorderSide.none,
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(8.0),
      //         borderSide: const BorderSide(color: Color(0xFFFE9072), width: 2.0),
      //       ),
      //       errorBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(8.0),
      //         borderSide: const BorderSide(color: Color(0xFFFF4F46)),
      //       ),
      //       contentPadding: const EdgeInsets.symmetric(
      //         horizontal: 16.0,
      //         vertical: 14.0,
      //       ),
      //       hintStyle: const TextStyle(
      //         fontFamily: 'Lufga',
      //         fontSize: 14.0,
      //         fontWeight: FontWeight.w400,
      //         color: Color(0xFF9E9E9E),
      //       ),
      //       labelStyle: const TextStyle(
      //         fontFamily: 'Lufga',
      //         fontSize: 14.0,
      //         fontWeight: FontWeight.w400,
      //         color: Color(0xFF373737),
      //       ),
      //     ),
      //
      //     // Card Theme
      //
      //     // Icon Theme
      //     iconTheme: const IconThemeData(color: Color(0xFF373737), size: 24.0),
      //
      //     // Divider Theme
      //     dividerTheme: const DividerThemeData(
      //       color: Color(0xFFE0E0E0),
      //       thickness: 1.0,
      //       space: 0,
      //     ),
      //   ),
      //   // Dark Theme (Optional)
      //   darkTheme: ThemeData(
      //     useMaterial3: true,
      //     fontFamily: 'Lufga',
      //     brightness: Brightness.dark,
      //     colorScheme: ColorScheme.dark(
      //       primary: const Color(0xFFFE9072),
      //       secondary: const Color(0xFFFF4F46),
      //       onSurface: Colors.white,
      //     ),
      //     textTheme: const TextTheme().apply(
      //       fontFamily: 'Lufga',
      //       displayColor: Colors.white,
      //       bodyColor: Colors.white,
      //     ),
      //   ),
      //   home: const OnboardingScreen(),
      //   debugShowCheckedModeBanner: false,
      // );
      theme: ThemeData(
        // textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
        //   bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
        // ),
        fontFamily: 'Lufga',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF00346C), // #FE9072 - Orange/Pink
          secondary: const Color(0xFF00346C), // #FF4F46 - Red
          surface: Colors.white,
          background: Colors.white,
          error: const Color(0xFFB00020),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF373737), // #373737 - Dark Grey
          onBackground: const Color(0xFF373737), // #373737 - Dark Grey
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
