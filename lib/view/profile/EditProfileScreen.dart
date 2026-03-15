import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';
import 'add_photos/add_photo.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool _hideAge = false;
  bool _hideDistance = false;

  // -------- Interests ----------
  final List<String> _selectedInterests = [];

  final Map<String, List<String>> _allInterests = {
    "Creativity 🎨": [
      "Poetry",
      "Sneakers",
      "Freelancing",
      "Photography",
      "Choir",
      "Cosplay",
      "Singing",
      "Writing",
      "Art",
      "Dancing",
      "NFTs",
      "Digital Art",
      "Music Production",
      "Graphic Design",
    ],
    "Business 💼": [
      "Entrepreneurship",
      "Startups",
      "Investing",
      "Marketing",
      "E-commerce",
      "Fintech",
      "Blockchain",
      "Real Estate",
    ],
    "Sports & Fitness 🏃‍♂️": [
      "Gym",
      "Yoga",
      "Running",
      "Cycling",
      "Football",
      "Basketball",
      "Tennis",
      "Swimming",
      "Martial Arts",
    ],
    "Technology 💻": [
      "Coding",
      "AI/ML",
      "Web3",
      "Gaming",
      "Robotics",
      "Data Science",
      "Cyber Security",
      "Mobile Apps",
    ],
    "Lifestyle 🌿": [
      "Travel",
      "Foodie",
      "Fashion",
      "Reading",
      "Meditation",
      "Mindfulness",
      "Sustainability",
      "Wellness",
    ],
    "Education 📚": [
      "Learning",
      "Courses",
      "Workshops",
      "Online Education",
      "Languages",
      "History",
      "Science",
      "Philosophy",
    ],
  };

  // -------- Dynamic Controllers ----------
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize all controllers dynamically
    _initializeControllers();
    _loadUserProfile();
  }

  void _initializeControllers() {
    // Define all field names that match API payload
    final fieldNames = [
      'relationshipGoal',
      'pronouns',
      'height',
      'languages',
      'zodiac',
      'education',
      'pets',
      'drinking',
      'smoking',
      'workout',
      'college',
      'jobTitle',
      'company',
      'city',
      'familyPlans',
      'communication',
      'loveStyle',
      'socialMedia',
      'gender',
      'orientation',
      'relationshipType',
    ];

    for (var field in fieldNames) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- Load User Profile ---
  Future<void> _loadUserProfile() async {
    try {
      String? token = await SecureStorageService.getToken();
      if (token == null) {
        _showToast("Authentication failed. Please login again.");
        setState(() => _isInitialLoading = false);
        return;
      }

      developer.log("Loading profile from: $base/api/Profile/GetUserProfileV2");

      final response = await http.get(
        Uri.parse('$base/api/Profile/GetUserProfileV2'),
        headers: {'Authorization': 'Bearer $token'},
      );

      developer.log("Profile Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> profileData = jsonDecode(response.body);
        developer.log("Full Profile Data: $profileData");

        if (profileData['Response'] != null &&
            profileData['Response'].isNotEmpty) {
          final profile = profileData['Response'][0];

          // Log all available fields
          developer.log("Available profile fields:");
          profile.forEach((key, value) {
            developer.log("$key: $value (${value.runtimeType})");
          });

          setState(() {
            // Map API fields to our controllers
            _controllers['relationshipGoal']?.text =
                profile['relationshipGoal']?.toString() ?? '';
            _controllers['pronouns']?.text =
                profile['pronouns']?.toString() ?? '';

            // Handle height - convert to string with cm
            if (profile['HeightCM'] != null) {
              double heightValue =
                  double.tryParse(profile['HeightCM'].toString()) ?? 0;
              _controllers['height']?.text = heightValue > 0
                  ? "${heightValue.toStringAsFixed(0)} cm"
                  : '';
            }

            _controllers['relationshipType']?.text =
                profile['relationship_type']?.toString() ?? '';
            _controllers['languages']?.text =
                profile['Languages']?.toString() ?? '';
            _controllers['zodiac']?.text = profile['Zodiac']?.toString() ?? '';
            _controllers['education']?.text =
                profile['education']?.toString() ?? '';
            _controllers['familyPlans']?.text =
                profile['family_plans']?.toString() ?? '';
            _controllers['communication']?.text =
                profile['communication']?.toString() ?? '';
            _controllers['loveStyle']?.text =
                profile['love_style']?.toString() ?? '';
            _controllers['pets']?.text = profile['Pets']?.toString() ?? '';
            _controllers['drinking']?.text =
                profile['drinking']?.toString() ?? '';
            _controllers['smoking']?.text =
                profile['smoking']?.toString() ?? '';
            _controllers['workout']?.text =
                profile['workout']?.toString() ?? '';
            _controllers['socialMedia']?.text =
                profile['social_media']?.toString() ?? '';
            _controllers['college']?.text =
                profile['college']?.toString() ?? '';
            _controllers['jobTitle']?.text =
                profile['Job_Title']?.toString() ?? '';
            _controllers['company']?.text =
                profile['company']?.toString() ?? '';
            _controllers['city']?.text = profile['city']?.toString() ?? '';
            _controllers['gender']?.text = profile['gender']?.toString() ?? '';
            _controllers['orientation']?.text =
                profile['Sexual_Orientation']?.toString() ?? '';

            // Handle boolean values
            _hideAge = profile['hideAge'] == true;
            _hideDistance = profile['hideDistance'] == true;

            // Handle interests
            _selectedInterests.clear();
            if (profile['userInterest'] != null &&
                profile['userInterest'] is List) {
              for (var interest in profile['userInterest']) {
                if (interest['InterestName'] != null) {
                  _selectedInterests.add(interest['InterestName'].toString());
                }
              }
            }

            if (_selectedInterests.isEmpty &&
                profile['Interest'] != null &&
                profile['Interest'] is List) {
              for (var interest in profile['Interest']) {
                if (interest != null) {
                  _selectedInterests.add(interest.toString());
                }
              }
            }

            developer.log(
              "Loaded ${_selectedInterests.length} interests: $_selectedInterests",
            );
          });
        } else {
          developer.log("No profile data found in response");
        }
      } else {
        developer.log(
          "Failed to load profile: ${response.statusCode} - ${response.body}",
        );
        _showToast("Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      developer.log("Error loading profile: $e", error: e);
      _showToast("Error loading profile");
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  // --- Save Profile ---
  Future<void> _saveProfile() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      String? token = await SecureStorageService.getToken();
      if (token == null) {
        _showToast("Authentication failed. Please login again.");
        setState(() => _isLoading = false);
        return;
      }

      // Prepare payload EXACTLY like Postman
      final Map<String, dynamic> payload = {
        "relationshipGoal": _controllers['relationshipGoal']?.text.trim() ?? "",
        "pronouns": _controllers['pronouns']?.text.trim() ?? "",
        "HeightCM": _parseHeight(_controllers['height']?.text.trim() ?? ""),
        "relationship_type":
            _controllers['relationshipType']?.text.trim() ?? "",
        "Languages": _controllers['languages']?.text.trim() ?? "",
        "Zodiac": _controllers['zodiac']?.text.trim() ?? "",
        "education": _controllers['education']?.text.trim() ?? "",
        "family_plans": _controllers['familyPlans']?.text.trim() ?? "",
        "communication": _controllers['communication']?.text.trim() ?? "",
        "love_style": _controllers['loveStyle']?.text.trim() ?? "",
        "Pets": _controllers['pets']?.text.trim() ?? "",
        "drinking": _controllers['drinking']?.text.trim() ?? "",
        "smoking": _controllers['smoking']?.text.trim() ?? "",
        "workout": _controllers['workout']?.text.trim() ?? "",
        "social_media": _controllers['socialMedia']?.text.trim() ?? "",
        "college": _controllers['college']?.text.trim() ?? "",
        "Job_Title": _controllers['jobTitle']?.text.trim() ?? "",
        "company": _controllers['company']?.text.trim() ?? "",
        "city": _controllers['city']?.text.trim() ?? "",
        "gender": _controllers['gender']?.text.trim() ?? "",
        "Sexual_Orientation": _controllers['orientation']?.text.trim() ?? "",
        "hideAge": _hideAge ? 1 : 0,
        "hideDistance": _hideDistance ? 1 : 0,
        "Interest": _selectedInterests,
      };

      // Log the payload
      developer.log("=== SENDING PAYLOAD ===");
      developer.log("URL: $base/api/Profile/UpdateUserProfileV2");
      developer.log("Token: Bearer ${token.substring(0, 20)}...");
      developer.log("Payload: ${jsonEncode(payload)}");

      final response = await http.post(
        Uri.parse("$base/api/Profile/UpdateUserProfileV2"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      developer.log("=== RESPONSE ===");
      developer.log("Status: ${response.statusCode}");
      developer.log("Headers: ${response.headers}");
      developer.log("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        developer.log("Parsed Response: $data");

        if (data['isSuccess'] == true || data['respCode'] == 0) {
          _showToast(
            data['message'] ?? "Profile updated successfully!",
            isError: false,
          );

          // Reload profile to see changes
          await Future.delayed(const Duration(seconds: 1));
          await _loadUserProfile();

          // Show success and optionally navigate back
          _showSuccessDialog();
        } else {
          _showToast("API Error: ${data['message']}");
        }
      } else {
        _showToast("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      developer.log("Save Error: $e", error: e);
      _showToast("Network Error: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int _parseHeight(String heightText) {
    if (heightText.isEmpty) return 0;

    // Try to extract numbers from string (e.g., "172 cm" -> 172)
    final regex = RegExp(r'(\d+(\.\d+)?)');
    final match = regex.firstMatch(heightText);

    if (match != null) {
      return double.parse(match.group(1)!).round();
    }

    return 0;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success!"),
        content: const Text("Profile updated successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit screen
            },
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog only
            },
            child: const Text("Stay Here"),
          ),
        ],
      ),
    );
  }

  // --- Validation ---
  bool _validateForm() {
    if ((_controllers['relationshipGoal']?.text.trim() ?? "").isEmpty) {
      _showToast("Please select a relationship goal");
      return false;
    }
    if ((_controllers['gender']?.text.trim() ?? "").isEmpty) {
      _showToast("Please select your gender");
      return false;
    }
    if ((_controllers['orientation']?.text.trim() ?? "").isEmpty) {
      _showToast("Please select your orientation");
      return false;
    }
    return true;
  }

  void _showToast(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- Dynamic Suggestion Picker ---
  void _showOptions({
    required String title,
    required List<String> options,
    required String controllerKey,
  }) {
    final controller = _controllers[controllerKey];
    if (controller == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      options[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: controller.text == options[index]
                        ? const Icon(Icons.check, color: Colors.pink, size: 24)
                        : null,
                    onTap: () {
                      setState(() => controller.text = options[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            if (controller.text.trim().isNotEmpty)
              ListTile(
                title: const Text(
                  "Clear selection",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onTap: () {
                  setState(() => controller.clear());
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // --- Specific Pickers ---
  void _showHeightPicker() {
    _showOptions(
      title: "Select Height",
      options: [
        "150 cm",
        "155 cm",
        "160 cm",
        "165 cm",
        "170 cm",
        "175 cm",
        "180 cm",
        "185 cm",
        "190 cm",
        "195 cm",
        "200 cm",
        "5'0\" (152 cm)",
        "5'5\" (165 cm)",
        "5'10\" (178 cm)",
        "6'0\" (183 cm)",
        "6'5\" (196 cm)",
      ],
      controllerKey: 'height',
    );
  }

  void _showPronounsPicker() {
    _showOptions(
      title: "Select Pronouns",
      options: ["He/Him", "She/Her", "They/Them", "Other", "Prefer not to say"],
      controllerKey: 'pronouns',
    );
  }

  void _showGenderPicker() {
    _showOptions(
      title: "Select Gender",
      options: [
        "Man",
        "Woman",
        "Non-binary",
        "Transgender",
        "Prefer not to say",
      ],
      controllerKey: 'gender',
    );
  }

  void _showOrientationPicker() {
    _showOptions(
      title: "Select Orientation",
      options: [
        "Straight",
        "Gay",
        "Lesbian",
        "Bisexual",
        "Pansexual",
        "Asexual",
        "Queer",
        "Questioning",
        "Prefer not to say",
      ],
      controllerKey: 'orientation',
    );
  }

  void _showRelationshipTypePicker() {
    _showOptions(
      title: "Select Relationship Type",
      options: [
        "Monogamous",
        "Polyamorous",
        "Open relationship",
        "Casual",
        "Friends with benefits",
        "It's complicated",
        "Single",
      ],
      controllerKey: 'relationshipType',
    );
  }

  void _showLanguagesPicker() {
    _showOptions(
      title: "Languages I know",
      options: [
        "English",
        "Hindi",
        "Punjabi",
        "Spanish",
        "French",
        "German",
        "Chinese",
        "Japanese",
        "Portuguese",
        "Russian",
        "Arabic",
        "Bengali",
        "Urdu",
        "Italian",
        "Korean",
      ],
      controllerKey: 'languages',
    );
  }

  void _showZodiacPicker() {
    _showOptions(
      title: "Zodiac Sign",
      options: [
        "Aries",
        "Taurus",
        "Gemini",
        "Cancer",
        "Leo",
        "Virgo",
        "Libra",
        "Scorpio",
        "Sagittarius",
        "Capricorn",
        "Aquarius",
        "Pisces",
      ],
      controllerKey: 'zodiac',
    );
  }

  void _showEducationPicker() {
    _showOptions(
      title: "Education",
      options: [
        "High School",
        "Some College",
        "Associate Degree",
        "Bachelor's Degree",
        "Master's Degree",
        "PhD",
        "Professional Degree",
        "Trade School",
        "GED",
        "No Formal Education",
      ],
      controllerKey: 'education',
    );
  }

  void _showPetsPicker() {
    _showOptions(
      title: "Pets",
      options: [
        "Dog",
        "Cat",
        "Bird",
        "Fish",
        "Reptile",
        "None",
        "Allergic",
        "Want pets",
        "Have pets",
      ],
      controllerKey: 'pets',
    );
  }

  void _showDrinkingPicker() {
    _showOptions(
      title: "Drinking",
      options: ["Not for me", "Socially", "Regularly", "Sober", "Occasionally"],
      controllerKey: 'drinking',
    );
  }

  void _showSmokingPicker() {
    _showOptions(
      title: "Smoking",
      options: [
        "Non-smoker",
        "Smoker",
        "Social smoker",
        "Trying to quit",
        "Vape",
      ],
      controllerKey: 'smoking',
    );
  }

  void _showWorkoutPicker() {
    _showOptions(
      title: "Workout",
      options: [
        "Never",
        "Sometimes",
        "Regularly",
        "Every day",
        "Athlete",
        "3 times a week",
      ],
      controllerKey: 'workout',
    );
  }

  void _showFamilyPlansPicker() {
    _showOptions(
      title: "Family Plans",
      options: [
        "Want someday",
        "Want soon",
        "Don't want",
        "Have kids",
        "Not sure",
        "Open to kids",
      ],
      controllerKey: 'familyPlans',
    );
  }

  void _showCommunicationPicker() {
    _showOptions(
      title: "Communication Style",
      options: [
        "Better in person",
        "Great texter",
        "Phone calls",
        "Video chats",
        "Slow responder",
        "Open and honest",
      ],
      controllerKey: 'communication',
    );
  }

  void _showLoveStylePicker() {
    _showOptions(
      title: "Love Style",
      options: [
        "Thoughtful gestures",
        "Quality time",
        "Words of affirmation",
        "Acts of service",
        "Physical touch",
        "Gift giving",
      ],
      controllerKey: 'loveStyle',
    );
  }

  void _showSocialMediaPicker() {
    _showOptions(
      title: "Social Media",
      options: [
        "Instagram",
        "Twitter",
        "Facebook",
        "LinkedIn",
        "TikTok",
        "Not active",
        "Snapchat",
        "WhatsApp",
      ],
      controllerKey: 'socialMedia',
    );
  }

  // --- Interests Selection ---
  void _openInterestsSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Interests ${_selectedInterests.length}/10",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              if (_selectedInterests.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedInterests.map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: Colors.pink.withOpacity(0.1),
                        labelStyle: const TextStyle(color: Colors.pink),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setModalState(
                            () => _selectedInterests.remove(interest),
                          );
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
              ],

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _allInterests.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: entry.value.map((item) {
                              final bool isSelected = _selectedInterests
                                  .contains(item);
                              return ChoiceChip(
                                label: Text(item),
                                selected: isSelected,
                                onSelected: (val) {
                                  setModalState(() {
                                    if (val && _selectedInterests.length < 10) {
                                      _selectedInterests.add(item);
                                    } else {
                                      _selectedInterests.remove(item);
                                    }
                                  });
                                  setState(() {});
                                },
                                selectedColor: Colors.pink.withOpacity(0.1),
                                backgroundColor: Colors.grey.shade100,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.pink
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.pink
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
              child: Column(
                children: [

                  AddPhotoList(),
                  // -------- Interests ----------
                  _buildSectionHeader("Interests", "+5%"),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: _openInterestsSelection,
                      leading: Icon(
                        Iconsax.heart,
                        size: 22,
                        color: Colors.grey[700],
                      ),
                      title: const Text(
                        "Interests",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: _selectedInterests.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                _selectedInterests.join(", "),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Add interests",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "${_selectedInterests.length}/10",
                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------- Gender & Orientation ----------
                  _buildSectionHeader("Gender & Orientation", "REQUIRED"),
                  _buildActionTile(
                    Iconsax.profile_2user,
                    "Gender",
                    _controllers['gender']?.text ?? "",
                    _showGenderPicker,
                  ),
                  _buildActionTile(
                    Iconsax.heart,
                    "Sexual Orientation",
                    _controllers['orientation']?.text ?? "",
                    _showOrientationPicker,
                  ),

                  // -------- Relationship ----------
                  _buildSectionHeader("Relationship", ""),
                  _buildActionTile(
                    Iconsax.eye,
                    "Looking for",
                    _controllers['relationshipGoal']?.text ?? "",
                    () => _showOptions(
                      title: "Looking for",
                      options: [
                        "New friends",
                        "Long-term",
                        "Short-term",
                        "Still figuring it out",
                      ],
                      controllerKey: 'relationshipGoal',
                    ),
                  ),
                  _buildActionTile(
                    Iconsax.lovely,
                    "Relationship Type",
                    _controllers['relationshipType']?.text ?? "",
                    _showRelationshipTypePicker,
                  ),

                  // -------- Basics ----------
                  _buildSectionHeader("Basics", ""),
                  _buildActionTile(
                    Iconsax.user,
                    "Pronouns",
                    _controllers['pronouns']?.text ?? "",
                    _showPronounsPicker,
                  ),
                  _buildActionTile(
                    Iconsax.ruler,
                    "Height",
                    _controllers['height']?.text ?? "",
                    _showHeightPicker,
                  ),
                  _buildActionTile(
                    Iconsax.language_circle,
                    "Languages I know",
                    _controllers['languages']?.text ?? "",
                    _showLanguagesPicker,
                  ),

                  // -------- More about me ----------
                  _buildSectionHeader("More about me", ""),
                  _buildActionTile(
                    Iconsax.moon,
                    "Zodiac",
                    _controllers['zodiac']?.text ?? "",
                    _showZodiacPicker,
                  ),
                  _buildActionTile(
                    Iconsax.teacher,
                    "Education",
                    _controllers['education']?.text ?? "",
                    _showEducationPicker,
                  ),
                  _buildActionTile(
                    Iconsax.pet,
                    "Pets",
                    _controllers['pets']?.text ?? "",
                    _showPetsPicker,
                  ),

                  // -------- Lifestyle ----------
                  _buildSectionHeader("Lifestyle", ""),
                  _buildActionTile(
                    Iconsax.glass,
                    "Drinking",
                    _controllers['drinking']?.text ?? "",
                    _showDrinkingPicker,
                  ),
                  _buildActionTile(
                    Iconsax.mask,
                    "Smoking",
                    _controllers['smoking']?.text ?? "",
                    _showSmokingPicker,
                  ),
                  _buildActionTile(
                    Iconsax.directbox_receive,
                    "Workout",
                    _controllers['workout']?.text ?? "",
                    _showWorkoutPicker,
                  ),

                  // -------- College/Uni ----------
                  _buildSectionHeader("College/Uni", "+4%"),
                  _buildInputTile("Add college", _controllers['college']!),

                  // -------- Job Title ----------
                  _buildSectionHeader("Job title", "IMPORTANT"),
                  _buildInputTile("Add job title", _controllers['jobTitle']!),

                  // -------- Company ----------
                  _buildSectionHeader("Company", ""),
                  _buildInputTile("Add company", _controllers['company']!),

                  // -------- City ----------
                  _buildSectionHeader("City", ""),
                  _buildInputTile("Add city", _controllers['city']!),

                  // -------- Additional Info ----------
                  _buildSectionHeader("Additional Info", ""),
                  _buildActionTile(
                    Iconsax.status_up,
                    "Family Plans",
                    _controllers['familyPlans']?.text ?? "",
                    _showFamilyPlansPicker,
                  ),
                  _buildActionTile(
                    Iconsax.message,
                    "Communication Style",
                    _controllers['communication']?.text ?? "",
                    _showCommunicationPicker,
                  ),
                  _buildActionTile(
                    Iconsax.lovely,
                    "Love Style",
                    _controllers['loveStyle']?.text ?? "",
                    _showLoveStylePicker,
                  ),
                  _buildActionTile(
                    Iconsax.global,
                    "Social Media",
                    _controllers['socialMedia']?.text ?? "",
                    _showSocialMediaPicker,
                  ),

                  // -------- Privacy Settings ----------
                  _buildSectionHeader("Control Your Profile", "Plus"),
                  _buildSwitchTile(
                    "Don't show my age",
                    _hideAge,
                    (v) => setState(() => _hideAge = v),
                  ),
                  _buildSwitchTile(
                    "Don't show my distance",
                    _hideDistance,
                    (v) => setState(() => _hideDistance = v),
                  ),

                  // -------- Debug Info (only in development) ----------
                  // if (const bool.fromEnvironment('dart.vm.product') == false)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Text(
                  //           "Debug Info:",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.red,
                  //           ),
                  //         ),
                  //         Text("Base URL: $base"),
                  //         Text(
                  //           "Selected Interests: ${_selectedInterests.length}",
                  //         ),
                  //         Text("Hide Age: $_hideAge"),
                  //         Text("Hide Distance: $_hideDistance"),
                  //       ],
                  //     ),
                  //   ),

                  // -------- Save Button ----------
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.pink)
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _saveProfile,
                              child: const Text(
                                "SAVE CHANGES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  // --- UI Helper Widgets ---
  Widget _buildSectionHeader(String title, String badge) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badge == "REQUIRED"
                    ? Colors.red.withOpacity(0.1)
                    : Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badge == "REQUIRED" ? Colors.red : Colors.pink,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: value.trim().isNotEmpty
            ? Text(
                value,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              )
            : Text(
                "Add $title",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }

  Widget _buildInputTile(String hint, TextEditingController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 15),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        activeColor: Colors.pink,
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
