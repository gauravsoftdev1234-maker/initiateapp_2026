// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // import '../../../controller/services/StorageService.dart';
// // import '../../../controller/services/app_api_service.dart';
// //
// // class AddPhotoList extends StatefulWidget {
// //   const AddPhotoList({super.key});
// //
// //   @override
// //   State<AddPhotoList> createState() => _AddPhotoListState();
// // }
// //
// // class _AddPhotoListState extends State<AddPhotoList> {
// //   List<dynamic> userImages = [];
// //   bool isLoading = true;
// //   int userId = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchUserProfileImages();
// //   }
// //
// //   // --- 1. Fetch Images ---
// //   Future<void> fetchUserProfileImages() async {
// //     try {
// //       String? token = await SecureStorageService.getToken();
// //       final response = await http.get(
// //         Uri.parse("$base/api/Profile/GetUserProfileV2"),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['isSuccess'] == true && data['Response'].isNotEmpty) {
// //           setState(() {
// //             userId = data['Response'][0]['UserId'];
// //             userImages = (data['Response'][0]['userImage'] as List).where((
// //               img,
// //             ) {
// //               return img['PhotoUrl'] != null &&
// //                   !img['PhotoUrl'].contains("sample string");
// //             }).toList();
// //             isLoading = false;
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   // --- 2. Delete Photo Logic ---
// //   Future<void> _deletePhoto(dynamic photoId, int index) async {
// //     if (photoId == null) {
// //       setState(
// //         () => userImages.removeAt(index),
// //       ); // If ID is null, just remove from UI
// //       return;
// //     }
// //
// //     try {
// //       String? token = await SecureStorageService.getToken();
// //       final response = await http.post(
// //         Uri.parse(
// //           "$base/api/Profile/DeleteUserPhotoByImageID?p_ImageId=$photoId",
// //         ),
// //         headers: {"Authorization": "Bearer $token"},
// //       );
// //       print("response.body ${response.body}");
// //       if (response.statusCode == 200) {
// //         fetchUserProfileImages(); // Refresh list after delete
// //       }
// //     } catch (e) {
// //       debugPrint("Delete error: $e");
// //     }
// //   }
// //
// //   // --- 3. Pick & Upload to CDN then Save ---
// //   Future<void> _pickImage() async {
// //     final ImagePicker picker = ImagePicker();
// //     final XFile? image = await picker.pickImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 70,
// //     );
// //
// //     if (image != null) {
// //       setState(() => isLoading = true);
// //       String? imageUrl = await _uploadToCDN(File(image.path));
// //
// //       if (imageUrl != null) {
// //         await _savePhotoToDatabase(imageUrl);
// //       }
// //       fetchUserProfileImages();
// //     }
// //   }
// //
// //   Future<String?> _uploadToCDN(File file) async {
// //     try {
// //       List<int> imageBytes = await file.readAsBytes();
// //       String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
// //
// //       final String uploadUrl =
// //           "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=";
// //
// //       var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
// //       request.fields['file'] = base64Image;
// //
// //       var streamedResponse = await request.send();
// //       var response = await http.Response.fromStream(streamedResponse);
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         return data['record']; // Returns the URL
// //       }
// //     } catch (e) {
// //       debugPrint("CDN Error: $e");
// //     }
// //     return null;
// //   }
// //
// //   Future<void> _savePhotoToDatabase(String url) async {
// //     try {
// //       String? token = await SecureStorageService.getToken();
// //       await http.post(
// //         Uri.parse("$base/api/Profile/SaveUserPhotos"),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Content-Type": "application/json",
// //         },
// //         body: jsonEncode({
// //           "UserID": userId,
// //           "photos": [url],
// //         }),
// //       );
// //     } catch (e) {
// //       debugPrint("Save API Error: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildHeader(),
// //           const SizedBox(height: 15),
// //           isLoading
// //               ? const Center(
// //                   child: CircularProgressIndicator(color: Color(0xFFFE3C72)),
// //                 )
// //               : GridView.builder(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: 9,
// //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 3,
// //                     crossAxisSpacing: 10,
// //                     mainAxisSpacing: 10,
// //                     childAspectRatio: 0.8,
// //                   ),
// //                   itemBuilder: (context, index) {
// //                     if (index < userImages.length) {
// //                       return _buildPhotoCard(userImages[index], index, true);
// //                     }
// //                     return _buildPhotoCard(null, index, false);
// //                   },
// //                 ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Row(
// //       children: [
// //         const Text(
// //           "Media",
// //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(width: 8),
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFFFE3C72),
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: const Text(
// //             "ADD NOW",
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 10,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //         const Spacer(),
// //
// //       ],
// //     );
// //   }
// //
// //   Widget _buildPhotoCard(dynamic imageData, int index, bool hasImage) {
// //     return Stack(
// //       clipBehavior: Clip.none,
// //       children: [
// //         GestureDetector(
// //           onTap: hasImage ? null : _pickImage,
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: Colors.grey[200],
// //               borderRadius: BorderRadius.circular(12),
// //               border: hasImage
// //                   ? null
// //                   : Border.all(color: Colors.grey.shade400, width: 1),
// //             ),
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(12),
// //               child: hasImage
// //                   ? CachedNetworkImage(
// //                       imageUrl: imageData['PhotoUrl'],
// //                       fit: BoxFit.cover,
// //                       width: double.infinity,
// //                       height: double.infinity,
// //                     )
// //                   : const Center(
// //                       child: Icon(Icons.edit, color: Colors.grey, size: 30),
// //                     ),
// //             ),
// //           ),
// //         ),
// //         Positioned(
// //           bottom: -5,
// //           right: -5,
// //           child: GestureDetector(
// //             onTap: hasImage
// //                 ? () => _deletePhoto(imageData['Id'], index)
// //                 : _pickImage,
// //             child: Container(
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 shape: BoxShape.circle,
// //                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
// //               ),
// //               child: CircleAvatar(
// //                 radius: 12,
// //                 backgroundColor: Colors.white,
// //                 child: Icon(
// //                   hasImage ? Icons.delete : Icons.edit,
// //                   size: 16,
// //                   color: hasImage ? Colors.red : const Color(0xFF010F33),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shimmer/shimmer.dart'; // Shimmer effect ke liye (optional)
//
// import '../../../controller/services/StorageService.dart';
// import '../../../controller/services/app_api_service.dart';
//
// class AddPhotoList extends StatefulWidget {
//   const AddPhotoList({super.key});
//
//   @override
//   State<AddPhotoList> createState() => _AddPhotoListState();
// }
//
// class _AddPhotoListState extends State<AddPhotoList> {
//   List<dynamic> userImages = [];
//   bool isLoading = true;
//   int userId = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfileImages();
//   }
//
//   Future<void> fetchUserProfileImages() async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       final response = await http.get(
//         Uri.parse("$base/api/Profile/GetUserProfileV2"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['isSuccess'] == true && data['Response'].isNotEmpty) {
//           setState(() {
//             userId = data['Response'][0]['UserId'];
//             userImages = (data['Response'][0]['userImage'] as List).where((img) {
//               return img['PhotoUrl'] != null &&
//                   !img['PhotoUrl'].contains("sample string");
//             }).toList();
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // --- Optimized Delete Logic ---
//   Future<void> _deletePhoto(dynamic photoId, int index) async {
//     // UI se turant hatane ke liye (Optimistic Update)
//     final backup = List.from(userImages);
//     setState(() => userImages.removeAt(index));
//
//     try {
//       String? token = await SecureStorageService.getToken();
//       final response = await http.post(
//         Uri.parse("$base/api/Profile/DeleteUserPhotoByImageID?p_ImageId=$photoId"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode != 200) {
//         setState(() => userImages = backup); // Error aane par wapas layein
//         _showSnackBar("Failed to delete image");
//       }
//     } catch (e) {
//       setState(() => userImages = backup);
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//
//     if (image != null) {
//       setState(() => isLoading = true);
//       String? imageUrl = await _uploadToCDN(File(image.path));
//
//       if (imageUrl != null) {
//         await _savePhotoToDatabase(imageUrl);
//         fetchUserProfileImages();
//       } else {
//         setState(() => isLoading = false);
//         _showSnackBar("Upload failed");
//       }
//     }
//   }
//
//   Future<String?> _uploadToCDN(File file) async {
//     try {
//       List<int> imageBytes = await file.readAsBytes();
//       String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
//       final String uploadUrl = "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=";
//
//       var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
//       request.fields['file'] = base64Image;
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body)['record'];
//       }
//     } catch (e) { debugPrint(e.toString()); }
//     return null;
//   }
//
//   Future<void> _savePhotoToDatabase(String url) async {
//     try {
//       String? token = await SecureStorageService.getToken();
//       await http.post(
//         Uri.parse("$base/api/Profile/SaveUserPhotos"),
//         headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
//         body: jsonEncode({"UserID": userId, "photos": [url]}),
//       );
//     } catch (e) { debugPrint(e.toString()); }
//   }
//
//   void _showSnackBar(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),
//           const SizedBox(height: 20),
//           isLoading
//               ? _buildShimmerLoading()
//               : GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 9,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.8,
//             ),
//             itemBuilder: (context, index) {
//               if (index < userImages.length) {
//                 return _buildPhotoCard(userImages[index], index, true);
//               }
//               return _buildPhotoCard(null, index, false);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Text("Media", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
//         const SizedBox(width: 10),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//           decoration: BoxDecoration(color: const Color(0xFFFE3C72), borderRadius: BorderRadius.circular(20)),
//           child: const Text("ADD NOW", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPhotoCard(dynamic imageData, int index, bool hasImage) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         GestureDetector(
//           onTap: hasImage ? null : _pickImage,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(15),
//               border: hasImage ? null : Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: hasImage
//                   ? CachedNetworkImage(
//                 imageUrl: imageData['PhotoUrl'],
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//                 // Professional Loading
//                 placeholder: (context, url) => Container(
//                   color: Colors.grey[200],
//                   child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey)),
//                 ),
//                 // Error Image
//                 errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined, color: Colors.grey),
//               )
//                   : const Center(child: Icon(Icons.add_rounded, color: Colors.grey, size: 35)),
//             ),
//           ),
//         ),
//         // Action Button (Delete or Add)
//         Positioned(
//           bottom: -6,
//           right: -6,
//           child: GestureDetector(
//             onTap: hasImage ? () => _deletePhoto(imageData['Id'], index) : _pickImage,
//             child: Container(
//               padding: const EdgeInsets.all(2),
//               decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))]),
//               child: CircleAvatar(
//                 radius: 13,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   hasImage ? Icons.close_rounded : Icons.add_rounded,
//                   size: 18,
//                   color: hasImage ? Colors.grey[600] : const Color(0xFFFE3C72),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Optional: Skeleton loading for better UX
//   Widget _buildShimmerLoading() {
//     return GridView.builder(
//       shrinkWrap: true,
//       itemCount: 9,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
//       itemBuilder: (context, index) => Container(
//         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
//       ),
//     );
//   }
// }
//
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui'; // Blur effect ke liye

