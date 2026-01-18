// import 'package:flutter/material.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final Color kPrimaryColor = const Color(0xFFFF4F46);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
//         title: Text(
//           "Profile",
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: Icon(Iconsax.setting_2, color: Colors.grey[400], size: 22),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//
//             // --- PROFILE IMAGE & PROGRESS SECTION ---
//             Center(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Circular Progress Ring
//                   SizedBox(
//                     width: 130,
//                     height: 130,
//                     child: CircularProgressIndicator(
//                       value: 0.75, // 75% complete
//                       strokeWidth: 4,
//                       color: kPrimaryColor,
//                       backgroundColor: Colors.grey[100],
//                     ),
//                   ),
//                   // User Avatar
//                   const CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.white,
//                     backgroundImage: NetworkImage(
//                       "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500",
//                     ),
//                   ),
//                   // Camera Icon Badge
//                   Positioned(
//                     bottom: 5,
//                     right: 5,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: kPrimaryColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: const Icon(
//                         Iconsax.camera,
//                         color: Colors.white,
//                         size: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // --- EDIT BUTTON ---
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//               decoration: BoxDecoration(
//                 color: kPrimaryColor,
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: kPrimaryColor.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Iconsax.edit_2, color: Colors.white, size: 14),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Edit profile",
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//             Text(
//               "Emma, 25",
//               style: GoogleFonts.poppins(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: -0.5,
//               ),
//             ),
//
//             const SizedBox(height: 35),
//
//             // --- PREMIUM CARD SECTION ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(22),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFF4F46), Color(0xFFFF857D)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "Subscription",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 2,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.black26,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.flash_on,
//                                         color: Colors.white,
//                                         size: 10,
//                                       ),
//                                       Text(
//                                         " Premium",
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.white,
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.baseline,
//                               textBaseline: TextBaseline.alphabetic,
//                               children: [
//                                 Text(
//                                   "8\$",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   " /per month",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white.withOpacity(0.8),
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "Unlimited",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white.withOpacity(0.6),
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Icon(Iconsax.edit, color: Colors.white, size: 45),
//                       ],
//                     ),
//                     const SizedBox(height: 25),
//                     _buildFeatureItem("Unlimited pins"),
//                     _buildFeatureItem("Unlimited Matching"),
//                     _buildFeatureItem("Unlimited liking"),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // --- SETTINGS LIST SECTION (In-page) ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               child: Column(
//                 children: [
//                   _settingRow(Iconsax.user, "Account"),
//                   _settingRow(Iconsax.card, "Payment Options"),
//                   _settingRow(Iconsax.key, "Password"),
//                   _settingRow(
//                     Iconsax.notification,
//                     "Push Notification",
//                     isSwitch: true,
//                     value: true,
//                   ),
//                   _settingRow(
//                     Iconsax.location,
//                     "Location",
//                     isSwitch: true,
//                     value: false,
//                   ),
//                   _settingRow(Iconsax.document_text, "Terms of services"),
//                   _settingRow(Iconsax.user_minus, "Delete Account"),
//                 ],
//               ),
//             ),
//
//             // --- LOGOUT BUTTON ---
//             Padding(
//               padding: const EdgeInsets.all(30),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kPrimaryColor,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   "Logout",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Feature Item for Premium Card
//   Widget _buildFeatureItem(String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           const Icon(Icons.check, color: Colors.white, size: 18),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Setting Row Widget
//   Widget _settingRow(
//     IconData icon,
//     String title, {
//     bool isSwitch = false,
//     bool value = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey[400], size: 20),
//           const SizedBox(width: 18),
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.black87,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Spacer(),
//           if (isSwitch)
//             SizedBox(
//               height: 20,
//               width: 40,
//               child: Switch(
//                 value: value,
//                 onChanged: (v) {},
//                 activeColor: kPrimaryColor,
//                 inactiveThumbColor: Colors.grey[300],
//               ),
//             )
//           else
//             Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
//         ],
//       ),
//     );
//   }
// }
//
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:initiate/view/rootscreen/rootscreen.dart';

