import 'package:flutter/material.dart';
import 'package:initiateapp_2026app_2026/permission_screen/PermissionGate.dart';
import 'controller/services/AppConfig.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize AppConfig
  final appConfig = AppConfig();
  // Initialize no_screenshot
  // await NoScreenshot.instance.screenshotOff();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initiate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lufga',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF00346C),
          secondary: const Color(0xFF00346C),
          surface: Colors.white,
          background: Colors.white,
          error: const Color(0xFFB00020),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF373737),
          onBackground: const Color(0xFF373737),
          onError: Colors.white,
          brightness: Brightness.light,
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF373737),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Lufga',
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF373737),
          ),
          iconTheme: IconThemeData(color: Color(0xFF373737), size: 24.0),
          actionsIconTheme: IconThemeData(color: Color(0xFF373737), size: 24.0),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00346C),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'Lufga',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(88, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0,
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00346C),
            textStyle: const TextStyle(
              fontFamily: 'Lufga',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Input Decoration Theme
      ),
      home: PermissionGate(), // 👈 important
    );
  }
}

// // Secure Screen Wrapper Widget
// class SecureScreenWrapper extends StatefulWidget {
//   final Widget child;
//
//   const SecureScreenWrapper({super.key, required this.child});
//
//   @override
//   State<SecureScreenWrapper> createState() => _SecureScreenWrapperState();
// }
//
// class _SecureScreenWrapperState extends State<SecureScreenWrapper> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // Enable screenshot protection when screen is loaded
//     _enableScreenshotProtection();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     // Optionally disable when screen is disposed
//     // _disableScreenshotProtection();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//
//     // Handle app lifecycle changes
//     if (state == AppLifecycleState.resumed) {
//       // App is back in foreground
//       _enableScreenshotProtection();
//     } else if (state == AppLifecycleState.paused) {
//       // App is in background
//       // You can choose to disable or keep enabled
//       // _disableScreenshotProtection();
//     }
//   }
//
//   Future<void> _enableScreenshotProtection() async {
//     try {
//       if (Platform.isAndroid || Platform.isIOS) {
//         await NoScreenshot.instance.screenshotOff();
//         print("Screenshot protection enabled");
//       }
//     } catch (e) {
//       print("Error enabling screenshot protection: $e");
//     }
//   }
//
//   Future<void> _disableScreenshotProtection() async {
//     try {
//       if (Platform.isAndroid || Platform.isIOS) {
//         await NoScreenshot.instance.screenshotOn();
//         print("Screenshot protection disabled");
//       }
//     } catch (e) {
//       print("Error disabling screenshot protection: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
