// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
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
//       "name": "Ananya", "age": 23, "loc": "Mumbai",
//       "img": "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500"
//       ],
//       "bio": "Fashion designer & coffee enthusiast. Always looking for new cafes to explore in Mumbai!"
//     },
//     {
//       "name": "Ishani", "age": 24, "loc": "Bangalore",
//       "img": "https://images.unsplash.com/photo-1634155100346-633f24a35766?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1634155100346-633f24a35766?q=80&w=500",
//         "https://images.unsplash.com/photo-1619613143920-94f4a38f383e?q=80&w=500",
//         "https://images.unsplash.com/photo-1595211097188-12c8279023c9?q=80&w=500",
//         "https://images.unsplash.com/photo-1604004541734-8af971d6f5a8?q=80&w=500"
//       ],
//       "bio": "Techie by day, dancer by night. Let's talk about startups and salsa."
//     },
//     {
//       "name": "Aditi", "age": 22, "loc": "Pune",
//       "img": "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1614289365518-735f7a5615cd?q=80&w=500",
//         "https://images.unsplash.com/photo-1622227181313-1725594b2323?q=80&w=500"
//       ],
//       "bio": "Architecture student. I love historic buildings and photography."
//     },
//     {
//       "name": "Sanya", "age": 25, "loc": "Chandigarh",
//       "img": "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500",
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=500",
//         "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500"
//       ],
//       "bio": "Fitness lover. If I'm not at the gym, I'm probably at a pet cafe."
//     },
//     {
//       "name": "Mehak", "age": 20, "loc": "Jaipur",
//       "img": "https://images.unsplash.com/photo-1619613143920-94f4a38f383e?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1619613143920-94f4a38f383e?q=80&w=500",
//         "https://images.unsplash.com/photo-1595211097188-12c8279023c9?q=80&w=500",
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1588516999521-4303334e5191?q=80&w=500"
//       ],
//       "bio": "Artist and dreamer. Jaipur's culture is my biggest inspiration."
//     },
//     {
//       "name": "Riya", "age": 23, "loc": "Hyderabad",
//       "img": "https://images.unsplash.com/photo-1622227181313-1725594b2323?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1622227181313-1725594b2323?q=80&w=500",
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=500",
//         "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=500"
//       ],
//       "bio": "Foodie for life. Biryani is my love language. Let's discover new eateries!"
//     },
//     {
//       "name": "Kavya", "age": 22, "loc": "Chennai",
//       "img": "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1617922001439-4a2e6562f328?q=80&w=500",
//         "https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?q=80&w=500",
//         "https://images.unsplash.com/photo-1634155100346-633f24a35766?q=80&w=500",
//         "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=500"
//       ],
//       "bio": "Yoga practitioner and nature lover. Peace over everything."
//     },
//     {
//       "name": "Sneha", "age": 24, "loc": "Kolkata",
//       "img": "https://images.unsplash.com/photo-1614289365518-735f7a5615cd?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1614289365518-735f7a5615cd?q=80&w=500",
//         "https://images.unsplash.com/photo-1621184455862-c163dfb30e0f?q=80&w=500",
//         "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=500",
//         "https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?q=80&w=500"
//       ],
//       "bio": "Bookworm. You can find me in old libraries or quaint bookstores."
//     },
//     {
//       "name": "Tanya", "age": 21, "loc": "Lucknow",
//       "img": "https://images.unsplash.com/photo-1595211097188-12c8279023c9?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1595211097188-12c8279023c9?q=80&w=500",
//         "https://images.unsplash.com/photo-1634155100346-633f24a35766?q=80&w=500",
//         "https://images.unsplash.com/photo-1619613143920-94f4a38f383e?q=80&w=500",
//         "https://images.unsplash.com/photo-1604004541734-8af971d6f5a8?q=80&w=500"
//       ],
//       "bio": "Classical singer. Exploring the depths of music and life."
//     },
//     {
//       "name": "Priya", "age": 22, "loc": "Delhi",
//       "img": "https://images.unsplash.com/photo-1604004541734-8af971d6f5a8?q=80&w=500",
//       "images": [
//         "https://images.unsplash.com/photo-1604004541734-8af971d6f5a8?q=80&w=500",
//         "https://images.unsplash.com/photo-1622227181313-1725594b2323?q=80&w=500",
//         "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=500",
//         "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?q=80&w=500"
//       ],
//       "bio": "Journalist. I love telling stories that matter. Big traveler!"
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text("Discover", style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
//       ),
//       body: profiles.isEmpty
//           ? const Center(child: Text("No more profiles"))
//           : Column(
//         children: [
//           Expanded(
//             child: CardSwiper(
//               controller: controller,
//               cardsCount: profiles.length,
//               // FIX: Dynamic cards display based on list length to avoid assertion error
//               numberOfCardsDisplayed: profiles.length >= 3 ? 3 : profiles.length,
//               backCardOffset: const Offset(0, 40),
//               padding: const EdgeInsets.all(20),
//               cardBuilder: (context, index, x, y) {
//                 return Stack(
//                   children: [
//                     _buildCard(profiles[index]),
//                     if (x > 50) _swipeLabel("INITIATE MATCH", Colors.green, Alignment.topLeft),
//                     if (x < -50) _swipeLabel("TERMINATE", Colors.red, Alignment.topRight),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _buildActionButtons(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
// // --- Same UI helper widgets as before (SwipeLabel, BuildCard, ActionButtons) ---
// // ... (Paste your existing helper methods here)
// }