// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Add this import for precaching
// import 'package:initiate/view/starting_screens/login/login.dart';
// import 'package:page_transition/page_transition.dart';
// import '../../../model/onboarding_model.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   int _currentIndex = 0;
//   late PageController _controller;
//   final List<ImageProvider> _imageProviders = [];
//
//   final Color kPrimaryColor = const Color(0xFFE5573E);
//
//   @override
//   void initState() {
//     _controller = PageController(initialPage: 0);
//
//     // Preload images to prevent flickering
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _precacheImages();
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _precacheImages() {
//     for (var content in contents) {
//       if (content.imagePath != null && content.imagePath!.isNotEmpty) {
//         try {
//           // Create image provider and cache it
//           final imageProvider = AssetImage(content.imagePath!);
//           precacheImage(imageProvider, context);
//           _imageProviders.add(imageProvider);
//         } catch (e) {
//           // If image fails to load, add null to maintain index
//           _imageProviders.add(AssetImage(''));
//         }
//       } else {
//         _imageProviders.add(AssetImage(''));
//       }
//     }
//   }
//
//   final List<OnboardingContent> contents = [
//     OnboardingContent(
//       title: "Discover socializing:\nWhere your social\ncircle begins!",
//       description:
//           "The platform to expand your social circle with new friends and shared experiences!",
//       imagePath: "assets/images/onboarding_images/onboarding1.jpg",
//       iconPlaceholder: Icons.people_alt_rounded,
//     ),
//     OnboardingContent(
//       title: "Made Friends,\nTalk to them,\nMake bonds.",
//       description:
//           "Now, talk, bond, and turn connections into meaningful relationships!",
//       imagePath: "assets/images/onboarding_images/onboarding2.jpg",
//       iconPlaceholder: Icons.chat_bubble_outline_rounded,
//     ),
//     OnboardingContent(
//       title: "Meet new\npeople in your\narea",
//       description: "Expand your social circle with exciting local connections!",
//       imagePath: "assets/images/onboarding_images/onboarding3.jpg",
//       iconPlaceholder: Icons.map_outlined,
//     ),
//     OnboardingContent(
//       title: "Get\nReady",
//       description:
//           "Unlock a new world of connections with Discover Socializing.",
//       imagePath: "assets/images/onboarding_images/onboarding1.jpg",
//       iconPlaceholder: Icons.rocket_launch_outlined,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // 1. TOP BAR (Skip Button)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     _controller.jumpToPage(contents.length - 1);
//                   },
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 16,
//                       fontFamily: 'Lufga',
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // 2. MIDDLE CONTENT (PageView)
//             Expanded(
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: contents.length,
//                 onPageChanged: (int index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 itemBuilder: (_, i) {
//                   return AnimatedBuilder(
//                     animation: _controller,
//                     builder: (context, child) {
//                       // Calculate page offset for smooth transitions
//                       double pageOffset = 0;
//                       if (_controller.position.haveDimensions) {
//                         pageOffset = _controller.page! - i;
//                       }
//
//                       return Transform.translate(
//                         offset: Offset(pageOffset * 50, 0),
//                         child: Opacity(
//                           opacity: 1 - pageOffset.abs(),
//                           child: Padding(
//                             padding: const EdgeInsets.all(30),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: Container(
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[50],
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.grey[100]!,
//                                       ),
//                                     ),
//                                     child: _buildImageWidget(i),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 40),
//
//                                 // --- TITLE WITH LUFGA ---
//                                 Text(
//                                   contents[i].title,
//                                   style: const TextStyle(
//                                     fontFamily: 'Lufga',
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.0,
//                                     letterSpacing: -0.5,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 15),
//
//                                 // --- DESCRIPTION WITH LUFGA ---
//                                 Text(
//                                   contents[i].description,
//                                   style: TextStyle(
//                                     fontFamily: 'Lufga',
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                     height: 1.5,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Expanded(flex: 1, child: Container()),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//
//             // 3. BOTTOM NAVIGATION AREA
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (_currentIndex != contents.length - 1)
//                     Row(
//                       children: List.generate(
//                         contents.length,
//                         (index) => buildDot(index, context),
//                       ),
//                     )
//                   else
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: kPrimaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.favorite,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//
//                   if (_currentIndex == contents.length - 1)
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               PageTransition(
//                                 type: PageTransitionType.fade,
//                                 childBuilder: (context) => AuthFlow()
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFFF4F46),
//                             foregroundColor: Colors.black,
//                             elevation: 0,
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: const Text(
//                             "Get started",
//                             style: TextStyle(
//                               fontFamily: 'Lufga',
//                               fontSize: 14,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     GestureDetector(
//                       onTap: () {
//                         _controller.nextPage(
//                           duration: const Duration(
//                             milliseconds: 500,
//                           ), // Increased duration
//                           curve: Curves.easeInOut, // Smoother curve
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: kPrimaryColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildImageWidget(int index) {
//     final content = contents[index];
//
//     if (content.imagePath != null && content.imagePath!.isNotEmpty) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(100),
//         child: _imageProviders.isNotEmpty && index < _imageProviders.length
//             ? Image(
//           // Solution: ResizeImage provider use karein quality limit karne ke liye
//           image: ResizeImage(
//             _imageProviders[index],
//             width: 700, // Quality reduce karne ke liye target width
//           ),
//           fit: BoxFit.cover,
//           frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//             if (wasSynchronouslyLoaded) return child;
//             return AnimatedOpacity(
//               opacity: frame == null ? 0 : 1,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//               child: child,
//             );
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(content.iconPlaceholder, size: 100, color: kPrimaryColor);
//           },
//         )
//             : Image.asset(
//           content.imagePath!,
//           fit: BoxFit.cover,
//           cacheWidth: 300, // Image.asset mein ye parameter chalta hai
//           cacheHeight: 300,
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(content.iconPlaceholder, size: 100, color: kPrimaryColor);
//           },
//         ),
//       );
//     }
//
//     return Icon(content.iconPlaceholder, size: 100, color: kPrimaryColor);
//   }
//
//   Container buildDot(int index, BuildContext context) {
//     return Container(
//       height: 8,
//       width: _currentIndex == index ? 24 : 8,
//       margin: const EdgeInsets.only(right: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: _currentIndex == index ? kPrimaryColor : const Color(0xFFD6D6D6),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:initiate/view/starting_screens/login/login.dart'; // Apne path ke hisaab se check karein
import 'package:page_transition/page_transition.dart';

// Model definition (In case it's not in a separate file)
class OnboardingContent {
  final String title;
  final String description;
  final String? imagePath;
  final IconData iconPlaceholder;

  OnboardingContent({
    required this.title,
    required this.description,
    this.imagePath,
    required this.iconPlaceholder,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  late PageController _controller;
  final List<ImageProvider> _imageProviders = [];
  final Color kPrimaryColor = const Color(0xFFFF4F46); // Modern Vibrant Red

  final List<OnboardingContent> contents = [
    OnboardingContent(
      title: "Find your\nperfect Spark ✨",
      description: "Stop scrolling, start connecting. Our algorithm finds the person who truly matches your vibe.",
      imagePath: "assets/images/onboarding_images/onboarding1.jpg",
      iconPlaceholder: Icons.auto_awesome_rounded,
    ),
    OnboardingContent(
      title: "Real Chats,\nZero Noise 💬",
      description: "Genuine conversations that lead to meaningful bonds. No more ghosting, just real connections.",
      imagePath: "assets/images/onboarding_images/onboarding2.jpg",
      iconPlaceholder: Icons.chat_bubble_rounded,
    ),
    OnboardingContent(
      title: "Meet People\nIn Your Area 📍",
      description: "Discover amazing people just around the corner. Your next best friend or partner is closer than you think.",
      imagePath: "assets/images/onboarding_images/onboarding3.jpg",
      iconPlaceholder: Icons.location_on_rounded,
    ),
    OnboardingContent(
      title: "Ready to Initiate ? ❤️",
      description: "Join thousands of people finding their soulmates every day. Your journey starts now.",
      imagePath: "assets/images/onboarding_images/onboarding4.png",
      iconPlaceholder: Icons.rocket_launch_rounded,
    ),
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _precacheImages();
    super.initState();
  }

  void _precacheImages() {
    for (var content in contents) {
      if (content.imagePath != null) {
        final imageProvider = AssetImage(content.imagePath!);
        _imageProviders.add(imageProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // SKIP BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _controller.jumpToPage(contents.length - 1),
                  child: Text("Skip", style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),

            // MIDDLE CONTENT
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (_, i) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double pageOffset = 0;
                      if (_controller.position.haveDimensions) pageOffset = _controller.page! - i;

                      return Opacity(
                        opacity: (1 - pageOffset.abs()).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Circular Image Container
                              Container(
                                height: MediaQuery.of(context).size.width * 0.75,
                                width: MediaQuery.of(context).size.width * 0.75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 30, spreadRadius: 5)
                                  ],
                                ),
                                child: _buildImageWidget(i),
                              ),
                              const SizedBox(height: 50),

                              // Title
                              Text(
                                contents[i].title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1),
                              ),
                              const SizedBox(height: 20),

                              // Description
                              Text(
                                contents[i].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // BOTTOM CONTROLS
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicator
                  Row(
                    children: List.generate(contents.length, (index) => _buildDot(index)),
                  ),

                  // Action Button
                  _currentIndex == contents.length - 1
                      ? _buildStartButton()
                      : _buildNextButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(int index) {
    final content = contents[index];
    return ClipOval(
      child: Image.asset(
        content.imagePath ?? "",
        fit: BoxFit.cover,
        cacheWidth: 800, // Reduced quality for performance
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[100],
          child: Icon(content.iconPlaceholder, size: 80, color: kPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentIndex == index ? kPrimaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  AuthFlow()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text("Get Started", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

