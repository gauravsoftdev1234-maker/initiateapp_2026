import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// class ChatMainScreen extends StatefulWidget {
//   const ChatMainScreen({super.key});
//
//   @override
//   State<ChatMainScreen> createState() => _ChatMainScreenState();
// }
//
// class _ChatMainScreenState extends State<ChatMainScreen> {
//   final Color kPrimaryColor = const Color(0xFFFF4F46);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const Padding(
//           padding: EdgeInsets.all(10.0),
//           child: CircleAvatar(
//             backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200"),
//           ),
//         ),
//         title: Text("Chats",
//             style: GoogleFonts.poppins(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
//         centerTitle: true,
//         actions: [
//           IconButton(icon: const Icon(Iconsax.more_circle, color: Colors.grey), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           // --- Indian Style Status/Stories Section ---
//           _buildStatusSection(),
//
//           const Divider(thickness: 0.5, height: 1, color: Color(0xFFEEEEEE)),
//
//           // --- Chat List with Indian Names ---
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               children: [
//                 _buildChatTile("Ananya Sharma", "Kal milte hain pakka! ☕", "18:31", 3, "https://i.pravatar.cc/150?u=a1"),
//                 _buildChatTile("Rahul Verma", "Hello, dinner ka kya plan hai?", "16:04", 0, "https://i.pravatar.cc/150?u=r1", isOnline: true),
//                 _buildChatTile("Priyanka Nair", "Haan, main images bhej rahi hoon.", "06:12", 0, "https://i.pravatar.cc/150?u=p1"),
//                 _buildChatTile("Ishaan Malhotra", "Thanks bhai! 😇", "Yesterday", 0, "https://i.pravatar.cc/150?u=i1"),
//                 _buildChatTile("Sanya Gupta", "Meeting kab start hogi?", "Yesterday", 0, "https://i.pravatar.cc/150?u=s1"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- WhatsApp Style Status Section ---
//   Widget _buildStatusSection() {
//     return Container(
//       height: 110,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         children: [
//           _statusItem("My Status", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200", isMe: true),
//           _statusItem("Ananya", "https://i.pravatar.cc/150?u=a1", hasUpdate: true),
//           _statusItem("Rahul", "https://i.pravatar.cc/150?u=r1", hasUpdate: true),
//           _statusItem("Sanya", "https://i.pravatar.cc/150?u=s1", hasUpdate: false),
//           _statusItem("Priyanka", "https://i.pravatar.cc/150?u=p1", hasUpdate: true),
//           _statusItem("Amit", "https://i.pravatar.cc/150?u=am1", hasUpdate: false),
//         ],
//       ),
//     );
//   }
//
//   Widget _statusItem(String name, String img, {bool hasUpdate = false, bool isMe = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 18),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(2.5),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isMe ? Colors.transparent : (hasUpdate ? kPrimaryColor : Colors.grey[300]!),
//                     width: 2.5,
//                   ),
//                 ),
//                 child: CircleAvatar(
//                   radius: 26,
//                   backgroundImage: NetworkImage(img),
//                 ),
//               ),
//               if (isMe)
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
//                     child: const Icon(Icons.add, color: Colors.white, size: 12),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             name,
//             style: GoogleFonts.poppins(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChatTile(String name, String msg, String time, int count, String img, {bool isOnline = false}) {
//     return ListTile(
//       onTap: () {},
//       contentPadding: const EdgeInsets.symmetric(vertical: 6),
//       leading: Stack(
//         children: [
//           CircleAvatar(radius: 26, backgroundImage: NetworkImage(img)),
//           if (isOnline)
//             Positioned(
//                 right: 1,
//                 bottom: 1,
//                 child: Container(
//                     height: 12,
//                     width: 12,
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2)
//                     )
//                 )
//             ),
//         ],
//       ),
//       title: Text(name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF2E3E5C))),
//       subtitle: Text(msg, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(time, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 6),
//           if (count > 0)
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
//               child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Dark Background
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Top Image with Orange Glow Border
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFEE6044).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEE6044).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.network(
                  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=500', // Hardworking / Chat related image
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 2. Main Title
            const Text(
              'COMING SOON!',
              style: TextStyle(
                fontFamily: 'Lufga', // Using your app font
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // 3. Subtitle / Description
            const Text(
              "We're working in a lot of effort to bring\nthis feature to you. Stay tuned!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lufga',
                fontSize: 16,
                color: Colors.deepOrange,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 60),

            // 4. Custom Loading Indicator (Orange Circle)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 0.7, // 70% progress dikhane ke liye
                    strokeWidth: 6,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFEE6044).withOpacity(0.8),
                    ),
                  ),
                ),
                const Text(
                  "70%",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Optional: Tagline
            Text(
              "Progress: Hard at work",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