import '../../../controller/services/StorageService.dart';
import '../../../controller/services/app_api_service.dart';

class AddPhotoList extends StatefulWidget {
  const AddPhotoList({super.key});

  @override
  State<AddPhotoList> createState() => _AddPhotoListState();
}

class _AddPhotoListState extends State<AddPhotoList> {
  List<dynamic> userImages = [];
  bool isLoading = true;      // Initial fetch loader
  bool isUploading = false;   // Uploading specific loader
  int userId = 0;

  @override
  void initState() {
    super.initState();
    fetchUserProfileImages();
  }

  Future<void> fetchUserProfileImages() async {
    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.get(
        Uri.parse("$base/api/Profile/GetUserProfileV2"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccess'] == true && data['Response'].isNotEmpty) {
          setState(() {
            userId = data['Response'][0]['UserId'];
            userImages = (data['Response'][0]['userImage'] as List).where((img) {
              return img['PhotoUrl'] != null &&
                  !img['PhotoUrl'].contains("sample string");
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deletePhoto(dynamic photoId, int index) async {
    final backup = List.from(userImages);
    setState(() => userImages.removeAt(index));

    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.post(
        Uri.parse("$base/api/Profile/DeleteUserPhotoByImageID?p_ImageId=$photoId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) {
        setState(() => userImages = backup);
        _showSnackBar("Failed to delete image");
      }
    } catch (e) {
      setState(() => userImages = backup);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Quality optimized to 35 and MaxWidth 1080 for faster uploads
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 35,
      maxWidth: 1080,
    );

    if (image != null) {
      setState(() => isUploading = true); // Start Upload Loader
      try {
        String? imageUrl = await _uploadToCDN(File(image.path));

        if (imageUrl != null) {
          await _savePhotoToDatabase(imageUrl);
          await fetchUserProfileImages();
        } else {
          _showSnackBar("Upload failed");
        }
      } finally {
        setState(() => isUploading = false); // Stop Upload Loader
      }
    }
  }

  Future<String?> _uploadToCDN(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
      final String uploadUrl = "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=";

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['file'] = base64Image;
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['record'];
      }
    } catch (e) { debugPrint(e.toString()); }
    return null;
  }

  Future<void> _savePhotoToDatabase(String url) async {
    try {
      String? token = await SecureStorageService.getToken();
      await http.post(
        Uri.parse("$base/api/Profile/SaveUserPhotos"),
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({"UserID": userId, "photos": [url]}),
      );
    } catch (e) { debugPrint(e.toString()); }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        children: [
          // MAIN UI
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              isLoading
                  ? _buildShimmerLoading()
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  if (index < userImages.length) {
                    return _buildPhotoCard(userImages[index], index, true);
                  }
                  return _buildPhotoCard(null, index, false);
                },
              ),
            ],
          ),

          // UPLOADING CENTER LOADER
          if (isUploading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFFE3C72),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Uploading Photo...",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text("Media", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFE3C72), borderRadius: BorderRadius.circular(20)),
          child: const Text("ADD NOW", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(dynamic imageData, int index, bool hasImage) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: hasImage ? null : _pickImage,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: hasImage ? null : Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: hasImage
                  ? CachedNetworkImage(
                imageUrl: imageData['PhotoUrl'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                memCacheWidth: 400, // Optimized display cache
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
              )
                  : const Center(child: Icon(Icons.add_rounded, color: Colors.grey, size: 35)),
            ),
          ),
        ),
        Positioned(
          bottom: -6,
          right: -6,
          child: GestureDetector(
            onTap: hasImage ? () => _deletePhoto(imageData['Id'], index) : _pickImage,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.white,
                child: Icon(
                  hasImage ? Icons.close_rounded : Icons.add_rounded,
                  size: 18,
                  color: hasImage ? Colors.grey[600] : const Color(0xFFFE3C72),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
      itemBuilder: (context, index) => Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15))),
    );
  }
}