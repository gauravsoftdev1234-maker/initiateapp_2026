import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart'; // ✅ ADDED

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';
// import 'FindingPeopleOverlay.dart';
//
// /// ============================
// /// THEME (Premium)
// /// ============================
// class _ActivityChip {
//   final String label;
//   final IconData icon;
//   const _ActivityChip(this.label, this.icon);
// }
//
class AppThemeX {
  static const bg = Colors.white;
  static const card = Colors.white;
  static const text = Color(0xFF1F2937);
  static const sub = Color(0xFF6B7280);
  static const line = Color(0xFFEEF0F4);

  static const red = Color(0xFFFD5068);
  static const purple = Color(0xFF7C4DFF);
  static const green = Color(0xFF22C55E);
  static const yellow = Color(0xFFFBBF24);
  static const blue = Color(0xFF3B82F6);
}
//
// /// ============================
// /// ✅ SHIMMER HELPERS (Package based)
// /// ============================
// class AppShimmerX {
//   static Widget box({
//     required double width,
//     required double height,
//     double radius = 16,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: Shimmer.fromColors(
//         baseColor: const Color(0xFFE9ECF3),
//         highlightColor: const Color(0xFFF7F8FB),
//         child: Container(width: width, height: height, color: Colors.white),
//       ),
//     );
//   }
//
//   static Widget circle({required double size}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(size / 2),
//       child: Shimmer.fromColors(
//         baseColor: const Color(0xFFE9ECF3),
//         highlightColor: const Color(0xFFF7F8FB),
//         child: Container(width: size, height: size, color: Colors.white),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// SIMPLE SHIMMER (No package)  (kept as-is, not removed)
// /// ============================
// class ShimmerBox extends StatefulWidget {
//   final double width;
//   final double height;
//   final double radius;
//
//   const ShimmerBox({
//     super.key,
//     required this.width,
//     required this.height,
//     this.radius = 16,
//   });
//
//   @override
//   State<ShimmerBox> createState() => _ShimmerBoxState();
// }
//
// class _ShimmerBoxState extends State<ShimmerBox>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1100),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _c,
//       builder: (_, __) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(widget.radius),
//           child: CustomPaint(
//             painter: _ShimmerPainter(_c.value),
//             child: SizedBox(width: widget.width, height: widget.height),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _ShimmerPainter extends CustomPainter {
//   final double t;
//   _ShimmerPainter(this.t);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Offset.zero & size,
//       Paint()..color = const Color(0xFFE9ECF3),
//     );
//
//     final bandW = size.width * 0.55;
//     final x = (size.width + bandW) * t - bandW;
//
//     final rect = Rect.fromLTWH(x, 0, bandW, size.height);
//     final shader = const LinearGradient(
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//       colors: [Color(0x00FFFFFF), Color(0x66FFFFFF), Color(0x00FFFFFF)],
//       stops: [0.2, 0.5, 0.8],
//     ).createShader(rect);
//
//     canvas.drawRect(rect, Paint()..shader = shader);
//   }
//
//   @override
//   bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
//       oldDelegate.t != t;
// }
//
// /// ============================
// /// MODELS
// /// ============================
// class DiscoveryUser {
//   final int userId;
//   final String fullName;
//   final String gender;
//   final int age;
//   final String city;
//   final String bio;
//   final double heightCm;
//   final String lookingFor;
//   final String profilePic;
//   final double distanceKm;
//   final String smoking;
//   final String drinking;
//   final String zodiac;
//   final String education;
//   final String university;
//   final String jobTitle;
//   final String company;
//   final String sexualOrientation;
//   final String workout;
//   final List<String> galleryImages;
//
//   DiscoveryUser({
//     required this.userId,
//     required this.fullName,
//     required this.gender,
//     required this.age,
//     required this.city,
//     required this.bio,
//     required this.heightCm,
//     required this.lookingFor,
//     required this.profilePic,
//     required this.distanceKm,
//     required this.smoking,
//     required this.drinking,
//     required this.zodiac,
//     required this.education,
//     required this.university,
//     required this.jobTitle,
//     required this.company,
//     required this.sexualOrientation,
//     required this.workout,
//     required this.galleryImages,
//   });
//
//   factory DiscoveryUser.fromJson(Map<String, dynamic> json) {
//     List<String> images = [];
//
//     try {
//       if (json['gallery_images'] != null) {
//         final galleryData = json['gallery_images'];
//
//         if (galleryData is List) {
//           for (final item in galleryData) {
//             if (item is String) {
//               final clean = item
//                   .replaceAll('"', '')
//                   .replaceAll('[', '')
//                   .replaceAll(']', '')
//                   .trim();
//               if (clean.isNotEmpty && clean.startsWith('http')) {
//                 images.add(clean);
//               }
//             }
//           }
//         } else if (galleryData is String) {
//           try {
//             final List<dynamic> parsed = jsonDecode(galleryData);
//             for (final item in parsed) {
//               if (item is String) {
//                 final clean = item
//                     .replaceAll('"', '')
//                     .replaceAll('[', '')
//                     .replaceAll(']', '')
//                     .trim();
//                 if (clean.isNotEmpty && clean.startsWith('http')) {
//                   images.add(clean);
//                 }
//               }
//             }
//           } catch (_) {
//             final cleaned = galleryData
//                 .replaceAll('"[', '')
//                 .replaceAll(']"', '')
//                 .replaceAll('"', '')
//                 .replaceAll('[', '')
//                 .replaceAll(']', '');
//             for (final part in cleaned.split(',')) {
//               final clean = part.trim();
//               if (clean.isNotEmpty && clean.startsWith('http')) {
//                 images.add(clean);
//               }
//             }
//           }
//         }
//       }
//
//       if (images.isEmpty &&
//           json['ProfilePic'] != null &&
//           json['ProfilePic'].toString().trim().isNotEmpty) {
//         final pic = json['ProfilePic'].toString().trim();
//         if (pic.startsWith('http')) images.insert(0, pic);
//       }
//
//       images = images.toSet().toList();
//     } catch (_) {}
//
//     return DiscoveryUser(
//       userId: json['UserId'] ?? 0,
//       fullName: json['FullName'] ?? 'Unknown',
//       gender: json['Gender'] ?? 'Not specified',
//       age: json['Age'] ?? 0,
//       city: json['City'] ?? 'Unknown location',
//       bio: json['Bio'] ?? '',
//       heightCm: (json['HeightCm'] ?? 0.0).toDouble(),
//       lookingFor: json['LookingFor'] ?? 'Not specified',
//       profilePic: (json['ProfilePic'] ?? '').toString(),
//       distanceKm: (json['DistanceKm'] ?? 0.0).toDouble(),
//       smoking: json['smoking'] ?? 'Not specified',
//       drinking: json['drinking'] ?? 'Not specified',
//       zodiac: json['zodiac'] ?? 'Not specified',
//       education: json['education'] ?? 'Not specified',
//       university: json['university'] ?? 'Not specified',
//       jobTitle: json['job_title'] ?? 'Not specified',
//       company: json['company'] ?? 'Not specified',
//       sexualOrientation: json['sexual_orientation'] ?? 'Not specified',
//       workout: json['workout'] ?? 'Not specified',
//       galleryImages: images,
//     );
//   }
// }
//
// class UserPreferences {
//   int minAge;
//   int maxAge;
//   int searchRadiusKm;
//   String lookingFor;
//
//   UserPreferences({
//     required this.minAge,
//     required this.maxAge,
//     required this.searchRadiusKm,
//     required this.lookingFor,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'p_MinAge': minAge,
//     'p_MaxAge': maxAge,
//     'p_SearchRadiusKm': searchRadiusKm,
//     'p_LookingFor': lookingFor,
//   };
// }
//
// /// ============================
// /// MAIN SCREEN
// /// ============================
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
//   bool _isProfileExpanded = false;
//   DiscoveryUser? _selectedProfile;
//
//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _isLocationUpdating = false;
//
//   bool _isPreferencesLoading = false;
//   bool _isFilterVisible = false;
//
//   late PageController _galleryPageController;
//   int _currentGalleryIndex = 0;
//
//   final List<String> _lookingForOptions = const ['Male', 'Female', 'Other'];
//
//   UserPreferences _userPreferences = UserPreferences(
//     minAge: 18,
//     maxAge: 35,
//     searchRadiusKm: 50,
//     lookingFor: 'Male',
//   );
//
//   final CardSwiperController _cardSwiperController = CardSwiperController();
//   List<DiscoveryUser> profiles = [];
//   List<DiscoveryUser> swipedProfiles = [];
//
//   final List<_ActivityChip> _activityOptions = const [
//     _ActivityChip('New here', Iconsax.user_add),
//     _ActivityChip('Active', Iconsax.flash_1),
//     _ActivityChip('Recently active', Iconsax.clock),
//     _ActivityChip('Nearby', Iconsax.location),
//   ];
//   int _selectedActivityIndex = 2; // default: Recently active
//
//   late final AnimationController _likeFlashController;
//   late final AnimationController _dislikeFlashController;
//   late final AnimationController _likeBtnController;
//   late final AnimationController _dislikeBtnController;
//   late final AnimationController _undoBtnController;
//   late final AnimationController _directMessageController;
//
//   bool _showLikeFlash = false;
//   bool _showDislikeFlash = false;
//   bool _isSendingMessage = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _galleryPageController = PageController();
//     _galleryPageController.addListener(() {
//       final p = _galleryPageController.hasClients
//           ? (_galleryPageController.page ?? 0.0)
//           : 0.0;
//       final idx = p.round();
//       if (idx != _currentGalleryIndex) {
//         setState(() => _currentGalleryIndex = idx);
//       }
//     });
//
//     _likeFlashController =
//     AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..addStatusListener((s) {
//       if (s == AnimationStatus.completed) {
//         if (mounted) setState(() => _showLikeFlash = false);
//         _likeFlashController.reset();
//       }
//     });
//
//     _dislikeFlashController =
//     AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..addStatusListener((s) {
//       if (s == AnimationStatus.completed) {
//         if (mounted) setState(() => _showDislikeFlash = false);
//         _dislikeFlashController.reset();
//       }
//     });
//
//     _likeBtnController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//       lowerBound: 0.86,
//       upperBound: 1.12,
//     )..value = 1.0;
//
//     _dislikeBtnController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//       lowerBound: 0.86,
//       upperBound: 1.12,
//     )..value = 1.0;
//
//     _undoBtnController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//       lowerBound: 0.86,
//       upperBound: 1.12,
//     )..value = 1.0;
//
//     _directMessageController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//       lowerBound: 0.86,
//       upperBound: 1.12,
//     )..value = 1.0;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchDiscovery();
//       await _updateUserLocation();
//     });
//   }
//
//   @override
//   void dispose() {
//     _galleryPageController.dispose();
//     _cardSwiperController.dispose();
//     _likeFlashController.dispose();
//     _dislikeFlashController.dispose();
//     _likeBtnController.dispose();
//     _dislikeBtnController.dispose();
//     _undoBtnController.dispose();
//     _directMessageController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateUserLocation() async {
//     print("test 12345");
//     try {
//       setState(() => _isLocationUpdating = true);
//
//       // First, fetch user profile to get profile picture
//       String? profilePicUrl;
//       try {
//         String? token = await SecureStorageService.getToken();
//         if (token != null) {
//           final response = await http.get(
//             Uri.parse("$base/api/Profile/GetUserProfile"),
//             headers: {"Authorization": "Bearer $token"},
//           );
//           final responseData = jsonDecode(response.body);
//           if (response.statusCode == 200 &&
//               responseData['isSuccess'] == true &&
//               responseData['Response'] != null) {
//             final userData = responseData['Response'][0];
//             if (userData['profilepic'] != null &&
//                 userData['profilepic'].isNotEmpty) {
//               profilePicUrl = userData['profilepic'];
//             }
//           }
//         }
//       } catch (e) {
//         print("Error fetching profile pic: $e");
//       }
//
//       // Show finding people overlay with profile picture
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return FindingPeopleOverlay(
//             message: "Finding people near you...",
//             onCancel: () {
//               Navigator.of(context).pop();
//               setState(() => _isLocationUpdating = false);
//             },
//             profileImageUrl: profilePicUrl, // Pass the profile picture
//           );
//         },
//       );
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//
//         final token = await SecureStorageService.getToken();
//         if (token == null) return;
//
//         await http.post(
//           Uri.parse("$base/api/Location/updateUserLocation"),
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "application/json",
//           },
//           body: jsonEncode({
//             "Latitude": position.latitude.toString(),
//             "Longitude": position.longitude.toString(),
//           }),
//         );
//
//         // Dismiss the finding people overlay
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//
//         // Show refreshing overlay while fetching new profiles
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return FindingPeopleOverlay(
//               message: "Refreshing profiles near you...",
//               showCancelButton: false,
//               profileImageUrl: profilePicUrl, // Pass the profile picture
//             );
//           },
//         );
//
//         await _fetchDiscovery();
//
//         // Dismiss the refreshing overlay
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       }
//     } catch (e) {
//       // ignore: avoid_print
//       print("Location Update Error: $e");
//       if (mounted) {
//         // Dismiss any open dialogs
//         Navigator.of(context).popUntil((route) => route.isFirst);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating location: $e'),
//             backgroundColor: AppThemeX.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         // Ensure all dialogs are dismissed
//         Navigator.of(context).popUntil((route) => route.isFirst);
//         setState(() => _isLocationUpdating = false);
//       }
//     }
//   }
//
//   final Map<int, int> _cardImageIndex = {};
//   bool _isValidHttpUrl(String url) {
//     final u = url.trim();
//     return u.startsWith('http://') || u.startsWith('https://');
//   }
//
//   String _formatDistance(double km) {
//     if (km < 1) return '${(km * 1000).round()} m away';
//     if (km < 10) return '${km.toStringAsFixed(1)} km away';
//     return '${km.round()} km away';
//   }
//
//   List<String> _getInterests(DiscoveryUser user) {
//     final interests = <String>[];
//
//     void add(String v) {
//       final t = v.trim();
//       if (t.isNotEmpty && t != 'Not specified') interests.add(t);
//     }
//
//     add(user.workout);
//     add(user.smoking);
//     add(user.drinking);
//     add(user.zodiac);
//     add(user.education);
//     add(user.jobTitle);
//
//     if (interests.isEmpty) {
//       interests.addAll([
//         'Photography',
//         'Harry Potter',
//         'Biryani',
//         'Ludo',
//         'Stand-up comedy',
//         'K-Pop',
//         'Drawing',
//         'Dancing',
//         'Street food',
//       ]);
//     }
//     return interests;
//   }
//
//   /// ✅ NEW: Better loading skeleton using shimmer package
//   Widget _buildLoadingSkeleton() {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Expanded(
//             child: AppShimmerX.box(
//               width: double.infinity,
//               height: double.infinity,
//               radius: 28,
//             ),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AppShimmerX.circle(size: 72),
//               const SizedBox(width: 14),
//               AppShimmerX.circle(size: 72),
//               const SizedBox(width: 14),
//               AppShimmerX.circle(size: 72),
//               const SizedBox(width: 14),
//               AppShimmerX.circle(size: 72),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _fetchDiscovery() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//
//       final token = await SecureStorageService.getToken();
//       if (token == null) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Authentication token not found';
//         });
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse("$base/api/Profile/GetUserDiscoveryList"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: {"Limit": "1000", "Offset": "0"},
//       );
//
//       final responseData = jsonDecode(response.body);
//       // ignore: avoid_print
//       print(responseData);
//
//       if (response.statusCode == 200) {
//         if (responseData['isSuccess'] == true) {
//           final List<dynamic> data = responseData['Response'] ?? [];
//           setState(() {
//             profiles = data
//                 .map((j) => DiscoveryUser.fromJson(j))
//                 .where((u) => u.userId != 0)
//                 .toList();
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _isLoading = false;
//             _errorMessage =
//                 responseData['message'] ?? 'Failed to load profiles';
//           });
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Server error: ${response.statusCode}';
//         });
//       }
//     } catch (_) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Network error';
//       });
//     }
//   }
//
//   Future<void> _handleSwipeAction(int userId, bool isLike) async {
//     try {
//       final token = await SecureStorageService.getToken();
//       if (token == null) {
//         print("❌ No token found");
//         return;
//       }
//
//       print("📤 Sending swipe action - UserId: $userId, IsLike: $isLike");
//       print("🔑 Token: $token");
//
//       final response = await http.post(
//         Uri.parse("$base/api/Profile/SetUserLikeDislikeValue"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"p_ToUserId": userId, "p_IsLike": isLike}),
//       );
//
//       // Print response status
//       print("📥 Response Status Code: ${response.statusCode}");
//
//       // Print response body
//       print("📦 Response Body: ${response.body}");
//
//       // Parse and print formatted response
//       try {
//         final responseData = jsonDecode(response.body);
//         print("📊 Parsed Response:");
//         print("   isSuccess: ${responseData['isSuccess']}");
//         print("   message: ${responseData['message']}");
//         print("   response: ${responseData['Response']}");
//       } catch (e) {
//         print("⚠️ Could not parse response as JSON: $e");
//       }
//
//       if (response.statusCode == 200) {
//         print("✅ Swipe action successful");
//       } else {
//         print("⚠️ Swipe action failed with status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error in _handleSwipeAction: $e");
//     }
//   }
//
//   Future<void> _sendDirectMessage(int receiverId, String message) async {
//     if (message.trim().isEmpty) return;
//
//     setState(() {
//       _isSendingMessage = true;
//     });
//
//     try {
//       final token = await SecureStorageService.getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Authentication failed')));
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse("$base/api/ChatMaster/SendDirectMessage"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "p_ReceiverId": receiverId,
//           "p_Message": message,
//           "p_MessageType": "text",
//           "p_fileurl": "",
//         }),
//       );
//
//       final responseData = jsonDecode(response.body);
//       // ignore: avoid_print
//       print(receiverId);
//
//       if (response.statusCode == 200 && responseData['isSuccess'] == true) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Message sent successfully'),
//               backgroundColor: AppThemeX.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 responseData['message'] ?? 'Failed to send message',
//               ),
//               backgroundColor: AppThemeX.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending message: $e'),
//             backgroundColor: AppThemeX.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSendingMessage = false;
//         });
//       }
//     }
//   }
//
//   void _showDirectMessageDialog(DiscoveryUser user) {
//     final TextEditingController messageController = TextEditingController();
//     final FocusNode focusNode = FocusNode();
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(25),
//                 child:
//                 user.profilePic.isNotEmpty &&
//                     _isValidHttpUrl(user.profilePic)
//                     ? Image.network(
//                   user.profilePic,
//                   width: 40,
//                   height: 40,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (_, child, progress) {
//                     if (progress == null) return child;
//                     return AppShimmerX.circle(size: 40); // ✅ ADDED
//                   },
//                   errorBuilder: (_, __, ___) => Container(
//                     width: 40,
//                     height: 40,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.person, color: Colors.grey),
//                   ),
//                 )
//                     : Container(
//                   width: 40,
//                   height: 40,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.person, color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Send Message',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppThemeX.text,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'To: ${user.fullName}',
//                       style: TextStyle(fontSize: 14, color: AppThemeX.sub),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: TextField(
//               controller: messageController,
//               focusNode: focusNode,
//               maxLines: 5,
//               minLines: 3,
//               decoration: InputDecoration(
//                 hintText: 'Type your message here...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: AppThemeX.line),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: AppThemeX.blue, width: 2),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[50],
//               ),
//               autofocus: true,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: _isSendingMessage
//                   ? null
//                   : () {
//                 focusNode.unfocus();
//                 Navigator.of(context).pop();
//               },
//               style: TextButton.styleFrom(foregroundColor: AppThemeX.sub),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _isSendingMessage
//                   ? null
//                   : () async {
//                 final message = messageController.text;
//                 if (message.trim().isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter a message'),
//                       backgroundColor: AppThemeX.red,
//                     ),
//                   );
//                   return;
//                 }
//
//                 focusNode.unfocus();
//                 Navigator.of(context).pop();
//                 await _sendDirectMessage(user.userId, message);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppThemeX.blue,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: _isSendingMessage
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//                   : const Text('Send'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _animateButton(AnimationController c) {
//     c.forward().then((_) => c.reverse()).catchError((_) {});
//   }
//
//   void _handleSwipe(int index, CardSwiperDirection direction) {
//     if (index >= profiles.length) return;
//
//     final user = profiles[index];
//     swipedProfiles.add(user);
//
//     if (direction == CardSwiperDirection.right) {
//       setState(() {
//         _showLikeFlash = true;
//         _selectedProfile = user;
//       });
//       _likeFlashController.forward();
//       _animateButton(_likeBtnController);
//       _handleSwipeAction(user.userId, true);
//     } else if (direction == CardSwiperDirection.left) {
//       setState(() => _showDislikeFlash = true);
//       _dislikeFlashController.forward();
//       _animateButton(_dislikeBtnController);
//       _handleSwipeAction(user.userId, false);
//     }
//   }
//
//   void _handleLike() {
//     if (profiles.isEmpty) return;
//     _animateButton(_likeBtnController);
//     _cardSwiperController.swipe(CardSwiperDirection.right);
//   }
//
//   void _handleDislike() {
//     if (profiles.isEmpty) return;
//     _animateButton(_dislikeBtnController);
//     _cardSwiperController.swipe(CardSwiperDirection.left);
//   }
//
//   void _handleUndo() {
//     if (swipedProfiles.isEmpty) return;
//     _animateButton(_undoBtnController);
//     final lastSwiped = swipedProfiles.removeLast();
//     setState(() => profiles.insert(0, lastSwiped));
//   }
//
//   void _handleDirectMessage() {
//     if (profiles.isEmpty) return;
//     _animateButton(_directMessageController);
//     _showDirectMessageDialog(profiles.first);
//   }
//
//   void _showFullProfile(DiscoveryUser profile) {
//     setState(() {
//       _selectedProfile = profile;
//       _isProfileExpanded = true;
//       _currentGalleryIndex = 0;
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       if (_galleryPageController.hasClients) {
//         _galleryPageController.jumpToPage(0);
//       }
//     });
//   }
//
//   void _hideFullProfile() {
//     setState(() {
//       _isProfileExpanded = false;
//       _selectedProfile = null;
//       _currentGalleryIndex = 0;
//     });
//   }
//
//   Future<void> _updateUserPreferences(BuildContext sheetContext) async {
//     try {
//       setState(() => _isPreferencesLoading = true);
//
//       final token = await SecureStorageService.getToken();
//       if (token == null) return;
//
//       final response = await http.post(
//         Uri.parse("$base/api/Profile/UpdatePreferencese"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(_userPreferences.toJson()),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['isSuccess'] == true) {
//           if (Navigator.canPop(sheetContext)) {
//             Navigator.pop(sheetContext);
//           } else {
//             Navigator.of(sheetContext, rootNavigator: true).pop();
//           }
//
//           await _fetchDiscovery();
//           if (mounted) setState(() => _isFilterVisible = false);
//         }
//       }
//     } catch (e) {
//       // ignore: avoid_print
//       print("Update Preferences Error: $e");
//     } finally {
//       if (mounted) setState(() => _isPreferencesLoading = false);
//     }
//   }
//
//   void _showFilterBottomSheet() {
//     setState(() => _isFilterVisible = true);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _buildFilterBottomSheet(),
//     ).then((_) {
//       if (mounted) setState(() => _isFilterVisible = false);
//     });
//   }
//
//   Widget _buildFilterBottomSheet() {
//     return StatefulBuilder(
//       builder: (sheetContext, setModalState) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Discovery Preferences',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(sheetContext),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(height: 1, color: Colors.grey.shade200),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//                   children: [
//                     _buildPreferenceItem(
//                       title: 'Age Range',
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _buildDropdown<int>(
//                               value: _userPreferences.minAge,
//                               items: List.generate(83, (i) => i + 18),
//                               onChanged: (v) {
//                                 if (v == null) return;
//                                 setModalState(() {
//                                   _userPreferences.minAge = v;
//                                   if (_userPreferences.maxAge < v) {
//                                     _userPreferences.maxAge = v;
//                                   }
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           const Text('to'),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _buildDropdown<int>(
//                               value: _userPreferences.maxAge,
//                               items: List.generate(83, (i) => i + 18)
//                                   .where(
//                                     (age) => age >= _userPreferences.minAge,
//                               )
//                                   .toList(),
//                               onChanged: (v) {
//                                 if (v == null) return;
//                                 setModalState(() {
//                                   _userPreferences.maxAge = v;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     _buildPreferenceItem(
//                       title: 'Distance',
//                       child: _buildDropdown<int>(
//                         value: _userPreferences.searchRadiusKm,
//                         items: const [5, 10, 25, 50, 100, 200],
//                         onChanged: (v) {
//                           if (v == null) return;
//                           setModalState(() {
//                             _userPreferences.searchRadiusKm = v;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     _buildPreferenceItem(
//                       title: 'Looking for',
//                       child: _buildDropdown<String>(
//                         value: _userPreferences.lookingFor,
//                         items: _lookingForOptions,
//                         onChanged: (v) {
//                           if (v == null) return;
//                           setModalState(() {
//                             _userPreferences.lookingFor = v;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     ElevatedButton(
//                       onPressed: _isPreferencesLoading
//                           ? null
//                           : () => _updateUserPreferences(sheetContext),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppThemeX.red,
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       child: _isPreferencesLoading
//                           ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                           : const Text('Apply'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPreferenceItem({required String title, required Widget child}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 8),
//         child,
//       ],
//     );
//   }
//
//   Widget _buildDropdown<T>({
//     required T value,
//     required List<T> items,
//     required ValueChanged<T?> onChanged,
//   }) {
//     final safeValue = items.contains(value) ? value : items.first;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButton<T>(
//         value: safeValue,
//         isExpanded: true,
//         underline: const SizedBox(),
//         icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
//         items: items
//             .map(
//               (item) => DropdownMenuItem<T>(
//             value: item,
//             child: Text(item.toString()),
//           ),
//         )
//             .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
//
//   Widget _statusPill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFDFF7E8),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Color(0xFF0F5132),
//           fontSize: 14,
//           fontWeight: FontWeight.w800,
//           letterSpacing: -0.2,
//         ),
//       ),
//     );
//   }
//
//   Widget _interestChipDark(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 15,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.2,
//         ),
//       ),
//     );
//   }
//
//   Widget _cardFallback() {
//     return Container(
//       color: const Color(0xFFE9ECF3),
//       child: const Center(
//         child: Icon(Iconsax.user, size: 56, color: AppThemeX.sub),
//       ),
//     );
//   }
//
//   Widget _pillButton({
//     required String text,
//     required IconData icon,
//     required VoidCallback onTap,
//     Color bg = Colors.white,
//     Color fg = AppThemeX.text,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(999),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(999),
//           border: Border.all(color: AppThemeX.line),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 14,
//               offset: const Offset(0, 8),
//               color: Colors.black.withOpacity(0.06),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 16, color: fg),
//             const SizedBox(width: 8),
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: 12.6,
//                 fontWeight: FontWeight.w900,
//                 color: fg,
//                 letterSpacing: -0.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionCard({
//     required IconData icon,
//     required String title,
//     required Color iconColor,
//     Widget? trailing,
//     required Widget child,
//   }) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
//       padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//       decoration: BoxDecoration(
//         color: AppThemeX.card,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: AppThemeX.line),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//             color: Colors.black.withOpacity(0.05),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: iconColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, size: 18, color: iconColor),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 12.8,
//                   fontWeight: FontWeight.w900,
//                   color: AppThemeX.sub,
//                 ),
//               ),
//               const Spacer(),
//               if (trailing != null) trailing,
//             ],
//           ),
//           const SizedBox(height: 10),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoTile(
//       IconData icon,
//       String label,
//       String value, {
//         Color iconColor = const Color(0xFF6B7280),
//         bool showDivider = true,
//       }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         border: showDivider
//             ? const Border(bottom: BorderSide(color: AppThemeX.line))
//             : null,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 18, color: iconColor),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 12.6,
//                 fontWeight: FontWeight.w900,
//                 color: AppThemeX.text,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 12.6,
//                 fontWeight: FontWeight.w700,
//                 color: AppThemeX.sub,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _chip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F8FB),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: AppThemeX.line),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12.2,
//           fontWeight: FontWeight.w800,
//           color: AppThemeX.sub,
//         ),
//       ),
//     );
//   }
//
//   Widget _bigActionButton({
//     required String text,
//     required VoidCallback onTap,
//     Color textColor = AppThemeX.text,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF7F8FB),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: AppThemeX.line),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13.5,
//               fontWeight: FontWeight.w900,
//               color: textColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFullProfile(DiscoveryUser user) {
//     final interests = _getInterests(user);
//
//     List<String> allImages = [];
//     if (user.profilePic.isNotEmpty && _isValidHttpUrl(user.profilePic)) {
//       allImages.add(user.profilePic.trim());
//     }
//     allImages.addAll(user.galleryImages.where(_isValidHttpUrl));
//     allImages = allImages.toSet().toList();
//
//     return Material(
//       color: Colors.white,
//       child: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "${user.fullName}, ${user.age}",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: -0.4,
//                         color: AppThemeX.text,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   InkWell(
//                     onTap: _hideFullProfile,
//                     borderRadius: BorderRadius.circular(999),
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF7F8FB),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: AppThemeX.line),
//                       ),
//                       child: const Icon(
//                         Iconsax.close_circle,
//                         size: 20,
//                         color: AppThemeX.text,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(24),
//                         child: Stack(
//                           children: [
//                             SizedBox(
//                               height: 340,
//                               width: double.infinity,
//                               child: allImages.isEmpty
//                                   ? Container(
//                                 color: const Color(0xFFE9ECF3),
//                                 child: const Center(
//                                   child: Icon(
//                                     Iconsax.user,
//                                     size: 52,
//                                     color: AppThemeX.sub,
//                                   ),
//                                 ),
//                               )
//                                   : PageView.builder(
//                                 controller: _galleryPageController,
//                                 itemCount: allImages.length,
//                                 itemBuilder: (_, index) {
//                                   final url = allImages[index].trim();
//                                   return Image.network(
//                                     url,
//                                     fit: BoxFit.cover,
//                                     loadingBuilder: (_, child, progress) {
//                                       if (progress == null) return child;
//                                       // ✅ UPDATED: shimmer package
//                                       return AppShimmerX.box(
//                                         width: double.infinity,
//                                         height: 340,
//                                         radius: 0,
//                                       );
//                                     },
//                                     errorBuilder: (_, __, ___) =>
//                                         Container(
//                                           color: const Color(0xFFE9ECF3),
//                                           child: const Center(
//                                             child: Icon(
//                                               Iconsax.gallery_slash,
//                                               size: 52,
//                                               color: AppThemeX.sub,
//                                             ),
//                                           ),
//                                         ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             if (allImages.length > 1)
//                               Positioned(
//                                 top: 12,
//                                 left: 12,
//                                 right: 12,
//                                 child: Row(
//                                   children: List.generate(allImages.length, (
//                                       i,
//                                       ) {
//                                     return Expanded(
//                                       child: Container(
//                                         height: 3,
//                                         margin: const EdgeInsets.symmetric(
//                                           horizontal: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: _currentGalleryIndex == i
//                                               ? Colors.white
//                                               : Colors.white.withOpacity(0.45),
//                                           borderRadius: BorderRadius.circular(
//                                             99,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                               ),
//                             Positioned(
//                               bottom: 14,
//                               right: 14,
//                               child: _pillButton(
//                                 text: "Reply",
//                                 icon: Iconsax.send_2,
//                                 fg: AppThemeX.blue,
//                                 bg: Colors.white.withOpacity(0.95),
//                                 onTap: () => _showDirectMessageDialog(user),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     _sectionCard(
//                       icon: Iconsax.search_normal,
//                       title: "Looking for",
//                       iconColor: AppThemeX.sub,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Iconsax.heart_add,
//                             size: 16,
//                             color: AppThemeX.red,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               user.lookingFor.isNotEmpty
//                                   ? user.lookingFor
//                                   : "Not specified",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w900,
//                                 color: AppThemeX.text,
//                                 letterSpacing: -0.2,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _sectionCard(
//                       icon: Iconsax.note_2,
//                       title: "Essentials",
//                       iconColor: AppThemeX.sub,
//                       trailing: InkWell(
//                         borderRadius: BorderRadius.circular(12),
//                         child: const Padding(
//                           padding: EdgeInsets.all(6),
//                           child: Icon(
//                             Iconsax.more,
//                             size: 18,
//                             color: AppThemeX.sub,
//                           ),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           _buildInfoTile(
//                             Iconsax.location,
//                             "Distance",
//                             _formatDistance(user.distanceKm),
//                             iconColor: AppThemeX.purple,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.woman,
//                             "Gender",
//                             user.gender.isNotEmpty
//                                 ? user.gender
//                                 : "Not specified",
//                             iconColor: AppThemeX.blue,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.ruler,
//                             "Height",
//                             user.heightCm > 0
//                                 ? "${user.heightCm.toStringAsFixed(0)} cm"
//                                 : "Not specified",
//                             iconColor: AppThemeX.green,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.briefcase,
//                             "Profession",
//                             user.jobTitle.isNotEmpty
//                                 ? user.jobTitle
//                                 : "Not specified",
//                             iconColor: AppThemeX.yellow,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.teacher,
//                             "Education",
//                             user.education.isNotEmpty
//                                 ? user.education
//                                 : "Not specified",
//                             iconColor: AppThemeX.purple,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.activity,
//                             "Workout",
//                             user.workout.isNotEmpty
//                                 ? user.workout
//                                 : "Not specified",
//                             iconColor: AppThemeX.green,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.cup,
//                             "Drinking",
//                             user.drinking.isNotEmpty
//                                 ? user.drinking
//                                 : "Not specified",
//                             iconColor: AppThemeX.yellow,
//                           ),
//                           _buildInfoTile(
//                             Iconsax.edit,
//                             "Smoking",
//                             user.smoking.isNotEmpty
//                                 ? user.smoking
//                                 : "Not specified",
//                             iconColor: AppThemeX.red,
//                             showDivider: false,
//                           ),
//                           const SizedBox(height: 10),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: _pillButton(
//                               text: "Reply",
//                               icon: Iconsax.send_2,
//                               fg: AppThemeX.blue,
//                               bg: const Color(0xFFF7F8FB),
//                               onTap: () => _showDirectMessageDialog(user),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (interests.isNotEmpty)
//                       Container(
//                         margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
//                         padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//                         decoration: BoxDecoration(
//                           color: AppThemeX.card,
//                           borderRadius: BorderRadius.circular(22),
//                           border: Border.all(color: AppThemeX.line),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Row(
//                               children: [
//                                 Icon(
//                                   Iconsax.tag,
//                                   size: 18,
//                                   color: AppThemeX.sub,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   "Interests",
//                                   style: TextStyle(
//                                     fontSize: 12.8,
//                                     fontWeight: FontWeight.w900,
//                                     color: AppThemeX.sub,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children: interests.take(10).map(_chip).toList(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     const SizedBox(height: 14),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 6, 14, 18),
//                       child: Column(
//                         children: [
//                           _bigActionButton(
//                             text: "Share ${user.fullName}'s profile",
//                             onTap: () {},
//                           ),
//                           const SizedBox(height: 10),
//                           _bigActionButton(
//                             text: "Block ${user.fullName}",
//                             onTap: () {},
//                           ),
//                           const SizedBox(height: 10),
//                           _bigActionButton(
//                             text: "Report ${user.fullName}",
//                             onTap: () {},
//                             textColor: const Color(0xFFEF4444),
//                           ),
//                         ],
//                       ),
//                     ),
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
//   Widget _topProgressBarsDynamic({
//     required int segments,
//     required int activeIndex,
//   }) {
//     final seg = segments <= 0 ? 1 : segments;
//     final act = activeIndex.clamp(0, seg - 1);
//
//     return Row(
//       children: List.generate(seg, (i) {
//         final isActive = i == act;
//         return Expanded(
//           child: Container(
//             height: 4,
//             margin: EdgeInsets.only(right: i == seg - 1 ? 0 : 8),
//             decoration: BoxDecoration(
//               color: isActive ? Colors.white : Colors.black.withOpacity(0.25),
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTinderCard(DiscoveryUser user) {
//     List<String> allImages = [];
//     if (user.profilePic.isNotEmpty && _isValidHttpUrl(user.profilePic)) {
//       allImages.add(user.profilePic.trim());
//     }
//     allImages.addAll(user.galleryImages.where(_isValidHttpUrl));
//     allImages = allImages.toSet().toList();
//
//     if (allImages.isEmpty) {
//       allImages = [];
//     }
//
//     return GestureDetector(
//       onTap: () => _showFullProfile(user),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             allImages.isEmpty
//                 ? _cardFallback()
//                 : PageView.builder(
//               itemCount: allImages.length,
//               onPageChanged: (i) {
//                 setState(() {
//                   _cardImageIndex[user.userId] = i;
//                 });
//               },
//               itemBuilder: (_, i) {
//                 final url = allImages[i];
//                 return Image.network(
//                   url,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (_, child, p) {
//                     if (p == null) return child;
//                     // ✅ UPDATED: shimmer package
//                     return AppShimmerX.box(
//                       width: double.infinity,
//                       height: double.infinity,
//                       radius: 0,
//                     );
//                   },
//                   errorBuilder: (_, __, ___) => _cardFallback(),
//                 );
//               },
//             ),
//             Positioned(
//               top: 12,
//               left: 14,
//               right: 14,
//               child: _topProgressBarsDynamic(
//                 segments: allImages.isEmpty ? 1 : allImages.length,
//                 activeIndex: _cardImageIndex[user.userId] ?? 0,
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.0),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(26),
//                     topRight: Radius.circular(26),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _statusPill("Recently active"),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   user.fullName,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 34,
//                                     fontWeight: FontWeight.w900,
//                                     letterSpacing: -0.6,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "${user.age}",
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.95),
//                                   fontSize: 32,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: -0.4,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               const Icon(
//                                 Icons.verified,
//                                 size: 28,
//                                 color: Color(0xFF1D9BF0),
//                               ),
//                             ],
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () => _showFullProfile(user),
//                           borderRadius: BorderRadius.circular(999),
//                           child: Container(
//                             width: 44,
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.55),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.18),
//                               ),
//                             ),
//                             child: const Icon(
//                               Iconsax.arrow_up_3,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(
//                           Iconsax.location,
//                           size: 16,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           user.distanceKm > 0
//                               ? "${user.distanceKm.toStringAsFixed(2)} km away"
//                               : "Nearby",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 14),
//                     Row(
//                       children: [
//                         Icon(
//                           Iconsax.heart,
//                           size: 18,
//                           color: Colors.white.withOpacity(0.95),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "Interests",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.95),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: -0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: _getInterests(
//                         user,
//                       ).take(9).map(_interestChipDark).toList(),
//                     ),
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
//   Widget _actionCircle({
//     required IconData icon,
//     required Color iconColor,
//     required VoidCallback onTap,
//     double size = 72,
//     bool primary = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(999),
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           border: Border.all(color: AppThemeX.line),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(primary ? 0.14 : 0.10),
//               blurRadius: primary ? 16 : 12,
//               offset: const Offset(0, 7),
//             ),
//           ],
//         ),
//         child: Icon(icon, color: iconColor, size: 38),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppThemeX.bg,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Initly',
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w900,
//                           color: AppThemeX.red,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: _isLocationUpdating
//                                 ? null
//                                 : () async {
//                               await _updateUserLocation();
//                               await _fetchDiscovery();
//                             },
//                             borderRadius: BorderRadius.circular(999),
//                             child: Container(
//                               width: 42,
//                               height: 42,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: AppThemeX.line),
//                               ),
//                               child: _isLocationUpdating
//                                   ? const Padding(
//                                 padding: EdgeInsets.all(12),
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: AppThemeX.red,
//                                 ),
//                               )
//                                   : const Icon(
//                                 Iconsax.gps,
//                                 size: 18,
//                                 color: AppThemeX.text,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           InkWell(
//                             onTap: _showFilterBottomSheet,
//                             borderRadius: BorderRadius.circular(999),
//                             child: Container(
//                               width: 42,
//                               height: 42,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: AppThemeX.line),
//                               ),
//                               child: Icon(
//                                 Iconsax.setting_4,
//                                 size: 18,
//                                 color: _isFilterVisible
//                                     ? AppThemeX.red
//                                     : AppThemeX.text,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: _isLoading || _isLocationUpdating
//                   // ✅ UPDATED: Better shimmer skeleton (instead of just overlay)
//                       ? _buildLoadingSkeleton()
//                       : _errorMessage != null
//                       ? const Center(child: Text("No Profile Found"))
//                       : profiles.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Iconsax.user,
//                           size: 64,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 14),
//                         Text(
//                           'No more profiles',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w800,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Check back later',
//                           style: TextStyle(
//                             fontSize: 12.8,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: CardSwiper(
//                       controller: _cardSwiperController,
//                       cardsCount: profiles.length,
//                       cardBuilder: (context, index, _, __) {
//                         return _buildTinderCard(profiles[index]);
//                       },
//                       onSwipe: (prev, current, direction) {
//                         if (prev != null) {
//                           _handleSwipe(prev, direction);
//                         }
//                         return true;
//                       },
//                       allowedSwipeDirection: AllowedSwipeDirection.only(
//                         left: true,
//                         right: true,
//                       ),
//                       numberOfCardsDisplayed: profiles.length >= 2
//                           ? 2
//                           : profiles.length,
//                       backCardOffset: const Offset(0, 10),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12, top: 6),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ScaleTransition(
//                         scale: _undoBtnController,
//                         child: _actionCircle(
//                           icon: Iconsax.refresh,
//                           iconColor: Colors.orange,
//                           onTap: _handleUndo,
//                           size: 72,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       ScaleTransition(
//                         scale: _dislikeBtnController,
//                         child: _actionCircle(
//                           icon: Icons.close,
//                           iconColor: AppThemeX.red,
//                           onTap: _handleDislike,
//                           size: 72,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       ScaleTransition(
//                         scale: _likeBtnController,
//                         child: _actionCircle(
//                           icon: Iconsax.heart,
//                           iconColor: AppThemeX.green,
//                           onTap: _handleLike,
//                           size: 72,
//                           primary: true,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       ScaleTransition(
//                         scale: _directMessageController,
//                         child: _actionCircle(
//                           icon: Icons.telegram,
//                           iconColor: AppThemeX.blue,
//                           onTap: _handleDirectMessage,
//                           size: 72,
//                           primary: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (_isProfileExpanded && _selectedProfile != null)
//               Positioned.fill(child: _buildFullProfile(_selectedProfile!)),
//             if (_showLikeFlash)
//               Positioned.fill(
//                 child: AnimatedBuilder(
//                   animation: _likeFlashController,
//                   builder: (_, __) {
//                     final v = _likeFlashController.value;
//                     return Opacity(
//                       opacity: 1.0 - v,
//                       child: Container(
//                         color: AppThemeX.green.withOpacity(0.18),
//                         child: Center(
//                           child: Transform.scale(
//                             scale: 0.9 + (v * 0.5),
//                             child: Container(
//                               width: 160,
//                               height: 160,
//                               decoration: BoxDecoration(
//                                 color: AppThemeX.green,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppThemeX.green.withOpacity(0.55),
//                                     blurRadius: 22,
//                                     spreadRadius: 6,
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Iconsax.heart,
//                                 color: Colors.white,
//                                 size: 86,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             if (_showDislikeFlash)
//               Positioned.fill(
//                 child: AnimatedBuilder(
//                   animation: _dislikeFlashController,
//                   builder: (_, __) {
//                     final v = _dislikeFlashController.value;
//                     return Opacity(
//                       opacity: 1.0 - v,
//                       child: Container(
//                         color: AppThemeX.red.withOpacity(0.18),
//                         child: Center(
//                           child: Transform.scale(
//                             scale: 0.9 + (v * 0.5),
//                             child: Container(
//                               width: 160,
//                               height: 160,
//                               decoration: BoxDecoration(
//                                 color: AppThemeX.red,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppThemeX.red.withOpacity(0.55),
//                                     blurRadius: 22,
//                                     spreadRadius: 6,
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Iconsax.close_circle,
//                                 color: Colors.white,
//                                 size: 86,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
