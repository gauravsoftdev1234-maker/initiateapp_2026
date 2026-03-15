//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';
//
// // Ensure these paths match your project structure
// import '../../../controller/services/AuthService.dart';
// import '../../../controller/services/StorageService.dart';
// import '../../complete_profile/complete_profile.dart';
// import '../../rootscreen/rootscreen.dart';
//
// class AuthFlow extends StatefulWidget {
//   const AuthFlow({super.key});
//
//   @override
//   _AuthFlowState createState() => _AuthFlowState();
// }
//
// class _AuthFlowState extends State<AuthFlow> with TickerProviderStateMixin {
//   // State Variables
//   bool showOtpScreen = false;
//   bool isLoading = false;
//   int _quoteIndex = 0;
//
//   // Services
//   final StorageService _storage = StorageService();
//   final AuthService _authService = AuthService();
//
//   // Controllers
//   final TextEditingController phoneController = TextEditingController();
//   final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
//
//   // Animation Controllers
//   late AnimationController _heartController;
//   late AnimationController _fadeController;
//
//   final List<String> quotes = [
//     "Design your destiny.",
//     "Connections that matter.",
//     "Your perfect match is just a tap away.",
//     "Real people. Real stories."
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Heart pulse animation
//     _heartController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..repeat(reverse: true);
//
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     )..forward();
//
//     // Rotate quotes every 4 seconds
//     _startQuoteTimer();
//   }
//
//   void _startQuoteTimer() async {
//     while (mounted) {
//       await Future.delayed(const Duration(seconds: 4));
//       if (mounted && !showOtpScreen) {
//         setState(() {
//           _quoteIndex = (_quoteIndex + 1) % quotes.length;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _heartController.dispose();
//     _fadeController.dispose();
//     phoneController.dispose();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   // --- Logic Methods ---
//
//   Future<void> handleSendOtp() async {
//     final mobile = phoneController.text.trim();
//     if (mobile.length < 10) {
//       _showSnackBar("Please enter a valid mobile number");
//       return;
//     }
//
//     setState(() => isLoading = true);
//     final result = await _authService.sendOtp(mobile);
//     setState(() => isLoading = false);
//
//     if (result['success']) {
//       setState(() => showOtpScreen = true);
//       _showSnackBar(result['message']);
//     } else {
//       _showSnackBar(result['message']);
//     }
//   }
//
//   Future<void> handleVerifyAndLogin() async {
//     String otp = otpControllers.map((e) => e.text).join();
//     String mobile = phoneController.text.trim();
//
//     if (otp.length < 4) {
//       _showSnackBar("Please enter complete OTP");
//       return;
//     }
//
//     setState(() => isLoading = true);
//     final verifyResult = await _authService.verifyOtp(mobile, otp);
//
//     if (verifyResult['success']) {
//       bool isProfileDone = verifyResult['isProfileCompleted'] ?? false;
//       final loginResult = await _authService.loginAndSaveToken(mobile: mobile, otp: otp);
//
//       setState(() => isLoading = false);
//
//       if (loginResult['success']) {
//         await _storage.saveLoginStatus(true);
//         await _storage.setFirstTime(false);
//         await _storage.saveProfileStatus(isProfileDone);
//         await _storage.saveMobile(mobile);
//
//         if (!mounted) return;
//         Navigator.pushAndRemoveUntil(
//           context,
//           PageTransition(
//             type: PageTransitionType.fade,
//             child: isProfileDone ? const RootScreen() : const ProfileCompleteFlow(),
//           ),
//               (route) => false,
//         );
//       } else {
//         _showSnackBar(loginResult['message']);
//       }
//     } else {
//       setState(() => isLoading = false);
//       _showSnackBar(verifyResult['message']);
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
//         backgroundColor: const Color(0xFFEE6044),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(20),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
//
//   // --- PREMIUM UI Building Blocks ---
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           // Background with subtle darkening
//           Positioned.fill(
//             child: Image.asset("assets/images/lbg.jpg", fit: BoxFit.cover,filterQuality: FilterQuality.low,cacheWidth: 1080,),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.center,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.2),
//                     Colors.black.withOpacity(0.6),
//                     Colors.black,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Premium blur overlay at top
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.5),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Column(
//               children: [
//                 // Premium Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "INITLY",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 8,
//                         ),
//                       ),
//                       if (!showOtpScreen)
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//
//                           child: Row(
//                             children: [
//
//
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Center(
//                       child: isLoading
//                           ? _buildPremiumLoader()
//                           : AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 500),
//                         child: showOtpScreen ? _buildPremiumOtpScreen() : _buildPremiumLoginScreen(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 _buildPremiumPoweredBy(),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPremiumLoader() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const CircularProgressIndicator(
//           color: Color(0xFFEE6044),
//           strokeWidth: 2,
//         ),
//         const SizedBox(height: 20),
//         Text(
//           "CONNECTING",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.6),
//             fontSize: 10,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 3,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPremiumLoginScreen() {
//     return SingleChildScrollView(
//       child: Column(
//         key: const ValueKey(1),
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Premium quote with glass effect
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.format_quote, color: const Color(0xFFEE6044).withOpacity(0.5), size: 14),
//                 const SizedBox(width: 6),
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 600),
//                   child: Text(
//                     quotes[_quoteIndex],
//                     key: ValueKey(_quoteIndex),
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.7),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       letterSpacing: 0.5,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 40),
//
//           // Premium main heading with better typography
//           const Text(
//             "Find Your\nMatch.",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 48,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -1.5,
//               height: 0.95,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // Subheading
//           Text(
//             "Connect with people who share your vibe",
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.4),
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//               letterSpacing: 0.3,
//             ),
//           ),
//
//           const SizedBox(height: 48),
//
//           // Premium input with better glass effect
//           _buildPremiumGlassInput(
//             controller: phoneController,
//             hint: "Mobile number",
//             icon: Icons.phone_android_rounded,
//           ),
//
//           const SizedBox(height: 30),
//
//           _buildPremiumActionButton("Continue", handleSendOtp),
//
//           const SizedBox(height: 20),
//
//           // Terms text
//           Center(
//             child: Text(
//               "By continuing, you agree to our Terms & Privacy Policy",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.3),
//                 fontSize: 10,
//                 fontWeight: FontWeight.w400,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPremiumOtpScreen() {
//     return SingleChildScrollView(
//       child: Column(
//         key: const ValueKey(2),
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Back button with better design
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: IconButton(
//               onPressed: () => setState(() => showOtpScreen = false),
//               icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
//               style: IconButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Premium heading
//           const Text(
//             "Verify Code",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 36,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -1,
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           // Phone number with highlight
//           RichText(
//             text: TextSpan(
//               text: "Code sent to ",
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.5),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               children: [
//                 TextSpan(
//                   text: "+91 ${phoneController.text}",
//                   style: const TextStyle(
//                     color: Color(0xFFEE6044),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 40),
//
//           // Premium OTP boxes
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: List.generate(4, (index) => _buildPremiumOtpBox(index)),
//           ),
//
//           const SizedBox(height: 40),
//
//           _buildPremiumActionButton("Verify & Login", handleVerifyAndLogin),
//
//           const SizedBox(height: 20),
//
//           // Resend with timer effect
//           Center(
//             child: Column(
//               children: [
//                 Text(
//                   "Didn't receive code?",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: handleSendOtp,
//                   style: TextButton.styleFrom(
//                     foregroundColor: const Color(0xFFEE6044),
//                     textStyle: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   child: const Text("Resend OTP"),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPremiumPoweredBy() {
//     return Column(
//       children: [
//         Container(
//           height: 1,
//           width: 60,
//           color: Colors.white.withOpacity(0.2),
//         ),
//         const SizedBox(height: 15),
//         Text(
//           "POWERED BY",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.3),
//             fontSize: 9,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 2.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "HEART",
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontWeight: FontWeight.w700,
//                 fontSize: 14,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(width: 6),
//             ScaleTransition(
//               scale: Tween(begin: 0.9, end: 1.2).animate(_heartController),
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEE6044).withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.favorite,
//                   color: Color(0xFFEE6044),
//                   size: 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),
//         Text(
//           "© 2026 • All rights reserved",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.2),
//             fontSize: 8,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPremiumGlassInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 18),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.phone,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 1,
//               ),
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(10),
//                 FilteringTextInputFormatter.digitsOnly
//               ],
//               decoration: InputDecoration(
//                 icon: Icon(
//                   icon,
//                   color: const Color(0xFFEE6044),
//                   size: 22,
//                 ),
//                 hintText: hint,
//                 hintStyle: TextStyle(
//                   color: Colors.white.withOpacity(0.3),
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPremiumOtpBox(int index) {
//     return Container(
//       width: 65,
//       height: 70,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               border: Border.all(color: Colors.white.withOpacity(0.15)),
//             ),
//             child: Center(
//               child: TextField(
//                 focusNode: _focusNodes[index],
//                 controller: otpControllers[index],
//                 onChanged: (v) {
//                   if (v.length == 1 && index < 3) {
//                     _focusNodes[index + 1].requestFocus();
//                   }
//                   if (v.isEmpty && index > 0) {
//                     _focusNodes[index - 1].requestFocus();
//                   }
//                 },
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 2,
//                 ),
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(1),
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "•",
//                   hintStyle: TextStyle(
//                     color: Colors.white.withOpacity(0.2),
//                     fontSize: 28,
//                   ),
//                   contentPadding: EdgeInsets.zero,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPremiumActionButton(String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFEE6044), Color(0xFFFF7B5C)],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFEE6044).withOpacity(0.3),
//               blurRadius: 25,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             label.toUpperCase(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//               letterSpacing: 2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../../../controller/services/AuthService.dart';
import '../../../controller/services/StorageService.dart';
import '../../complete_profile/complete_profile.dart';
import '../../rootscreen/rootscreen.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  _AuthFlowState createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> with TickerProviderStateMixin {
  bool showOtpScreen = false;
  bool isLoading = false;
  int _quoteIndex = 0;

  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<String> quotes = [
    "Design your destiny.",
    "Connections that matter.",
    "Your perfect match is just a tap away.",
    "Real people. Real stories.",
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _startQuoteTimer();
  }

  void _startQuoteTimer() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && !showOtpScreen) {
        setState(() => _quoteIndex = (_quoteIndex + 1) % quotes.length);
      }
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    phoneController.dispose();
    for (var c in otpControllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }

  // ── Logic ──

  Future<void> handleSendOtp() async {
    final mobile = phoneController.text.trim();
    if (mobile.length < 10) {
      _showSnackBar("Please enter a valid mobile number");
      return;
    }
    setState(() => isLoading = true);
    final result = await _authService.sendOtp(mobile);
    setState(() => isLoading = false);
    if (result['success']) {
      setState(() => showOtpScreen = true);
    }
    _showSnackBar(result['message']);
  }

  Future<void> handleVerifyAndLogin() async {
    String otp = otpControllers.map((e) => e.text).join();
    String mobile = phoneController.text.trim();
    if (otp.length < 4) {
      _showSnackBar("Please enter complete OTP");
      return;
    }
    setState(() => isLoading = true);
    final verifyResult = await _authService.verifyOtp(mobile, otp);

    if (verifyResult['success']) {
      bool isProfileDone = verifyResult['isProfileCompleted'] ?? false;
      final loginResult = await _authService.loginAndSaveToken(
        mobile: mobile,
        otp: otp,
      );
      setState(() => isLoading = false);

      if (loginResult['success']) {
        await _storage.saveLoginStatus(true);
        await _storage.setFirstTime(false);
        await _storage.saveProfileStatus(isProfileDone);
        await _storage.saveMobile(mobile);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: isProfileDone
                ? const RootScreen()
                : const ProfileCompleteFlow(),
          ),
          (route) => false,
        );
      } else {
        _showSnackBar(loginResult['message']);
      }
    } else {
      setState(() => isLoading = false);
      _showSnackBar(verifyResult['message']);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xffC2185B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/lbg.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              cacheWidth: 1080,
            ),
          ),

          /// Dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x44000000),
                    Color(0xAA000000),
                    Color(0xFF0A0A0F),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          /// Pink glow bottom-left
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffE91E63).withOpacity(0.15),
              ),
            ),
          ),

          /// Pink glow top-right
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffAD1457).withOpacity(0.12),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ScaleTransition(
                            scale: Tween<double>(begin: 0.88, end: 1.12)
                                .animate(
                                  CurvedAnimation(
                                    parent: _pulseCtrl,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                            child: const Icon(
                              Icons.favorite,
                              color: Color(0xffFF4081),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "INITLY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 8,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Center(
                      child: isLoading
                          ? _buildLoader()
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 450),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: showOtpScreen
                                  ? _buildOtpScreen()
                                  : _buildLoginScreen(),
                            ),
                    ),
                  ),
                ),

                _buildFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            color: const Color(0xffFF4081),
            strokeWidth: 1.5,
            backgroundColor: Colors.white.withOpacity(0.08),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "CONNECTING",
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginScreen() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          key: const ValueKey(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Rotating quote chip
              _QuoteChip(quotes: quotes, index: _quoteIndex),

              const SizedBox(height: 36),

              /// Headline
              const Text(
                "Find Your\nMatch.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  height: 0.92,
                  fontFamily: 'Georgia',
                ),
              ),

              const SizedBox(height: 8),

              /// Accent line + subtext
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [Color(0xffFF4081), Color(0xffC2185B)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Connect with people who share your vibe",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              _buildGlassInput(
                controller: phoneController,
                hint: "Enter your mobile number",
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
                formatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 28),

              _GlowButton(label: "Continue", onTap: handleSendOtp),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "By continuing, you agree to our Terms & Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontSize: 10,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpScreen() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Back button
          GestureDetector(
            onTap: () => setState(() => showOtpScreen = false),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            "Verify\nCode",
            style: TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 0.95,
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 28,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [Color(0xffFF4081), Color(0xffC2185B)],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  text: "Sent to ",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12.5,
                  ),
                  children: [
                    TextSpan(
                      text: "+91 ${phoneController.text}",
                      style: const TextStyle(
                        color: Color(0xffFF4081),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (i) => _buildOtpBox(i)),
          ),

          const SizedBox(height: 36),

          _GlowButton(label: "Verify & Login", onTap: handleVerifyAndLogin),

          const SizedBox(height: 24),

          Center(
            child: Column(
              children: [
                Text(
                  "Didn't receive code?",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: handleSendOtp,
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color(0xffFF4081),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffFF4081).withOpacity(0.3),
                      const Color(0xffC2185B).withOpacity(0.2),
                    ],
                  ),
                ),
                child: Icon(icon, color: const Color(0xffFF4081), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: formatters,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 68,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xffFF4081).withOpacity(0.25),
            ),
          ),
          child: TextField(
            focusNode: _focusNodes[index],
            controller: otpControllers[index],
            onChanged: (v) {
              if (v.length == 1 && index < 3) {
                _focusNodes[index + 1].requestFocus();
              }
              if (v.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "·",
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 32,
              ),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(width: 40, height: 1, color: Colors.white.withOpacity(0.12)),
        const SizedBox(height: 12),
        Text(
          "POWERED BY",
          style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 8,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "HEART",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 8),
            ScaleTransition(
              scale: Tween<double>(begin: 0.88, end: 1.14).animate(
                CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffFF4081).withOpacity(0.3),
                      const Color(0xffC2185B).withOpacity(0.2),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xffFF4081),
                  size: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "© 2026 • All rights reserved",
          style: TextStyle(color: Colors.white.withOpacity(0.15), fontSize: 8),
        ),
      ],
    );
  }
}

/// ── Rotating quote chip ──
class _QuoteChip extends StatelessWidget {
  final List<String> quotes;
  final int index;
  const _QuoteChip({required this.quotes, required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: const Color(0xffFF4081).withOpacity(0.7),
                size: 13,
              ),
              const SizedBox(width: 7),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  quotes[index],
                  key: ValueKey(index),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Glowing CTA button ──
class _GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.onTap});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _glow = Tween<double>(
      begin: 10,
      end: 26,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xffFF4081), Color(0xffAD1457)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffE91E63).withOpacity(0.5),
                    blurRadius: _glow.value,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