// Import your storage service
import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final Color kPrimaryColor = const Color(0xFFFF4F46);

  // Profile Data
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isPremium = true; // You can get this from API response
  bool _pushNotificationsEnabled = true;
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // --- API Service Method ---
  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await SecureStorageService.getToken();
      final String url = "$base/api/Profile/GetUserProfile";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint(
        "Profile API Response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['isSuccess'] == true) {
          if (responseData['Response'] != null &&
              responseData['Response'].isNotEmpty) {
            setState(() {
              _userProfile = UserProfile.fromJson(responseData['Response'][0]);
            });
          }
        } else {
          // Show error if needed
          debugPrint("Failed to fetch profile: ${responseData['message']}");
        }
      } else {
        debugPrint("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- API Service for Toggle Actions ---
  Future<void> _togglePushNotifications(bool value) async {
    // Implement your API call here
    setState(() {
      _pushNotificationsEnabled = value;
    });

    // Example API call:
    // String? token = await SecureStorageService.getToken();
    // final response = await http.post(
    //   Uri.parse("$base/api/Profile/UpdateNotification"),
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Authorization": "Bearer $token",
    //   },
    //   body: jsonEncode({"notificationsEnabled": value}),
    // );
  }

  Future<void> _toggleLocation(bool value) async {
    // Implement your API call here
    setState(() {
      _locationEnabled = value;
    });
  }

  // --- Premium Status Check ---
  Widget _buildPremiumStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.white, size: 10),
          Text(
            _isPremium ? " Premium" : " Free",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // --- Calculate Age from DOB ---
  int? _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return null;
    try {
      DateTime birthDate = DateTime.parse(dob);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4F46)),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  // --- PROFILE IMAGE & PROGRESS SECTION ---
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular Progress Ring
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: 0.75, // 75% complete
                            strokeWidth: 4,
                            color: kPrimaryColor,
                            backgroundColor: Colors.grey[100],
                          ),
                        ),
                        // User Avatar
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _userProfile?.profileImageUrl != null
                              ? NetworkImage(_userProfile!.profileImageUrl!)
                              : const NetworkImage(
                                      "https://images.unsplash.com/photo-1695927621677-ec96e048dce2?q=80&w=1035&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    )
                                    as ImageProvider,
                          child: _userProfile?.profileImageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        // Camera Icon Badge
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Iconsax.camera,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- EDIT BUTTON ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.edit_2,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Edit profile",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- USER NAME AND AGE ---
                  Text(
                    "${_userProfile?.fullName ?? 'User'}, ${_userProfile?.age != null ? '${_userProfile!.age}' : 'N/A'}",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  // --- BIO ---
                  if (_userProfile?.bio != null &&
                      _userProfile!.bio!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: Text(
                        _userProfile!.bio!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                  const SizedBox(height: 35),

                  // --- PREMIUM CARD SECTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF4F46), Color(0xFFFF857D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Subscription",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildPremiumStatus(),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        _isPremium ? "159" : "Free",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (_isPremium)
                                        Text(
                                          " /per month",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    _isPremium ? "Unlimited" : "Basic",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Iconsax.edit,
                                color: Colors.white,
                                size: 45,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildFeatureItem(
                            "Unlimited pins",
                            enabled: _isPremium,
                          ),
                          _buildFeatureItem(
                            "Unlimited Matching",
                            enabled: _isPremium,
                          ),
                          _buildFeatureItem(
                            "Unlimited liking",
                            enabled: _isPremium,
                          ),
                          if (!_isPremium)
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to subscription page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: Text(
                                  "Upgrade to Premium",
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- USER DETAILS SECTION ---
                  if (_userProfile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Details",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _detailRow(
                            Iconsax.people,
                            "Gender",
                            _userProfile!.gender ?? "Not set",
                          ),
                          _detailRow(
                            Iconsax.location,
                            "City",
                            _userProfile!.city ?? "Not set",
                          ),
                          if (_userProfile!.lookingFor != null)
                            _detailRow(
                              Iconsax.heart,
                              "Looking for",
                              _userProfile!.lookingFor!,
                            ),
                          if (_userProfile!.heightCm != null &&
                              _userProfile!.heightCm! > 0)
                            _detailRow(
                              Iconsax.ruler,
                              "Height",
                              "${_userProfile!.heightCm!.toStringAsFixed(0)} cm",
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                  // --- SETTINGS LIST SECTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        _settingRow(Iconsax.user, "Account"),
                        _settingRow(Iconsax.card, "Payment Options"),
                        _settingRow(Iconsax.key, "Password"),
                        _settingRow(
                          Iconsax.notification,
                          "Push Notification",
                          isSwitch: true,
                          value: _pushNotificationsEnabled,
                          onChanged: _togglePushNotifications,
                        ),
                        _settingRow(
                          Iconsax.location,
                          "Location",
                          isSwitch: true,
                          value: _locationEnabled,
                          onChanged: _toggleLocation,
                        ),
                        _settingRow(Iconsax.document_text, "Terms of services"),
                        _settingRow(Iconsax.user_minus, "Delete Account"),
                      ],
                    ),
                  ),

                  // --- LOGOUT BUTTON ---
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Implement logout functionality
                        // await SecureStorageService.deleteToken();
                        // Navigator.pushReplacement(...);
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Feature Item for Premium Card
  Widget _buildFeatureItem(String label, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: enabled ? FontWeight.w400 : FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Detail Row Widget
  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Setting Row Widget
  Widget _settingRow(
    IconData icon,
    String title, {
    bool isSwitch = false,
    bool value = false,
    Function(bool)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 18),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (isSwitch)
            SizedBox(
              height: 20,
              width: 40,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: kPrimaryColor,
                inactiveThumbColor: Colors.grey[300],
              ),
            )
          else
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
        ],
      ),
    );
  }
}

