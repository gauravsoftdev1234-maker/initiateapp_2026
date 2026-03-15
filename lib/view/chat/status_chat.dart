//
//
// import 'dart:math';
// import 'dart:io';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import '../../controller/services/StorageService.dart';
// import '../../controller/services/app_api_service.dart';
//
// /// ============================
// /// PREMIUM THEME (match chat ui)
// /// ============================
// class StatusThemeX {
//   static const Color bg = Colors.white;
//   static const Color text = Color(0xFF121417);
//   static const Color sub = Color(0xFF6B7280);
//   static const Color line = Color(0xFFE7EAF0);
//
//   static const Color green = Color(0xFF16A34A);
//   static const Color blue = Color(0xFF2563EB);
//   static const Color amber = Color(0xFFF59E0B);
//   static const Color red = Color(0xFFEF4444);
//
//   static const Color chip = Color(0xFFF3F5F9);
// }
//
// /// ============================
// /// TIME FORMAT (AM/PM)
// /// ============================
// String formatTimeAmPm(DateTime? dt) {
//   if (dt == null) return "";
//   int h = dt.hour;
//   final m = dt.minute.toString().padLeft(2, '0');
//   final ampm = h >= 12 ? "PM" : "AM";
//   h = h % 12;
//   if (h == 0) h = 12;
//   return "$h:$m $ampm";
// }
//
// /// Try parse different date formats safely
// DateTime? tryParseAnyDate(dynamic v) {
//   if (v == null) return null;
//   final s = v.toString().trim();
//   if (s.isEmpty) return null;
//
//   // Most APIs: ISO
//   final iso = DateTime.tryParse(s);
//   if (iso != null) return iso;
//
//   // Try: dd-MM-yyyy HH:mm:ss  OR  dd-MM-yyyy
//   try {
//     final parts = s.split(' ');
//     final d = parts[0].split('-');
//     if (d.length == 3) {
//       final dd = int.parse(d[0]);
//       final mm = int.parse(d[1]);
//       final yy = int.parse(d[2]);
//       int hh = 0, mn = 0, ss = 0;
//       if (parts.length > 1) {
//         final t = parts[1].split(':');
//         if (t.isNotEmpty) hh = int.parse(t[0]);
//         if (t.length > 1) mn = int.parse(t[1]);
//         if (t.length > 2) ss = int.parse(t[2]);
//       }
//       return DateTime(yy, mm, dd, hh, mn, ss);
//     }
//   } catch (_) {}
//   return null;
// }
//
// class StatusChat extends StatefulWidget {
//   const StatusChat({super.key});
//
//   @override
//   State<StatusChat> createState() => _StatusChatState();
// }
//
// class _StatusChatState extends State<StatusChat> {
//   List<dynamic> otherStatusList = [];
//   dynamic myStatusData;
//   bool isLoading = true;
//   bool isUploading = false;
//   double uploadProgress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchActiveStatus();
//   }
//
//   Future<void> fetchActiveStatus() async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       final response = await http.get(
//         Uri.parse("$base/api/Profile/GetActiveStatus"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200 && data['isSuccess'] == true) {
//         final fullList = (data['Response'] ?? []) as List<dynamic>;
//         setState(() {
//           myStatusData =
//               fullList.firstWhere((e) => e['IsSelf'] == 1, orElse: () => null);
//           otherStatusList = fullList.where((e) => e['IsSelf'] == 0).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           otherStatusList = [];
//         });
//       }
//     } catch (_) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _pickAndUploadStatus() async {
//     final ImagePicker picker = ImagePicker();
//
//     try {
//       final XFile? file = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//         maxWidth: 720,
//       );
//
//       if (file != null) {
//         setState(() {
//           isUploading = true;
//           uploadProgress = 0.15;
//         });
//
//         String? token = await SecureStorageService.getToken();
//
//         setState(() => uploadProgress = 0.35);
//
//         final imageBytes = await File(file.path).readAsBytes();
//         final base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
//
//         setState(() => uploadProgress = 0.55);
//
//         const String uploadUrl =
//             "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=Status&FileName=";
//         final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
//         request.fields['file'] = base64Image;
//
//         setState(() => uploadProgress = 0.75);
//
//         final res = await request.send();
//         final resData = jsonDecode(await res.stream.bytesToString());
//
//         if (resData['isSuccess'] == true) {
//           setState(() => uploadProgress = 0.9);
//
//           await http.post(
//             Uri.parse("$base/api/Profile/AddUserStatus"),
//             headers: {
//               "Authorization": "Bearer $token",
//               "Content-Type": "application/json",
//             },
//             body: jsonEncode({
//               "p_MediaType": "PHOTO",
//               "p_MediaUrl": resData['record'],
//               "p_ThumbUrl": resData['record'],
//               "p_Duration": 20,
//               "p_Caption": "",
//             }),
//           );
//
//           setState(() => uploadProgress = 1.0);
//           await Future.delayed(const Duration(milliseconds: 250));
//
//           _showSnackBar("Status uploaded successfully!", isError: false);
//           fetchActiveStatus();
//         } else {
//           throw Exception("Upload failed: ${resData['message']}");
//         }
//       }
//     } catch (e) {
//       _showSnackBar("Upload failed: ${e.toString()}", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() {
//           isUploading = false;
//           uploadProgress = 0.0;
//         });
//       }
//     }
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
//         backgroundColor: isError ? StatusThemeX.red : StatusThemeX.green,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const SizedBox(
//         height: 124,
//         child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//       );
//     }
//
//     return Container(
//       color: StatusThemeX.bg,
//       padding: const EdgeInsets.only(top: 0, bottom: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(18, 8, 18, 10),
//             child: Row(
//               children: [
//                 Icon(Iconsax.flash_1, size: 16, color: StatusThemeX.amber),
//                 SizedBox(width: 8),
//                 Text(
//                   "Status updates",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w900,
//                     fontSize: 14.8,
//                     color: StatusThemeX.text,
//                     letterSpacing: -0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 112,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: otherStatusList.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) return _buildMyStatusTile();
//                 return _buildHorizontalUserItem(otherStatusList[index - 1]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMyStatusTile() {
//     final hasStatus = myStatusData != null && (myStatusData['TotalStatus'] ?? 0) > 0;
//     final hasUnseen = myStatusData?['HasUnseen'] == 1;
//
//     final profileUrl = (myStatusData?['profilepic'] ?? "").toString();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               GestureDetector(
//                 onTap: isUploading
//                     ? null
//                     : () => hasStatus ? _openViewer(myStatusData) : _pickAndUploadStatus(),
//                 child: Opacity(
//                   opacity: isUploading ? 0.75 : 1.0,
//                   child: CustomPaint(
//                     painter: isUploading
//                         ? null
//                         : StatusRingPainter(
//                       statusCount: myStatusData?['TotalStatus'] ?? 0,
//                       isSeen: !hasUnseen,
//                     ),
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       child: CircleAvatar(
//                         radius: 28,
//                         backgroundColor: const Color(0xFFF1F3F6),
//                         backgroundImage: profileUrl.isNotEmpty
//                             ? CachedNetworkImageProvider(profileUrl, maxWidth: 160)
//                             : null,
//                         child: profileUrl.isEmpty
//                             ? const Icon(Iconsax.user, color: StatusThemeX.sub, size: 22)
//                             : null,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Upload overlay
//               if (isUploading)
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.black.withOpacity(0.45),
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SizedBox(
//                             width: 30,
//                             height: 30,
//                             child: CircularProgressIndicator(
//                               value: uploadProgress,
//                               strokeWidth: 2,
//                               valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                               backgroundColor: Colors.white24,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             "${(uploadProgress * 100).toInt()}%",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 8.5,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//               // Add button
//               if (!isUploading)
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: GestureDetector(
//                     onTap: _pickAndUploadStatus,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//                       child: const CircleAvatar(
//                         radius: 9.5,
//                         backgroundColor: StatusThemeX.green,
//                         child: Icon(Iconsax.add, size: 14, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 7),
//           const Text(
//             "My status",
//             style: TextStyle(
//               fontSize: 11.6,
//               fontWeight: FontWeight.w900,
//               color: StatusThemeX.text,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             hasStatus ? "Tap to view" : "Tap to add",
//             style: TextStyle(
//               fontSize: 10.5,
//               fontWeight: FontWeight.w800,
//               color: StatusThemeX.sub.withOpacity(0.75),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHorizontalUserItem(dynamic user) {
//     final hasUnseen = user['HasUnseen'] == 1;
//
//     final profileUrl = (user['profilepic'] ?? "").toString();
//     final name = (user['FullName'] ?? "").toString();
//
//     return GestureDetector(
//       onTap: () => _openViewer(user),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6),
//         child: Column(
//           children: [
//             CustomPaint(
//               painter: StatusRingPainter(
//                 statusCount: user['TotalStatus'] ?? 1,
//                 isSeen: !hasUnseen,
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 child: CircleAvatar(
//                   radius: 28,
//                   backgroundColor: const Color(0xFFF1F3F6),
//                   backgroundImage: profileUrl.isNotEmpty
//                       ? CachedNetworkImageProvider(profileUrl, maxWidth: 160)
//                       : null,
//                   child: profileUrl.isEmpty
//                       ? const Icon(Iconsax.user, size: 22, color: StatusThemeX.sub)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 7),
//             SizedBox(
//               width: 74,
//               child: Text(
//                 name,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 11.4,
//                   fontWeight: FontWeight.w900,
//                   color: StatusThemeX.text,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _openViewer(dynamic user) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StatusViewerScreen(
//           userId: user['StatusUserId'],
//           userName: user['FullName'],
//           canViewers: user['CanViewers'] == 1,
//           seenCount: user['SeenCount'] ?? 0,
//         ),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// VIEWER SCREEN (Premium)
// /// ============================
// class StatusViewerScreen extends StatefulWidget {
//   final int userId;
//   final String userName;
//   final bool canViewers;
//   final int seenCount;
//
//   const StatusViewerScreen({
//     super.key,
//     required this.userId,
//     required this.userName,
//     required this.canViewers,
//     required this.seenCount,
//   });
//
//   @override
//   State<StatusViewerScreen> createState() => _StatusViewerScreenState();
// }
//
// class _StatusViewerScreenState extends State<StatusViewerScreen> {
//   List<dynamic> statusList = [];
//   bool loading = true;
//   int currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserStatusList();
//   }
//
//   Future<void> fetchUserStatusList() async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       final response = await http.get(
//         Uri.parse("$base/api/Profile/GetUserStatusList?p_StatusUserId=${widget.userId}"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           statusList = jsonDecode(response.body)['Response'] ?? [];
//           loading = false;
//         });
//         if (statusList.isNotEmpty) {
//           markAsSeen(statusList[0]['StatusId']);
//         }
//       } else {
//         setState(() => loading = false);
//       }
//     } catch (_) {
//       setState(() => loading = false);
//     }
//   }
//
//   Future<void> markAsSeen(int statusId) async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       await http.post(
//         Uri.parse("$base/api/Profile/AddStatusView"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"p_StatusId": statusId}),
//       );
//     } catch (_) {}
//   }
//
//   void _prev() {
//     if (currentIndex <= 0) return;
//     setState(() {
//       currentIndex--;
//     });
//     markAsSeen(statusList[currentIndex]['StatusId']);
//   }
//
//   void _next() {
//     if (currentIndex < statusList.length - 1) {
//       setState(() {
//         currentIndex++;
//       });
//       markAsSeen(statusList[currentIndex]['StatusId']);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator(color: Colors.white24)),
//       );
//     }
//
//     if (statusList.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Iconsax.info_circle, color: Colors.white, size: 44),
//               const SizedBox(height: 12),
//               Text(
//                 "No status available for ${widget.userName}",
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
//               ),
//               const SizedBox(height: 18),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Go Back"),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final item = statusList[currentIndex];
//     final caption = (item['Caption'] ?? "").toString();
//     final dt = tryParseAnyDate(item['CreatedOn'] ?? item['CreatedAt'] ?? item['Date'] ?? item['MsgDate']);
//     final timeText = formatTimeAmPm(dt);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           GestureDetector(
//             onTapUp: (details) {
//               final w = MediaQuery.of(context).size.width;
//               if (details.globalPosition.dx < w / 3) {
//                 _prev();
//               } else {
//                 _next();
//               }
//             },
//             child: Center(
//               child: CachedNetworkImage(
//                 imageUrl: item['MediaUrl'],
//                 fit: BoxFit.contain,
//                 memCacheWidth: 1080,
//                 placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white24),
//                 errorWidget: (context, url, error) => Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Iconsax.gallery_slash, color: Colors.white54, size: 46),
//                     SizedBox(height: 10),
//                     Text("Failed to load image", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w800)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Column(
//               children: [
//                 // Progress bars
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: Row(
//                     children: statusList.asMap().entries.map((e) {
//                       final active = e.key <= currentIndex;
//                       return Expanded(
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           height: 2.4,
//                           margin: const EdgeInsets.symmetric(horizontal: 2),
//                           decoration: BoxDecoration(
//                             color: active ? Colors.white : Colors.white24,
//                             borderRadius: BorderRadius.circular(99),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.10),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white24),
//                         ),
//                         child: const Icon(Iconsax.user, color: Colors.white, size: 18),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.userName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 14.5,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 const Icon(Iconsax.clock, size: 12, color: Colors.white70),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   timeText.isEmpty ? " " : timeText,
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w800,
//                                     fontSize: 11.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Iconsax.close_circle, color: Colors.white, size: 22),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 if (caption.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.45),
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: Colors.white24),
//                         ),
//                         child: Text(
//                           caption,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12.5,
//                             height: 1.25,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           // Viewers chip
//           if (widget.canViewers)
//             Positioned(
//               bottom: 34,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   const Icon(Iconsax.arrow_up_2, color: Colors.white70, size: 18),
//                   const SizedBox(height: 6),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.55),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white24),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Iconsax.eye, color: Colors.white, size: 18),
//                         const SizedBox(width: 8),
//                         Text(
//                           "${widget.seenCount} views",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w900,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ============================
// /// STATUS RING PAINTER (Premium)
// /// ============================
// class StatusRingPainter extends CustomPainter {
//   final int statusCount;
//   final bool isSeen;
//
//   StatusRingPainter({required this.statusCount, required this.isSeen});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (statusCount == 0) return;
//
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 3.2;
//
//     paint.color = isSeen ? Colors.grey.shade400 : StatusThemeX.green;
//
//     final radius = size.width / 2;
//     final center = Offset(size.width / 2, size.height / 2);
//
//     if (statusCount == 1) {
//       canvas.drawCircle(center, radius, paint);
//     } else {
//       const gap = 0.17;
//       final arc = (2 * pi - (statusCount * gap)) / statusCount;
//
//       for (int i = 0; i < statusCount; i++) {
//         canvas.drawArc(
//           Rect.fromCircle(center: center, radius: radius),
//           (i * (arc + gap)) - pi / 2,
//           arc,
//           false,
//           paint,
//         );
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant StatusRingPainter oldDelegate) {
//     return oldDelegate.statusCount != statusCount || oldDelegate.isSeen != isSeen;
//   }
// }

import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

/// ============================
/// PREMIUM THEME
/// ============================
class StatusThemeX {
  static const Color bg = Colors.white;
  static const Color text = Color(0xFF121417);
  static const Color sub = Color(0xFF6B7280);
  static const Color line = Color(0xFFE7EAF0);

  static const Color green = Color(0xFF16A34A);
  static const Color blue = Color(0xFF2563EB);
  static const Color amber = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
}

/// ============================
/// TIME FORMAT (AM/PM)
/// ============================
String formatTimeAmPm(DateTime? dt) {
  if (dt == null) return "";
  int h = dt.hour;
  final m = dt.minute.toString().padLeft(2, '0');
  final ampm = h >= 12 ? "PM" : "AM";
  h = h % 12;
  if (h == 0) h = 12;
  return "$h:$m $ampm";
}

DateTime? tryParseAnyDate(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty) return null;

  final iso = DateTime.tryParse(s);
  if (iso != null) return iso;

  // dd-MM-yyyy HH:mm:ss OR dd-MM-yyyy
  try {
    final parts = s.split(' ');
    final d = parts[0].split('-');
    if (d.length == 3) {
      final dd = int.parse(d[0]);
      final mm = int.parse(d[1]);
      final yy = int.parse(d[2]);
      int hh = 0, mn = 0, ss = 0;
      if (parts.length > 1) {
        final t = parts[1].split(':');
        if (t.isNotEmpty) hh = int.parse(t[0]);
        if (t.length > 1) mn = int.parse(t[1]);
        if (t.length > 2) ss = int.parse(t[2]);
      }
      return DateTime(yy, mm, dd, hh, mn, ss);
    }
  } catch (_) {}
  return null;
}

/// ============================
/// STATUS LIST WIDGET
/// ============================
class StatusChat extends StatefulWidget {
  const StatusChat({super.key});

  @override
  State<StatusChat> createState() => _StatusChatState();
}

class _StatusChatState extends State<StatusChat> {
  List<dynamic> otherStatusList = [];
  dynamic myStatusData;
  bool isLoading = true;

  bool isUploading = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    fetchActiveStatus();
  }

  Future<void> fetchActiveStatus() async {
    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.get(
        Uri.parse("$base/api/Profile/GetActiveStatus"),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);
      //print("GetActiveStatus ${data}");
      if (response.statusCode == 200 && data['isSuccess'] == true) {
        final fullList = (data['Response'] ?? []) as List<dynamic>;
        setState(() {
          myStatusData = fullList.firstWhere(
            (e) => e['IsSelf'] == 1,
            orElse: () => null,
          );
          otherStatusList = fullList.where((e) => e['IsSelf'] == 0).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          otherStatusList = [];
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndUploadStatus() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
        maxWidth: 720,
      );

      if (file == null) return;

      setState(() {
        isUploading = true;
        uploadProgress = 0.15;
      });

      String? token = await SecureStorageService.getToken();

      setState(() => uploadProgress = 0.35);

      final imageBytes = await File(file.path).readAsBytes();
      final base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";

      setState(() => uploadProgress = 0.55);

      const String uploadUrl =
          "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=Status&FileName=";
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['file'] = base64Image;

      setState(() => uploadProgress = 0.75);

      final res = await request.send();
      final resData = jsonDecode(await res.stream.bytesToString());

      if (resData['isSuccess'] == true) {
        setState(() => uploadProgress = 0.9);

        await http.post(
          Uri.parse("$base/api/Profile/AddUserStatus"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "p_MediaType": "PHOTO",
            "p_MediaUrl": resData['record'],
            "p_ThumbUrl": resData['record'],
            "p_Duration": 30,
            "p_Caption": "",
          }),
        );

        setState(() => uploadProgress = 1.0);
        await Future.delayed(const Duration(milliseconds: 250));
        _showSnackBar("Status uploaded successfully!", isError: false);
        fetchActiveStatus();
      } else {
        throw Exception("Upload failed: ${resData['message']}");
      }
    } catch (e) {
      _showSnackBar("Upload failed: ${e.toString()}", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
          uploadProgress = 0.0;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: isError ? StatusThemeX.red : StatusThemeX.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      color: StatusThemeX.bg,
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 108,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: otherStatusList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildMyStatusTile();
                return _buildHorizontalUserItem(otherStatusList[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatusTile() {
    final hasStatus =
        myStatusData != null && (myStatusData['TotalStatus'] ?? 0) > 0;
    final hasUnseen = myStatusData?['HasUnseen'] == 1;

    final profileUrl = (myStatusData?['profilepic'] ?? "").toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: isUploading
                    ? null
                    : () => hasStatus
                          ? _openViewer(myStatusData)
                          : _pickAndUploadStatus(),
                child: Opacity(
                  opacity: isUploading ? 0.75 : 1.0,
                  child: CustomPaint(
                    painter: isUploading
                        ? null
                        : StatusRingPainter(
                            statusCount: myStatusData?['TotalStatus'] ?? 0,
                            isSeen: !hasUnseen,
                          ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFF1F3F6),
                        backgroundImage: profileUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                                profileUrl,
                                maxWidth: 160,
                              )
                            : null,
                        child: profileUrl.isEmpty
                            ? const Icon(
                                Iconsax.user,
                                color: StatusThemeX.sub,
                                size: 22,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.45),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              value: uploadProgress,
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${(uploadProgress * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (!isUploading)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: _pickAndUploadStatus,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 9.5,
                        backgroundColor: StatusThemeX.green,
                        child: Icon(Iconsax.add, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            "My status",
            style: TextStyle(
              fontSize: 11.6,
              fontWeight: FontWeight.w900,
              color: StatusThemeX.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hasStatus ? "Tap to view" : "Tap to add",
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: StatusThemeX.sub.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalUserItem(dynamic user) {
    final hasUnseen = user['HasUnseen'] == 1;
    final profileUrl = (user['profilepic'] ?? "").toString();
    final name = (user['FullName'] ?? "").toString();

    return GestureDetector(
      onTap: () => _openViewer(user),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            CustomPaint(
              painter: StatusRingPainter(
                statusCount: user['TotalStatus'] ?? 1,
                isSeen: !hasUnseen,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFF1F3F6),
                  backgroundImage: profileUrl.isNotEmpty
                      ? CachedNetworkImageProvider(profileUrl, maxWidth: 160)
                      : null,
                  child: profileUrl.isEmpty
                      ? const Icon(
                          Iconsax.user,
                          size: 22,
                          color: StatusThemeX.sub,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: 74,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.4,
                  fontWeight: FontWeight.w900,
                  color: StatusThemeX.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openViewer(dynamic user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatusViewerScreen(
          userId: user['StatusUserId'],
          userName: user['FullName'],
          canViewers: user['CanViewers'] == 1,
          seenCount: user['SeenCount'] ?? 0,
        ),
      ),
    );
  }
}

/// ============================
/// VIEWER SCREEN (NO OVERFLOW)
/// ============================
class StatusViewerScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final bool canViewers;
  final int seenCount;

  const StatusViewerScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.canViewers,
    required this.seenCount,
  });

  @override
  State<StatusViewerScreen> createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen> {
  List<dynamic> statusList = [];
  bool loading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserStatusList();
  }

  Future<void> fetchUserStatusList() async {
    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.get(
        Uri.parse(
          "$base/api/Profile/GetUserStatusList?p_StatusUserId=${widget.userId}",
        ),
        headers: {"Authorization": "Bearer $token"},
      );
      //  print("GetUserStatusList ${response.body}");
      if (response.statusCode == 200) {
        setState(() {
          statusList = jsonDecode(response.body)['Response'] ?? [];
          loading = false;
        });
        if (statusList.isNotEmpty) {
          markAsSeen(statusList[0]['StatusId']);
        }
      } else {
        setState(() => loading = false);
      }
    } catch (_) {
      setState(() => loading = false);
    }
  }

  Future<void> markAsSeen(int statusId) async {
    try {
      String? token = await SecureStorageService.getToken();
      await http.post(
        Uri.parse("$base/api/Profile/AddStatusView"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"p_StatusId": statusId}),
      );
    } catch (_) {}
  }

  void _prev() {
    if (currentIndex <= 0) return;
    setState(() => currentIndex--);
    markAsSeen(statusList[currentIndex]['StatusId']);
  }

  void _next() {
    if (currentIndex < statusList.length - 1) {
      setState(() => currentIndex++);
      markAsSeen(statusList[currentIndex]['StatusId']);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white24)),
      );
    }

    if (statusList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.info_circle, color: Colors.white, size: 44),
              const SizedBox(height: 12),
              Text(
                "No status available for ${widget.userName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    final item = statusList[currentIndex];
    final caption = (item['Caption'] ?? "").toString();

    final dt = tryParseAnyDate(
      item['CreatedOn'] ?? item['CreatedAt'] ?? item['Date'] ?? item['MsgDate'],
    );
    final timeText = formatTimeAmPm(dt);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image
          GestureDetector(
            onTapUp: (details) {
              final w = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < w / 3) {
                _prev();
              } else {
                _next();
              }
            },
            child: Center(
              child: CachedNetworkImage(
                imageUrl: item['MediaUrl'],
                fit: BoxFit.contain,
                memCacheWidth: 1080,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(color: Colors.white24),
                errorWidget: (context, url, error) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Iconsax.gallery_slash,
                      color: Colors.white54,
                      size: 46,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Failed to load image",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top overlay (NO OVERFLOW)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✅ important
                children: [
                  // Progress bars
                  Row(
                    children: statusList.asMap().entries.map((e) {
                      final active = e.key <= currentIndex;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2.4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.white24,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Header row (tight)
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Iconsax.user,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Iconsax.clock,
                                  size: 12,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  timeText.isEmpty ? " " : timeText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.close_circle,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  // Caption chip (clipped + max lines) ✅ prevents overflow
                  if (caption.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 20,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              caption,
                              maxLines: 2, // ✅ fixed
                              overflow: TextOverflow.ellipsis, // ✅ fixed
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Viewers chip
          if (widget.canViewers)
            Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Icon(
                    Iconsax.arrow_up_2,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.eye, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${widget.seenCount} views",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// ============================
/// RING PAINTER
/// ============================
class StatusRingPainter extends CustomPainter {
  final int statusCount;
  final bool isSeen;

  StatusRingPainter({required this.statusCount, required this.isSeen});

  @override
  void paint(Canvas canvas, Size size) {
    if (statusCount == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.2;

    paint.color = isSeen ? Colors.grey.shade400 : StatusThemeX.green;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    if (statusCount == 1) {
      canvas.drawCircle(center, radius, paint);
    } else {
      const gap = 0.17;
      final arc = (2 * pi - (statusCount * gap)) / statusCount;

      for (int i = 0; i < statusCount; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          (i * (arc + gap)) - pi / 2,
          arc,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant StatusRingPainter oldDelegate) {
    return oldDelegate.statusCount != statusCount ||
        oldDelegate.isSeen != isSeen;
  }
}
