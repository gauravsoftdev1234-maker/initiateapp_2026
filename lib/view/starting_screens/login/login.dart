// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';
//
// import '../../../controller/services/AuthService.dart';
// import '../../complete_profile/complete_profile.dart';
//
// class AuthFlow extends StatefulWidget {
//   @override
//   _AuthFlowState createState() => _AuthFlowState();
// }
//
// class _AuthFlowState extends State<AuthFlow> {
//   bool showOtpScreen = false;
//   bool isLoading = false;
//   final TextEditingController phoneController = TextEditingController();
//   // 4 boxes ke liye controllers
//   final List<TextEditingController> otpControllers = List.generate(
//     4,
//     (_) => TextEditingController(),
//   );
//   final AuthService _authService = AuthService();
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
//       _showSnackBar(
//         "OTP sent successfully: ${result['message']}",
//       ); // Sirf testing ke liye message dikhaya hai
//     } else {
//       _showSnackBar(result['message']);
//     }
//   }
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
//
//     // 1. Verify OTP
//     final verifyResult = await _authService.verifyOtp(mobile, otp);
//
//     if (verifyResult['success']) {
//       // 2. Login to get JWT Token
//       final loginResult = await _authService.loginAndSaveToken(
//         mobile: mobile,
//         otp: otp,
//       );
//
//       setState(() => isLoading = false);
//
//       if (loginResult['success']) {
//         // 3. Navigate to Dashboard
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.fade,
//             childBuilder: (context) => ProfileCompleteFlow(),
//           ),
//         );
//       } else {
//         _showSnackBar(loginResult['message']);
//       }
//     } else {
//       setState(() => isLoading = false);
//       _showSnackBar(verifyResult['message']);
//     }
//   }
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/lobg.png"),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Colors.black.withOpacity(0.6),
//                   BlendMode.darken,
//                 ),
//               ),
//             ),
//           ),
//
//           // Content
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: isLoading
//                   ? Center(
//                       child: CircularProgressIndicator(color: Colors.white),
//                     )
//                   : AnimatedSwitcher(
//                       duration: Duration(milliseconds: 500),
//                       child: showOtpScreen
//                           ? _buildOtpScreen()
//                           : _buildLoginScreen(),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- UI Screens ---
//
//   Widget _buildLoginScreen() {
//     return Column(
//       key: ValueKey(1),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Welcome Back",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           "Login to continue your journey",
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//         SizedBox(height: 50),
//         _glassInput(
//           controller: phoneController,
//           hint: "Enter Phone Number",
//           icon: Icons.phone_android,
//           type: TextInputType.phone,
//         ),
//         SizedBox(height: 30),
//         _actionButton("GET OTP", handleSendOtp),
//       ],
//     );
//   }
//
//   Widget _buildOtpScreen() {
//     return Column(
//       key: ValueKey(2),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => setState(() => showOtpScreen = false),
//         ),
//         SizedBox(height: 20),
//         Text(
//           "Verification",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           "We sent a code to ${phoneController.text}",
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//         SizedBox(height: 40),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(4, (index) => _otpBox(index)),
//         ),
//         SizedBox(height: 40),
//         _actionButton("VERIFY & PROCEED", handleVerifyAndLogin),
//         Center(
//           child: TextButton(
//             onPressed: handleSendOtp, // Resend logic
//             child: Text("Resend Code", style: TextStyle(color: Colors.white70)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // --- Helper Components ---
//
//   Widget _otpBox(int index) {
//     return Container(
//       height: 65,
//       width: 65,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.4)),
//       ),
//       child: TextField(
//         controller: otpControllers[index],
//         onChanged: (value) {
//           if (value.length == 1 && index < 3)
//             FocusScope.of(context).nextFocus();
//           if (value.isEmpty && index > 0)
//             FocusScope.of(context).previousFocus();
//         },
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(1),
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: InputDecoration(border: InputBorder.none),
//       ),
//     );
//   }
//
//   Widget _glassInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required TextInputType type,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: type,
//         style: TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.white70),
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.white54),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: 18),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionButton(String label, VoidCallback onTap) {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFFEE6044),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import '../../../controller/services/AuthService.dart';
import '../../complete_profile/complete_profile.dart';