// --- User Profile Model Class ---
class UserProfile {
  final String? fullName;
  final String? gender;
  final String? bio;
  final double? heightCm;
  final String? city;
  final String? lookingFor;
  final String? longitude;
  final String? latitude;
  final List<UserImage>? userImages;
  final String? dob;
  final int? age;

  UserProfile({
    this.fullName,
    this.gender,
    this.bio,
    this.heightCm,
    this.city,
    this.lookingFor,
    this.longitude,
    this.latitude,
    this.userImages,
    this.dob,
    this.age,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Calculate age if DOB is available
    int? calculatedAge;
    if (json['DOB'] != null && json['DOB'].toString().isNotEmpty) {
      try {
        DateTime birthDate = DateTime.parse(json['DOB']);
        DateTime currentDate = DateTime.now();
        calculatedAge = currentDate.year - birthDate.year;
        if (currentDate.month < birthDate.month ||
            (currentDate.month == birthDate.month &&
                currentDate.day < birthDate.day)) {
          calculatedAge--;
        }
      } catch (e) {
        calculatedAge = null;
      }
    }

    return UserProfile(
      fullName: json['FullName'],
      gender: json['Gender'],
      bio: json['Bio'],
      heightCm: json['HeightCm'] != null
          ? double.tryParse(json['HeightCm'].toString())
          : null,
      city: json['City'],
      lookingFor: json['LookingFor'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      dob: json['DOB'],
      age: calculatedAge,
      userImages: json['userImage'] != null
          ? (json['userImage'] as List)
                .map((imageJson) => UserImage.fromJson(imageJson))
                .toList()
          : null,
    );
  }

  // Get profile image URL (first image that is marked as profile pic, or first image)
  String? get profileImageUrl {
    if (userImages == null || userImages!.isEmpty) return null;

    // Try to find profile picture
    final profilePic = userImages!.firstWhere(
      (image) => image.isProfilePic == true,
      orElse: () => userImages!.first,
    );

    return profilePic.photoUrl;
  }
}

// --- User Image Model Class ---
class UserImage {
  final int id;
  final String photoUrl;
  final bool isProfilePic;
  final int userId;

  UserImage({
    required this.id,
    required this.photoUrl,
    required this.isProfilePic,
    required this.userId,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json['Id'] ?? 0,
      photoUrl: json['PhotoUrl'] ?? '',
      isProfilePic: json['IsProfilePic'] ?? false,
      userId: json['UserId'] ?? 0,
    );
  }
}

// --- Profile Service Class ---
class ProfileService {
  static Future<UserProfile?> getUserProfile() async {
    try {
      String? token = await SecureStorageService.getToken();
      final String url = "$base/api/Profile/GetUserProfile";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['isSuccess'] == true) {
          if (responseData['Response'] != null &&
              responseData['Response'].isNotEmpty) {
            return UserProfile.fromJson(responseData['Response'][0]);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("ProfileService Error: $e");
      return null;
    }
  }

  static Future<bool> updateUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      String? token = await SecureStorageService.getToken();
      final String url = "$base/api/Profile/UpdateUserProfile";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['isSuccess'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Update Profile Error: $e");
      return false;
    }
  }
}
