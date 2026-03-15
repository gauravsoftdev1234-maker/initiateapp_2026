//
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// // Aapne paths ke hisaab se sahi kar lein
// import '../../../controller/services/AuthService.dart';
// import '../../../controller/services/StorageService.dart';
// import '../../complete_profile/complete_profile.dart';
// import '../../rootscreen/rootscreen.dart';
// import '../login/login.dart';
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
//
//   final StorageService _storage = StorageService();
//   final AuthService _authService = AuthService();
//
//   String _statusMessage = 'Initializing...';
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimation();
//     _initializeApp();
//   }
//
//   void _setupAnimation() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_animationController);
//     _animationController.forward();
//   }
//
//   Future<void> _initializeApp() async {
//     // 1. Minimum delay branding dikhane ke liye
//     await Future.delayed(const Duration(seconds: 2));
//
//     // 2. Navigation Handle karein
//     await _handleNavigation();
//   }
//
//   Future<void> _handleNavigation() async {
//     setState(() => _statusMessage = 'Verifying Session...');
//
//     // A. Pehle check karein onboarding hui hai ya nahi (Local Check)
//     String? isFirstTime = await _storage.readRaw('isFirstTime');
//     if (isFirstTime == null || isFirstTime == 'true') {
//       _moveNext(const OnboardingScreen());
//       return;
//     }
//
//     // B. API Se Check karein "Already Logged In"
//     // Note: AuthService mein checkAlreadyLogin() banaya tha wahi use ho raha hai
//     final response = await _authService.checkAlreadyLogin();
//
//     if (!mounted) return;
//
//     // Logic: Agar isSuccess true hai aur Response 1 hai (As per your API)
//     if (response['isSuccess'] == true && response['Response'] == 1) {
//       bool isProfileComplete = response['isProfileCompleted'] ?? false;
//
//       // Local storage sync karein taaki app offline bhi state yaad rakhe
//       await _storage.saveLoginStatus(true);
//       await _storage.saveProfileStatus(isProfileComplete);
//
//       if (isProfileComplete) {
//         _moveNext(const RootScreen());
//       } else {
//         _moveNext(const ProfileCompleteFlow());
//       }
//     } else {
//       // Session expired ya login nahi hai
//       await _storage.saveLoginStatus(false);
//       _moveNext(AuthFlow());
//     }
//   }
//
//   void _moveNext(Widget nextScreen) {
//     if (!mounted) return;
//     Navigator.of(context).pushReplacement(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 800),
//       ),
//     );
//   }
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
//         decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFEE6044).withOpacity(0.1),
//                 ),
//                 child: Image.asset("assets/images/Initly.png"),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Initly',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 32,
//                   letterSpacing: 4,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               // Loader
//               const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEE6044)),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 _statusMessage,
//                 style: const TextStyle(
//                   color: Colors.white38,
//                   fontSize: 12,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../../../controller/services/AuthService.dart';
import '../../../controller/services/StorageService.dart';
import '../../complete_profile/complete_profile.dart';
import '../../rootscreen/rootscreen.dart';
import '../login/login.dart';
import '../onboarding/obardingscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Logo fade + scale
  late AnimationController _logoCtrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  // Tagline fade
  late AnimationController _tagCtrl;
  late Animation<double> _tagFade;
  late Animation<Offset> _tagSlide;

  // Floating particles
  late AnimationController _particleCtrl;

  // Pulsing ring
  late AnimationController _ringCtrl;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();
  String _statusMessage = 'Finding your spark...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));

    // Tagline
    _tagCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _tagFade = CurvedAnimation(parent: _tagCtrl, curve: Curves.easeOut);
    _tagSlide = Tween<Offset>(
        begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _tagCtrl, curve: Curves.easeOutCubic));

    // Particles
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();

    // Pulse ring
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();
    _ringScale =
        Tween<double>(begin: 0.85, end: 1.35).animate(
            CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));
    _ringOpacity =
        Tween<double>(begin: 0.6, end: 0.0).animate(
            CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));

    // Start sequence
    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _tagCtrl.forward();
    });
  }

  Future<void> _initializeApp() async {

    await Future.delayed(const Duration(seconds: 2));
    await _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;  // ← add this line
    setState(() => _statusMessage = 'Verifying session...');

    String? isFirstTime = await _storage.readRaw('isFirstTime');
    if (isFirstTime == null || isFirstTime == 'true') {
      _moveNext(const OnboardingScreen());
      return;
    }

    final response = await _authService.checkAlreadyLogin();
    if (!mounted) return;

    if (response['isSuccess'] == true && response['Response'] == 1) {
      bool isProfileComplete = response['isProfileCompleted'] ?? false;
      await _storage.saveLoginStatus(true);
      await _storage.saveProfileStatus(isProfileComplete);
      _moveNext(isProfileComplete ? const RootScreen() : const ProfileCompleteFlow());
    } else {
      await _storage.saveLoginStatus(false);
      _moveNext(AuthFlow());
    }
  }

  void _moveNext(Widget nextScreen) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _tagCtrl.dispose();
    _particleCtrl.dispose();
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// ── Background ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A0A0F), Color(0xFF160818), Color(0xFF1E0A14)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// ── Ambient orbs ──
          Positioned(
            top: -80,
            left: -60,
            child: _GlowOrb(color: const Color(0xffE91E63).withOpacity(0.18), size: 300),
          ),
          Positioned(
            bottom: -60,
            right: -80,
            child: _GlowOrb(color: const Color(0xffAD1457).withOpacity(0.22), size: 280),
          ),
          Positioned(
            top: size.height * 0.4,
            left: size.width * 0.5,
            child: _GlowOrb(color: const Color(0xffFF4081).withOpacity(0.10), size: 180),
          ),

          /// ── Floating particles ──
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlePainter(_particleCtrl.value),
            ),
          ),

          /// ── Center content ──
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Pulsing ring + logo
                AnimatedBuilder(
                  animation: _ringCtrl,
                  builder: (_, __) {
                    return SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          Opacity(
                            opacity: _ringOpacity.value,
                            child: Transform.scale(
                              scale: _ringScale.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xffFF4081).withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Logo container
                          ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xffFF4081), Color(0xffC2185B)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffE91E63).withOpacity(0.5),
                                      blurRadius: 40,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(22),
                                    child: Image.asset(
                                      "assets/images/Initly.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// App name
                FadeTransition(
                  opacity: _logoFade,
                  child: const Text(
                    'INITLY',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 10,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Tagline
                SlideTransition(
                  position: _tagSlide,
                  child: FadeTransition(
                    opacity: _tagFade,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 1,
                          color: const Color(0xffFF4081).withOpacity(0.6),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Where connections begin',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 28,
                          height: 1,
                          color: const Color(0xffFF4081).withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ── Bottom loader + status ──
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _logoFade,
              child: Column(
                children: [
                  // Dot loader
                  _DotLoader(),
                  const SizedBox(height: 16),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Glow orb ──
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// ── Floating heart particles ──
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(
    18,
        (i) => _Particle(i),
  );

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress + p.offset) % 1.0;
      final x = p.x * size.width;
      final y = size.height - (t * (size.height + 60)) + 30;
      final opacity = (sin(t * pi)).clamp(0.0, 1.0) * p.alpha;
      final radius = p.size * (0.7 + 0.3 * sin(t * pi * 2));

      final paint = Paint()
        ..color = const Color(0xffFF4081).withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  late double x, offset, alpha, size;
  _Particle(int seed) {
    final r = Random(seed * 137);
    x = r.nextDouble();
    offset = r.nextDouble();
    alpha = 0.08 + r.nextDouble() * 0.18;
    size = 1.5 + r.nextDouble() * 3.0;
  }
}

/// ── Animated dot loader ──
class _DotLoader extends StatefulWidget {
  @override
  State<_DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<_DotLoader> with TickerProviderStateMixin {
  final List<AnimationController> _ctrls = [];
  final List<Animation<double>> _anims = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 600))
        ..repeat(reverse: true);
      _ctrls.add(ctrl);
      _anims.add(Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeInOut)));
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffFF4081).withOpacity(_anims[i].value),
            ),
          ),
        );
      }),
    );
  }
}

