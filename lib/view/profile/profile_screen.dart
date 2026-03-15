import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:initiateapp_2026app_2026/view/ContactsScreen/ContactsScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_compress/video_compress.dart';
import 'package:initiateapp_2026app_2026/view/starting_screens/login/login.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- EXISTING VARIABLES ---
  bool _hidemyprofile = false; // Your existing variable
  String? _mysteryEndTime; // Add this
  int? _remainingSeconds; // Add this
  String fullName = "N/A";
  String userGender = "N/A";
  String ageText = "N/A";
  String profilePicUrl = "https://via.placeholder.com/150";
  String bio = "";
  String city = "";
  bool isLoading = true;
  bool isUploading = false;
  File? _selectedImage;
  double completionProgress = 0.62;

  // --- VIDEO VARIABLES - UPDATED TO USE userVideo ARRAY ---
  List<Map<String, dynamic>> videoClips = []; // Store video objects from API
  bool isVideoUploading = false;
  bool isVideoCompressing = false;
  File? _selectedVideo;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool isVideoPlaying = false;
  bool showVideoPlayer = false;
  String? selectedVideoUrl;
  double compressionProgress = 0.0;
  String compressionStatus = "";
  Subscription? _compressSubscription;

  @override
  void initState() {
    super.initState();
    userProfile(); // Existing function call
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _compressSubscription?.unsubscribe();
    VideoCompress.dispose();
    super.dispose();
  }

  // --- EXISTING FUNCTIONS (Age, Profile, Upload, Logout) ---

  int calculateAge(String dobString) {
    try {
      List<String> parts = dobString.split('-');
      if (parts.length != 3) return 28;
      Map<String, int> monthMap = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };
      int day = int.tryParse(parts[0]) ?? 1;
      int year = int.tryParse(parts[2]) ?? 2000;
      int month = monthMap[parts[1]] ?? 1;
      DateTime now = DateTime.now();
      DateTime dob = DateTime(year, month, day);
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day))
        age--;
      return age > 0 ? age : 28;
    } catch (e) {
      return 28;
    }
  }

  Future<void> userProfile() async {
    try {
      String? token = await SecureStorageService.getToken();

      print(token);
      final response = await http.get(
        Uri.parse("$base/api/Profile/GetUserProfile"),
        headers: {"Authorization": "Bearer $token"},
      );
      final responseData = jsonDecode(response.body);
      // print(responseData);
      if (response.statusCode == 200 &&
          responseData['isSuccess'] == true &&
          responseData['Response'] != null) {
        final userData = responseData['Response'][0];
        setState(() {
          fullName = userData['FullName'] ?? "N/A";
          userGender = userData['Gender'] ?? "N/A";
          // print(userGender);
          bio = userData['Bio']?.toString() ?? "";
          city = userData['City']?.toString() ?? "";
          if (userData['DOB'] != null) {
            ageText = "${calculateAge(userData['DOB'])} yrs";
          }
          if (userData['profilepic'] != null &&
              userData['profilepic'].isNotEmpty) {
            profilePicUrl = userData['profilepic'];
          }

          // ✅ Load video clips from userVideo array
          if (userData['userVideo'] != null && userData['userVideo'] is List) {
            videoClips = List<Map<String, dynamic>>.from(userData['userVideo']);
            print("Loaded ${videoClips.length} video clips");
          }

          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Update your function
  Future<void> hideProfile(bool newValue) async {
    try {
      String? token = await SecureStorageService.getToken();
      print(token);

      final response = await http.post(
        Uri.parse("$base/api/Profile/ToggleMysteryProfile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"p_IsEnable": newValue}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['isSuccess'] == true) {
          setState(() {
            _hidemyprofile = newValue;
            if (responseData.containsKey('mysteryEndTime')) {
              _mysteryEndTime = responseData['mysteryEndTime'];
            }
            if (responseData.containsKey('remainingSeconds')) {
              _remainingSeconds = responseData['remainingSeconds'];
            }
          });

          // Show animated custom message
          _showAnimatedMessage(
            context,
            message:
                responseData['message'] ??
                (newValue ? 'Profile hidden' : 'Profile visible'),
            isSuccess: true,
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        _showAnimatedMessage(
          context,
          message: 'Something went wrong',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _hidemyprofile = !newValue;
      });
      _showAnimatedMessage(context, message: 'Network error', isSuccess: false);
    }
  }

  void _showAnimatedMessage(
    BuildContext context, {
    required String message,
    required bool isSuccess,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              // Clamp opacity between 0 and 1
              final opacity = value.clamp(0.0, 1.0);
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: opacity, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSuccess
                      ? [Colors.pink[400]!, Colors.pink[400]!]
                      : [Colors.red[400]!, Colors.orange[400]!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isSuccess ? Colors.green : Colors.red).withOpacity(
                      0.3,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSuccess ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
      await _uploadProfilePicture();
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null) return;
    setState(() => isUploading = true);
    try {
      String? cdnUrl = await _uploadImageToCDN(_selectedImage!);
      if (cdnUrl != null) await _updateProfilePhoto(cdnUrl);
    } catch (e) {
      setState(() => isUploading = false);
    }
  }

  Future<String?> _uploadImageToCDN(File imageFile) async {
    try {
      String? token = await SecureStorageService.getToken();
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64WithMime =
          "data:image/jpeg;base64,${base64Encode(imageBytes)}";
      final String uploadUrl =
          "https://cdn.cloudbill.in/api/CDN/UploadBase64?APkey=initiate&SecKey=initiate_date&SepretFolder=UserPhoto&FileName=";
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.fields['file'] = base64WithMime;
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseString);
        return responseData['record'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _updateProfilePhoto(String imageUrl) async {
    try {
      String? token = await SecureStorageService.getToken();
      final response = await http.post(
        Uri.parse("$base/api/Profile/UpdateUserProfilePhoto"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"p_ProfilePhoto": imageUrl}),
      );
      if (response.statusCode == 200) {
        setState(() {
          profilePicUrl = imageUrl;
          isUploading = false;
          _selectedImage = null;
        });
      }
    } catch (e) {
      setState(() => isUploading = false);
    }
  }

  // --- VIDEO FUNCTIONS WITH COMPRESSION USING VIDEO_COMPRESS ---

  // Get file size in MB
  Future<double> _getFileSizeInMB(File file) async {
    int bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  // Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  // Pick video from gallery
  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );

    if (video != null) {
      File videoFile = File(video.path);
      double fileSizeMB = await _getFileSizeInMB(videoFile);
      int fileSizeBytes = await videoFile.length();

      print("Original video size: ${fileSizeMB.toStringAsFixed(2)} MB");

      // If video is already under 50MB, upload directly
      if (fileSizeMB <= 50) {
        setState(() {
          _selectedVideo = videoFile;
          isVideoUploading = true;
        });
        await _uploadVideoToCDN(videoFile);
      } else {
        // Show compression dialog with size info
        _showCompressionDialog(videoFile, fileSizeBytes);
      }
    }
  }

  // Show compression options dialog
  void _showCompressionDialog(File videoFile, int fileSizeBytes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Video Too Large"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 50),
            const SizedBox(height: 15),
            Text(
              "Video size: ${_formatFileSize(fileSizeBytes)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Maximum allowed size is 50 MB. Would you like to compress it?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Recommended: Medium quality (good balance)",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _compressVideo(videoFile);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Compress Video"),
          ),
        ],
      ),
    );
  }

  // Compress video using VideoCompress
  Future<void> _compressVideo(File videoFile) async {
    setState(() {
      isVideoCompressing = true;
      compressionProgress = 0.0;
      compressionStatus = "Analyzing video...";
    });

    try {
      // Get video info first
      final info = await VideoCompress.getMediaInfo(videoFile.path);
      print("Video info: ${info.toJson()}");

      setState(() {
        compressionStatus = "Compressing video... This may take a moment";
      });

      // Subscribe to compression progress
      _compressSubscription = VideoCompress.compressProgress$.subscribe((
        progress,
      ) {
        setState(() {
          compressionProgress = progress / 100.0;
        });
      });

      // Compress video with options
      final MediaInfo? compressedMedia = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality, // Medium quality for good balance
        deleteOrigin: false, // Keep original file
        startTime: 0,
        duration: 30, // Max 30 seconds
        includeAudio: true,
        frameRate: 30, // Standard frame rate
      );

      if (compressedMedia != null && compressedMedia.path != null) {
        File compressedFile = File(compressedMedia.path!);
        double compressedSizeMB = await _getFileSizeInMB(compressedFile);
        int compressedSizeBytes = await compressedFile.length();

        print(
          "Compressed video size: ${compressedSizeMB.toStringAsFixed(2)} MB",
        );

        setState(() {
          compressionProgress = 1.0;
        });

        // Check if compressed file is under 50MB
        if (compressedSizeMB <= 50) {
          setState(() {
            isVideoCompressing = false;
            _selectedVideo = compressedFile;
            isVideoUploading = true;
          });

          // Show success message
          _showSuccessCompressionDialog(
            compressedSizeBytes,
            videoFile.lengthSync(),
          );

          await _uploadVideoToCDN(compressedFile);
        } else {
          // Still too large, try higher compression
          setState(() {
            isVideoCompressing = false;
          });
          _showCompressionFailedDialog(compressedFile, compressedSizeBytes);
        }
      } else {
        // Compression failed
        setState(() {
          isVideoCompressing = false;
        });
        _showSnackBar(
          "Video compression failed. Please try a different video.",
        );
      }
    } catch (e) {
      setState(() {
        isVideoCompressing = false;
      });
      print("Compression error: $e");
      _showSnackBar("Error compressing video: $e");
    } finally {
      _compressSubscription?.unsubscribe();
    }
  }

  // Show success compression dialog
  void _showSuccessCompressionDialog(int compressedSize, int originalSize) {
    double reductionPercent =
        ((originalSize - compressedSize) / originalSize * 100);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Compression Successful"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 15),
            Text(
              "Original: ${_formatFileSize(originalSize)}",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "Compressed: ${_formatFileSize(compressedSize)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "Reduced by ${reductionPercent.toStringAsFixed(1)}%",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Show dialog if compression still results in large file
  void _showCompressionFailedDialog(File videoFile, int fileSizeBytes) {
    double sizeMB = fileSizeBytes / (1024 * 1024);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Still Too Large"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 15),
            Text(
              "Compressed size: ${sizeMB.toStringAsFixed(2)} MB",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Video is still over 50 MB. Try with a shorter or lower quality video.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Tips:\n• Record shorter clips (15-20 seconds)\n• Use lower resolution\n• Avoid high motion content",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Upload video to CDN
  Future<void> _uploadVideoToCDN(File videoFile) async {
    try {
      String? token = await SecureStorageService.getToken();

      setState(() {
        compressionStatus = "Uploading to CDN...";
      });

      // Read file as bytes
      List<int> videoBytes = await videoFile.readAsBytes();

      // Create multipart request for video upload
      final String uploadUrl =
          "https://cdn.cloudbill.in/api/CDN/upload?APkey=initiate&SecKey=initiate_date&SepretFolder=Video&FileName=";

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file to request
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        videoBytes,
        filename: 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
        contentType: http.MediaType('video', 'mp4'),
      );
      request.files.add(multipartFile);

      // Send request with progress tracking
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseString);
        print("Video CDN Response: $responseData");

        if (responseData['isSuccess'] == true) {
          String videoUrl = responseData['record'] ?? '';

          if (videoUrl.isNotEmpty) {
            // Save video URL to backend
            await _saveVideoClip(videoUrl);
          } else {
            setState(() {
              isVideoUploading = false;
              isVideoCompressing = false;
            });
            _showSnackBar("Failed to get video URL from CDN");
          }
        } else {
          setState(() {
            isVideoUploading = false;
            isVideoCompressing = false;
          });
          _showSnackBar("Video upload failed: ${responseData['message']}");
        }
      } else {
        setState(() {
          isVideoUploading = false;
          isVideoCompressing = false;
        });
        _showSnackBar(
          "Video upload failed with status: ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() {
        isVideoUploading = false;
        isVideoCompressing = false;
      });
      print("Video upload error: $e");
      _showSnackBar("Error uploading video: $e");
    }
  }

  // ✅ UPDATED: Save video clip to user profile using UploadVideoClip API
  Future<void> _saveVideoClip(String videoUrl) async {
    try {
      String? token = await SecureStorageService.getToken();

      final response = await http.post(
        Uri.parse("$base/api/ChatMaster/UploadVideoClip"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"VideoUrl": videoUrl, "Status": "A"}),
      );

      print("Save video response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isSuccess'] == true) {
          // Add the new video to the list with a temporary ID
          // In a real app, you might want to refresh the profile to get the actual ID
          setState(() {
            videoClips.add({
              'Id': DateTime.now().millisecondsSinceEpoch, // Temporary ID
              'UserId': 0,
              'VideoUrl': videoUrl,
              'Status': 'A',
            });
            isVideoUploading = false;
            isVideoCompressing = false;
            _selectedVideo = null;
          });
          _showSnackBar("Video uploaded successfully!", isError: false);
        } else {
          setState(() {
            isVideoUploading = false;
            isVideoCompressing = false;
          });
          _showSnackBar("Failed to save video: ${responseData['message']}");
        }
      } else {
        setState(() {
          isVideoUploading = false;
          isVideoCompressing = false;
        });
        _showSnackBar(
          "Failed to save video: Server error ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() {
        isVideoUploading = false;
        isVideoCompressing = false;
      });
      print("Save video error: $e");
      _showSnackBar("Error saving video: $e");
    }
  }

  // ✅ UPDATED: Delete video clip using the video ID
  Future<void> _deleteVideoClip(Map<String, dynamic> video) async {
    int videoId = video['Id'];
    String videoUrl = video['VideoUrl'];

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Video'),
        content: const Text('Are you sure you want to delete this video clip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        String? token = await SecureStorageService.getToken();

        // Call API to delete video - adjust endpoint as needed
        final response = await http.post(
          Uri.parse("$base/api/ChatMaster/DeleteVideoClip"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode({"VideoId": videoId}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['isSuccess'] == true) {
            setState(() {
              videoClips.removeWhere((v) => v['Id'] == videoId);
              if (selectedVideoUrl == videoUrl) {
                selectedVideoUrl = null;
                showVideoPlayer = false;
                _videoController?.dispose();
                _chewieController?.dispose();
              }
            });
            _showSnackBar("Video deleted successfully!", isError: false);
          } else {
            _showSnackBar("Failed to delete video: ${responseData['message']}");
          }
        } else {
          _showSnackBar(
            "Failed to delete video: Server error ${response.statusCode}",
          );
        }
      } catch (e) {
        _showSnackBar("Error deleting video: $e");
      }
    }
  }

  // Play video
  void _playVideo(String videoUrl) async {
    // Dispose any existing controllers
    _videoController?.pause();
    _videoController?.dispose();
    _chewieController?.dispose();

    setState(() {
      selectedVideoUrl = videoUrl;
      showVideoPlayer = true;
    });

    _videoController = VideoPlayerController.network(videoUrl);
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoController!.value.aspectRatio,
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Error loading video',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() {});
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoon() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.rocket_launch, size: 50, color: Color(0xFFFE3C72)),
            const SizedBox(height: 15),
            const Text(
              "Working on it!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "This premium feature is coming soon to Initly.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SecureStorageService.clearToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthFlow()),
      );
    }
  }

  // --- MODERN UI BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        title: isLoading
            ? const SizedBox(width: 50, child: LinearProgressIndicator())
            : Row(
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF1D9BF0),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ageText,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile Photo Section
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 25, top: 10),
                  child: Column(
                    children: [
                      _buildAvatar(),
                      const SizedBox(height: 15),
                      _buildEditButton(),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Video Clip Section - UPDATED to use videoClips
                _buildVideoSection(),
                // First, check if user is female
                if (userGender.toLowerCase() == 'female')
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: _buildSwitchTile(
                      "Make Profile Mystery",
                      _hidemyprofile,
                      (v) {
                        if (v == true) {
                          // Show dialog when trying to hide profile
                          showHideProfileDialog(context);
                          // Revert the switch since we're showing dialog
                          setState(() => _hidemyprofile = false);
                        } else {
                          // Directly call unhide without dialog
                          setState(() => _hidemyprofile = false);
                          hideProfile(false);
                        }
                      },
                    ),
                  )
                else
                  // Optionally show nothing or a disabled state
                  SizedBox.shrink(), // This hides the widget completely
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.red[400]!, Colors.red[900]!],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.block_flipped,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Block Contact',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      'Stop receiving messages and calls',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      // Show block confirmation dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Platinum Card
                _buildPlatinumCard(),

                // Logout & Footer
                _buildFooter(),
              ],
            ),
          ),
          if (isUploading || isVideoUploading || isVideoCompressing)
            _buildLoadingOverlay(),
          if (showVideoPlayer && selectedVideoUrl != null)
            _buildVideoPlayerOverlay(),
        ],
      ),
    );
  }

  Future<void> showHideProfileDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 36), // For balance
                      Text(
                        'Mystery Profile',
                        style: TextStyle(
                          fontSize: 14, // Reduced from 18
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6), // Reduced from 8
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16, // Reduced from 20
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(height: 1, color: Colors.grey[200]),

                // Content
                Padding(
                  padding: const EdgeInsets.all(24), // Reduced from 32
                  child: Column(
                    children: [
                      // Animated icon
                      Container(
                        padding: const EdgeInsets.all(16), // Reduced from 20
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.purple[100]!, Colors.blue[100]!],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.visibility_off_rounded,
                          size: 30, // Reduced from 48
                          color: Colors.purple[700],
                        ),
                      ),

                      const SizedBox(height: 10), // Reduced from 24
                      // Title
                      Text(
                        'Switch to Mystery Mode?',
                        style: TextStyle(
                          fontSize: 16, // Reduced from 24
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),

                      const SizedBox(height: 10), // Reduced from 12
                      // Description
                      Text(
                        'Your profile will be hidden from others. You won\'t appear in discovery feeds until you turn this off.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12, // Reduced from 16
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 14), // Reduced from 16
                      // Info chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, // Reduced from 16
                          vertical: 8, // Reduced from 10
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(
                            26,
                          ), // Reduced from 30
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16, // Reduced from 18
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 6), // Reduced from 8
                            Text(
                              'You can re-enable after 72hours',
                              style: TextStyle(
                                fontSize: 12, // Reduced from 14
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(height: 1, color: Colors.grey[200]),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(14), // Reduced from 16
                  child: Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ), // Reduced from 16
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                14,
                              ), // Reduced from 16
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14, // Reduced from 16
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10), // Reduced from 12
                      // Confirm button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Call your hide profile function
                            hideProfile(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ), // Reduced from 16
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.pink, Colors.pink[600]!],
                              ),
                              borderRadius: BorderRadius.circular(
                                14,
                              ), // Reduced from 16
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple[200]!,
                                  blurRadius: 10, // Reduced from 12
                                  offset: const Offset(0, 3), // Reduced from 4
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Mystery Profile',
                                style: TextStyle(
                                  fontSize: 14, // Reduced from 16
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        activeColor: Colors.pink,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey[200],
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : (profilePicUrl.isNotEmpty &&
                          profilePicUrl != "https://via.placeholder.com/150"
                      ? CachedNetworkImageProvider(profilePicUrl)
                            as ImageProvider
                      : const AssetImage('assets/images/Initly.png')),
          ),
        ),
        GestureDetector(
          onTap: _pickImage,
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black,
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  // ✅ UPDATED: Video Section Widget using videoClips array
  Widget _buildVideoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.video_library, color: Color(0xFFFE3C72), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Video Clips",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (videoClips.length < 10) // Allow up to 10 videos
                ElevatedButton.icon(
                  onPressed: (isVideoCompressing || isVideoUploading)
                      ? null
                      : _pickVideo,
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(videoClips.isEmpty ? "Add Video" : "Add More"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Showcase your personality with short video clips (max 30 sec, under 50MB)",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Video List from API
          if (videoClips.isEmpty)
            _buildEmptyVideoState()
          else
            _buildVideoList(),
        ],
      ),
    );
  }

  Widget _buildEmptyVideoState() {
    return GestureDetector(
      onTap: (isVideoCompressing || isVideoUploading) ? null : _pickVideo,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              "Add your first video clip",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "30 seconds max • Under 50MB",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ UPDATED: Build video list from videoClips array
  Widget _buildVideoList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videoClips.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> video = videoClips[index];
          String videoUrl = video['VideoUrl'];
          int videoId = video['Id'];

          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                // Video Thumbnail
                GestureDetector(
                  onTap: () => _playVideo(videoUrl),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/video_placeholder.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),

                // Delete button
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => _deleteVideoClip(video),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // Video ID indicator (optional - shows count)
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "#${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Video Player Overlay
  Widget _buildVideoPlayerOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Center(
            child:
                _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? GestureDetector(
                    onTap:
                        () {}, // Prevent tap from closing when tapping on video
                    child: AspectRatio(
                      aspectRatio: _chewieController!
                          .videoPlayerController
                          .value
                          .aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),

          // Close button (top-left)
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                // Properly dispose controllers before hiding
                _videoController?.pause();
                _videoController?.dispose();
                _chewieController?.dispose();
                _videoController = null;
                _chewieController = null;

                setState(() {
                  showVideoPlayer = false;
                  selectedVideoUrl = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
      ),
      icon: const Icon(Icons.edit, size: 18),
      label: const Text(
        "Edit profile",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _buildPlatinumCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Initly ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "PLATINUM",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _showComingSoon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "UPGRADE",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _comparisonRow("Priority Likes", true, true),
          _comparisonRow("Message Before Matching", false, true),
          _comparisonRow("See Who Likes You", true, true),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _showComingSoon,
            child: const Text(
              "See all Features",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comparisonRow(String text, bool gold, bool platinum) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 13)),
          Row(
            children: [
              Icon(gold ? Icons.check : Icons.lock, size: 16),
              const SizedBox(width: 40),
              Icon(platinum ? Icons.check : Icons.lock, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            "Logout",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        const Icon(Icons.favorite, color: Color(0xFFEC0032), size: 30),
        const Text(
          "Made with love in India",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          "© ${DateTime.now().year} All rights reserved",
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isVideoCompressing) ...[
                const CircularProgressIndicator(color: Color(0xFFFE3C72)),
                const SizedBox(height: 15),
                Text(
                  compressionStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 200,
                    height: 8,
                    child: LinearProgressIndicator(
                      value: compressionProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFFE3C72),
                      ),
                    ),
                  ),
                ),
                Text(
                  "${(compressionProgress * 100).toInt()}%",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Please wait...",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ] else if (isVideoUploading) ...[
                const CircularProgressIndicator(color: Color(0xFFFE3C72)),
                const SizedBox(height: 15),
                const Text(
                  "Uploading video...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ] else ...[
                const CircularProgressIndicator(color: Color(0xFFFE3C72)),
                const SizedBox(height: 15),
                const Text(
                  "Uploading...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
