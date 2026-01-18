//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import '../onboarding/obardingscreen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   bool _isCheckingLocation = false;
//   String _statusMessage = 'Initializing...';
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 1. Animation Setup
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_animationController);
//     _animationController.forward();
//
//     // 2. Start location permission check and navigation
//     Timer(const Duration(milliseconds: 500), () {
//       _checkLocationAndNavigate();
//     });
//   }
//
//   Future<void> _checkLocationAndNavigate() async {
//     setState(() {
//       _isCheckingLocation = true;
//       _statusMessage = 'Checking location services...';
//     });
//
//     // Check if location services are enabled
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//     if (!serviceEnabled) {
//       setState(() {
//         _statusMessage = 'Location services are disabled';
//       });
//
//       // Wait a bit then navigate anyway (or show dialog)
//       Timer(const Duration(seconds: 2), () {
//         _navigateToOnboarding();
//       });
//       return;
//     }
//
//     setState(() {
//       _statusMessage = 'Checking permissions...';
//     });
//
//     // Check location permission
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       setState(() {
//         _statusMessage = 'Requesting location permission...';
//       });
//
//       permission = await Geolocator.requestPermission();
//
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _statusMessage = 'Location permission denied';
//         });
//
//         // Wait then navigate
//         Timer(const Duration(seconds: 2), () {
//           _navigateToOnboarding();
//         });
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _statusMessage = 'Location permission permanently denied';
//       });
//
//       // Wait then navigate
//       Timer(const Duration(seconds: 2), () {
//         _navigateToOnboarding();
//       });
//       return;
//     }
//
//     // Permission granted, try to get current position
//     setState(() {
//       _statusMessage = 'Getting current location...';
//     });
//
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.medium,
//       );
//
//       // Store location data if needed
//       print('Location obtained: ${position.latitude}, ${position.longitude}');
//
//       setState(() {
//         _statusMessage = 'Location obtained successfully!';
//       });
//
//       // Navigate after a short delay
//       Timer(const Duration(seconds: 1), () {
//         _navigateToOnboarding();
//       });
//
//     } catch (e) {
//       print('Error getting location: $e');
//       setState(() {
//         _statusMessage = 'Could not get location';
//       });
//
//       // Navigate anyway after delay
//       Timer(const Duration(seconds: 2), () {
//         _navigateToOnboarding();
//       });
//     }
//   }
//
//   void _navigateToOnboarding() {
//     Navigator.of(context).pushReplacement(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//         const OnboardingScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 800),
//       ),
//     );
//   }
//
//
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color(0xFF121212), // Dark Premium Background
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo Design
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFEE6044).withOpacity(0.1),
//                 ),
//                 child: const Icon(
//                   Icons.all_inclusive_rounded,
//                   size: 80,
//                   color: Color(0xFFEE6044),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // App Name
//               const Text(
//                 'INITIATE',
//                 style: TextStyle(
//                   fontFamily: 'Lufga',
//                   fontWeight: FontWeight.w700,
//                   fontSize: 32,
//                   letterSpacing: 4,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Start something meaningful',
//                 style: TextStyle(
//                   fontFamily: 'Lufga',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 14,
//                   color: Colors.white54,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//
//               // Status indicator
//               const SizedBox(height: 30),
//               if (_isCheckingLocation)
//                 Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     Container(
//                       width: 30,
//                       height: 30,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           const Color(0xFFEE6044).withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       _statusMessage,
//                       style: const TextStyle(
//                         fontFamily: 'Lufga',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12,
//                         color: Colors.white54,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:initiate/view/rootscreen/rootscreen.dart';
import 'package:initiate/view/starting_screens/login/login.dart';

// Aapne paths ke hisaab se imports change kar lein
import '../../complete_profile/complete_profile.dart';
import '../onboarding/obardingscreen.dart';
// import '../auth/login_screen.dart';
// import '../profile/profile_complete_screen.dart';
// import '../root/root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Secure Storage Instance
  final _storage = const FlutterSecureStorage();

  String _statusMessage = 'Initializing...';
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();

    // 1. Animation Setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();

    // 2. Start Initializing App
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // A. Location Check (Optional but kept from your original code)
    await _checkLocationPermissions();

    // B. Thoda wait taaki logo dikhe
    await Future.delayed(const Duration(seconds: 2));

    // C. Logic for Navigation
    await _handleNavigation();
  }

  Future<void> _checkLocationPermissions() async {
    setState(() => _statusMessage = 'Checking location...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _handleNavigation() async {
    setState(() => _statusMessage = 'Finalizing...');

    // Read Flags from Secure Storage
    // Note: Secure Storage returns Strings, not Booleans
    String? isFirstTime = await _storage.read(key: 'isFirstTime');
    String? isLoggedIn = await _storage.read(key: 'isLoggedIn');
    String? isProfileComplete = await _storage.read(key: 'isProfileComplete');

    if (!mounted) return;

    Widget nextScreen;

    // --- NAVIGATION LOGIC ---
    if (isFirstTime == null || isFirstTime == 'true') {
      nextScreen = const OnboardingScreen();
    } else if (isLoggedIn != 'true') {
      nextScreen = AuthFlow();
    } else if (isProfileComplete != 'true') {
      nextScreen = const ProfileCompleteFlow();
    } else {
      nextScreen = const RootScreen();
    }

    // Navigate with Fade Transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF121212), // Premium Dark
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEE6044).withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.all_inclusive_rounded,
                  size: 80,
                  color: Color(0xFFEE6044),
                ),
              ),
              const SizedBox(height: 24),
              // App Title
              const Text(
                'INITIATE',
                style: TextStyle(
                  fontFamily: 'Lufga',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              // Status Loader
              if (_isChecking)
                Column(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFEE6044),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
