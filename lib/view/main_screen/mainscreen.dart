//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:ui' as ui;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
//
// import '../../controller/services/StorageService.dart';
// import '../../controller/services/app_api_service.dart';
// import '../../testibg.dart';
//
// // ─── Theme ────────────────────────────────────────────────────────────────────
//
// // AppThemeX is assumed to exist in testibg.dart / app_api_service.dart
// // If it doesn't, uncomment:
// // class AppThemeX {
// //   static const Color red   = Color(0xFFFF4458);
// //   static const Color green = Color(0xFF3EC875);
// //   static const Color blue  = Color(0xFF2196F3);
// //   static const Color text  = Color(0xFF1A1A2E);
// //   static const Color sub   = Color(0xFF888888);
// //   static Color get line    => const Color(0xFFE0E0E0);
// // }
//
// // ─── AppShimmerX ──────────────────────────────────────────────────────────────
//
// class AppShimmerX {
//   static Widget circle({double size = 40}) => Container(
//     width: size,
//     height: size,
//     decoration: const BoxDecoration(
//       color: Color(0xFFE0E0E0),
//       shape: BoxShape.circle,
//     ),
//   );
// }
//
// // ─── _Shimmer ─────────────────────────────────────────────────────────────────
//
// class _Shimmer extends StatefulWidget {
//   final BorderRadius borderRadius;
//   const _Shimmer({
//     this.borderRadius = const BorderRadius.all(Radius.circular(0)),
//   });
//   @override
//   State<_Shimmer> createState() => _ShimmerState();
// }
//
// class _ShimmerState extends State<_Shimmer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1300),
//     )..repeat();
//     _anim = Tween(
//       begin: -2.0,
//       end: 2.0,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => ClipRRect(
//         borderRadius: widget.borderRadius,
//         child: SizedBox.expand(
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(_anim.value - 1, 0),
//                 end: Alignment(_anim.value + 1, 0),
//                 colors: const [
//                   Color(0xFFE4E4E4),
//                   Color(0xFFF0F0F0),
//                   Color(0xFFEBEBEB),
//                   Color(0xFFF0F0F0),
//                   Color(0xFFE4E4E4),
//                 ],
//                 stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SmartImage extends StatelessWidget {
//   final String url;
//   final double? width;
//   final double? height;
//   final BoxFit fit;
//   final Color placeholderColor;
//   final Widget errorChild;
//
//   const _SmartImage({
//     Key? key,
//     required this.url,
//     this.width,
//     this.height,
//     required this.fit,
//     required this.placeholderColor,
//     required this.errorChild,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       url,
//       width: width,
//       height: height,
//       fit: fit,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Container(
//           width: width,
//           height: height,
//           color: placeholderColor,
//           child: Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                         loadingProgress.expectedTotalBytes!
//                   : null,
//               color: Colors.white,
//             ),
//           ),
//         );
//       },
//       errorBuilder: (context, error, stackTrace) => errorChild,
//     );
//   }
// }
// // ─── Profile Model ────────────────────────────────────────────────────────────
//
// class Profile {
//   final int userId;
//   final String name;
//   final int age;
//   final String bio;
//   final Color cardColor;
//   final bool verified;
//   final String location;
//   final String imageUrl;
//   final String lookingFor;
//   final List<String> galleryImages;
//   final String? gender;
//   final String? smoking;
//   final String? drinking;
//   final String? zodiac;
//   final String? education;
//   final String? jobTitle;
//   final String? company;
//   final double? distanceKm;
//   final bool isMysteryActive;
//
//   const Profile({
//     required this.userId,
//     required this.name,
//     required this.age,
//     required this.bio,
//     required this.cardColor,
//     this.verified = false,
//     required this.location,
//     required this.imageUrl,
//     required this.lookingFor,
//     required this.galleryImages,
//     this.gender,
//     this.smoking,
//     this.drinking,
//     this.zodiac,
//     this.education,
//     this.jobTitle,
//     this.company,
//     this.distanceKm,
//     this.isMysteryActive = false,
//   });
//
//   factory Profile.fromJson(Map<String, dynamic> json) {
//     List<String> gallery = [];
//     try {
//       final raw = json['gallery_images'];
//       if (raw != null && raw is List && raw.isNotEmpty) {
//         final joined = raw.join(',');
//         final cleaned = joined
//             .replaceAll('[', '')
//             .replaceAll(']', '')
//             .replaceAll('"', '')
//             .trim();
//         gallery = cleaned
//             .split(',')
//             .map((e) => e.trim())
//             .where((e) => e.isNotEmpty && e.startsWith('http'))
//             .toList();
//       }
//     } catch (_) {}
//
//     final colors = [
//       const Color(0xFFD4A574),
//       const Color(0xFF7EC8C8),
//       const Color(0xFF8B7355),
//       const Color(0xFFB5838D),
//       const Color(0xFF6B8F71),
//       const Color(0xFF9B8EA8),
//     ];
//     final color = colors[(json['UserId'] ?? 0) % colors.length];
//     final profilePic = json['ProfilePic'] ?? '';
//     final allImages = [
//       profilePic,
//       ...gallery,
//     ].where((e) => e.isNotEmpty).cast<String>().toList();
//
//     final dist = json['DistanceKm'];
//     final distStr = dist != null
//         ? '${(dist as num).toStringAsFixed(0)} miles away'
//         : 'Nearby';
//
//     return Profile(
//       userId: json['UserId'] ?? 0,
//       name: json['FullName'] ?? 'Unknown',
//       age: json['Age'] ?? 0,
//       bio: json['Bio'] ?? '',
//       cardColor: color,
//       location: distStr,
//       imageUrl: profilePic,
//       lookingFor: json['LookingFor'] ?? 'Not specified',
//       galleryImages: allImages,
//       gender: json['Gender'],
//       smoking: json['smoking'],
//       drinking: json['drinking'],
//       zodiac: json['zodiac'],
//       education: json['education'],
//       jobTitle: json['job_title'],
//       company: json['company'],
//       distanceKm: (json['DistanceKm'] as num?)?.toDouble(),
//       isMysteryActive: json['IsMysteryActive'] == true,
//     );
//   }
// }
//
// // ─── UserPreferences ──────────────────────────────────────────────────────────
//
// class UserPreferences {
//   int minAge;
//   int maxAge;
//   int searchRadiusKm;
//   String lookingFor;
//
//   UserPreferences({
//     this.minAge = 18,
//     this.maxAge = 50,
//     this.searchRadiusKm = 50,
//     this.lookingFor = 'Everyone',
//   });
//
//   Map<String, dynamic> toJson() => {
//     "MinAge": minAge,
//     "MaxAge": maxAge,
//     "Radius": searchRadiusKm,
//     "LookingFor": lookingFor,
//   };
//
//   factory UserPreferences.fromJson(Map<String, dynamic> json) =>
//       UserPreferences(
//         minAge: json['MinAge'] ?? 18,
//         maxAge: json['MaxAge'] ?? 50,
//         searchRadiusKm: json['Radius'] ?? 50,
//         lookingFor: json['LookingFor'] ?? 'Everyone',
//       );
// }
//
// // ─── ApiService ───────────────────────────────────────────────────────────────
//
// class ApiService {
//   static Future<List<Profile>> getDiscoveryList() async {
//     try {
//       final token = await SecureStorageService.getToken();
//       final res = await http.post(
//         Uri.parse('$base/api/Profile/GetUserDiscoveryList'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({"Limit": 1000, "Offset": 0}),
//       );
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['isSuccess'] == true && data['Response'] != null) {
//           return (data['Response'] as List)
//               .map((e) => Profile.fromJson(e))
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Discovery error: $e');
//       return [];
//     }
//   }
//
//   static Future<bool?> setLikeDislike(int userId, bool isLike) async {
//     try {
//       final token = await SecureStorageService.getToken();
//       final res = await http.post(
//         Uri.parse('$base/api/Profile/SetUserLikeDislikeValue'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({"p_ToUserId": userId, "p_IsLike": isLike}),
//       );
//       final data = jsonDecode(res.body);
//       if (data['isSuccess'] == true) return data['isMatch'] == true;
//       return null;
//     } catch (e) {
//       debugPrint('LikeDislike error: $e');
//       return null;
//     }
//   }
//
//   static Future<String> getMyProfilePic() async {
//     try {
//       final token = await SecureStorageService.getToken();
//       final res = await http.get(
//         Uri.parse('$base/api/Profile/GetUserProfile'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['isSuccess'] == true && data['Response'] != null) {
//           final resp = data['Response'];
//           final profile = resp is List ? resp.first : resp;
//           String pic = profile['profilepic'] ?? profile['ProfilePic'] ?? '';
//           if (pic.isEmpty) {
//             final images = profile['userImage'] as List?;
//             if (images != null && images.isNotEmpty) {
//               final main = images.firstWhere(
//                 (img) => img['IsProfilePic'] == true,
//                 orElse: () => images.first,
//               );
//               pic = main['PhotoUrl'] ?? '';
//             }
//           }
//           return pic;
//         }
//       }
//       return '';
//     } catch (e) {
//       return '';
//     }
//   }
//
//   static Future<bool> updateUserLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         final token = await SecureStorageService.getToken();
//         if (token == null) return false;
//         final res = await http.post(
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
//         return res.statusCode == 200;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Location error: $e');
//       return false;
//     }
//   }
//
//   static Future<bool> sendDirectMessage(int receiverId, String message) async {
//     try {
//       final token = await SecureStorageService.getToken();
//       if (token == null) return false;
//       final res = await http.post(
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
//       final data = jsonDecode(res.body);
//       return res.statusCode == 200 && data['isSuccess'] == true;
//     } catch (e) {
//       debugPrint('SendMessage error: $e');
//       return false;
//     }
//   }
//
//   static Future<UserPreferences?> getUserPreferences() async {
//     try {
//       final token = await SecureStorageService.getToken();
//       if (token == null) return null;
//       final res = await http.get(
//         Uri.parse("$base/api/Profile/GetUserPreferences"),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['isSuccess'] == true && data['Response'] != null) {
//           return UserPreferences.fromJson(data['Response']);
//         }
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   static Future<bool> updateUserPreferences(UserPreferences preferences) async {
//     try {
//       final token = await SecureStorageService.getToken();
//       if (token == null) return false;
//       final res = await http.post(
//         Uri.parse("$base/api/Profile/UpdatePreferencese"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(preferences.toJson()),
//       );
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         return data['isSuccess'] == true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MAIN SCREEN
// // ─────────────────────────────────────────────────────────────────────────────
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   // ── State ──
//   int _navIndex = 0;
//   int _tabIndex = 0;
//   List<Profile> _deck = [];
//   List<Profile> _matches = [];
//   bool _isLoading = true;
//   String? _errorMsg;
//   String _myProfilePic = '';
//   bool _isPreferencesLoading = false;
//   UserPreferences _userPreferences = UserPreferences();
//
//   // ── CardSwiper controller ──
//   // This is used to trigger swipes / undo from the action buttons
//   final CardSwiperController _swiperCtrl = CardSwiperController();
//
//   final List<String> _lookingForOptions = [
//     'Everyone',
//     'Men',
//     'Women',
//     'Non-binary',
//   ];
//
//   // ── Lifecycle ──────────────────────────────────────────────────────────────
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   @override
//   void dispose() {
//     _swiperCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Init ───────────────────────────────────────────────────────────────────
//
//   Future<void> _init() async {
//     // await ApiService.updateUserLocation();
//     final results = await Future.wait([
//       ApiService.getDiscoveryList(),
//       ApiService.getMyProfilePic(),
//       ApiService.getUserPreferences(),
//     ]);
//     if (mounted) {
//       setState(() {
//         _deck = results[0] as List<Profile>;
//         _myProfilePic = results[1] as String;
//         if (results[2] != null) {
//           _userPreferences = results[2] as UserPreferences;
//         }
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _loadProfiles() async {
//     setState(() {
//       _isLoading = true;
//       _errorMsg = null;
//     });
//     try {
//       final profiles = await ApiService.getDiscoveryList();
//       if (mounted)
//         setState(() {
//           _deck = profiles;
//           _isLoading = false;
//         });
//     } catch (e) {
//       if (mounted)
//         setState(() {
//           _errorMsg = 'Failed to load profiles';
//           _isLoading = false;
//         });
//     }
//   }
//
//   Future<void> _fetchDiscovery() async {
//     setState(() => _isLoading = true);
//     try {
//       final profiles = await ApiService.getDiscoveryList();
//       if (mounted)
//         setState(() {
//           _deck = profiles;
//           _isLoading = false;
//         });
//     } catch (e) {
//       if (mounted)
//         setState(() {
//           _errorMsg = 'Failed to load profiles';
//           _isLoading = false;
//         });
//     }
//   }
//
//   // ── CardSwiper callbacks ───────────────────────────────────────────────────
//
//   /// Called automatically by CardSwiper after every swipe.
//   bool _onSwipe(
//     int previousIndex,
//     int? currentIndex,
//     CardSwiperDirection direction,
//   ) {
//     if (previousIndex >= _deck.length) return true;
//     final p = _deck[previousIndex];
//     HapticFeedback.lightImpact();
//
//     if (direction == CardSwiperDirection.right) {
//       _matches.add(p);
//       ApiService.setLikeDislike(p.userId, true).then((isMatch) {
//         if (isMatch == true) {
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (mounted) _showMatchDialog(p);
//           });
//         }
//       });
//     } else if (direction == CardSwiperDirection.left) {
//       ApiService.setLikeDislike(p.userId, false);
//     }
//
//     // Return true → allow the swipe
//     return true;
//   }
//
//   bool _onUndo(
//     int? previousIndex,
//     int currentIndex,
//     CardSwiperDirection direction,
//   ) {
//     HapticFeedback.selectionClick();
//     return true;
//   }
//
//   // ── Action bar callbacks (trigger CardSwiper programmatically) ─────────────
//
//   void _onRewind() {
//     if (_deck.isEmpty) return;
//     _swiperCtrl.undo();
//   }
//
//   void _onSwipeLeft() {
//     if (_deck.isEmpty) return;
//     _swiperCtrl.swipe(CardSwiperDirection.left);
//   }
//
//   void _onSwipeRight() {
//     if (_deck.isEmpty) return;
//     _swiperCtrl.swipe(CardSwiperDirection.right);
//   }
//
//   void _onDirectMessage() {
//     if (_deck.isEmpty) return;
//     HapticFeedback.mediumImpact();
//     // deck[0] is the topmost visible card
//     _openDirectMessageSheet(_deck[0]);
//   }
//
//   // ── Sheets / Dialogs ───────────────────────────────────────────────────────
//
//   void _openDirectMessageSheet(Profile profile) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _DirectMessageSheet(profile: profile),
//     );
//   }
//
//   void _showMatchDialog(Profile p) {
//     if (!mounted) return;
//     HapticFeedback.heavyImpact();
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => MatchDialog(
//         profile: p,
//         myProfilePic: _myProfilePic,
//         onSendMessage: () => _openDirectMessageSheet(p),
//       ),
//     );
//   }
//
//   void _openProfileDetail(Profile p) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _ProfileDetailSheet(
//         profile: p,
//         onReply: () => _openDirectMessageSheet(p),
//       ),
//     );
//   }
//
//   // ── Filter sheet ───────────────────────────────────────────────────────────
//
//   void _showFilterBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _buildFilterSheet(),
//     );
//   }
//
//   Widget _buildFilterSheet() {
//     return StatefulBuilder(
//       builder: (sheetCtx, setModal) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
//                       onPressed: () => Navigator.pop(sheetCtx),
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
//                     _prefItem(
//                       title: 'Age Range',
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _dropdown<int>(
//                               value: _userPreferences.minAge,
//                               items: List.generate(83, (i) => i + 18),
//                               onChanged: (v) {
//                                 if (v == null) return;
//                                 setModal(() {
//                                   _userPreferences.minAge = v;
//                                   if (_userPreferences.maxAge < v)
//                                     _userPreferences.maxAge = v;
//                                 });
//                               },
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: Text('to'),
//                           ),
//                           Expanded(
//                             child: _dropdown<int>(
//                               value: _userPreferences.maxAge,
//                               items: List.generate(83, (i) => i + 18)
//                                   .where((a) => a >= _userPreferences.minAge)
//                                   .toList(),
//                               onChanged: (v) {
//                                 if (v != null)
//                                   setModal(() => _userPreferences.maxAge = v);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     _prefItem(
//                       title: 'Distance',
//                       child: _dropdown<int>(
//                         value: _userPreferences.searchRadiusKm,
//                         items: const [5, 10, 25, 50, 100, 200],
//                         onChanged: (v) {
//                           if (v != null)
//                             setModal(() => _userPreferences.searchRadiusKm = v);
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     _prefItem(
//                       title: 'Looking for',
//                       child: _dropdown<String>(
//                         value: _userPreferences.lookingFor,
//                         items: _lookingForOptions,
//                         onChanged: (v) {
//                           if (v != null)
//                             setModal(() => _userPreferences.lookingFor = v);
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     ElevatedButton(
//                       onPressed: _isPreferencesLoading
//                           ? null
//                           : () async {
//                               setState(() => _isPreferencesLoading = true);
//                               final ok = await ApiService.updateUserPreferences(
//                                 _userPreferences,
//                               );
//                               if (ok && mounted) {
//                                 Navigator.pop(sheetCtx);
//                                 await _fetchDiscovery();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Preferences updated successfully',
//                                     ),
//                                     backgroundColor: AppThemeX.green,
//                                   ),
//                                 );
//                               }
//                               if (mounted)
//                                 setState(() => _isPreferencesLoading = false);
//                             },
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
//                               width: 22,
//                               height: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
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
//   Widget _prefItem({required String title, required Widget child}) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         title,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey[600],
//         ),
//       ),
//       const SizedBox(height: 8),
//       child,
//     ],
//   );
//
//   Widget _dropdown<T>({
//     required T value,
//     required List<T> items,
//     required void Function(T?) onChanged,
//   }) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey.shade300),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: DropdownButton<T>(
//       value: value,
//       items: items
//           .map(
//             (item) =>
//                 DropdownMenuItem<T>(value: item, child: Text(item.toString())),
//           )
//           .toList(),
//       onChanged: onChanged,
//       isExpanded: true,
//       underline: const SizedBox(),
//       icon: const Icon(Icons.arrow_drop_down),
//     ),
//   );
//
//   // ── Home body ──────────────────────────────────────────────────────────────
//
//   Widget _buildHomeBody() {
//     if (_isLoading) return const _LoadingView();
//     if (_errorMsg != null)
//       return _ErrorView(message: _errorMsg!, onRetry: _loadProfiles);
//     if (_deck.isEmpty) return _EmptyDeckView(onRefresh: _loadProfiles);
//
//     // ── CardSwiper with back card hidden and fixed dimensions ──
//     return CardSwiper(
//       controller: _swiperCtrl,
//       cardsCount: _deck.length,
//       numberOfCardsDisplayed: 2, // Only show 1 card (hide back card)
//       isLoop: false,
//       padding: EdgeInsets.zero,
//       // Remove backCardOffset and scale to hide back card completely
//       backCardOffset: Offset.zero, // No offset
//       scale: 1.0, // Full scale
//       onSwipe: _onSwipe,
//       onUndo: _onUndo,
//       cardBuilder:
//           (
//             context,
//             index,
//             horizontalThresholdPercentage,
//             verticalThresholdPercentage,
//           ) {
//             if (index >= _deck.length) return const SizedBox.shrink();
//             final profile = _deck[index];
//
//             // Live LIKE/NOPE overlay driven by drag percentage
//             String? overlayLabel;
//             if (horizontalThresholdPercentage > 20) overlayLabel = 'LIKE';
//             if (horizontalThresholdPercentage < -20) overlayLabel = 'NOPE';
//
//             return _ProfileCard(
//               key: ValueKey('card_${profile.userId}'),
//               profile: profile,
//               overlayLabel: overlayLabel,
//               onInfoTap: () => _openProfileDetail(profile),
//               // Add fixed width constraint if needed
//             );
//           },
//     );
//   }
//
//   // ── Build ──────────────────────────────────────────────────────────────────
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             // Top bar
//             _TinderTopBar(
//               tabIndex: _tabIndex,
//               onTabChanged: (i) => setState(() => _tabIndex = i),
//               onFilter: _showFilterBottomSheet,
//             ),
//             SizedBox(height: 10),
//             // Main content
//             Expanded(
//               child: _navIndex == 0
//                   ? Column(
//                       children: [
//                         // ── Card area: Expanded → fills all remaining height ──
//                         Expanded(
//                           child: Container(
//                             height: 400,
//                             width: double.infinity,
//                             color: Colors.transparent,
//                             child: _buildHomeBody(),
//                           ),
//                         ),
//                         // Action buttons sit below the card
//                         _ActionBar(
//                           onRewind: _onRewind,
//                           onDislike: _onSwipeLeft,
//                           onDirectMessage: _onDirectMessage,
//                           onLike: _onSwipeRight,
//                           hasDeck: _deck.isNotEmpty,
//                         ),
//                       ],
//                     )
//                   : _navIndex == 2
//                   ? _MatchesView(matches: _matches)
//                   : const _PlaceholderView(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  TOP BAR
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _TinderTopBar extends StatelessWidget {
//   final int tabIndex;
//   final ValueChanged<int> onTabChanged;
//   final VoidCallback onFilter;
//
//   const _TinderTopBar({
//     required this.tabIndex,
//     required this.onTabChanged,
//     required this.onFilter,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               "initily",
//               style: TextStyle(
//                 color: Colors.pink,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//
//           GestureDetector(
//             onTap: onFilter,
//             child: const Icon(
//               Icons.tune_rounded,
//               color: Colors.black54,
//               size: 26,
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {},
//             child: const Icon(
//               Iconsax.notification,
//               color: Color(0xFFFF2600),
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TopTab extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   const _TopTab({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: selected ? Colors.black : Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//           border: selected
//               ? null
//               : Border.all(color: Colors.grey.shade300, width: 1.5),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black54,
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  LOADING / ERROR / EMPTY VIEWS
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _LoadingView extends StatefulWidget {
//   const _LoadingView();
//   @override
//   State<_LoadingView> createState() => _LoadingViewState();
// }
//
// class _LoadingViewState extends State<_LoadingView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _c;
//   late Animation<double> _p;
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..repeat(reverse: true);
//     _p = Tween(
//       begin: 0.9,
//       end: 1.05,
//     ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ScaleTransition(
//           scale: _p,
//           child: ShaderMask(
//             shaderCallback: (b) => const LinearGradient(
//               colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
//             ).createShader(b),
//             child: const Icon(
//               Icons.local_fire_department,
//               size: 60,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           'Finding people near you...',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Colors.black45,
//           ),
//         ),
//         const SizedBox(height: 14),
//         SizedBox(
//           width: 140,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(3),
//             child: const LinearProgressIndicator(
//               minHeight: 3,
//               color: Color(0xFFFF4458),
//               backgroundColor: Color(0xFFFFE0E3),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorView({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.black26),
//         const SizedBox(height: 16),
//         Text(
//           message,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black54,
//           ),
//         ),
//         const SizedBox(height: 20),
//         TextButton(
//           onPressed: onRetry,
//           child: const Text(
//             'Try Again',
//             style: TextStyle(
//               color: Color(0xFFFF4458),
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// class _EmptyDeckView extends StatelessWidget {
//   final VoidCallback onRefresh;
//   const _EmptyDeckView({required this.onRefresh});
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ShaderMask(
//           shaderCallback: (b) => const LinearGradient(
//             colors: [Color(0xFFFFCDD2), Color(0xFFFFE0E3)],
//           ).createShader(b),
//           child: const Icon(
//             Icons.local_fire_department,
//             size: 72,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 18),
//         const Text(
//           "You've seen everyone!",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Colors.black54,
//           ),
//         ),
//         const SizedBox(height: 6),
//         const Text(
//           'Come back later',
//           style: TextStyle(fontSize: 14, color: Colors.black38),
//         ),
//         const SizedBox(height: 24),
//         GestureDetector(
//           onTap: onRefresh,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
//               ),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: const Text(
//               'Refresh',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// class _ProfileCard extends StatefulWidget {
//   final Profile profile;
//   final String? overlayLabel;
//   final VoidCallback onInfoTap;
//
//   const _ProfileCard({
//     super.key,
//     required this.profile,
//     required this.overlayLabel,
//     required this.onInfoTap,
//   });
//
//   @override
//   State<_ProfileCard> createState() => _ProfileCardState();
// }
//
// class _ProfileCardState extends State<_ProfileCard> {
//   int _photoIdx = 0;
//
//   void _tap(double dx, double width) {
//     final imgs = widget.profile.galleryImages;
//     if (imgs.length <= 1) return;
//     setState(() {
//       _photoIdx = dx > width / 2
//           ? (_photoIdx + 1).clamp(0, imgs.length - 1)
//           : (_photoIdx - 1).clamp(0, imgs.length - 1);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final imgs = widget.profile.galleryImages;
//     final count = imgs.isEmpty ? 1 : imgs.length;
//     final idx = _photoIdx.clamp(0, imgs.isEmpty ? 0 : imgs.length - 1);
//     final imgUrl = imgs.isEmpty ? widget.profile.imageUrl : imgs[idx];
//
//     // Fixed width 400, full height
//     return SizedBox(
//       width: 400,
//       height: double.infinity,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           fit: StackFit.expand, // This makes children expand to fill
//           children: [
//             // ①  FULL-BLEED PHOTO — covers every pixel of the card
//             GestureDetector(
//               onTapUp: (d) {
//                 final box = context.findRenderObject() as RenderBox?;
//                 if (box != null) _tap(d.localPosition.dx, box.size.width);
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 220),
//                   transitionBuilder: (child, anim) =>
//                       FadeTransition(opacity: anim, child: child),
//                   child: _SmartImage(
//                     key: ValueKey('${widget.profile.userId}_$imgUrl'),
//                     url: imgUrl,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover, // This ensures image covers full area
//                     placeholderColor: widget.profile.cardColor,
//                     errorChild: Container(
//                       width: double.infinity,
//                       height: double.infinity,
//                       color: widget.profile.cardColor,
//                       child: Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.asset(
//                               'assets/images/logo.png',
//                               width: 90,
//                               height: 90,
//                               fit: BoxFit.contain,
//                               errorBuilder: (_, __, ___) => Icon(
//                                 Icons.person_rounded,
//                                 size: 90,
//                                 color: Colors.white.withOpacity(0.45),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               widget.profile.name.isNotEmpty
//                                   ? widget.profile.name[0]
//                                   : '?',
//                               style: TextStyle(
//                                 fontSize: 52,
//                                 fontWeight: FontWeight.w800,
//                                 color: Colors.white.withOpacity(0.55),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // ②  MYSTERY BLUR (optional)
//             if (widget.profile.isMysteryActive)
//               Positioned.fill(
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     BackdropFilter(
//                       filter: ui.ImageFilter.blur(sigmaX: 26, sigmaY: 26),
//                       child: Container(color: Colors.black.withOpacity(0.40)),
//                     ),
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 74,
//                             height: 74,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.14),
//                               border: Border.all(
//                                 color: Colors.white60,
//                                 width: 2,
//                               ),
//                             ),
//                             child: const Icon(
//                               Icons.lock_rounded,
//                               color: Colors.white,
//                               size: 36,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Mystery Profile',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 18,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.18),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: Colors.white30),
//                             ),
//                             child: const Text(
//                               'Like to reveal',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             // ③  PHOTO PROGRESS BARS — thin lines at very top of card
//             if (!widget.profile.isMysteryActive)
//               Positioned(
//                 top: 8,
//                 left: 8,
//                 right: 8,
//                 child: Row(
//                   children: List.generate(count, (i) {
//                     final isActive = i == idx;
//                     return Expanded(
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         height: 2.5,
//                         margin: const EdgeInsets.symmetric(horizontal: 2),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.40),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//
//             // ④  BOTTOM GRADIENT + INFO
//             if (!widget.profile.isMysteryActive)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(14, 100, 14, 18),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Color(0x55000000),
//                         Color(0xCC000000),
//                         Color(0xF2000000),
//                       ],
//                       stops: [0.0, 0.35, 0.65, 1.0],
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.baseline,
//                               textBaseline: TextBaseline.alphabetic,
//                               children: [
//                                 Flexible(
//                                   child: Text(
//                                     widget.profile.name,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.w800,
//                                       letterSpacing: -0.3,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '${widget.profile.age}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 if (widget.profile.verified) ...[
//                                   const SizedBox(width: 6),
//                                   const Icon(
//                                     Icons.verified,
//                                     color: Color(0xFF5BB8F5),
//                                     size: 20,
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: widget.onInfoTap,
//                             child: Container(
//                               width: 38,
//                               height: 38,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.25),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.keyboard_arrow_up_rounded,
//                                 color: Colors.black87,
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on_rounded,
//                             color: Colors.white70,
//                             size: 14,
//                           ),
//                           const SizedBox(width: 3),
//                           Text(
//                             widget.profile.location,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.profile.jobTitle.toString(),
//
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             // ⑤  LIKE / NOPE STAMP
//             if (widget.overlayLabel != null)
//               _CardStamp(label: widget.overlayLabel!),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ─────────────────────────────────────────────────────────────────────────────
// //  CARD STAMP (LIKE / NOPE)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _CardStamp extends StatefulWidget {
//   final String label;
//   const _CardStamp({required this.label});
//   @override
//   State<_CardStamp> createState() => _CardStampState();
// }
//
// class _CardStampState extends State<_CardStamp>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _c;
//   late Animation<double> _s;
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 180),
//     );
//     _s = Tween<double>(
//       begin: 0.6,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
//     _c.forward();
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
//     final isLike = widget.label == 'LIKE';
//
//     // LIKE → top-left, rotated counter-clockwise (matching screenshot)
//     // NOPE → top-right, rotated clockwise
//     return Positioned(
//       top: 40,
//       left: isLike ? 16 : null,
//       right: isLike ? null : 16,
//       child: ScaleTransition(
//         scale: _s,
//         child: Transform.rotate(
//           angle: isLike ? -0.35 : 0.35,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: isLike
//                     ? const Color(0xFF3EC875)
//                     : const Color(0xFFFF4458),
//                 width: 4,
//               ),
//               borderRadius: BorderRadius.circular(6),
//               color: Colors.transparent,
//             ),
//             child: Text(
//               widget.label,
//               style: TextStyle(
//                 color: isLike
//                     ? const Color(0xFF3EC875)
//                     : const Color(0xFFFF4458),
//                 fontSize: 42,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 4,
//                 height: 1.0,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  ACTION BAR
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _ActionBar extends StatelessWidget {
//   final VoidCallback onRewind;
//   final VoidCallback onDislike;
//   final VoidCallback onDirectMessage;
//   final VoidCallback onLike;
//   final bool hasDeck;
//
//   const _ActionBar({
//     required this.onRewind,
//     required this.onDislike,
//     required this.onDirectMessage,
//     required this.onLike,
//     required this.hasDeck,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _ActionBtn(
//             size: 60,
//             shadowColor: Colors.orange,
//             onTap: onRewind,
//             child: Image.asset(
//               'assets/images/undo.png',
//               color: Colors.orange,
//
//               width: 30,
//               height: 30,
//               errorBuilder: (_, __, ___) => const Icon(
//                 Icons.undo_rounded,
//                 color: Colors.orange,
//                 size: 22,
//               ),
//             ),
//           ),
//           _ActionBtn(
//             size: 62,
//             shadowColor: const Color(0xFFFF4458),
//             onTap: hasDeck ? onDislike : null,
//             child: Image.asset(
//               'assets/images/dislike.png',
//               width: 30,
//               height: 30,
//               errorBuilder: (_, __, ___) => const Icon(
//                 Icons.close_rounded,
//                 color: Color(0xFFFF4458),
//                 size: 30,
//               ),
//             ),
//           ),
//
//           _ActionBtn(
//             size: 62,
//             shadowColor: const Color(0xFF3EC875),
//             onTap: hasDeck ? onLike : null,
//             child: Image.asset(
//               'assets/images/like.png',
//               width: 36,
//               height: 36,
//               errorBuilder: (_, __, ___) => const Icon(
//                 Icons.favorite_rounded,
//                 color: Color(0xFF3EC875),
//                 size: 32,
//               ),
//             ),
//           ),
//           _ActionBtn(
//             size: 60,
//             shadowColor: const Color(0xFFFF4458),
//             onTap: hasDeck ? onDirectMessage : null,
//             child: Image.asset(
//               'assets/images/directmessage.png',
//               width: 30,
//               height: 30,
//               color: hasDeck ? null : Colors.black26,
//               errorBuilder: (_, __, ___) => Icon(
//                 Icons.send_rounded,
//                 color: hasDeck ? const Color(0xFFFF4458) : Colors.black26,
//                 size: 22,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ActionBtn extends StatefulWidget {
//   final double size;
//   final VoidCallback? onTap;
//   final Widget child;
//   final Color shadowColor;
//   const _ActionBtn({
//     required this.size,
//     required this.onTap,
//     required this.child,
//     required this.shadowColor,
//   });
//   @override
//   State<_ActionBtn> createState() => _ActionBtnState();
// }
//
// class _ActionBtnState extends State<_ActionBtn> {
//   bool _pressed = false;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       onTapDown: (_) {
//         if (widget.onTap != null) setState(() => _pressed = true);
//       },
//       onTapUp: (_) => setState(() => _pressed = false),
//       onTapCancel: () => setState(() => _pressed = false),
//       child: AnimatedScale(
//         scale: _pressed ? 0.90 : 1.0,
//         duration: const Duration(milliseconds: 100),
//         curve: Curves.easeOut,
//         child: Container(
//           width: widget.size,
//           height: widget.size,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.10),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Center(child: widget.child),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  PROFILE DETAIL SHEET
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _ProfileDetailSheet extends StatefulWidget {
//   final Profile profile;
//   final VoidCallback onReply;
//   const _ProfileDetailSheet({required this.profile, required this.onReply});
//   @override
//   State<_ProfileDetailSheet> createState() => _ProfileDetailSheetState();
// }
//
// class _ProfileDetailSheetState extends State<_ProfileDetailSheet> {
//   int _photo = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final imgs = widget.profile.galleryImages;
//     final count = imgs.isEmpty ? 1 : imgs.length;
//     final imgUrl = imgs.isEmpty
//         ? widget.profile.imageUrl
//         : imgs[_photo.clamp(0, imgs.length - 1)];
//
//     return DraggableScrollableSheet(
//       initialChildSize: 0.92,
//       minChildSize: 0.5,
//       maxChildSize: 0.98,
//       snap: true,
//       snapSizes: const [0.5, 0.92, 0.98],
//       builder: (ctx, ctrl) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: CustomScrollView(
//           controller: ctrl,
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         '${widget.profile.name}, ${widget.profile.age}',
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         width: 36,
//                         height: 36,
//                         decoration: const BoxDecoration(
//                           color: Colors.black87,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.keyboard_arrow_down_rounded,
//                           color: Colors.white,
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 12)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: AspectRatio(
//                     aspectRatio: 0.82,
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 260),
//                           transitionBuilder: (child, anim) =>
//                               FadeTransition(opacity: anim, child: child),
//                           child: _SmartImage(
//                             key: ValueKey(
//                               'detail_${widget.profile.userId}_$imgUrl',
//                             ),
//                             url: imgUrl,
//                             fit: BoxFit.cover,
//                             placeholderColor: widget.profile.cardColor,
//                             errorChild: Container(
//                               color: widget.profile.cardColor,
//                               child: Center(
//                                 child: Image.asset(
//                                   'assets/images/logo.png',
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.contain,
//                                   errorBuilder: (_, __, ___) => Text(
//                                     widget.profile.name.isNotEmpty
//                                         ? widget.profile.name[0]
//                                         : '?',
//                                     style: const TextStyle(
//                                       fontSize: 64,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.white54,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // Progress bars
//                         Positioned(
//                           top: 10,
//                           left: 8,
//                           right: 8,
//                           child: Row(
//                             children: List.generate(
//                               count,
//                               (i) => Expanded(
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   height: 3,
//                                   margin: const EdgeInsets.symmetric(
//                                     horizontal: 2,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: i == _photo
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.4),
//                                     borderRadius: BorderRadius.circular(2),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // Tap to change photo
//                         Positioned.fill(
//                           child: GestureDetector(
//                             onTapUp: (d) {
//                               if (imgs.length <= 1) return;
//                               final w =
//                                   context
//                                       .findRenderObject()
//                                       ?.paintBounds
//                                       .width ??
//                                   300;
//                               setState(() {
//                                 _photo = d.localPosition.dx > w / 2
//                                     ? (_photo + 1).clamp(0, imgs.length - 1)
//                                     : (_photo - 1).clamp(0, imgs.length - 1);
//                               });
//                             },
//                           ),
//                         ),
//                         // Reply button
//                         Positioned(
//                           bottom: 14,
//                           right: 14,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                               Future.delayed(
//                                 const Duration(milliseconds: 200),
//                                 widget.onReply,
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 18,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.15),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.send_rounded,
//                                     color: Color(0xFFFF4458),
//                                     size: 16,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     'Reply',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 14,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 20)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: _InfoCard(
//                   icon: Icons.search_rounded,
//                   label: 'Bio',
//                   child: Text(
//                     widget.profile.bio,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 14)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: _InfoCard(
//                   icon: Icons.person_outline_rounded,
//                   label: 'Essentials',
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _InfoRow(
//                         icon: Icons.location_on_outlined,
//                         text: widget.profile.location,
//                       ),
//                       if (widget.profile.gender != null)
//                         _InfoRow(
//                           icon: Icons.person_outline,
//                           text: widget.profile.gender!,
//                         ),
//                       if (widget.profile.jobTitle != null)
//                         _InfoRow(
//                           icon: Icons.work_outline_rounded,
//                           text: [
//                             widget.profile.jobTitle,
//                             widget.profile.company,
//                           ].where((e) => e != null).join(' at '),
//                         ),
//                       if (widget.profile.education != null)
//                         _InfoRow(
//                           icon: Icons.school_outlined,
//                           text: widget.profile.education!,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             if (widget.profile.bio.isNotEmpty) ...[
//               const SliverToBoxAdapter(child: SizedBox(height: 14)),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     "",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                       height: 1.6,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             const SliverToBoxAdapter(child: SizedBox(height: 40)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Widget child;
//   const _InfoCard({
//     required this.icon,
//     required this.label,
//     required this.child,
//   });
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade50,
//       borderRadius: BorderRadius.circular(14),
//       border: Border.all(color: Colors.grey.shade200),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: Colors.grey.shade400, size: 15),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         child,
//       ],
//     ),
//   );
// }
//
// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   const _InfoRow({required this.icon, required this.text});
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.only(bottom: 8),
//     child: Row(
//       children: [
//         Icon(icon, color: Colors.grey.shade500, size: 16),
//         const SizedBox(width: 6),
//         Flexible(
//           child: Text(
//             text,
//             style: const TextStyle(fontSize: 14, color: Colors.black87),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MATCHES VIEW
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _MatchesView extends StatelessWidget {
//   final List<Profile> matches;
//   const _MatchesView({required this.matches});
//
//   @override
//   Widget build(BuildContext context) {
//     if (matches.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.favorite_border_rounded,
//               size: 60,
//               color: Color(0xFFFFCDD2),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'No matches yet',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black54,
//               ),
//             ),
//             SizedBox(height: 6),
//             Text(
//               'Start swiping!',
//               style: TextStyle(fontSize: 14, color: Colors.black38),
//             ),
//           ],
//         ),
//       );
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
//           child: Text(
//             'Your Matches',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         Expanded(
//           child: GridView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 0.75,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//             ),
//             itemCount: matches.length,
//             itemBuilder: (ctx, i) {
//               final m = matches[i];
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     _SmartImage(
//                       key: ValueKey('match_${m.userId}'),
//                       url: m.imageUrl,
//                       placeholderColor: m.cardColor,
//                       errorChild: Container(
//                         color: m.cardColor,
//                         child: Center(
//                           child: Text(
//                             m.name.isNotEmpty ? m.name[0] : '?',
//                             style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white54,
//                             ),
//                           ),
//                         ),
//                       ),
//                       fit: BoxFit.fitHeight,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [Colors.transparent, Colors.black54],
//                           ),
//                         ),
//                         child: Text(
//                           m.name,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _PlaceholderView extends StatelessWidget {
//   const _PlaceholderView();
//   @override
//   Widget build(BuildContext context) => const Center(
//     child: Text(
//       'Coming soon',
//       style: TextStyle(color: Colors.black38, fontSize: 16),
//     ),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  DIRECT MESSAGE SHEET
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _DirectMessageSheet extends StatefulWidget {
//   final Profile profile;
//   const _DirectMessageSheet({required this.profile});
//   @override
//   State<_DirectMessageSheet> createState() => _DirectMessageSheetState();
// }
//
// class _DirectMessageSheetState extends State<_DirectMessageSheet> {
//   final _ctrl = TextEditingController();
//   final _scroll = ScrollController();
//   final List<_ChatMsg> _msgs = [];
//
//   static const _quick = [
//     '👋 Hey there!',
//     '☕ Coffee sometime?',
//     '😊 Love your vibe!',
//     '✈️ Wanna explore?',
//   ];
//   static const _auto = [
//     'Hey! 😊',
//     "That's so sweet!",
//     'Would love that! 🌟',
//     'You seem really fun!',
//     'Tell me more!',
//   ];
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _scroll.dispose();
//     super.dispose();
//   }
//
//   void _send(String text) {
//     if (text.trim().isEmpty) return;
//     setState(() {
//       _msgs.add(_ChatMsg(text: text, isMe: true));
//       _ctrl.clear();
//     });
//     _scrollDown();
//     ApiService.sendDirectMessage(widget.profile.userId, text);
//     Future.delayed(const Duration(milliseconds: 1200), () {
//       if (!mounted) return;
//       setState(
//         () => _msgs.add(
//           _ChatMsg(text: _auto[_msgs.length % _auto.length], isMe: false),
//         ),
//       );
//       _scrollDown();
//     });
//   }
//
//   void _scrollDown() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scroll.hasClients) {
//         _scroll.animateTo(
//           _scroll.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final inset = MediaQuery.of(context).viewInsets.bottom;
//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 280),
//       curve: Curves.easeOut,
//       padding: EdgeInsets.only(bottom: inset),
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.80,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 36,
//                       height: 4,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Stack(
//                         children: [
//                           Container(
//                             width: 44,
//                             height: 44,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color(0xFFFF4458),
//                                 width: 2,
//                               ),
//                             ),
//                             child: ClipOval(
//                               child: _SmartImage(
//                                 key: ValueKey('dm_${widget.profile.userId}'),
//                                 url: widget.profile.imageUrl,
//                                 placeholderColor: widget.profile.cardColor,
//                                 errorChild: Container(
//                                   color: widget.profile.cardColor,
//                                   child: const Icon(
//                                     Icons.person_rounded,
//                                     color: Colors.white54,
//                                     size: 24,
//                                   ),
//                                 ),
//                                 fit: BoxFit.fitHeight,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 1,
//                             bottom: 1,
//                             child: Container(
//                               width: 11,
//                               height: 11,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF3EC875),
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   width: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.profile.name,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             const Text(
//                               'Active now',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF3EC875),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.close_rounded,
//                           color: Colors.black38,
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Messages
//             Expanded(
//               child: _msgs.isEmpty
//                   ? _EmptyDM(profile: widget.profile)
//                   : ListView.builder(
//                       controller: _scroll,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       itemCount: _msgs.length,
//                       itemBuilder: (_, i) => _Bubble(msg: _msgs[i]),
//                     ),
//             ),
//             // Quick replies
//             if (_msgs.isEmpty)
//               SizedBox(
//                 height: 46,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   itemCount: _quick.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 8),
//                   itemBuilder: (_, i) => GestureDetector(
//                     onTap: () => _send(_quick[i]),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF4458).withOpacity(0.07),
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(
//                           color: const Color(0xFFFF4458).withOpacity(0.25),
//                         ),
//                       ),
//                       child: Text(
//                         _quick[i],
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFFFF4458),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 6),
//             // Input row
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, -3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: TextField(
//                         controller: _ctrl,
//                         maxLines: null,
//                         textInputAction: TextInputAction.send,
//                         onSubmitted: _send,
//                         style: const TextStyle(fontSize: 15),
//                         decoration: InputDecoration(
//                           hintText: 'Message ${widget.profile.name}...',
//                           hintStyle: const TextStyle(
//                             color: Colors.black38,
//                             fontSize: 14,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 10,
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () => _send(_ctrl.text),
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.send_rounded,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ChatMsg {
//   final String text;
//   final bool isMe;
//   _ChatMsg({required this.text, required this.isMe});
// }
//
// class _Bubble extends StatelessWidget {
//   final _ChatMsg msg;
//   const _Bubble({required this.msg});
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.70,
//         ),
//         decoration: BoxDecoration(
//           gradient: msg.isMe
//               ? const LinearGradient(
//                   colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : null,
//           color: msg.isMe ? null : Colors.grey.shade100,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
//             bottomRight: Radius.circular(msg.isMe ? 4 : 18),
//           ),
//         ),
//         child: Text(
//           msg.text,
//           style: TextStyle(
//             color: msg.isMe ? Colors.white : Colors.black87,
//             fontSize: 14,
//             height: 1.4,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EmptyDM extends StatelessWidget {
//   final Profile profile;
//   const _EmptyDM({required this.profile});
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 70,
//           height: 70,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: const Color(0xFFFF4458), width: 2.5),
//           ),
//           child: ClipOval(
//             child: _SmartImage(
//               key: ValueKey('emptydm_${profile.userId}'),
//               url: profile.imageUrl,
//               placeholderColor: profile.cardColor,
//               errorChild: Container(
//                 color: profile.cardColor,
//                 child: const Icon(
//                   Icons.person_rounded,
//                   color: Colors.white54,
//                   size: 36,
//                 ),
//               ),
//               fit: BoxFit.fitHeight,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           'Say hi to ${profile.name}! 👋',
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Start the conversation',
//           style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
//         ),
//       ],
//     ),
//   );
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  MATCH DIALOG
// // ─────────────────────────────────────────────────────────────────────────────
//
// class MatchDialog extends StatefulWidget {
//   final Profile profile;
//   final String myProfilePic;
//   final VoidCallback onSendMessage;
//   const MatchDialog({
//     super.key,
//     required this.profile,
//     required this.myProfilePic,
//     required this.onSendMessage,
//   });
//   @override
//   State<MatchDialog> createState() => _MatchDialogState();
// }
//
// class _MatchDialogState extends State<MatchDialog>
//     with TickerProviderStateMixin {
//   late AnimationController _ctrl, _heartCtrl;
//   late Animation<double> _scale, _fade, _heartBeat;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 550),
//     );
//     _heartCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 650),
//     )..repeat(reverse: true);
//     _scale = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
//     _fade = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
//     _heartBeat = Tween<double>(
//       begin: 1.0,
//       end: 1.18,
//     ).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
//     _ctrl.forward();
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _heartCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fade,
//       child: ScaleTransition(
//         scale: _scale,
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 22),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(24, 32, 24, 26),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   const Color(0xFFFF4458),
//                   const Color(0xFFFF6B81),
//                   widget.profile.cardColor.withOpacity(0.85),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(28),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFFF4458).withOpacity(0.4),
//                   blurRadius: 40,
//                   offset: const Offset(0, 14),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ScaleTransition(
//                   scale: _heartBeat,
//                   child: const Text('💕', style: TextStyle(fontSize: 50)),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "It's a Match!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 34,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: -1,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'You and ${widget.profile.name} liked each other',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//                 const SizedBox(height: 26),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _MAv(
//                       url: widget.myProfilePic,
//                       color: const Color(0xFFFF7A8A),
//                     ),
//                     Transform.translate(
//                       offset: const Offset(0, -8),
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.12),
//                               blurRadius: 8,
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text('💕', style: TextStyle(fontSize: 14)),
//                         ),
//                       ),
//                     ),
//                     _MAv(
//                       url: widget.profile.imageUrl,
//                       color: widget.profile.cardColor,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 26),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFFFF4458),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       elevation: 0,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Future.delayed(
//                         const Duration(milliseconds: 200),
//                         widget.onSendMessage,
//                       );
//                     },
//                     child: const Text(
//                       'Send a Message',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'Keep Swiping',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _MAv extends StatelessWidget {
//   final String url;
//   final Color color;
//   const _MAv({required this.url, required this.color});
//   @override
//   Widget build(BuildContext context) => Container(
//     width: 86,
//     height: 86,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       border: Border.all(color: Colors.white, width: 3.5),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.18),
//           blurRadius: 14,
//           offset: const Offset(0, 5),
//         ),
//       ],
//     ),
//     child: ClipOval(
//       child: _SmartImage(
//         key: ValueKey('mav_$url'),
//         url: url,
//         placeholderColor: color,
//         errorChild: Container(
//           color: color,
//           child: const Icon(
//             Icons.person_rounded,
//             color: Colors.white54,
//             size: 42,
//           ),
//         ),
//         fit: BoxFit.fitHeight,
//       ),
//     ),
//   );
// }
// 14 march 2026 12:15 AM
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';
import '../../testibg.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SHIMMER
// ─────────────────────────────────────────────────────────────────────────────

class AppShimmerX {
  static Widget circle({double size = 40}) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Color(0xFFE0E0E0),
      shape: BoxShape.circle,
    ),
  );
}

class _Shimmer extends StatefulWidget {
  final BorderRadius borderRadius;
  const _Shimmer({
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
  });
  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween(begin: -2.0, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(_anim.value - 1, 0),
                end: Alignment(_anim.value + 1, 0),
                colors: const [
                  Color(0xFFE4E4E4),
                  Color(0xFFF0F0F0),
                  Color(0xFFEBEBEB),
                  Color(0xFFF0F0F0),
                  Color(0xFFE4E4E4),
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMART IMAGE
// ─────────────────────────────────────────────────────────────────────────────

class _SmartImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color placeholderColor;
  final Widget errorChild;

  const _SmartImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    required this.fit,
    required this.placeholderColor,
    required this.errorChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return errorChild;
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      maxWidthDiskCache: 800,
      maxHeightDiskCache: 1200,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: placeholderColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Shimmer(),
            Center(
              child: Icon(
                Icons.person_rounded,
                size: 48,
                color: Colors.white.withOpacity(0.25),
              ),
            ),
          ],
        ),
      ),
      errorWidget: (context, url, error) => errorChild,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PROFILE MODEL
// ─────────────────────────────────────────────────────────────────────────────

class Profile {
  final int userId;
  final String name;
  final int age;
  final String bio;
  final Color cardColor;
  final bool verified;
  final String location;
  final String imageUrl;
  final String lookingFor;
  final List<String> galleryImages;
  final String? gender;
  final String? smoking;
  final String? drinking;
  final String? zodiac;
  final String? education;
  final String? jobTitle;
  final String? company;
  final double? distanceKm;
  final bool isMysteryActive;

  const Profile({
    required this.userId,
    required this.name,
    required this.age,
    required this.bio,
    required this.cardColor,
    this.verified = false,
    required this.location,
    required this.imageUrl,
    required this.lookingFor,
    required this.galleryImages,
    this.gender,
    this.smoking,
    this.drinking,
    this.zodiac,
    this.education,
    this.jobTitle,
    this.company,
    this.distanceKm,
    this.isMysteryActive = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    List<String> gallery = [];
    try {
      final raw = json['gallery_images'];
      if (raw != null && raw is List && raw.isNotEmpty) {
        final joined = raw.join(',');
        final cleaned = joined
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .trim();
        gallery = cleaned
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty && e.startsWith('http'))
            .toList();
      }
    } catch (_) {}

    final colors = [
      const Color(0xFFD4A574),
      const Color(0xFF7EC8C8),
      const Color(0xFF8B7355),
      const Color(0xFFB5838D),
      const Color(0xFF6B8F71),
      const Color(0xFF9B8EA8),
    ];
    final color = colors[(json['UserId'] ?? 0) % colors.length];
    final profilePic = json['ProfilePic'] ?? '';
    final allImages = [profilePic, ...gallery]
        .where((e) => e.isNotEmpty)
        .cast<String>()
        .toList();

    final dist = json['DistanceKm'];
    final distStr = dist != null
        ? '${(dist as num).toStringAsFixed(0)} miles away'
        : 'Nearby';

    return Profile(
      userId: json['UserId'] ?? 0,
      name: json['FullName'] ?? 'Unknown',
      age: json['Age'] ?? 0,
      bio: json['Bio'] ?? '',
      cardColor: color,
      location: distStr,
      imageUrl: profilePic,
      lookingFor: json['LookingFor'] ?? 'Not specified',
      galleryImages: allImages,
      gender: json['Gender'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      zodiac: json['zodiac'],
      education: json['education'],
      jobTitle: json['job_title'],
      company: json['company'],
      distanceKm: (json['DistanceKm'] as num?)?.toDouble(),
      isMysteryActive: json['IsMysteryActive'] == true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  USER PREFERENCES
// ─────────────────────────────────────────────────────────────────────────────

class UserPreferences {
  int minAge;
  int maxAge;
  int searchRadiusKm;
  String lookingFor;

  UserPreferences({
    this.minAge = 18,
    this.maxAge = 50,
    this.searchRadiusKm = 50,
    this.lookingFor = 'Everyone',
  });

  Map<String, dynamic> toJson() => {
    "MinAge": minAge,
    "MaxAge": maxAge,
    "Radius": searchRadiusKm,
    "LookingFor": lookingFor,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        minAge: json['MinAge'] ?? 18,
        maxAge: json['MaxAge'] ?? 50,
        searchRadiusKm: json['Radius'] ?? 50,
        lookingFor: json['LookingFor'] ?? 'Everyone',
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  API SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  static Future<List<Profile>> getDiscoveryList() async {
    try {
      final token = await SecureStorageService.getToken();
      final res = await http.post(
        Uri.parse('$base/api/Profile/GetUserDiscoveryList'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"Limit": 1000, "Offset": 0}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['isSuccess'] == true && data['Response'] != null) {
          return (data['Response'] as List)
              .map((e) => Profile.fromJson(e))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Discovery error: $e');
      return [];
    }
  }

  static Future<bool?> setLikeDislike(int userId, bool isLike) async {
    try {
      final token = await SecureStorageService.getToken();
      final res = await http.post(
        Uri.parse('$base/api/Profile/SetUserLikeDislikeValue'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"p_ToUserId": userId, "p_IsLike": isLike}),
      );
      final data = jsonDecode(res.body);
      if (data['isSuccess'] == true) return data['isMatch'] == true;
      return null;
    } catch (e) {
      debugPrint('LikeDislike error: $e');
      return null;
    }
  }

  static Future<String> getMyProfilePic() async {
    try {
      final token = await SecureStorageService.getToken();
      final res = await http.get(
        Uri.parse('$base/api/Profile/GetUserProfile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['isSuccess'] == true && data['Response'] != null) {
          final resp = data['Response'];
          final profile = resp is List ? resp.first : resp;
          String pic = profile['profilepic'] ?? profile['ProfilePic'] ?? '';
          if (pic.isEmpty) {
            final images = profile['userImage'] as List?;
            if (images != null && images.isNotEmpty) {
              final main = images.firstWhere(
                    (img) => img['IsProfilePic'] == true,
                orElse: () => images.first,
              );
              pic = main['PhotoUrl'] ?? '';
            }
          }
          return pic;
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static Future<bool> updateUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final token = await SecureStorageService.getToken();
        if (token == null) return false;
        final res = await http.post(
          Uri.parse("$base/api/Location/updateUserLocation"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "Latitude": position.latitude.toString(),
            "Longitude": position.longitude.toString(),
          }),
        );
        return res.statusCode == 200;
      }
      return false;
    } catch (e) {
      debugPrint('Location error: $e');
      return false;
    }
  }

  static Future<bool> sendDirectMessage(int receiverId, String message) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return false;
      final res = await http.post(
        Uri.parse("$base/api/ChatMaster/SendDirectMessage"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "p_ReceiverId": receiverId,
          "p_Message": message,
          "p_MessageType": "text",
          "p_fileurl": "",
        }),
      );
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['isSuccess'] == true;
    } catch (e) {
      debugPrint('SendMessage error: $e');
      return false;
    }
  }

  static Future<UserPreferences?> getUserPreferences() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return null;
      final res = await http.get(
        Uri.parse("$base/api/Profile/GetUserPreferences"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['isSuccess'] == true && data['Response'] != null) {
          return UserPreferences.fromJson(data['Response']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUserPreferences(UserPreferences preferences) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return false;
      final res = await http.post(
        Uri.parse("$base/api/Profile/UpdatePreferencese"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(preferences.toJson()),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['isSuccess'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ANIMATED ACTION BUTTON SYSTEM
// ─────────────────────────────────────────────────────────────────────────────

/// Single particle for burst effect
class _Particle {
  final double angle;
  final double distance;
  final double size;
  final Color color;
  _Particle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
  });
}

/// Paints burst particles around the button center
class _BurstPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0 → 1
  _BurstPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (final p in particles) {
      final dist = p.distance * progress;
      final dx = cx + math.cos(p.angle) * dist;
      final dy = cy + math.sin(p.angle) * dist;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), p.size * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}

/// "LIKE" / "NOPE" label that floats up and fades out above the button
class _FloatingLabel extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onDone;
  const _FloatingLabel({
    required this.text,
    required this.color,
    required this.onDone,
  });
  @override
  State<_FloatingLabel> createState() => _FloatingLabelState();
}

class _FloatingLabelState extends State<_FloatingLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _y, _opacity, _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _y = Tween<double>(begin: 0, end: -52)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 40),
    ]).animate(_c);
    _scale = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.4, end: 1.25)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(_c);
    _c.forward().then((_) => widget.onDone());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _y.value),
        child: Opacity(
          opacity: _opacity.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: widget.color, width: 1.5),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full animated button: press-bounce + ring-pulse + particle-burst + icon-bounce + floating label
class _AnimatedActionBtn extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  final Color shadowColor;
  final bool useGradient;
  final List<Color>? gradientColors;
  final String? burstLabel;
  final List<Color> burstColors;
  final bool disabled;

  const _AnimatedActionBtn({
    Key? key,
    required this.size,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    required this.shadowColor,
    this.useGradient = false,
    this.gradientColors,
    this.burstLabel,
    this.burstColors = const [],
    this.disabled = false,
  }) : super(key: key);

  @override
  State<_AnimatedActionBtn> createState() => _AnimatedActionBtnState();
}

class _AnimatedActionBtnState extends State<_AnimatedActionBtn>
    with TickerProviderStateMixin {
  // Press scale
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  // Burst particles
  late AnimationController _burstCtrl;
  late Animation<double> _burstAnim;

  // Ring pulse
  late AnimationController _ringCtrl;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  // Icon bounce + wobble
  late AnimationController _iconCtrl;
  late Animation<double> _iconScale;
  late Animation<double> _iconRotate;

  List<_Particle> _particles = [];
  bool _showLabel = false;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _pressScale = Tween<double>(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));

    _burstCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 520));
    _burstAnim = CurvedAnimation(parent: _burstCtrl, curve: Curves.easeOut);

    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480));
    _ringScale = Tween<double>(begin: 1.0, end: 2.1)
        .animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));
    _ringOpacity = Tween<double>(begin: 0.55, end: 0.0)
        .animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));

    _iconCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _iconScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.38)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.38, end: 0.88)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.88, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 35),
    ]).animate(_iconCtrl);
    _iconRotate = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 0.20), weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.20, end: -0.14), weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.14, end: 0.0), weight: 40),
    ]).animate(_iconCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _burstCtrl.dispose();
    _ringCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _generateParticles() {
    final colors = widget.burstColors.isEmpty
        ? [widget.iconColor, widget.shadowColor]
        : widget.burstColors;
    _particles = List.generate(14, (i) {
      return _Particle(
        angle: (i / 14) * 2 * math.pi + _rng.nextDouble() * 0.35,
        distance: 30 + _rng.nextDouble() * 22,
        size: 3.0 + _rng.nextDouble() * 3.5,
        color: colors[i % colors.length],
      );
    });
  }

  /// Fire all visual animations. Called both from tap and from swipe.
  void triggerAnim() {
    if (widget.disabled) return;
    HapticFeedback.mediumImpact();
    _burstCtrl.reset();
    _ringCtrl.reset();
    _iconCtrl.reset();
    _generateParticles();
    if (mounted) setState(() => _showLabel = widget.burstLabel != null);
    _burstCtrl.forward();
    _ringCtrl.forward();
    _iconCtrl.forward();
  }

  void _handleTap() {
    if (widget.onTap == null || widget.disabled) return;
    widget.onTap!(); // onTap triggers swipe → _onSwipe fires triggerAnim()

    _burstCtrl.reset();
    _ringCtrl.reset();
    _iconCtrl.reset();
    _generateParticles();

    if (mounted) setState(() => _showLabel = widget.burstLabel != null);

    _burstCtrl.forward();
    _ringCtrl.forward();
    _iconCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.size * 0.42;

    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) {
        if (widget.onTap != null && !widget.disabled) _pressCtrl.forward();
      },
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: SizedBox(
        width: widget.size + 24,
        height: widget.size + 36,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Floating label above button
            if (_showLabel && widget.burstLabel != null)
              Positioned(
                top: 0,
                child: _FloatingLabel(
                  text: widget.burstLabel!,
                  color: widget.shadowColor,
                  onDone: () {
                    if (mounted) setState(() => _showLabel = false);
                  },
                ),
              ),

            Positioned(
              bottom: 0,
              left: 12,
              right: 12,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _pressScale,
                  _burstAnim,
                  _ringScale,
                  _ringOpacity,
                  _iconScale,
                  _iconRotate,
                ]),
                builder: (_, __) {
                  return ScaleTransition(
                    scale: _pressScale,
                    child: SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Ring pulse
                          if (_ringCtrl.isAnimating || _ringCtrl.value > 0)
                            Transform.scale(
                              scale: _ringScale.value,
                              child: Container(
                                width: widget.size,
                                height: widget.size,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: widget.shadowColor
                                        .withOpacity(_ringOpacity.value),
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),

                          // Burst particles
                          if (_particles.isNotEmpty)
                            Positioned.fill(
                              child: OverflowBox(
                                maxWidth: widget.size * 2.5,
                                maxHeight: widget.size * 2.5,
                                child: CustomPaint(
                                  size: Size(widget.size * 2.5, widget.size * 2.5),
                                  painter: _BurstPainter(
                                    particles: _particles,
                                    progress: _burstAnim.value,
                                  ),
                                ),
                              ),
                            ),

                          // Button body
                          Container(
                            width: widget.size,
                            height: widget.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: widget.useGradient && !widget.disabled
                                  ? LinearGradient(
                                colors: widget.gradientColors ??
                                    [
                                      widget.iconColor,
                                      widget.iconColor.withOpacity(0.75),
                                    ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                              color: widget.useGradient ? null : Colors.white,
                              boxShadow: widget.disabled
                                  ? []
                                  : [
                                BoxShadow(
                                  color: widget.shadowColor
                                      .withOpacity(0.22),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: _iconCtrl.isAnimating
                                    ? _iconRotate.value
                                    : 0.0,
                                child: Transform.scale(
                                  scale: _iconCtrl.isAnimating
                                      ? _iconScale.value
                                      : 1.0,
                                  child: Icon(
                                    widget.icon,
                                    color: widget.useGradient && !widget.disabled
                                        ? Colors.white
                                        : widget.disabled
                                        ? Colors.black26
                                        : widget.iconColor,
                                    size: iconSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ACTION BAR
// ─────────────────────────────────────────────────────────────────────────────

class _ActionBar extends StatefulWidget {
  final VoidCallback onRewind;
  final VoidCallback onDislike;
  final VoidCallback onDirectMessage;
  final VoidCallback onLike;
  final bool hasDeck;

  const _ActionBar({
    Key? key,
    required this.onRewind,
    required this.onDislike,
    required this.onDirectMessage,
    required this.onLike,
    required this.hasDeck,
  }) : super(key: key);

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  // Keys so _MainScreenState can fire animations on swipe
  final _likeKey    = GlobalKey<_AnimatedActionBtnState>();
  final _dislikeKey = GlobalKey<_AnimatedActionBtnState>();
  final _rewindKey  = GlobalKey<_AnimatedActionBtnState>();

  /// Called by parent when a card is swiped right
  void triggerLike()    => _likeKey.currentState?.triggerAnim();
  /// Called by parent when a card is swiped left
  void triggerDislike() => _dislikeKey.currentState?.triggerAnim();
  /// Called by parent when undo is triggered
  void triggerRewind()  => _rewindKey.currentState?.triggerAnim();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 20, 10),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rewind
          _AnimatedActionBtn(
            key: _rewindKey,
            size: 45,
            onTap: widget.onRewind,
            icon: Icons.replay_rounded,
            iconColor: Colors.orange,
            shadowColor: Colors.orange,
            burstColors: [Colors.orange, Colors.amber, const Color(0xFFFFCC80)],
          ),

          // Dislike — NOPE burst
          _AnimatedActionBtn(
            key: _dislikeKey,
            size: 55,
            onTap: widget.hasDeck ? widget.onDislike : null,
            icon: Icons.close_rounded,
            iconColor: const Color(0xFFFF4458),
            shadowColor: const Color(0xFFFF4458),
            burstLabel: 'NOPE',
            burstColors: [
              const Color(0xFFFF4458),
              const Color(0xFFFF7A8A),
              Colors.redAccent,
            ],
            disabled: !widget.hasDeck,
          ),

          // Like — gradient + LIKE burst
          _AnimatedActionBtn(
            key: _likeKey,
            size: 55,
            onTap: widget.hasDeck ? widget.onLike : null,
            icon: Icons.favorite_rounded,
            iconColor: Colors.white,
            shadowColor: const Color(0xFFFF4458),
            useGradient: true,
            gradientColors: const [Color(0xFFFF4458), Color(0xFFFF7F8E)],
            burstLabel: 'LIKE',
            burstColors: [
              const Color(0xFFFF4458),
              const Color(0xFFFFB3BE),
              Colors.pink,
              Colors.white,
            ],
            disabled: !widget.hasDeck,
          ),

          // Message
          _AnimatedActionBtn(
            size: 45,
            onTap: widget.hasDeck ? widget.onDirectMessage : null,
            icon: Icons.send_rounded,
            iconColor: const Color(0xFF9B59B6),
            shadowColor: const Color(0xFF9B59B6),
            burstColors: [
              const Color(0xFF9B59B6),
              const Color(0xFFD7A8F0),
              const Color(0xFFCE93D8),
            ],
            disabled: !widget.hasDeck,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0;
  int _tabIndex = 0;
  List<Profile> _deck = [];
  List<Profile> _matches = [];
  bool _isLoading = true;
  String? _errorMsg;
  String _myProfilePic = '';
  bool _isPreferencesLoading = false;
  UserPreferences _userPreferences = UserPreferences();

  final CardSwiperController _swiperCtrl = CardSwiperController();
  final _actionBarKey = GlobalKey<_ActionBarState>();

  final List<String> _lookingForOptions = [
    'Everyone',
    'Men',
    'Women',
    'Non-binary',
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _swiperCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final results = await Future.wait([
      ApiService.getDiscoveryList(),
      ApiService.getMyProfilePic(),
      ApiService.getUserPreferences(),
    ]);
    if (mounted) {
      setState(() {
        _deck = results[0] as List<Profile>;
        _myProfilePic = results[1] as String;
        if (results[2] != null) {
          _userPreferences = results[2] as UserPreferences;
        }
        _isLoading = false;
        // Pre-warm image cache for all profiles in background
        _prewarmImages(_deck);
      });
    }
  }

  /// Pre-warm: silently download & cache all profile images in background
  void _prewarmImages(List<Profile> profiles) {
    if (!mounted) return;
    for (final p in profiles) {
      for (final url in p.galleryImages) {
        if (url.isNotEmpty) {
          CachedNetworkImage.evictFromCache(url); // no-op if already cached
          precacheImage(
            CachedNetworkImageProvider(url),
            context,
          ).catchError((_) {});
        }
      }
    }
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final profiles = await ApiService.getDiscoveryList();
      if (mounted) {
        setState(() {
          _deck = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = 'Failed to load profiles';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchDiscovery() async {
    setState(() => _isLoading = true);
    try {
      final profiles = await ApiService.getDiscoveryList();
      if (mounted) {
        setState(() {
          _deck = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = 'Failed to load profiles';
          _isLoading = false;
        });
      }
    }
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    if (previousIndex >= _deck.length) return true;
    final p = _deck[previousIndex];
    HapticFeedback.lightImpact();

    if (direction == CardSwiperDirection.right) {
      _matches.add(p);
      _actionBarKey.currentState?.triggerLike();
      ApiService.setLikeDislike(p.userId, true).then((isMatch) {
        if (isMatch == true) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _showMatchDialog(p);
          });
        }
      });
    } else if (direction == CardSwiperDirection.left) {
      _actionBarKey.currentState?.triggerDislike();
      ApiService.setLikeDislike(p.userId, false);
    }
    return true;
  }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
      ) {
    HapticFeedback.selectionClick();
    _actionBarKey.currentState?.triggerRewind();
    return true;
  }

  void _onRewind() {
    if (_deck.isEmpty) return;
    _swiperCtrl.undo();
  }

  void _onSwipeLeft() {
    if (_deck.isEmpty) return;
    _swiperCtrl.swipe(CardSwiperDirection.left);
  }

  void _onSwipeRight() {
    if (_deck.isEmpty) return;
    _swiperCtrl.swipe(CardSwiperDirection.right);
  }

  void _onDirectMessage() {
    if (_deck.isEmpty) return;
    HapticFeedback.mediumImpact();
    _openDirectMessageSheet(_deck[0]);
  }

  void _openDirectMessageSheet(Profile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DirectMessageSheet(profile: profile),
    );
  }

  void _showMatchDialog(Profile p) {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => MatchDialog(
        profile: p,
        myProfilePic: _myProfilePic,
        onSendMessage: () => _openDirectMessageSheet(p),
      ),
    );
  }

  void _openProfileDetail(Profile p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileDetailSheet(
        profile: p,
        onReply: () => _openDirectMessageSheet(p),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return StatefulBuilder(
      builder: (sheetCtx, setModal) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.62,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Discovery Preferences',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded,
                            size: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  children: [
                    _prefItem(
                      title: 'AGE RANGE',
                      child: Row(
                        children: [
                          Expanded(
                            child: _dropdown<int>(
                              value: _userPreferences.minAge,
                              items: List.generate(83, (i) => i + 18),
                              onChanged: (v) {
                                if (v == null) return;
                                setModal(() {
                                  _userPreferences.minAge = v;
                                  if (_userPreferences.maxAge < v) {
                                    _userPreferences.maxAge = v;
                                  }
                                });
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('to',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 14)),
                          ),
                          Expanded(
                            child: _dropdown<int>(
                              value: _userPreferences.maxAge,
                              items: List.generate(83, (i) => i + 18)
                                  .where((a) => a >= _userPreferences.minAge)
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setModal(() => _userPreferences.maxAge = v);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _prefItem(
                      title: 'DISTANCE',
                      child: _dropdown<int>(
                        value: _userPreferences.searchRadiusKm,
                        items: const [5, 10, 25, 50, 100, 200],
                        onChanged: (v) {
                          if (v != null) {
                            setModal(() => _userPreferences.searchRadiusKm = v);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _prefItem(
                      title: 'LOOKING FOR',
                      child: _dropdown<String>(
                        value: _userPreferences.lookingFor,
                        items: _lookingForOptions,
                        onChanged: (v) {
                          if (v != null) {
                            setModal(() => _userPreferences.lookingFor = v);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _isPreferencesLoading
                          ? null
                          : () async {
                        setState(() => _isPreferencesLoading = true);
                        final ok =
                        await ApiService.updateUserPreferences(
                          _userPreferences,
                        );
                        if (ok && mounted) {
                          Navigator.pop(sheetCtx);
                          await _fetchDiscovery();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Preferences updated successfully'),
                              backgroundColor: AppThemeX.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                            ),
                          );
                        }
                        if (mounted) {
                          setState(() => _isPreferencesLoading = false);
                        }
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4458).withOpacity(0.30),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isPreferencesLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _prefItem({required String title, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[400],
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<T>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<T>(
              value: item, child: Text(item.toString())))
              .toList(),
          onChanged: onChanged,
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.black45),
          style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
        ),
      );

  Widget _buildHomeBody() {
    if (_isLoading) return const _LoadingView();
    if (_errorMsg != null)
      return _ErrorView(message: _errorMsg!, onRetry: _loadProfiles);
    if (_deck.isEmpty) return _EmptyDeckView(onRefresh: _loadProfiles);

    return CardSwiper(
      controller: _swiperCtrl,
      cardsCount: _deck.length,
      numberOfCardsDisplayed: 2,
      isLoop: false,
      padding: EdgeInsets.zero,
      backCardOffset: Offset.zero,
      scale: 1.0,
      onSwipe: _onSwipe,
      onUndo: _onUndo,
      cardBuilder: (
          context,
          index,
          horizontalThresholdPercentage,
          verticalThresholdPercentage,
          ) {
        if (index >= _deck.length) return const SizedBox.shrink();
        final profile = _deck[index];

        String? overlayLabel;
        if (horizontalThresholdPercentage > 20) overlayLabel = 'LIKE';
        if (horizontalThresholdPercentage < -20) overlayLabel = 'NOPE';

        return _ProfileCard(
          key: ValueKey('card_${profile.userId}'),
          profile: profile,
          overlayLabel: overlayLabel,
          onInfoTap: () => _openProfileDetail(profile),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TinderTopBar(
              tabIndex: _tabIndex,
              onTabChanged: (i) => setState(() => _tabIndex = i),
              onFilter: _showFilterBottomSheet,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _navIndex == 0
                  ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildHomeBody(),
                    ),
                  ),
                  _ActionBar(
                    key: _actionBarKey,
                    onRewind: _onRewind,
                    onDislike: _onSwipeLeft,
                    onDirectMessage: _onDirectMessage,
                    onLike: _onSwipeRight,
                    hasDeck: _deck.isNotEmpty,
                  ),
                ],
              )
                  : _navIndex == 2
                  ? _MatchesView(matches: _matches)
                  : const _PlaceholderView(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TinderTopBar extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onFilter;

  const _TinderTopBar({
    required this.tabIndex,
    required this.onTabChanged,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFFFF4458), Color(0xFFFF8C9A)],
            ).createShader(b),
            child: const Text(
              'initily',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune_rounded,
                  color: Colors.black54, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.notification,
                      color: Colors.black54, size: 20),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4458),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  LOADING / ERROR / EMPTY
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatefulWidget {
  const _LoadingView();
  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _p;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _p = Tween(begin: 0.9, end: 1.05)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _p,
          child: ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
            ).createShader(b),
            child: const Icon(Icons.local_fire_department,
                size: 64, color: Colors.white),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Finding people near you...',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black45),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              minHeight: 3,
              color: Color(0xFFFF4458),
              backgroundColor: Color(0xFFFFE0E3),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.grey.shade100, shape: BoxShape.circle),
          child: const Icon(Icons.wifi_off_rounded,
              size: 38, color: Colors.black26),
        ),
        const SizedBox(height: 18),
        Text(message,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54)),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4458).withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: const Color(0xFFFF4458).withOpacity(0.3)),
            ),
            child: const Text('Try Again',
                style: TextStyle(
                    color: Color(0xFFFF4458),
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ),
      ],
    ),
  );
}

class _EmptyDeckView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyDeckView({required this.onRefresh});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFFFFCDD2), Color(0xFFFFE0E3)],
          ).createShader(b),
          child: const Icon(Icons.local_fire_department,
              size: 72, color: Colors.white),
        ),
        const SizedBox(height: 18),
        const Text("You've seen everyone!",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54)),
        const SizedBox(height: 6),
        const Text('Come back later or expand your search',
            style: TextStyle(fontSize: 14, color: Colors.black38)),
        const SizedBox(height: 26),
        GestureDetector(
          onTap: onRefresh,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4458).withOpacity(0.30),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text('Refresh',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  PROFILE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCard extends StatefulWidget {
  final Profile profile;
  final String? overlayLabel;
  final VoidCallback onInfoTap;

  const _ProfileCard({
    super.key,
    required this.profile,
    required this.overlayLabel,
    required this.onInfoTap,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  int _photoIdx = 0;

  void _tap(double dx, double width) {
    final imgs = widget.profile.galleryImages;
    if (imgs.length <= 1) return;
    setState(() {
      _photoIdx = dx > width / 2
          ? (_photoIdx + 1).clamp(0, imgs.length - 1)
          : (_photoIdx - 1).clamp(0, imgs.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imgs = widget.profile.galleryImages;
    final count = imgs.isEmpty ? 1 : imgs.length;
    final idx = _photoIdx.clamp(0, imgs.isEmpty ? 0 : imgs.length - 1);
    final imgUrl = imgs.isEmpty ? widget.profile.imageUrl : imgs[idx];

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              GestureDetector(
                onTapUp: (d) =>
                    _tap(d.localPosition.dx, constraints.maxWidth),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: _SmartImage(
                    key: ValueKey('${widget.profile.userId}_$imgUrl'),
                    url: imgUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholderColor: widget.profile.cardColor,
                    errorChild: Container(
                      color: widget.profile.cardColor,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_rounded,
                                size: 90,
                                color: Colors.white.withOpacity(0.45)),
                            const SizedBox(height: 8),
                            Text(
                              widget.profile.name.isNotEmpty
                                  ? widget.profile.name[0]
                                  : '?',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Mystery blur
              if (widget.profile.isMysteryActive)
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                        child: Container(color: Colors.black.withOpacity(0.40)),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.14),
                                border: Border.all(
                                    color: Colors.white60, width: 2),
                              ),
                              child: const Icon(Icons.lock_rounded,
                                  color: Colors.white, size: 36),
                            ),
                            const SizedBox(height: 16),
                            const Text('Mystery Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: const Text('Like to reveal',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Animated pill dots
              if (!widget.profile.isMysteryActive && count > 1)
                Positioned(
                  top: 14,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(count, (i) {
                      final isActive = i == idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                        width: isActive ? 22 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

              // Bottom gradient + info
              if (!widget.profile.isMysteryActive)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 120, 16, 22),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x35000000),
                          Color(0xBB000000),
                          Color(0xF0000000),
                        ],
                        stops: [0.0, 0.3, 0.65, 1.0],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.profile.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.profile.age}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  if (widget.profile.verified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        color: Color(0xFF5BB8F5), size: 20),
                                  ],
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onInfoTap,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.20),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white38, width: 1.2),
                                ),
                                child: const Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: Colors.white,
                                    size: 22),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: Colors.white60, size: 13),
                            const SizedBox(width: 3),
                            Text(widget.profile.location,
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 13)),
                          ],
                        ),
                        if (widget.profile.jobTitle != null &&
                            widget.profile.jobTitle!.isNotEmpty) ...[
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              const Icon(Icons.work_outline_rounded,
                                  color: Colors.white54, size: 13),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  [
                                    widget.profile.jobTitle,
                                    if (widget.profile.company != null &&
                                        widget.profile.company!.isNotEmpty)
                                      widget.profile.company,
                                  ].join(' · '),
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.profile.bio.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.profile.bio,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              // LIKE / NOPE stamp
              if (widget.overlayLabel != null)
                _CardStamp(label: widget.overlayLabel!),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CARD STAMP
// ─────────────────────────────────────────────────────────────────────────────

class _CardStamp extends StatefulWidget {
  final String label;
  const _CardStamp({required this.label});
  @override
  State<_CardStamp> createState() => _CardStampState();
}

class _CardStampState extends State<_CardStamp>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _s = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLike = widget.label == 'LIKE';
    return Positioned(
      top: 40,
      left: isLike ? 16 : null,
      right: isLike ? null : 16,
      child: ScaleTransition(
        scale: _s,
        child: Transform.rotate(
          angle: isLike ? -0.35 : 0.35,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isLike
                    ? const Color(0xFF3EC875)
                    : const Color(0xFFFF4458),
                width: 4,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: isLike
                    ? const Color(0xFF3EC875)
                    : const Color(0xFFFF4458),
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PROFILE DETAIL SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileDetailSheet extends StatefulWidget {
  final Profile profile;
  final VoidCallback onReply;
  const _ProfileDetailSheet({required this.profile, required this.onReply});
  @override
  State<_ProfileDetailSheet> createState() => _ProfileDetailSheetState();
}

class _ProfileDetailSheetState extends State<_ProfileDetailSheet> {
  int _photo = 0;

  @override
  Widget build(BuildContext context) {
    final imgs = widget.profile.galleryImages;
    final count = imgs.isEmpty ? 1 : imgs.length;
    final imgUrl = imgs.isEmpty
        ? widget.profile.imageUrl
        : imgs[_photo.clamp(0, imgs.length - 1)];

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      snap: true,
      snapSizes: const [0.5, 0.92, 0.98],
      builder: (ctx, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: CustomScrollView(
          controller: ctrl,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(widget.profile.name,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                      letterSpacing: -0.5)),
                              const SizedBox(width: 8),
                              Text('${widget.profile.age}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54)),
                              if (widget.profile.verified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified,
                                    color: Color(0xFF5BB8F5), size: 20),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.black38, size: 13),
                              const SizedBox(width: 3),
                              Text(widget.profile.location,
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 0.82,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: _SmartImage(
                            key: ValueKey(
                                'detail_${widget.profile.userId}_$imgUrl'),
                            url: imgUrl,
                            fit: BoxFit.cover,
                            placeholderColor: widget.profile.cardColor,
                            errorChild: Container(
                              color: widget.profile.cardColor,
                              child: Center(
                                child: Text(
                                  widget.profile.name.isNotEmpty
                                      ? widget.profile.name[0]
                                      : '?',
                                  style: const TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (count > 1)
                          Positioned(
                            top: 14,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(count, (i) {
                                final isActive = i == _photo;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOut,
                                  width: isActive ? 22 : 7,
                                  height: 7,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        Positioned.fill(
                          child: GestureDetector(
                            onTapUp: (d) {
                              if (imgs.length <= 1) return;
                              final box = context.findRenderObject();
                              final w =
                              box is RenderBox ? box.size.width : 300.0;
                              setState(() {
                                _photo = d.localPosition.dx > w / 2
                                    ? (_photo + 1).clamp(0, imgs.length - 1)
                                    : (_photo - 1).clamp(0, imgs.length - 1);
                              });
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          right: 14,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                  const Duration(milliseconds: 200),
                                  widget.onReply);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.send_rounded,
                                      color: Color(0xFFFF4458), size: 16),
                                  SizedBox(width: 6),
                                  Text('Message',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black87)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            if (widget.profile.bio.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InfoCard(
                    icon: Icons.auto_awesome_rounded,
                    label: 'About',
                    child: Text(widget.profile.bio,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6)),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _InfoCard(
                  icon: Icons.person_outline_rounded,
                  label: 'Essentials',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: widget.profile.location),
                      if (widget.profile.gender != null)
                        _InfoRow(
                            icon: Icons.person_outline,
                            text: widget.profile.gender!),
                      if (widget.profile.jobTitle != null)
                        _InfoRow(
                          icon: Icons.work_outline_rounded,
                          text: [
                            widget.profile.jobTitle,
                            widget.profile.company,
                          ].where((e) => e != null).join(' at '),
                        ),
                      if (widget.profile.education != null)
                        _InfoRow(
                            icon: Icons.school_outlined,
                            text: widget.profile.education!),
                      if (widget.profile.zodiac != null)
                        _InfoRow(
                            icon: Icons.star_outline_rounded,
                            text: widget.profile.zodiac!),
                      if (widget.profile.smoking != null)
                        _InfoRow(
                            icon: Icons.smoke_free_rounded,
                            text: 'Smoking: ${widget.profile.smoking}'),
                      if (widget.profile.drinking != null)
                        _InfoRow(
                            icon: Icons.local_bar_outlined,
                            text: 'Drinking: ${widget.profile.drinking}'),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;
  const _InfoCard(
      {required this.icon, required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 15),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4)),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 16),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  MATCHES VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _MatchesView extends StatelessWidget {
  final List<Profile> matches;
  const _MatchesView({required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFE8EB), shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border_rounded,
                  size: 44, color: Color(0xFFFF4458)),
            ),
            const SizedBox(height: 18),
            const Text('No matches yet',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54)),
            const SizedBox(height: 6),
            const Text('Start swiping to find your match!',
                style: TextStyle(fontSize: 14, color: Colors.black38)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Text('Your Matches',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.3)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: matches.length,
            itemBuilder: (ctx, i) {
              final m = matches[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _SmartImage(
                      key: ValueKey('match_${m.userId}'),
                      url: m.imageUrl,
                      placeholderColor: m.cardColor,
                      errorChild: Container(
                        color: m.cardColor,
                        child: Center(
                          child: Text(
                            m.name.isNotEmpty ? m.name[0] : '?',
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white54),
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Text(m.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView();
  @override
  Widget build(BuildContext context) => const Center(
    child: Text('Coming soon',
        style: TextStyle(color: Colors.black38, fontSize: 16)),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  DIRECT MESSAGE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _DirectMessageSheet extends StatefulWidget {
  final Profile profile;
  const _DirectMessageSheet({required this.profile});
  @override
  State<_DirectMessageSheet> createState() => _DirectMessageSheetState();
}

class _DirectMessageSheetState extends State<_DirectMessageSheet> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<_ChatMsg> _msgs = [];

  static const _quick = [
    '👋 Hey there!',
    '☕ Coffee sometime?',
    '😊 Love your vibe!',
    '✈️ Wanna explore?',
  ];
  static const _auto = [
    'Hey! 😊',
    "That's so sweet!",
    'Would love that! 🌟',
    'You seem really fun!',
    'Tell me more!',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _msgs.add(_ChatMsg(text: text, isMe: true));
      _ctrl.clear();
    });
    _scrollDown();
    ApiService.sendDirectMessage(widget.profile.userId, text);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _msgs.add(
          _ChatMsg(text: _auto[_msgs.length % _auto.length], isMe: false)));
      _scrollDown();
    });
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF4458),
                                  Color(0xFFFF8C9A)
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ClipOval(
                              child: _SmartImage(
                                key: ValueKey(
                                    'dm_${widget.profile.userId}'),
                                url: widget.profile.imageUrl,
                                placeholderColor: widget.profile.cardColor,
                                errorChild: Container(
                                  color: widget.profile.cardColor,
                                  child: const Icon(Icons.person_rounded,
                                      color: Colors.white54, size: 24),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3EC875),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.profile.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87)),
                            const Text('Active now',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF3EC875),
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Colors.black54, size: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _msgs.isEmpty
                  ? _EmptyDM(profile: widget.profile)
                  : ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                itemCount: _msgs.length,
                itemBuilder: (_, i) => _Bubble(msg: _msgs[i]),
              ),
            ),
            if (_msgs.isEmpty)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: _quick.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => _send(_quick[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4458).withOpacity(0.07),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color(0xFFFF4458).withOpacity(0.25)),
                      ),
                      child: Text(_quick[i],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF4458))),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _ctrl,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _send,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Message ${widget.profile.name}...',
                          hintStyle: const TextStyle(
                              color: Colors.black38, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _send(_ctrl.text),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool isMe;
  _ChatMsg({required this.text, required this.isMe});
}

class _Bubble extends StatelessWidget {
  final _ChatMsg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70),
        decoration: BoxDecoration(
          gradient: msg.isMe
              ? const LinearGradient(
            colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: msg.isMe ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 18),
          ),
        ),
        child: Text(msg.text,
            style: TextStyle(
                color: msg.isMe ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4)),
      ),
    );
  }
}

class _EmptyDM extends StatelessWidget {
  final Profile profile;
  const _EmptyDM({required this.profile});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF4458), Color(0xFFFF8C9A)],
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: ClipOval(
            child: _SmartImage(
              key: ValueKey('emptydm_${profile.userId}'),
              url: profile.imageUrl,
              placeholderColor: profile.cardColor,
              errorChild: Container(
                color: profile.cardColor,
                child: const Icon(Icons.person_rounded,
                    color: Colors.white54, size: 36),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text('Say hi to ${profile.name}! 👋',
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        const SizedBox(height: 4),
        Text('Start the conversation',
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade500)),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  MATCH DIALOG
// ─────────────────────────────────────────────────────────────────────────────

class MatchDialog extends StatefulWidget {
  final Profile profile;
  final String myProfilePic;
  final VoidCallback onSendMessage;

  const MatchDialog({
    super.key,
    required this.profile,
    required this.myProfilePic,
    required this.onSendMessage,
  });

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog>
    with TickerProviderStateMixin {
  late AnimationController _ctrl, _heartCtrl;
  late Animation<double> _scale, _fade, _heartBeat;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _heartCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _heartBeat = Tween<double>(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _heartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFF4458),
                  const Color(0xFFFF6B81),
                  widget.profile.cardColor.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4458).withOpacity(0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _heartBeat,
                  child: const Text('💕',
                      style: TextStyle(fontSize: 50)),
                ),
                const SizedBox(height: 10),
                const Text("It's a Match!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1)),
                const SizedBox(height: 6),
                Text('You and ${widget.profile.name} liked each other',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MAv(
                        url: widget.myProfilePic,
                        color: const Color(0xFFFF7A8A)),
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8),
                          ],
                        ),
                        child: const Center(
                            child: Text('💕',
                                style: TextStyle(fontSize: 15))),
                      ),
                    ),
                    _MAv(
                        url: widget.profile.imageUrl,
                        color: widget.profile.cardColor),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF4458),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 200),
                          widget.onSendMessage);
                    },
                    child: const Text('Send a Message',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep Swiping',
                      style:
                      TextStyle(color: Colors.white70, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MAv extends StatelessWidget {
  final String url;
  final Color color;
  const _MAv({required this.url, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 88,
    height: 88,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipOval(
      child: _SmartImage(
        key: ValueKey('mav_$url'),
        url: url,
        placeholderColor: color,
        errorChild: Container(
          color: color,
          child: const Icon(Icons.person_rounded,
              color: Colors.white54, size: 42),
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}
