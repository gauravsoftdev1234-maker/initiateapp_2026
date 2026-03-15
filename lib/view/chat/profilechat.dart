//
// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../controller/services/StorageService.dart';
// import '../../controller/services/app_api_service.dart';
//
// class Profilechat extends StatefulWidget {
//   final String userid;
//   const Profilechat({super.key, required this.userid});
//
//   @override
//   State<Profilechat> createState() => _ProfilechatState();
// }
//
// class _ProfilechatState extends State<Profilechat> {
//   Map<String, dynamic>? userData;
//   List<String> allImages = [];
//   bool isLoading = true;
//   int _currentPage = 0;
//
//   // Premium palette
//   static const Color _bg = Color(0xFFF5F6F8);
//   static const Color _card = Colors.white;
//   static const Color _text = Color(0xFF101828);
//   static const Color _sub = Color(0xFF667085);
//   static const Color _line = Color(0xFFE5E7EB);
//
//   // Accent colors for Icons (premium)
//   static const Color _primary = Color(0xFFFD5068);
//   static const Color _blue = Color(0xFF2F80ED);
//   static const Color _green = Color(0xFF12B76A);
//   static const Color _orange = Color(0xFFF79009);
//   static const Color _purple = Color(0xFF7A5AF8);
//
//   @override
//   void initState() {
//     super.initState();
//     userbasedProfile();
//   }
//
//   bool _isValidHttpUrl(String? url) {
//     if (url == null) return false;
//     final u = url.trim();
//     return u.startsWith('http://') || u.startsWith('https://');
//   }
//
//   Future<void> userbasedProfile() async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       final response = await http.get(
//         Uri.parse("$base/api/Profile/GetUserProfileByIdV2?ToUserid=${widget.userid}"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (!mounted) return;
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['isSuccess'] == true && (data['Response'] ?? []).isNotEmpty) {
//           var user = data['Response'][0];
//
//           final List<String> tempImages = [];
//           final profilePic = (user['profilepic'] ?? user['ProfilePic'] ?? '').toString();
//           if (_isValidHttpUrl(profilePic)) tempImages.add(profilePic);
//
//           if (user['userImage'] != null && user['userImage'] is List) {
//             for (var img in user['userImage']) {
//               final url = (img['PhotoUrl'] ?? '').toString();
//               if (_isValidHttpUrl(url)) tempImages.add(url);
//             }
//           }
//
//           setState(() {
//             userData = user;
//             allImages = tempImages.toSet().toList();
//             isLoading = false;
//           });
//           return;
//         }
//       }
//       setState(() => isLoading = false);
//     } catch (_) {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   int _calculateAgeFromDob(String dob) {
//     try {
//       final parts = dob.split(RegExp(r'[-/]+'));
//       if (parts.length < 3) return 0;
//
//       int year;
//       if (parts[0].length == 4) {
//         year = int.parse(parts[0]); // yyyy-MM-dd
//       } else {
//         year = int.parse(parts[2]); // dd-MM-yyyy
//       }
//       final now = DateTime.now();
//       return now.year - year;
//     } catch (_) {
//       return 0;
//     }
//   }
//
//   String _safeText(dynamic v, {String fallback = "Not specified"}) {
//     final s = (v ?? '').toString().trim();
//     return s.isEmpty ? fallback : s;
//   }
//
//   void _prevPhoto() {
//     if (allImages.isEmpty) return;
//     if (_currentPage > 0) setState(() => _currentPage--);
//   }
//
//   void _nextPhoto() {
//     if (allImages.isEmpty) return;
//     if (_currentPage < allImages.length - 1) setState(() => _currentPage++);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final name = _safeText(userData?['FullName'], fallback: '');
//     final dob = _safeText(userData?['DOB'], fallback: '');
//     final age = dob.isEmpty ? '' : _calculateAgeFromDob(dob).toString();
//     final titleText = (name.isEmpty)
//         ? 'Profile'
//         : (age.isEmpty || age == '0')
//         ? name
//         : '$name, $age';
//
//     return Scaffold(
//       backgroundColor: _bg,
//       body: SafeArea(
//         child: isLoading
//             ? _buildLoading()
//             : (userData == null)
//             ? _buildErrorState()
//             : CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               pinned: true,
//               elevation: 0,
//               backgroundColor: _bg,
//               leading: IconButton(
//                 icon: const Icon(Iconsax.arrow_left_2, color: _text),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               title: Text(
//                 titleText,
//                 style: const TextStyle(
//                   color: _text,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                   letterSpacing: 0.1,
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Iconsax.more, color: _text),
//                 ),
//               ],
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
//                 child: Column(
//                   children: [
//                     _buildImageHero(),
//                     const SizedBox(height: 12),
//
//                     _buildQuickChips(),
//                     const SizedBox(height: 12),
//
//                     _infoCard(
//                       title: "Looking for",
//                       subtitle: _safeText(userData?['LookingFor'], fallback: 'Not specified'),
//                       leadingIcon: Iconsax.heart,
//                       iconColor: _primary,
//                       trailing: _pill("Preference"),
//                     ),
//
//                     _infoCard(
//                       title: "Essentials",
//                       subtitle: "Basics about $name",
//                       leadingIcon: Iconsax.user,
//                       iconColor: _blue,
//                       child: Column(
//                         children: [
//                           _rowTile(Iconsax.location, "Distance",
//                               _safeText(userData?['DistanceKm'], fallback: '—'), _orange),
//                           _divider(),
//                           _rowTile(Iconsax.cake, "DOB", _safeText(userData?['DOB'], fallback: '—'), _purple),
//                           _divider(),
//                           _rowTile(Iconsax.woman, "Gender",
//                               _safeText(userData?['Gender'], fallback: '—'), _primary),
//                           _divider(),
//                           _rowTile(Iconsax.ruler, "Height",
//                               "${_safeText(userData?['HeightCm'], fallback: '—')} cm", _green),
//                         ],
//                       ),
//                     ),
//
//                     if ((_safeText(userData?['Bio'], fallback: '')).isNotEmpty)
//                       _infoCard(
//                         title: "About",
//                         subtitle: "A few words",
//                         leadingIcon: Iconsax.note_2,
//                         iconColor: _purple,
//                         child: Text(
//                           _safeText(userData?['Bio'], fallback: ''),
//                           style: const TextStyle(
//                             fontSize: 13,
//                             height: 1.45,
//                             color: _text,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//
//                     const SizedBox(height: 12),
//                     _shareCard(name),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // -------------------------
//   // Loading / Error
//   // -------------------------
//   Widget _buildLoading() {
//     return Padding(
//       padding: const EdgeInsets.all(14),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 _shimmerCircle(42),
//                 const SizedBox(width: 10),
//                 Expanded(child: _shimmerBox(height: 16, radius: 10)),
//                 const SizedBox(width: 10),
//                 _shimmerCircle(36),
//               ],
//             ),
//             const SizedBox(height: 14),
//             _shimmerBox(height: 520, radius: 18),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(child: _shimmerBox(height: 34, radius: 18)),
//                 const SizedBox(width: 10),
//                 Expanded(child: _shimmerBox(height: 34, radius: 18)),
//                 const SizedBox(width: 10),
//                 Expanded(child: _shimmerBox(height: 34, radius: 18)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _shimmerBox(height: 110, radius: 16),
//             const SizedBox(height: 12),
//             _shimmerBox(height: 190, radius: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Iconsax.info_circle, size: 54, color: Colors.grey.shade500),
//             const SizedBox(height: 10),
//             const Text(
//               "Profile not available",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Please try again.",
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 14),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() => isLoading = true);
//                 userbasedProfile();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _text,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//               ),
//               child: const Text("Retry", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // -------------------------
//   // Premium Image Hero
//   // -------------------------
//   Widget _buildImageHero() {
//     final hasImage = allImages.isNotEmpty && _isValidHttpUrl(allImages[_currentPage]);
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(18),
//       child: Stack(
//         children: [
//           SizedBox(
//             height: 520,
//             width: double.infinity,
//             child: hasImage
//                 ? Image.network(
//               allImages[_currentPage],
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, progress) {
//                 if (progress == null) return child;
//                 return Shimmer.fromColors(
//                   baseColor: Colors.grey.shade300,
//                   highlightColor: Colors.grey.shade100,
//                   child: Container(color: Colors.grey.shade300),
//                 );
//               },
//               errorBuilder: (_, __, ___) => _imageFallback(),
//             )
//                 : _imageFallback(),
//           ),
//
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.05),
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           if (allImages.length > 1)
//             Positioned(
//               top: 14,
//               left: 14,
//               right: 14,
//               child: Row(
//                 children: List.generate(allImages.length, (index) {
//                   final active = _currentPage == index;
//                   return Expanded(
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 220),
//                       height: 3,
//                       margin: const EdgeInsets.symmetric(horizontal: 2),
//                       decoration: BoxDecoration(
//                         color: active ? Colors.white : Colors.white.withOpacity(0.35),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//
//           Positioned(
//             top: 18,
//             right: 14,
//             child: _glassPill("${_currentPage + 1}/${allImages.isEmpty ? 1 : allImages.length}"),
//           ),
//
//           Positioned.fill(
//             child: Row(
//               children: [
//                 Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _prevPhoto)),
//                 Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _nextPhoto)),
//               ],
//             ),
//           ),
//
//           Positioned(
//             bottom: 14,
//             left: 14,
//             right: 14,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _glassIcon(Iconsax.arrow_left_2, onTap: _prevPhoto),
//                 _glassIcon(Iconsax.arrow_right_3, onTap: _nextPhoto),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _imageFallback() {
//     return Container(
//       color: Colors.grey.shade200,
//       child: Center(
//         child: Icon(Iconsax.user, size: 64, color: Colors.grey.shade500),
//       ),
//     );
//   }
//
//   Widget _glassPill(String text) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(22),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           color: Colors.black.withOpacity(0.25),
//           child: Text(
//             text,
//             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _glassIcon(IconData icon, {required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             width: 42,
//             height: 42,
//             alignment: Alignment.center,
//             color: Colors.white.withOpacity(0.18),
//             child: Icon(icon, size: 18, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // -------------------------
//   // Cards / Rows
//   // -------------------------
//   Widget _infoCard({
//     required String title,
//     required String subtitle,
//     required IconData leadingIcon,
//     required Color iconColor,
//     Widget? trailing,
//     Widget? child,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: _card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _line),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: iconColor.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(leadingIcon, size: 18, color: iconColor),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: _text,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         color: _sub,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               if (trailing != null) trailing,
//             ],
//           ),
//           if (child != null) ...[
//             const SizedBox(height: 12),
//             child,
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _rowTile(IconData icon, String label, String value, Color iconColor) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 16, color: iconColor),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _text),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _sub),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _divider() => Divider(height: 1, thickness: 1, color: _line.withOpacity(0.9));
//
//   // -------------------------
//   // Chips
//   // -------------------------
//   Widget _buildQuickChips() {
//     final gender = _safeText(userData?['Gender'], fallback: '');
//     final height = _safeText(userData?['HeightCm'], fallback: '');
//     final looking = _safeText(userData?['LookingFor'], fallback: '');
//
//     final chips = <String>[];
//     if (gender.isNotEmpty && gender != 'Not specified') chips.add(gender);
//     if (height.isNotEmpty && height != 'Not specified') chips.add("$height cm");
//     if (looking.isNotEmpty && looking != 'Not specified') chips.add(looking);
//
//     if (chips.isEmpty) chips.addAll(["Verified", "Modern", "Premium"]);
//
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: chips.take(4).map((t) => _pill(t)).toList(),
//       ),
//     );
//   }
//
//   Widget _pill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F4F7),
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: _line),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _text),
//       ),
//     );
//   }
//
//   Widget _shareCard(String name) {
//     final n = name.isEmpty ? "this" : name;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: _card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _line),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: _blue.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Iconsax.share, size: 18, color: _blue),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "Share $n profile",
//               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _text),
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             style: TextButton.styleFrom(foregroundColor: _primary),
//             child: const Text("Share", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // -------------------------
//   // Shimmer Helpers
//   // -------------------------
//   Widget _shimmerBox({required double height, double radius = 14}) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         height: height,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(radius),
//         ),
//       ),
//     );
//   }
//
//   Widget _shimmerCircle(double size) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