class AuthFlow extends StatefulWidget {
  @override
  _AuthFlowState createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool showOtpScreen = false;
  bool isLoading = false;
  final _storage = const FlutterSecureStorage();
  final TextEditingController phoneController = TextEditingController();
  // 4 boxes ke liye controllers
  final List<TextEditingController> otpControllers = List.generate(
    4,
        (_) => TextEditingController(),
  );
  final AuthService _authService = AuthService();
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
      _showSnackBar(
        "OTP sent successfully: ${result['message']}",
      ); // Sirf testing ke liye message dikhaya hai
    } else {
      _showSnackBar(result['message']);
    }
  }
  // Future<void> handleVerifyAndLogin() async {
  //   String otp = otpControllers.map((e) => e.text).join();
  //   String mobile = phoneController.text.trim();
  //
  //   if (otp.length < 4) {
  //     _showSnackBar("Please enter complete OTP");
  //     return;
  //   }
  //
  //   setState(() => isLoading = true);
  //
  //   // 1. Verify OTP
  //   final verifyResult = await _authService.verifyOtp(mobile, otp);
  //
  //   if (verifyResult['success']) {
  //     // 2. Login to get JWT Token
  //     final loginResult = await _authService.loginAndSaveToken(
  //       mobile: mobile,
  //       otp: otp,
  //     );
  //
  //     setState(() => isLoading = false);
  //
  //     if (loginResult['success']) {
  //
  //       // 3. Navigate to Dashboard
  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.fade,
  //           childBuilder: (context) => ProfileCompleteFlow(),
  //         ),
  //       );
  //     } else {
  //       _showSnackBar(loginResult['message']);
  //     }
  //   } else {
  //     setState(() => isLoading = false);
  //     _showSnackBar(verifyResult['message']);
  //   }
  // }

  Future<void> handleVerifyAndLogin() async {
    String otp = otpControllers.map((e) => e.text).join();
    String mobile = phoneController.text.trim();

    if (otp.length < 4) {
      _showSnackBar("Please enter complete OTP");
      return;
    }

    setState(() => isLoading = true);

    // 1. Verify OTP
    final verifyResult = await _authService.verifyOtp(mobile, otp);

    if (verifyResult['success']) {
      // 2. Login to get JWT Token
      final loginResult = await _authService.loginAndSaveToken(
        mobile: mobile,
        otp: otp,
      );

      if (loginResult['success']) {
        // --- SECURE STORAGE FLAGS START ---

        // User login ho gaya hai
        await _storage.write(key: 'isLoggedIn', value: 'true');

        // Login tak pahunch gaya matlab onboarding dekh chuka hai
        await _storage.write(key: 'isFirstTime', value: 'false');

        // --- SECURE STORAGE FLAGS END ---

        setState(() => isLoading = false);

        // 3. Navigate to Profile Complete Flow
        if (!mounted) return;
        Navigator.pushReplacement( // pushReplacement use karein taaki user back karke OTP screen pe na aaye
          context,
          PageTransition(
            type: PageTransitionType.fade,
            childBuilder: (context) => const ProfileCompleteFlow(),
          ),
        );
      } else {
        setState(() => isLoading = false);
        _showSnackBar(loginResult['message']);
      }
    } else {
      setState(() => isLoading = false);
      _showSnackBar(verifyResult['message']);
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback color
      body: Stack(
        children: [
          // 1. Better Background with Overlay
          Positioned.fill(
            child: Image.asset("assets/images/lobg.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 2. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFEE6044)))
                  : AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: showOtpScreen ? _buildOtpScreen() : _buildLoginScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Modern Login Screen ---
  Widget _buildLoginScreen() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Get Started.",
          style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your phone number to continue.",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
        ),
        const SizedBox(height: 40),
        _modernGlassInput(
          controller: phoneController,
          hint: "Mobile Number",
          icon: Icons.phone_iphone_rounded,
        ),
        const SizedBox(height: 25),
        _mainActionButton("Continue", handleSendOtp),
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              children: const [
                TextSpan(text: "By continuing, you agree to our "),
                TextSpan(text: "Terms & Conditions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Modern OTP Screen ---
  Widget _buildOtpScreen() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => showOtpScreen = false),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          "Sent to +91 ${phoneController.text}",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) => _modernOtpBox(index)),
        ),
        const SizedBox(height: 35),
        _mainActionButton("Verify & Login", handleVerifyAndLogin),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: handleSendOtp,
            child: const Text("Resend Code", style: TextStyle(color: Color(0xFFEE6044), fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- UI Reusable Widgets ---

  Widget _modernGlassInput({required TextEditingController controller, required String hint, required IconData icon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              icon: Icon(icon, color: const Color(0xFFEE6044)),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernOtpBox(int index) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: TextField(
          controller: otpControllers[index],
          onChanged: (value) {
            if (value.length == 1 && index < 3) FocusScope.of(context).nextFocus();
            if (value.isEmpty && index > 0) FocusScope.of(context).previousFocus();
          },
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _mainActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEE6044), Color(0xFFC4452E)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEE6044).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}