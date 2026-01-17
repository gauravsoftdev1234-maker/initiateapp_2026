// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import 'DetailsSheet.dart';
//
// // --- MAIN SCREEN ---
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   final CardSwiperController controller = CardSwiperController();
//
//   final List<Map<String, dynamic>> profiles = [
//     {
//       "name": "Ananya",
//       "age": 23,
//       "loc": "Mumbai",
//       "edu_uni": "Mumbai University",
//       "edu_job": "Software Engineer",
//       "interests": ["Coding", "Coffee", "Hiking", "Yoga"],
//       "bio":
//           "Tech enthusiast who loves to explore hidden cafes in Mumbai and talk about future of AI.",
//       "img":
//           "https://images.unsplash.com/photo-1674116562358-9afaebea36aa?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
//       ],
//     },
//     {
//       "name": "Ishani",
//       "age": 24,
//       "loc": "Bangalore",
//       "edu_uni": "IISc Bangalore",
//       "edu_job": "Data Scientist",
//       "interests": ["Music", "Reading", "Star Gazing"],
//       "bio": "A mix of science and soul. I love exploring data and the stars.",
//       "img":
//       "https://images.unsplash.com/photo-1710449823856-b04144b66b8a?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
//       ],
//     },
//
//   ];
//
//   void _openDetails(Map<String, dynamic> girl) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DetailsSheet(girl: girl),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "Discover",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Iconsax.notification_copy, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: profiles.isEmpty
//           ? const Center(child: Text("No more profiles"))
//           : Column(
//               children: [
//                 Expanded(
//                   child: CardSwiper(
//                     controller: controller,
//                     cardsCount: profiles.length,
//                     numberOfCardsDisplayed: profiles.length >= 3
//                         ? 3
//                         : profiles.length,
//                     backCardOffset: const Offset(0, 40),
//                     padding: const EdgeInsets.all(20),
//                     cardBuilder: (context, index, x, y) {
//                       return Stack(
//                         children: [
//                           _buildCard(profiles[index]),
//                           if (x > 50)
//                             _swipeLabel(
//                               "TERMINATE",
//                               Colors.red,
//                               Alignment.topRight,
//                             ),
//                           if (x < -50)
//                             _swipeLabel(
//                               "INITIATE ",
//                               Colors.green,
//                               Alignment.topLeft,
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 _buildActionButtons(),
//                 const SizedBox(height: 20),
//               ],
//             ),
//     );
//   }
//
//   Widget _swipeLabel(String text, Color color, Alignment align) {
//     // Check kijiye ki left swipe hai ya right, uske hisaab se rotate karein
//     double rotation = align == Alignment.topLeft ? -0.2 : 0.2;
//
//     return Align(
//       alignment: align,
//       child: Transform.rotate(
//         angle: rotation, // Thoda tilt karne ke liye
//         child: Container(
//           margin: const EdgeInsets.all(45),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1), // Glassmorphism effect
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: color,
//               width: 4, // Bold border for stamp look
//             ),
//           ),
//           child: Text(
//             text,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: color,
//               fontSize: 12, // Text size ko thoda bada rakha hai
//               fontWeight: FontWeight.w900,
//               letterSpacing: 1.5,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard(Map<String, dynamic> girl) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         image: DecorationImage(
//           image: NetworkImage(girl['img']),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [Colors.black.withOpacity(0.9), Colors.transparent],
//             stops: const [0.1, 0.45],
//           ),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${girl['name']}, ${girl['age']}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       const Icon(
//                         Iconsax.location_copy,
//                         color: Colors.white70,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(
//                         girl['loc'],
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       const Icon(
//                         Iconsax.teacher_copy,
//                         color: Colors.white70,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(
//                         girl['edu_job'],
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () => _openDetails(girl),
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   color: Colors.white24,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Iconsax.arrow_down_1_copy,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _circleBtn(
//           Iconsax.refresh_copy,
//           Colors.orange,
//           () => controller.undo(),
//         ),
//         _circleBtn(
//           Iconsax.close_circle_copy,
//           Colors.redAccent,
//           () => controller.swipe(CardSwiperDirection.left),
//         ),
//         _circleBtn(
//           Iconsax.heart_copy,
//           Colors.greenAccent.shade700,
//           () => controller.swipe(CardSwiperDirection.right),
//         ),
//         _circleBtn(Iconsax.star_copy, Colors.blueAccent, () {}),
//       ],
//     );
//   }
//
//   Widget _circleBtn(IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 55,
//         width: 55,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.2),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Icon(icon, color: color, size: 26),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'DetailsSheet.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CardSwiperController controller = CardSwiperController();

  // Like Limit Logic
  int _likeCount = 0;
  final int _maxFreeLikes = 10;

  final List<Map<String, dynamic>> profiles = [
    {
      "name": "Ananya",
      "age": 23,
      "loc": "Mumbai",
      "edu_uni": "Mumbai University",
      "edu_job": "Software Engineer",
      "interests": ["Coding", "Coffee", "Hiking", "Yoga"],
      "bio": "Tech enthusiast who loves to explore hidden cafes in Mumbai.",
      "img":
          "https://images.unsplash.com/flagged/photo-1551854716-8b811be39e7e?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D=80&w=500",
      "images": [
        "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
        "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
        "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
        "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
      ],
    },
    {
      "name": "Priya",
      "age": 25,
      "loc": "Delhi",
      "edu_uni": "Delhi University",
      "edu_job": "Software Engineer",
      "interests": ["Coding", "Coffee", "Hiking", "Yoga"],
      "bio": "Tech enthusiast who loves to explore hidden cafes in Mumbai.",
      "img":
      "https://plus.unsplash.com/premium_photo-1682089810582-f7b200217b67?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D=80&w=500",
      "images": [
        "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
        "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
        "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
        "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
      ],
    },
    {
      "name": "Prity Gosh",
      "age": 29,
      "loc": "Kolkata",
      "edu_uni": "Kolkata University",
      "edu_job": "Software Engineer",
      "interests": ["Coding", "Coffee", "Hiking", "Yoga"],
      "bio": "Tech enthusiast who loves to explore hidden cafes in Mumbai.",
      "img":
      "https://images.unsplash.com/photo-1624610806703-99c0852c31c0?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D=80&w=500",
      "images": [
        "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
        "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
        "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
        "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
      ],
    },

  ];

  // Subscription Popup Logic
  void _showSubscriptionPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.heart_add_copy,
              size: 70,
              color: Color(0xFFEE6044),
            ),
            const SizedBox(height: 20),
            const Text(
              "Unlimited Likes!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Send many likes as you want and find your match faster.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEE6044),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Continue for ₹100",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Maybe Later",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(Map<String, dynamic> person) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailsSheet(person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Discover",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification_copy, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: profiles.isEmpty
          ? const Center(child: Text("Searching for more..."))
          : Column(
              children: [
                Expanded(
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: profiles.length,
                    numberOfCardsDisplayed: profiles.length >= 3
                        ? 3
                        : profiles.length,
                    onSwipe: (prev, curr, dir) {
                      if (dir == CardSwiperDirection.right) {
                        _likeCount++;
                        if (_likeCount >= _maxFreeLikes) {
                          _showSubscriptionPopup();
                        }
                      }
                      return true;
                    },
                    cardBuilder: (context, index, x, y) {
                      return Stack(
                        children: [
                          _buildCard(profiles[index]),
                          if (x < -50)
                            _swipeLabel(
                              "INITIATE",
                              Colors.green,
                              Alignment.topLeft,
                            ),
                          if (x > 50)

                          _swipeLabel(
                            "TERMINATE",
                            Colors.red,
                            Alignment.topRight,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _swipeLabel(String text, Color color, Alignment align) {
    double rotation = align == Alignment.topLeft ? -0.2 : 0.2;
    return Align(
      alignment: align,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          margin: const EdgeInsets.all(45),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> girl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(girl['img']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            stops: const [0.1, 0.45],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${girl['name']}, ${girl['age']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _cardSubText(Iconsax.location_copy, girl['loc']),
                  _cardSubText(Iconsax.teacher_copy, girl['edu_job']),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _openDetails(girl),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.arrow_down_1_copy,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardSubText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleBtn(
          Iconsax.refresh_copy,
          Colors.orange,
          () => controller.undo(),
        ),
        _circleBtn(
          Iconsax.close_circle_copy,
          Colors.redAccent,
          () => controller.swipe(CardSwiperDirection.left),
        ),
        _circleBtn(
          Iconsax.heart_copy,
          Colors.greenAccent.shade700,
          () => controller.swipe(CardSwiperDirection.right),
        ),
        _circleBtn(Iconsax.star_copy, Colors.blueAccent, () {}),
      ],
    );
  }

  Widget _circleBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