class Profilechat extends StatefulWidget {
  final String userid;
  const Profilechat({super.key, required this.userid});

  @override
  State<Profilechat> createState() => _ProfilechatState();
}

class _ProfilechatState extends State<Profilechat> {
  Map<String, dynamic>? userData;
  List<String> allImages = [];
  bool isLoading = true;
  int _currentPage = 0;

  // Premium palette
  static const Color _bg = Color(0xFFF5F6F8);
  static const Color _card = Colors.white;
  static const Color _text = Color(0xFF101828);
  static const Color _sub = Color(0xFF667085);
  static const Color _line = Color(0xFFE5E7EB);

  // Accent colors
  static const Color _primary = Color(0xFFFD5068);
  static const Color _blue = Color(0xFF2F80ED);
  static const Color _green = Color(0xFF12B76A);
  static const Color _orange = Color(0xFFF79009);
  static const Color _purple = Color(0xFF7A5AF8);

  @override
  void initState() {
    super.initState();
    userbasedProfile();
  }

  bool _isValidHttpUrl(String? url) {
    if (url == null) return false;
    final u = url.trim();
    return u.startsWith('http://') || u.startsWith('https://');
  }

  Future<void> userbasedProfile() async {
    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.get(
        Uri.parse(
          "$base/api/Profile/GetUserProfileByIdV2?ToUserid=${widget.userid}",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true && (data['Response'] ?? []).isNotEmpty) {
          var user = data['Response'][0];

          final List<String> tempImages = [];
          final profilePic = (user['profilepic'] ?? user['ProfilePic'] ?? '')
              .toString();
          if (_isValidHttpUrl(profilePic)) tempImages.add(profilePic);

          if (user['userImage'] != null && user['userImage'] is List) {
            for (var img in user['userImage']) {
              final url = (img['PhotoUrl'] ?? '').toString();
              if (_isValidHttpUrl(url)) tempImages.add(url);
            }
          }

          setState(() {
            userData = user;
            allImages = tempImages.toSet().toList();
            isLoading = false;
          });
          return;
        }
      }
      setState(() => isLoading = false);
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  int _calculateAgeFromDob(String dob) {
    try {
      final parts = dob.split(RegExp(r'[-/]+'));
      if (parts.length < 3) return 0;

      int year;
      if (parts[0].length == 4) {
        year = int.parse(parts[0]); // yyyy-MM-dd
      } else {
        year = int.parse(parts[2]); // dd-MM-yyyy
      }
      final now = DateTime.now();
      return now.year - year;
    } catch (_) {
      return 0;
    }
  }

  String _safeText(dynamic v, {String fallback = "Not specified"}) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty ? fallback : s;
  }

