//
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:intl/intl.dart';
// // import '../../controller/services/StorageService.dart';
// // import '../../controller/services/app_api_service.dart';
// // import '../rootscreen/rootscreen.dart';
// //
// // // class ProfileCompleteFlow extends StatefulWidget {
// // //   const ProfileCompleteFlow({super.key});
// // //
// // //   @override
// // //   _ProfileCompleteFlowState createState() => _ProfileCompleteFlowState();
// // // }
// // //
// // // class _ProfileCompleteFlowState extends State<ProfileCompleteFlow> {
// // //   final PageController _controller = PageController();
// // //   int _currentPage = 0;
// // //   bool _isLoading = false;
// // //   final Color kPrimaryColor = const Color(0xFFFF4F46);
// // //
// // //   // --- Form State ---
// // //   String selectedGender = "";
// // //   List<String> lookingFor = [];
// // //   DateTime? selectedDate;
// // //   List<String> selectedInterests = [];
// // //   List<File> selectedImages = [];
// // //   double? latitude;
// // //   double? longitude;
// // //
// // //   final TextEditingController nameController = TextEditingController();
// // //   final TextEditingController bioController = TextEditingController();
// // //   final TextEditingController workController = TextEditingController();
// // //   final TextEditingController cityController = TextEditingController();
// // //
// // //   final List<String> interestOptions = ["Gaming", "Music", "Gym", "Travel", "Art", "Cooking", "Photography", "Tech", "Movies"];
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _determinePosition();
// // //   }
// // //
// // //   Future<void> _determinePosition() async {
// // //     LocationPermission permission = await Geolocator.checkPermission();
// // //     if (permission == LocationPermission.denied) {
// // //       permission = await Geolocator.requestPermission();
// // //     }
// // //     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
// // //       Position position = await Geolocator.getCurrentPosition();
// // //       setState(() {
// // //         latitude = position.latitude;
// // //         longitude = position.longitude;
// // //       });
// // //     }
// // //   }
// // //
// // //   Future<void> profileValue() async {
// // //     setState(() => _isLoading = true);
// // //     try {
// // //       String? token = await SecureStorageService.getToken();
// // //       final String url = "$base/api/Profile/UpdateUserProfileByID";
// // //       Map<String, dynamic> body = {
// // //         "FullName": nameController.text,
// // //         "Gender": selectedGender,
// // //         "DOB": selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : "",
// // //         "Bio": bioController.text,
// // //         "HeightCm": "170",
// // //         "City": cityController.text.isEmpty ? "Unknown" : cityController.text,
// // //         "LookingFor": lookingFor.join(", "),
// // //         "Latitude": latitude?.toString() ?? "0.0",
// // //         "Longitude": longitude?.toString() ?? "0.0",
// // //       };
// // //       final response = await http.post(Uri.parse(url),
// // //           headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
// // //           body: jsonEncode(body));
// // //       setState(() => _isLoading = false);
// // //       if (response.statusCode == 200) { _showSuccessPopup(); }
// // //     } catch (e) {
// // //       setState(() => _isLoading = false);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double progress = (_currentPage + 1) / 6;
// // //
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         elevation: 0,
// // //         leading: _currentPage > 0 ? IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)) : null,
// // //         title: Column(
// // //           children: [
// // //             Text("Complete Profile", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
// // //             const SizedBox(height: 8),
// // //             ClipRRect(
// // //               borderRadius: BorderRadius.circular(10),
// // //               child: SizedBox(
// // //                 width: 100,
// // //                 height: 6,
// // //                 child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation(kPrimaryColor)),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         centerTitle: true,
// // //       ),
// // //       body: _isLoading
// // //           ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
// // //           : PageView(
// // //         controller: _controller,
// // //         physics: const NeverScrollableScrollPhysics(),
// // //         onPageChanged: (index) => setState(() => _currentIndex(index)),
// // //         children: [
// // //           _buildGenderScreen(),
// // //           _buildLookingForScreen(),
// // //           _buildAgeScreen(),
// // //           _buildInterestScreen(),
// // //           _buildPhotoScreen(),
// // //           _buildProfileDetailScreen(),
// // //         ],
// // //       ),
// // //       bottomNavigationBar: _buildBottomButton(),
// // //     );
// // //   }
// // //
// // //   void _currentIndex(int index) => _currentPage = index;
// // //
// // //   // --- UI Screens ---
// // //
// // //   Widget _buildGenderScreen() => _baseLayout("Who are you?", "This helps us find the best matches for you.", [
// // //     _selectionTile("Male", selectedGender == "Male", () => setState(() => selectedGender = "Male")),
// // //     const SizedBox(height: 15),
// // //     _selectionTile("Female", selectedGender == "Female", () => setState(() => selectedGender = "Female")),
// // //   ]);
// // //
// // //   Widget _buildLookingForScreen() => _baseLayout("Looking for...", "Select what interests you.", [
// // //     _selectionTile("Girls", lookingFor.contains("Girls"), () {
// // //       setState(() => lookingFor.contains("Girls") ? lookingFor.remove("Girls") : lookingFor.add("Girls"));
// // //     }),
// // //     const SizedBox(height: 15),
// // //     _selectionTile("Boys", lookingFor.contains("Boys"), () {
// // //       setState(() => lookingFor.contains("Boys") ? lookingFor.remove("Boys") : lookingFor.add("Boys"));
// // //     }),
// // //   ]);
// // //
// // //   Widget _buildAgeScreen() => _baseLayout("Your Birthday 🎂", "You must be 18+ to use this app.", [
// // //     GestureDetector(
// // //       onTap: () async {
// // //         DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
// // //         if (picked != null) setState(() => selectedDate = picked);
// // //       },
// // //       child: Container(
// // //         height: 70,
// // //         padding: const EdgeInsets.symmetric(horizontal: 20),
// // //         decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //           children: [
// // //             Text(selectedDate == null ? "Select Birth Date" : DateFormat('dd MMMM yyyy').format(selectedDate!), style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black, fontWeight: FontWeight.w600)),
// // //             Icon(Icons.calendar_today_rounded, color: kPrimaryColor),
// // //           ],
// // //         ),
// // //       ),
// // //     ),
// // //   ]);
// // //
// // //   Widget _buildInterestScreen() => _baseLayout("Interests", "Choose things that define you.", [
// // //     Wrap(
// // //       spacing: 12, runSpacing: 12,
// // //       children: interestOptions.map((e) {
// // //         bool sel = selectedInterests.contains(e);
// // //         return GestureDetector(
// // //           onTap: () => setState(() => sel ? selectedInterests.remove(e) : selectedInterests.add(e)),
// // //           child: Container(
// // //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// // //             decoration: BoxDecoration(
// // //               color: sel ? kPrimaryColor : Colors.white,
// // //               borderRadius: BorderRadius.circular(30),
// // //               border: Border.all(color: sel ? kPrimaryColor : Colors.grey[300]!),
// // //               boxShadow: sel ? [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
// // //             ),
// // //             child: Text(e, style: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
// // //           ),
// // //         );
// // //       }).toList(),
// // //     ),
// // //   ]);
// // //
// // //   Widget _buildPhotoScreen() => _baseLayout("Add Photos", "Upload at least 2 photos to stand out.", [
// // //     GridView.builder(
// // //       shrinkWrap: true,
// // //       itemCount: 6,
// // //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
// // //       itemBuilder: (ctx, i) => i < selectedImages.length
// // //           ? Stack(
// // //         children: [
// // //           ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(selectedImages[i], fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
// // //           Positioned(top: 5, right: 5, child: GestureDetector(onTap: () => setState(() => selectedImages.removeAt(i)), child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)))),
// // //         ],
// // //       )
// // //           : GestureDetector(
// // //         onTap: _pickImage,
// // //         child: Container(
// // //           decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid)),
// // //           child: Icon(Icons.add_rounded, size: 30, color: Colors.grey[400]),
// // //         ),
// // //       ),
// // //     ),
// // //   ]);
// // //
// // //   Widget _buildProfileDetailScreen() => _baseLayout("The Last Step", "Tell others more about yourself.", [
// // //     _modernInput(nameController, "Full Name", Icons.person_outline),
// // //     _modernInput(workController, "Profession", Icons.work_outline),
// // //     _modernInput(cityController, "City", Icons.location_on_outlined),
// // //     _modernInput(bioController, "About Me", Icons.notes_rounded, lines: 4),
// // //   ]);
// // //
// // //   // --- Helper Widgets ---
// // //
// // //   Widget _baseLayout(String title, String sub, List<Widget> children) {
// // //     return SingleChildScrollView(
// // //       padding: const EdgeInsets.all(30),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
// // //           const SizedBox(height: 8),
// // //           Text(sub, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
// // //           const SizedBox(height: 35),
// // //           ...children,
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _selectionTile(String label, bool isSelected, VoidCallback onTap) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: AnimatedContainer(
// // //         duration: const Duration(milliseconds: 200),
// // //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// // //         decoration: BoxDecoration(
// // //           color: isSelected ? kPrimaryColor : Colors.white,
// // //           borderRadius: BorderRadius.circular(20),
// // //           border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey[200]!),
// // //           boxShadow: [
// // //             if (isSelected) BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
// // //             else BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
// // //           ],
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
// // //             const Spacer(),
// // //             if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white)
// // //             else CircleAvatar(radius: 12, backgroundColor: Colors.grey[100]),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _modernInput(TextEditingController controller, String label, IconData icon, {int lines = 1}) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 20),
// // //       child: TextField(
// // //         controller: controller,
// // //         maxLines: lines,
// // //         decoration: InputDecoration(
// // //           prefixIcon: Icon(icon, color: kPrimaryColor),
// // //           labelText: label,
// // //           labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
// // //           filled: true,
// // //           fillColor: Colors.grey[50],
// // //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey[200]!)),
// // //           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: kPrimaryColor)),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildBottomButton() {
// // //     return Container(
// // //       padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
// // //       decoration: BoxDecoration(color: Colors.white),
// // //       child: ElevatedButton(
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: Colors.black,
// // //           minimumSize: const Size(double.infinity, 60),
// // //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //           elevation: 5,
// // //         ),
// // //         onPressed: () {
// // //           if (_currentPage < 5) {
// // //             _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
// // //           } else {
// // //             profileValue();
// // //           }
// // //         },
// // //         child: Text(_currentPage == 5 ? "FINISH" : "CONTINUE", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Future<void> _pickImage() async {
// // //     final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
// // //     if (picked != null) setState(() => selectedImages.add(File(picked.path)));
// // //   }
// // //
// // //   void _showSuccessPopup() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => AlertDialog(
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
// // //             const SizedBox(height: 20),
// // //             const Text("You're All Set!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// // //             const SizedBox(height: 10),
// // //             Text("Your profile has been successfully updated.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
// // //             const SizedBox(height: 30),
// // //             SizedBox(
// // //               width: double.infinity,
// // //               child: ElevatedButton(
// // //                 style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
// // //                 onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootScreen())),
// // //                 child: const Text("Go to Home", style: TextStyle(color: Colors.white)),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:intl/intl.dart';
// // import 'package:flutter_liveness_check/flutter_liveness_check.dart';
// //
// // // Note: Replace these imports with your actual project paths
// // import '../../controller/services/StorageService.dart';
// // import '../../controller/services/app_api_service.dart';
// // import '../rootscreen/rootscreen.dart';
// //
// // class ProfileCompleteFlow extends StatefulWidget {
// //   const ProfileCompleteFlow({super.key});
// //
// //   @override
// //   _ProfileCompleteFlowState createState() => _ProfileCompleteFlowState();
// // }
// //
// // class _ProfileCompleteFlowState extends State<ProfileCompleteFlow> {
// //   final PageController _controller = PageController();
// //   int _currentPage = 0;
// //   bool _isLoading = false;
// //   final Color kPrimaryColor = const Color(0xFFFF4F46);
// //
// //   // --- Form State ---
// //   String selectedGender = "";
// //   List<String> lookingFor = [];
// //   DateTime? selectedDate;
// //   List<String> selectedInterests = [];
// //   List<File> selectedImages = [];
// //   double? latitude;
// //   double? longitude;
// //
// //   // Face Verification State
// //   bool isVerified = false;
// //
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController bioController = TextEditingController();
// //   final TextEditingController workController = TextEditingController();
// //   final TextEditingController cityController = TextEditingController();
// //
// //   final List<String> interestOptions = [
// //     "Gaming", "Music", "Gym", "Travel", "Art", "Cooking", "Photography", "Tech", "Movies"
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _determinePosition();
// //   }
// //
// //   // --- Location Logic ---
// //   Future<void> _determinePosition() async {
// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //     }
// //     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
// //       Position position = await Geolocator.getCurrentPosition();
// //       setState(() {
// //         latitude = position.latitude;
// //         longitude = position.longitude;
// //       });
// //     }
// //   }
// //
// //   // --- Liveness Check Integration ---
// //   void _openLivenessCheck() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => LivenessCheckScreen(
// //           config: LivenessCheckConfig(
// //             appBarConfig: const AppBarConfig(
// //               title: 'Smile Verification',
// //               showBackButton: true,
// //             ),
// //             settings: const LivenessCheckSettings(
// //               enableBlinkDetection: false,    // Disabled as per your requirement
// //               enableSmileDetection: true,     // Enable smile detection
// //               enableEyesClosedCheck: true,    // Ensure eyes are open
// //               maxRetryAttempts: 3,
// //             ),
// //             messages: const LivenessCheckMessages(
// //               eyesClosed: 'Please keep your eyes open',
// //             ),
// //             placeholder: 'Please smile with your eyes open',
// //             callbacks: LivenessCheckCallbacks(
// //               onSuccess: () {
// //                 setState(() => isVerified = true);
// //                 Navigator.pop(context);
// //                 _showSnackBar("Identity Verified!", isError: false);
// //                 // Move to next page automatically after success
// //                 _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
// //               },
// //
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // --- API Submit Logic ---
// // // --- API Submit Logic ---
// //   Future<void> profileValue() async {
// //     setState(() => _isLoading = true);
// //     try {
// //       String? token = await SecureStorageService.getToken();
// //       // Ensure the base URL is correct from your service
// //       final String url = "$base/api/Profile/UpdateUserProfileByID";
// //
// //       // Convert image files to Base64 strings for the API
// //       List<String> base64Photos = [];
// //       for (File image in selectedImages) {
// //         List<int> imageBytes = await image.readAsBytes();
// //         base64Photos.add(base64Encode(imageBytes));
// //       }
// //
// //       // New Body Structure matching your requirement
// //       Map<String, dynamic> body = {
// //         "FullName": nameController.text,
// //         "Gender": selectedGender,
// //         "DOB": selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : "",
// //         "Bio": bioController.text,
// //         "HeightCm": "170", // Defaulting as per structure
// //         "City": cityController.text.isEmpty ? "Unknown" : cityController.text,
// //         "LookingFor": lookingFor.join(", "),
// //         "Latitude": latitude?.toString() ?? "0.0",
// //         "Longitude": longitude?.toString() ?? "0.0",
// //         "photos": base64Photos // List of strings
// //       };
// //
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $token"
// //         },
// //         body: jsonEncode(body),
// //       );
// //
// //       setState(() => _isLoading = false);
// //
// //       if (response.statusCode == 200) {
// //         _showSuccessPopup();
// //       } else {
// //         _showSnackBar("Update Failed: ${response.body}");
// //       }
// //     } catch (e) {
// //       setState(() => _isLoading = false);
// //       _showSnackBar("An error occurred. Please try again.");
// //       debugPrint("Update Error: $e");
// //     }
// //   }
// //   void _showSnackBar(String msg, {bool isError = true}) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     double progress = (_currentPage + 1) / 6;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: _currentPage > 0 ? IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
// //           onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
// //         ) : null,
// //         title: Column(
// //           children: [
// //             const Text("Complete Profile", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 8),
// //             SizedBox(
// //               width: 100,
// //               height: 4,
// //               child: LinearProgressIndicator(
// //                   value: progress,
// //                   backgroundColor: Colors.grey[200],
// //                   valueColor: AlwaysStoppedAnimation(kPrimaryColor)
// //               ),
// //             ),
// //           ],
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: _isLoading
// //           ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
// //           : PageView(
// //         controller: _controller,
// //         physics: const NeverScrollableScrollPhysics(),
// //         onPageChanged: (index) => setState(() => _currentPage = index),
// //         children: [
// //           _buildGenderScreen(),
// //           _buildLookingForScreen(),
// //           _buildAgeScreen(),
// //           _buildInterestScreen(),
// //           _buildPhotoScreen(),
// //           _buildProfileDetailScreen(),
// //         ],
// //       ),
// //       bottomNavigationBar: _buildBottomButton(),
// //     );
// //   }
// //
// //   // --- 1. Gender Selection ---
// //   Widget _buildGenderScreen() => _baseLayout("Who are you?", "Female users require a face verification for a safer community.", [
// //     _selectionTile("Male", selectedGender == "Male", () => setState(() {
// //       selectedGender = "Male";
// //       isVerified = false;
// //     })),
// //     const SizedBox(height: 15),
// //     _selectionTile("Female", selectedGender == "Female", () => setState(() => selectedGender = "Female")),
// //     if (selectedGender == "Female" && isVerified)
// //       Padding(
// //         padding: const EdgeInsets.only(top: 15, left: 5),
// //         child: Row(
// //           children: const [
// //             Icon(Icons.verified, color: Colors.green, size: 20),
// //             SizedBox(width: 8),
// //             Text("Verified Profile", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
// //           ],
// //         ),
// //       )
// //   ]);
// //
// //   // --- 2. Looking For ---
// //   Widget _buildLookingForScreen() => _baseLayout("Looking for...", "Select who you'd like to meet.", [
// //     _selectionTile("Male", lookingFor.contains("Male"), () {
// //       setState(() => lookingFor.contains("Male") ? lookingFor.remove("Male") : lookingFor.add("Male"));
// //     }),
// //     const SizedBox(height: 15),
// //     _selectionTile("Female", lookingFor.contains("Female"), () {
// //       setState(() => lookingFor.contains("Female") ? lookingFor.remove("Female") : lookingFor.add("Female"));
// //     }),
// //   ]);
// //
// //   // --- 3. Age Screen ---
// //   Widget _buildAgeScreen() => _baseLayout("Your Birthday", "Confirm your age to see relevant matches.", [
// //     GestureDetector(
// //       onTap: () async {
// //         DateTime? picked = await showDatePicker(
// //             context: context,
// //             initialDate: DateTime(2000),
// //             firstDate: DateTime(1950),
// //             lastDate: DateTime.now()
// //         );
// //         if (picked != null) setState(() => selectedDate = picked);
// //       },
// //       child: Container(
// //         height: 70,
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         decoration: BoxDecoration(
// //             color: Colors.grey[50],
// //             borderRadius: BorderRadius.circular(20),
// //             border: Border.all(color: Colors.grey[200]!)
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //                 selectedDate == null ? "Select Birth Date" : DateFormat('dd MMMM yyyy').format(selectedDate!),
// //                 style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black, fontWeight: FontWeight.w600)
// //             ),
// //             Icon(Icons.calendar_month, color: kPrimaryColor),
// //           ],
// //         ),
// //       ),
// //     ),
// //   ]);
// //
// //   // --- 4. Interests ---
// //   Widget _buildInterestScreen() => _baseLayout("Interests", "Choose things you're passionate about.", [
// //     Wrap(
// //       spacing: 12, runSpacing: 12,
// //       children: interestOptions.map((e) {
// //         bool sel = selectedInterests.contains(e);
// //         return GestureDetector(
// //           onTap: () => setState(() => sel ? selectedInterests.remove(e) : selectedInterests.add(e)),
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //             decoration: BoxDecoration(
// //               color: sel ? kPrimaryColor : Colors.white,
// //               borderRadius: BorderRadius.circular(30),
// //               border: Border.all(color: sel ? kPrimaryColor : Colors.grey[300]!),
// //             ),
// //             child: Text(e, style: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
// //           ),
// //         );
// //       }).toList(),
// //     ),
// //   ]);
// //
// //   // --- 5. Photos ---
// //   Widget _buildPhotoScreen() => _baseLayout("Add Photos", "Upload at least 2 photos.", [
// //     GridView.builder(
// //       shrinkWrap: true,
// //       itemCount: 6,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
// //       itemBuilder: (ctx, i) => i < selectedImages.length
// //           ? ClipRRect(
// //           borderRadius: BorderRadius.circular(15),
// //           child: Image.file(selectedImages[i], fit: BoxFit.cover)
// //       )
// //           : GestureDetector(
// //         onTap: _pickImage,
// //         child: Container(
// //           decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[300]!)),
// //           child: Icon(Icons.add_a_photo_outlined, color: Colors.grey[400]),
// //         ),
// //       ),
// //     ),
// //   ]);
// //
// //   // --- 6. Details ---
// //   Widget _buildProfileDetailScreen() => _baseLayout("Final Details", "Help people know you better.", [
// //     _modernInput(nameController, "Full Name", Icons.person_outline),
// //     _modernInput(workController, "Profession", Icons.work_outline),
// //     _modernInput(cityController, "City", Icons.location_on_outlined),
// //     _modernInput(bioController, "Bio", Icons.notes_outlined, lines: 3),
// //   ]);
// //
// //   // --- Shared UI Helpers ---
// //   Widget _baseLayout(String title, String sub, List<Widget> children) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(30),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
// //           const SizedBox(height: 8),
// //           Text(sub, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
// //           const SizedBox(height: 35),
// //           ...children,
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _selectionTile(String label, bool isSelected, VoidCallback onTap) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: isSelected ? kPrimaryColor : Colors.white,
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey[200]!),
// //           boxShadow: isSelected ? [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
// //         ),
// //         child: Row(
// //           children: [
// //             Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
// //             const Spacer(),
// //             if (isSelected) const Icon(Icons.check_circle, color: Colors.white)
// //             else CircleAvatar(radius: 12, backgroundColor: Colors.grey[50]),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _modernInput(TextEditingController controller, String label, IconData icon, {int lines = 1}) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 20),
// //       child: TextField(
// //         controller: controller,
// //         maxLines: lines,
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(icon, color: kPrimaryColor),
// //           labelText: label,
// //           filled: true,
// //           fillColor: Colors.grey[50],
// //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey[200]!)),
// //           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: kPrimaryColor)),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBottomButton() {
// //     // Condition to check if verification is needed for Step 1
// //     bool needsVerification = selectedGender == "Female" && !isVerified && _currentPage == 0;
// //
// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
// //       color: Colors.white,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: needsVerification ? kPrimaryColor : Colors.black,
// //           minimumSize: const Size(double.infinity, 60),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //           elevation: 0,
// //         ),
// //         onPressed: () {
// //           if (_currentPage == 0) {
// //             if (selectedGender == "") {
// //               _showSnackBar("Please select your gender");
// //             } else if (needsVerification) {
// //               _openLivenessCheck();
// //             } else {
// //               _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
// //             }
// //           } else if (_currentPage < 5) {
// //             _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
// //           } else {
// //             profileValue();
// //           }
// //         },
// //         child: Text(
// //             needsVerification ? "VERIFY FACE" : (_currentPage == 5 ? "FINISH" : "CONTINUE"),
// //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _pickImage() async {
// //     final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
// //     if (picked != null) setState(() => selectedImages.add(File(picked.path)));
// //   }
// //
// //   void _showSuccessPopup() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
// //             const SizedBox(height: 20),
// //             const Text("Profile Ready!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 10),
// //             const Text("Your account has been successfully set up.", textAlign: TextAlign.center),
// //             const SizedBox(height: 30),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
// //                 onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootScreen())),
// //                 child: const Text("Get Started", style: TextStyle(color: Colors.white)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:flutter_liveness_check/flutter_liveness_check.dart';
//
// // Ensure these paths match your project structure
// import '../../controller/services/StorageService.dart';
// import '../../controller/services/app_api_service.dart';
// import '../rootscreen/rootscreen.dart';
//
// class ProfileCompleteFlow extends StatefulWidget {
//   const ProfileCompleteFlow({super.key});
//
//   @override
//   _ProfileCompleteFlowState createState() => _ProfileCompleteFlowState();
// }
//
// class _ProfileCompleteFlowState extends State<ProfileCompleteFlow> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//   bool _isLoading = false;
//   final Color kPrimaryColor = const Color(0xFFFF4F46);
//
//   // --- Form State ---
//   String selectedGender = "";
//   List<String> lookingFor = [];
//   DateTime? selectedDate;
//   List<String> selectedInterests = [];
//   List<File> selectedImages = [];
//   double? latitude;
//   double? longitude;
//   bool isVerified = false;
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController bioController = TextEditingController();
//   final TextEditingController workController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//
//   final List<String> interestOptions = [
//     "Gaming", "Music", "Gym", "Travel", "Art", "Cooking", "Photography", "Tech", "Movies"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }
//
//   // --- Location Logic ---
//   Future<void> _determinePosition() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         latitude = position.latitude;
//         longitude = position.longitude;
//       });
//     }
//   }
//
//   // --- Liveness Check ---
//   void _openLivenessCheck() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LivenessCheckScreen(
//           config: LivenessCheckConfig(
//             appBarConfig: const AppBarConfig(title: 'Smile Verification', showBackButton: true),
//             settings: const LivenessCheckSettings(
//               enableBlinkDetection: false,
//               enableSmileDetection: true,
//               enableEyesClosedCheck: true,
//               maxRetryAttempts: 3,
//             ),
//             messages: const LivenessCheckMessages(eyesClosed: 'Please keep your eyes open'),
//             placeholder: 'Please smile with your eyes open',
//             callbacks: LivenessCheckCallbacks(
//               onSuccess: () {
//                 setState(() => isVerified = true);
//                 Navigator.pop(context);
//                 _showSnackBar("Identity Verified!", isError: false);
//                 _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//  baseurl/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=
//
//   _loadingText.value = "Uploading image ${done + 1}/$totalToUpload...";
//   final File file = data['file'] as File;
//   final String url = await _uploadImage(file, userToken);
//
//
//   // --- API Submit Logic ---
//   Future<void> profileValue() async {
//     setState(() => _isLoading = true);
//     try {
//       String? token = await SecureStorageService.getToken();
//       final String url = "$base/api/Profile/UpdateUserProfile";
//
//       // Convert image files to Base64 strings for the "photos" array
//       List<String> base64Photos = [];
//       for (File file in selectedImages) {
//         List<int> imageBytes = await file.readAsBytes();
//         base64Photos.add(base64Encode(imageBytes));
//       }
//
//       // Body structured exactly as requested
//       Map<String, dynamic> body = {
//         "FullName": nameController.text,
//         "Gender": selectedGender,
//         "DOB": selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : "",
//         "Bio": bioController.text,
//         "HeightCm": "", // Default or add a controller if needed
//         "City": cityController.text.isEmpty ? "Unknown" : cityController.text,
//         "LookingFor": lookingFor.join(", "),
//         "Latitude": latitude?.toString() ?? "0.0",
//         "Longitude": longitude?.toString() ?? "0.0",
//         "photos": base64Photos,
//       };
//
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(body),
//       );
//
//       setState(() => _isLoading = false);
//
//       if (response.statusCode == 200) {
//         _showSuccessPopup();
//       } else {
//         _showSnackBar("Update Failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showSnackBar("Error: $e");
//     }
//   }
//
//   void _showSnackBar(String msg, {bool isError = true}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double progress = (_currentPage + 1) / 6;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: _currentPage > 0 ? IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
//           onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
//         ) : null,
//         title: Column(
//           children: [
//             const Text("Complete Profile", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: 100,
//               height: 4,
//               child: LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.grey[200],
//                   valueColor: AlwaysStoppedAnimation(kPrimaryColor)
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
//           : PageView(
//         controller: _controller,
//         physics: const NeverScrollableScrollPhysics(),
//         onPageChanged: (index) => setState(() => _currentPage = index),
//         children: [
//           _buildGenderScreen(),
//           _buildLookingForScreen(),
//           _buildAgeScreen(),
//           _buildInterestScreen(),
//           _buildPhotoScreen(),
//           _buildProfileDetailScreen(),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomButton(),
//     );
//   }
//
//   // --- Screen Builders ---
//
//   Widget _buildGenderScreen() => _baseLayout("Who are you?", "Female users require a face verification for safety.", [
//     _selectionTile("Male", selectedGender == "Male", () => setState(() { selectedGender = "Male"; isVerified = false; })),
//     const SizedBox(height: 15),
//     _selectionTile("Female", selectedGender == "Female", () => setState(() => selectedGender = "Female")),
//     if (selectedGender == "Female" && isVerified)
//       const Padding(
//         padding: EdgeInsets.only(top: 15, left: 5),
//         child: Row(children: [Icon(Icons.verified, color: Colors.green, size: 20), SizedBox(width: 8), Text("Verified", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
//       )
//   ]);
//
//   Widget _buildLookingForScreen() => _baseLayout("Looking for...", "Select your preferences.", [
//     _selectionTile("Male", lookingFor.contains("Male"), () => setState(() => lookingFor.contains("Male") ? lookingFor.remove("Male") : lookingFor.add("Male"))),
//     const SizedBox(height: 15),
//     _selectionTile("Female", lookingFor.contains("Female"), () => setState(() => lookingFor.contains("Female") ? lookingFor.remove("Female") : lookingFor.add("Female"))),
//   ]);
//
//   Widget _buildAgeScreen() => _baseLayout("Your Birthday", "Confirm your age to proceed.", [
//     GestureDetector(
//       onTap: () async {
//         DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
//         if (picked != null) setState(() => selectedDate = picked);
//       },
//       child: Container(
//         height: 70, padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(selectedDate == null ? "Select Birth Date" : DateFormat('dd MMMM yyyy').format(selectedDate!), style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black, fontWeight: FontWeight.w600)),
//           Icon(Icons.calendar_month, color: kPrimaryColor),
//         ]),
//       ),
//     ),
//   ]);
//
//   Widget _buildInterestScreen() => _baseLayout("Interests", "Choose things you're passionate about.", [
//     Wrap(spacing: 12, runSpacing: 12, children: interestOptions.map((e) {
//       bool sel = selectedInterests.contains(e);
//       return GestureDetector(
//         onTap: () => setState(() => sel ? selectedInterests.remove(e) : selectedInterests.add(e)),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration: BoxDecoration(color: sel ? kPrimaryColor : Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: sel ? kPrimaryColor : Colors.grey[300]!)),
//           child: Text(e, style: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
//         ),
//       );
//     }).toList()),
//   ]);
//
//   Widget _buildPhotoScreen() => _baseLayout("Add Photos", "Upload at least 2 photos.", [
//     GridView.builder(
//       shrinkWrap: true, itemCount: 6,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
//       itemBuilder: (ctx, i) => i < selectedImages.length
//           ? Stack(children: [
//         ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(selectedImages[i], fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
//         Positioned(top: 5, right: 5, child: GestureDetector(onTap: () => setState(() => selectedImages.removeAt(i)), child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)))),
//       ])
//           : GestureDetector(onTap: _pickImage, child: Container(decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[300]!)), child: Icon(Icons.add_a_photo_outlined, color: Colors.grey[400]))),
//     ),
//   ]);
//
//   Widget _buildProfileDetailScreen() => _baseLayout("Final Details", "Help people know you better.", [
//     _modernInput(nameController, "Full Name", Icons.person_outline),
//     _modernInput(workController, "Profession", Icons.work_outline),
//     _modernInput(cityController, "City", Icons.location_on_outlined),
//     _modernInput(bioController, "Bio", Icons.notes_outlined, lines: 3),
//   ]);
//
//   // --- Widgets ---
//
//   Widget _baseLayout(String title, String sub, List<Widget> children) {
//     return SingleChildScrollView(padding: const EdgeInsets.all(30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
//       const SizedBox(height: 8),
//       Text(sub, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
//       const SizedBox(height: 35),
//       ...children,
//     ]));
//   }
//
//   Widget _selectionTile(String label, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(onTap: onTap, child: AnimatedContainer(
//       duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: isSelected ? kPrimaryColor : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey[200]!), boxShadow: isSelected ? [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : []),
//       child: Row(children: [
//         Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
//         const Spacer(),
//         if (isSelected) const Icon(Icons.check_circle, color: Colors.white) else CircleAvatar(radius: 12, backgroundColor: Colors.grey[50]),
//       ]),
//     ));
//   }
//
//   Widget _modernInput(TextEditingController controller, String label, IconData icon, {int lines = 1}) {
//     return Padding(padding: const EdgeInsets.only(bottom: 20), child: TextField(
//       controller: controller, maxLines: lines,
//       decoration: InputDecoration(prefixIcon: Icon(icon, color: kPrimaryColor), labelText: label, filled: true, fillColor: Colors.grey[50], enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey[200]!)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: kPrimaryColor))),
//     ));
//   }
//
//   Widget _buildBottomButton() {
//     bool needsVerification = selectedGender == "Female" && !isVerified && _currentPage == 0;
//     return Container(
//       padding: const EdgeInsets.fromLTRB(30, 10, 30, 40), color: Colors.white,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: needsVerification ? kPrimaryColor : Colors.black, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
//         onPressed: () {
//           if (_currentPage == 0) {
//             if (selectedGender == "") { _showSnackBar("Please select gender"); }
//             else if (needsVerification) { _openLivenessCheck(); }
//             else { _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut); }
//           } else if (_currentPage < 5) {
//             _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//           } else { profileValue(); }
//         },
//         child: Text(needsVerification ? "VERIFY FACE" : (_currentPage == 5 ? "FINISH" : "CONTINUE"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
//     if (picked != null) setState(() => selectedImages.add(File(picked.path)));
//   }
//
//   void _showSuccessPopup() {
//     showDialog(
//       context: context, barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         content: Column(mainAxisSize: MainAxisSize.min, children: [
//           const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
//           const SizedBox(height: 20),
//           const Text("Success!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 30),
//           SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootScreen())), child: const Text("Go to Home", style: TextStyle(color: Colors.white)))),
//         ]),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_liveness_check/flutter_liveness_check.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';
import '../rootscreen/rootscreen.dart';

class ProfileCompleteFlow extends StatefulWidget {
  const ProfileCompleteFlow({super.key});

  @override
  _ProfileCompleteFlowState createState() => _ProfileCompleteFlowState();
}

class _ProfileCompleteFlowState extends State<ProfileCompleteFlow> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  final Color kPrimaryColor = const Color(0xFFFF4F46);

  // --- Form State ---
  String selectedGender = "";
  List<String> lookingFor = [];
  DateTime? selectedDate;
  List<String> selectedInterests = [];
  List<File> selectedImages = [];
  List<ImageUploadStatus> imageUploadStatuses = []; // Track upload status
  double? latitude;
  double? longitude;
  bool isVerified = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final List<String> interestOptions = [
    "Gaming",
    "Music",
    "Gym",
    "Travel",
    "Art",
    "Cooking",
    "Photography",
    "Tech",
    "Movies",
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // --- Location Logic ---
  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }

  // --- Liveness Check ---
  void _openLivenessCheck() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivenessCheckScreen(
          config: LivenessCheckConfig(
            appBarConfig: const AppBarConfig(
              title: 'Smile Verification',
              showBackButton: true,
            ),
            settings: const LivenessCheckSettings(
              enableBlinkDetection: false,
              enableSmileDetection: true,
              enableEyesClosedCheck: true,
              maxRetryAttempts: 3,
            ),
            messages: const LivenessCheckMessages(
              eyesClosed: 'Please keep your eyes open',
            ),
            placeholder: 'Please smile with your eyes open',
            callbacks: LivenessCheckCallbacks(
              onSuccess: () {
                setState(() => isVerified = true);
                Navigator.pop(context);
                _showSnackBar("Identity Verified!", isError: false);
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // --- CDN Image Upload (Real-time when image is selected) ---
  Future<void> _uploadImageToCDN(File imageFile, int index) async {
    // Mark as uploading
    setState(() {
      imageUploadStatuses[index] = ImageUploadStatus(
        status: ImageStatus.uploading,
      );
    });

    try {
      String? token = await SecureStorageService.getToken();

      // Read file as bytes and encode to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Create unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String randomId = "${timestamp}_${index}";

      // Get file extension
      String extension = imageFile.path.split('.').last.toLowerCase();
      String fileName = "profile_$randomId.$extension";

      // Determine MIME type
      String mimeType = "image/jpeg";
      if (extension == 'png') {
        mimeType = "image/png";
      } else if (extension == 'gif') {
        mimeType = "image/gif";
      } else if (extension == 'webp') {
        mimeType = "image/webp";
      }

      // Create base64 string with mime type
      String base64WithMime = "data:$mimeType;base64,$base64Image";

      // CDN Upload URL
      final String uploadUrl =
          "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=";

      debugPrint("Uploading image to CDN: $uploadUrl");

      // Prepare request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file parameter
      request.fields['file'] = base64WithMime;

      // Send request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseString);
        debugPrint("CDN Response: $responseData");

        if (responseData['isSuccess'] == true) {
          String imageUrl = responseData['record'] ?? '';

          if (imageUrl.isNotEmpty) {
            // Update status with CDN URL
            setState(() {
              imageUploadStatuses[index] = ImageUploadStatus(
                status: ImageStatus.uploaded,
                url: imageUrl,
              );
            });

            debugPrint("Image uploaded successfully: $imageUrl");
            return;
          }
        }
      }

      // If failed
      setState(() {
        imageUploadStatuses[index] = ImageUploadStatus(
          status: ImageStatus.failed,
        );
      });
      debugPrint("CDN Upload Failed: ${response.statusCode} - $responseString");
    } catch (e) {
      // Mark as failed
      setState(() {
        imageUploadStatuses[index] = ImageUploadStatus(
          status: ImageStatus.failed,
        );
      });
      debugPrint("CDN Upload Error: $e");
    }
  }

  // --- Get all uploaded CDN URLs ---
  List<String> _getUploadedImageUrls() {
    List<String> urls = [];
    for (var status in imageUploadStatuses) {
      if (status.status == ImageStatus.uploaded && status.url != null) {
        urls.add(status.url!);
      }
    }
    return urls;
  }

  // --- Check if all images are uploaded ---
  bool _areAllImagesUploaded() {
    if (selectedImages.isEmpty) return false;

    for (var status in imageUploadStatuses) {
      if (status.status != ImageStatus.uploaded) {
        return false;
      }
    }
    return true;
  }

  // --- Check if any uploads failed ---
  bool _hasFailedUploads() {
    return imageUploadStatuses.any(
      (status) => status.status == ImageStatus.failed,
    );
  }

  // --- Check if any uploads are in progress ---
  bool _hasUploadingImages() {
    return imageUploadStatuses.any(
      (status) => status.status == ImageStatus.uploading,
    );
  }
  final _storage = const FlutterSecureStorage();
  // --- Retry failed uploads ---
  Future<void> _retryFailedUploads() async {
    for (int i = 0; i < imageUploadStatuses.length; i++) {
      if (imageUploadStatuses[i].status == ImageStatus.failed) {
        await _uploadImageToCDN(selectedImages[i], i);
      }
    }
  }

  // --- API Submit Logic ---
  Future<void> profileValue() async {
    // First check if all images are uploaded
    if (!_areAllImagesUploaded()) {
      _showSnackBar("Please wait for all images to upload");
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? token = await SecureStorageService.getToken();
      final String url = "$base/api/Profile/UpdateUserProfile";

      // Get uploaded CDN URLs
      List<String> uploadedImageUrls = _getUploadedImageUrls();

      if (uploadedImageUrls.isEmpty) {
        _showSnackBar("No images uploaded");
        setState(() => _isLoading = false);
        return;
      }

      // Prepare the body
      Map<String, dynamic> body = {
        "FullName": nameController.text.trim(),
        "Gender": selectedGender,
        "DOB": selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : "",
        "Bio": bioController.text.trim(),
        "HeightCm": "", // Add height controller if needed
        "City": cityController.text.trim().isEmpty
            ? "Unknown"
            : cityController.text.trim(),
        "LookingFor": lookingFor.join(", "),
        "Latitude": latitude?.toString() ?? "0.0",
        "Longitude": longitude?.toString() ?? "0.0",
        "photos": uploadedImageUrls, // CDN URLs array
      };

      debugPrint(
        "Sending profile data with ${uploadedImageUrls.length} images",
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "Profile update response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isSuccess'] == true ||
            responseData['success'] == true ||
            responseData['status'] == 'success') {
          // Profile save hone ke baad wale button par:
          await _storage.write(key: 'isProfileComplete', value: 'true');
// Phir RootScreen par bhejien
          _showSuccessPopup();
        } else {
          _showSnackBar(
            "Update Failed: ${responseData['message'] ?? 'Unknown error'}",
          );
        }
      } else {
        _showSnackBar(
          "Update Failed: Server responded with ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Profile update error: $e");
      _showSnackBar("Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- Pick and Upload Image ---
  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      File imageFile = File(picked.path);
      int newIndex = selectedImages.length;

      // Add to lists
      setState(() {
        selectedImages.add(imageFile);
        imageUploadStatuses.add(
          ImageUploadStatus(status: ImageStatus.uploading),
        );
      });

      // Start upload immediately
      await _uploadImageToCDN(imageFile, newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentPage + 1) / 6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              )
            : null,
        title: Column(
          children: [
            const Text(
              "Complete Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              height: 4,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(kPrimaryColor),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kPrimaryColor),
                  const SizedBox(height: 20),
                  const Text(
                    "Submitting profile...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildGenderScreen(),
                _buildLookingForScreen(),
                _buildAgeScreen(),
                _buildInterestScreen(),
                _buildPhotoScreen(),
                _buildProfileDetailScreen(),
              ],
            ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // --- Screen Builders ---

  Widget _buildGenderScreen() => _baseLayout(
    "Who are you?",
    "Female users require a face verification for safety.",
    [
      _selectionTile(
        "Male",
        selectedGender == "Male",
        () => setState(() {
          selectedGender = "Male";
          isVerified = false;
        }),
      ),
      const SizedBox(height: 15),
      _selectionTile(
        "Female",
        selectedGender == "Female",
        () => setState(() => selectedGender = "Female"),
      ),
      if (selectedGender == "Female" && isVerified)
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 5),
          child: Row(
            children: [
              Icon(Icons.verified, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                "Verified",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  Widget _buildLookingForScreen() =>
      _baseLayout("Looking for...", "Select your preferences.", [
        _selectionTile(
          "Male",
          lookingFor.contains("Male"),
          () => setState(
            () => lookingFor.contains("Male")
                ? lookingFor.remove("Male")
                : lookingFor.add("Male"),
          ),
        ),
        const SizedBox(height: 15),
        _selectionTile(
          "Female",
          lookingFor.contains("Female"),
          () => setState(
            () => lookingFor.contains("Female")
                ? lookingFor.remove("Female")
                : lookingFor.add("Female"),
          ),
        ),
      ]);

  Widget _buildAgeScreen() =>
      _baseLayout("Your Birthday", "Confirm your age to proceed.", [
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? "Select Birth Date"
                      : DateFormat('dd MMMM yyyy').format(selectedDate!),
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate == null ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.calendar_month, color: kPrimaryColor),
              ],
            ),
          ),
        ),
      ]);

  Widget _buildInterestScreen() => _baseLayout(
    "Interests",
    "Choose things you're passionate about.",
    [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: interestOptions.map((e) {
          bool sel = selectedInterests.contains(e);
          return GestureDetector(
            onTap: () => setState(
              () =>
                  sel ? selectedInterests.remove(e) : selectedInterests.add(e),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: sel ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: sel ? kPrimaryColor : Colors.grey[300]!,
                ),
              ),
              child: Text(
                e,
                style: TextStyle(
                  color: sel ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );

  Widget _buildPhotoScreen() =>
      _baseLayout("Add Photos", "Upload at least 2 photos.", [
        GridView.builder(
          shrinkWrap: true,
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (ctx, i) => i < selectedImages.length
              ? Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        selectedImages[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // Upload Status Overlay
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: _buildUploadStatusWidget(i)),
                    ),

                    // Remove button (only if not uploading)
                    if (imageUploadStatuses[i].status != ImageStatus.uploading)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => setState(() {
                            selectedImages.removeAt(i);
                            imageUploadStatuses.removeAt(i);
                          }),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
        ),

        // Upload Status Summary
        if (selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // Upload stats
                _buildUploadStats(),
                const SizedBox(height: 10),

                // Retry button for failed uploads
                if (_hasFailedUploads())
                  ElevatedButton.icon(
                    onPressed: _retryFailedUploads,
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text("Retry Failed Uploads"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
      ]);

  Widget _buildUploadStatusWidget(int index) {
    var status = imageUploadStatuses[index];

    if (status.status == ImageStatus.uploading) {
      return const CircularProgressIndicator(color: Colors.white);
    } else if (status.status == ImageStatus.failed) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 30),
          SizedBox(height: 5),
          Text("Failed", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      );
    } else if (status.status == ImageStatus.uploaded) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 30),
          SizedBox(height: 5),
          Text("Uploaded", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      );
    }

    return Container();
  }

  Widget _buildUploadStats() {
    int total = selectedImages.length;
    int uploaded = imageUploadStatuses
        .where((s) => s.status == ImageStatus.uploaded)
        .length;
    int failed = imageUploadStatuses
        .where((s) => s.status == ImageStatus.failed)
        .length;
    int uploading = imageUploadStatuses
        .where((s) => s.status == ImageStatus.uploading)
        .length;

    return Column(
      children: [
        Text(
          "$uploaded/$total images uploaded",
          style: TextStyle(
            color: uploaded == total ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (failed > 0)
          Text(
            "$failed failed",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        if (uploading > 0)
          Text(
            "$uploading uploading...",
            style: const TextStyle(color: Colors.blue, fontSize: 12),
          ),
        if (uploaded == total && total >= 2)
          const Text(
            "✓ All images ready for submission",
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildProfileDetailScreen() =>
      _baseLayout("Final Details", "Help people know you better.", [
        _modernInput(nameController, "Full Name *", Icons.person_outline),
        _modernInput(workController, "Profession", Icons.work_outline),
        _modernInput(cityController, "City *", Icons.location_on_outlined),
        _modernInput(bioController, "Bio", Icons.notes_outlined, lines: 3),
        const SizedBox(height: 10),
        Text(
          "* Required fields",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ]);

  // --- Widgets ---

  Widget _baseLayout(String title, String sub, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(sub, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          const SizedBox(height: 35),
          ...children,
        ],
      ),
    );
  }

  Widget _selectionTile(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey[200]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white)
            else
              CircleAvatar(radius: 12, backgroundColor: Colors.grey[50]),
          ],
        ),
      ),
    );
  }

  Widget _modernInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: kPrimaryColor),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    bool needsVerification =
        selectedGender == "Female" && !isVerified && _currentPage == 0;

    // Check if on photo screen and have at least 2 images
    bool hasEnoughPhotos = _currentPage == 4
        ? selectedImages.length >= 2
        : true;

    // Check if all images are uploaded on photo screen
    bool allImagesUploaded = _currentPage == 4 ? _areAllImagesUploaded() : true;

    // Check if images are still uploading
    bool imagesUploading = _currentPage == 4 ? _hasUploadingImages() : false;

    // Check required fields for final screen
    bool hasRequiredFields = _currentPage == 5
        ? nameController.text.trim().isNotEmpty &&
              selectedGender.isNotEmpty &&
              selectedDate != null
        : true;

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: needsVerification
              ? kPrimaryColor
              : (_currentPage == 4 && imagesUploading)
              ? Colors.blue
              : (_currentPage == 4 && !allImagesUploaded)
              ? Colors.orange
              : !hasEnoughPhotos || !hasRequiredFields
              ? Colors.black
              : Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          if (_currentPage == 0) {
            if (selectedGender == "") {
              _showSnackBar("Please select gender");
            } else if (needsVerification) {
              _openLivenessCheck();
            } else {
              _controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } else if (_currentPage == 4) {
            if (selectedImages.length < 2) {
              _showSnackBar("Please upload at least 2 photos");
            } else if (imagesUploading) {
              _showSnackBar("Please wait for images to finish uploading");
            } else if (!allImagesUploaded) {
              _showSnackBar(
                "Some images failed to upload. Please retry or remove them.",
              );
            } else {
              _controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } else if (_currentPage == 5) {
            if (nameController.text.trim().isEmpty) {
              _showSnackBar("Please enter your name");
            } else if (selectedGender.isEmpty) {
              _showSnackBar("Please select your gender");
            } else if (selectedDate == null) {
              _showSnackBar("Please select your birth date");
            } else {
              profileValue();
            }
          } else if (_currentPage < 5) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Text(
          needsVerification
              ? "VERIFY FACE"
              : (_currentPage == 4 && imagesUploading)
              ? "UPLOADING..."
              : (_currentPage == 4 && !allImagesUploaded)
              ? "UPLOAD"
              : (_currentPage == 5 ? "COMPLETE PROFILE" : "CONTINUE"),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Profile Completed!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your profile has been successfully created."
                  ,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RootScreen()),
                ),
                child: const Text(
                  "Go to Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Classes for Image Upload Status ---

enum ImageStatus { uploading, uploaded, failed }

class ImageUploadStatus {
  final ImageStatus status;
  final String? url;

  ImageUploadStatus({required this.status, this.url});
}