  void _prevPhoto() {
    if (allImages.isEmpty) return;
    if (_currentPage > 0) setState(() => _currentPage--);
  }

  void _nextPhoto() {
    if (allImages.isEmpty) return;
    if (_currentPage < allImages.length - 1) setState(() => _currentPage++);
  }

  void _openFullScreenGallery() {
    if (allImages.isEmpty) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => _FullScreenGallery(
          images: allImages,
          initialIndex: _currentPage,
          title: _safeText(userData?['FullName'], fallback: 'Profile'),
        ),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _safeText(userData?['FullName'], fallback: '');
    final dob = _safeText(userData?['DOB'], fallback: '');
    final age = dob.isEmpty ? '' : _calculateAgeFromDob(dob).toString();
    final titleText = (name.isEmpty)
        ? 'Profile'
        : (age.isEmpty || age == '0')
        ? name
        : '$name, $age';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: isLoading
            ? _buildLoading()
            : (userData == null)
            ? _buildErrorState()
            : Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: _bg,
                        leading: IconButton(
                          icon: const Icon(Iconsax.arrow_left_2, color: _text),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          titleText,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 0.1,
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.more, color: _text),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 110),
                          child: Column(
                            children: [
                              _buildImageHero(),
                              const SizedBox(height: 12),
                              _buildQuickChips(),
                              const SizedBox(height: 12),

                              _infoCard(
                                title: "Looking for",
                                subtitle: _safeText(
                                  userData?['LookingFor'],
                                  fallback: 'Not specified',
                                ),
                                leadingIcon: Iconsax.heart,
                                iconColor: _primary,
                                trailing: _pill("Preference"),
                              ),

                              _infoCard(
                                title: "Essentials",
                                subtitle: "Basics about $name",
                                leadingIcon: Iconsax.user,
                                iconColor: _blue,
                                child: Column(
                                  children: [
                                    _rowTile(
                                      Iconsax.location,
                                      "Distance",
                                      _safeText(
                                        userData?['DistanceKm'],
                                        fallback: '—',
                                      ),
                                      _orange,
                                    ),
                                    _divider(),
                                    _rowTile(
                                      Iconsax.cake,
                                      "DOB",
                                      _safeText(
                                        userData?['DOB'],
                                        fallback: '—',
                                      ),
                                      _purple,
                                    ),
                                    _divider(),
                                    _rowTile(
                                      Iconsax.woman,
                                      "Gender",
                                      _safeText(
                                        userData?['Gender'],
                                        fallback: '—',
                                      ),
                                      _primary,
                                    ),
                                    _divider(),
                                    _rowTile(
                                      Iconsax.ruler,
                                      "Height",
                                      "${_safeText(userData?['HeightCm'], fallback: '—')} cm",
                                      _green,
                                    ),
                                  ],
                                ),
                              ),

                              if ((_safeText(
                                userData?['Bio'],
                                fallback: '',
                              )).isNotEmpty)
                                _infoCard(
                                  title: "About",
                                  subtitle: "A few words",
                                  leadingIcon: Iconsax.note_2,
                                  iconColor: _purple,
                                  child: Text(
                                    _safeText(userData?['Bio'], fallback: ''),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.45,
                                      color: _text,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 12),
                              _shareCard(name),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // -------------------------
  // Loading / Error
  // -------------------------
  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                _shimmerCircle(42),
                const SizedBox(width: 10),
                Expanded(child: _shimmerBox(height: 16, radius: 10)),
                const SizedBox(width: 10),
                _shimmerCircle(36),
              ],
            ),
            const SizedBox(height: 14),
            _shimmerBox(height: 520, radius: 18),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _shimmerBox(height: 34, radius: 18)),
                const SizedBox(width: 10),
                Expanded(child: _shimmerBox(height: 34, radius: 18)),
                const SizedBox(width: 10),
                Expanded(child: _shimmerBox(height: 34, radius: 18)),
              ],
            ),
            const SizedBox(height: 12),
            _shimmerBox(height: 110, radius: 16),
            const SizedBox(height: 12),
            _shimmerBox(height: 190, radius: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.info_circle, size: 54, color: Colors.grey.shade500),
            const SizedBox(height: 10),
            const Text(
              "Profile not available",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Please try again.",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                setState(() => isLoading = true);
                userbasedProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _text,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // Premium Image Hero (Tap to full screen)
  // -------------------------
  Widget _buildImageHero() {
    final hasImage =
        allImages.isNotEmpty && _isValidHttpUrl(allImages[_currentPage]);

    return GestureDetector(
      onTap: _openFullScreenGallery, // ✅ open full screen on tap
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              SizedBox(
                height: 540,
                width: double.infinity,
                child: hasImage
                    ? Image.network(
                        allImages[_currentPage],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(color: Colors.grey.shade300),
                          );
                        },
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      )
                    : _imageFallback(),
              ),

              // premium gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.10),
                        Colors.transparent,
                        Colors.black.withOpacity(0.42),
                      ],
                    ),
                  ),
                ),
              ),

              // top indicators
              if (allImages.length > 1)
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    children: List.generate(allImages.length, (index) {
                      final active = _currentPage == index;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white
                                : Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              // top right pill
              Positioned(
                top: 18,
                right: 14,
                child: _glassPill(
                  "${_currentPage + 1}/${allImages.isEmpty ? 1 : allImages.length}",
                ),
              ),

              // swipe by tap left/right areas
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _prevPhoto,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _nextPhoto,
                      ),
                    ),
                  ],
                ),
              ),

              // bottom hint + arrows
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _glassIcon(Iconsax.arrow_left_2, onTap: _prevPhoto),
                    _tapHintPill(),
                    _glassIcon(Iconsax.arrow_right_3, onTap: _nextPhoto),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tapHintPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: Colors.white.withOpacity(0.14),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.maximize_4, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text(
                "Tap to view full",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(Iconsax.user, size: 64, color: Colors.grey.shade500),
      ),
    );
  }

  Widget _glassPill(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: Colors.black.withOpacity(0.25),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.18),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // Cards / Rows (unchanged logic)
  // -------------------------
  Widget _infoCard({
    required String title,
    required String subtitle,
    required IconData leadingIcon,
    required Color iconColor,
    Widget? trailing,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(leadingIcon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _sub,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (child != null) ...[const SizedBox(height: 12), child],
        ],
      ),
    );
  }

  Widget _rowTile(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _text,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _sub,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, thickness: 1, color: _line.withOpacity(0.9));

  // -------------------------
  // Chips
  // -------------------------
  Widget _buildQuickChips() {
    final gender = _safeText(userData?['Gender'], fallback: '');
    final height = _safeText(userData?['HeightCm'], fallback: '');
    final looking = _safeText(userData?['LookingFor'], fallback: '');

    final chips = <String>[];
    if (gender.isNotEmpty && gender != 'Not specified') chips.add(gender);
    if (height.isNotEmpty && height != 'Not specified') chips.add("$height cm");
    if (looking.isNotEmpty && looking != 'Not specified') chips.add(looking);

    if (chips.isEmpty) chips.addAll(["Verified", "Modern", "Premium"]);

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: chips.take(4).map((t) => _pill(t)).toList(),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: _text,
        ),
      ),
    );
  }

  Widget _shareCard(String name) {
    final n = name.isEmpty ? "this" : name;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.share, size: 18, color: _blue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Share $n profile",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: _text,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: _primary),
            child: const Text(
              "Share",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Shimmer Helpers
  // -------------------------
  Widget _shimmerBox({required double height, double radius = 14}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ===========================================================
// ✅ Full Screen Gallery (Zoom + Swipe) - NEW WIDGET
// ===========================================================
class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.98),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) {
                final url = widget.images[i];
                return Center(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Iconsax.image,
                        color: Colors.white70,
                        size: 64,
                      ),
                    ),
                  ),
                );
              },
            ),

            // top bar
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Iconsax.close_square,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _counterPill("${_index + 1}/${widget.images.length}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterPill(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Text(
        t,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}
