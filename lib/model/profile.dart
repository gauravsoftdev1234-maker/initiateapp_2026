class GirlProfile {
  final String name;
  final int age;
  final String location;
  final String imageUrl;

  GirlProfile({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
  });
}

final List<GirlProfile> indianGirls = [
  GirlProfile(
    name: "Ananya",
    age: 23,
    location: "Mumbai",
    imageUrl:
    "https://images.unsplash.com/photo-1589156229687-496a31ad1d1f?q=80&w=500",
  ),
  GirlProfile(
    name: "Ishani",
    age: 24,
    location: "Bangalore",
    imageUrl:
    "https://images.unsplash.com/photo-1614283233556-f35b0c801ef1?q=80&w=500",
  ),
  GirlProfile(
    name: "Aditi",
    age: 22,
    location: "Pune",
    imageUrl:
    "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=500",
  ),
  GirlProfile(
    name: "Sanya",
    age: 25,
    location: "Chandigarh",
    imageUrl:
    "https://images.unsplash.com/photo-1503104834685-7205e8607eb9?q=80&w=500",
  ),
  GirlProfile(
    name: "Mehak",
    age: 20,
    location: "Jaipur",
    imageUrl:
    "https://images.unsplash.com/photo-1533227268408-a774695d9ae9?q=80&w=500",
  ),
  GirlProfile(
    name: "Riya",
    age: 23,
    location: "Hyderabad",
    imageUrl:
    "https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=500",
  ),
  GirlProfile(
    name: "Kavya",
    age: 22,
    location: "Chennai",
    imageUrl:
    "https://images.unsplash.com/photo-1512316609839-ce289d3eba0a?q=80&w=500",
  ),
  GirlProfile(
    name: "Sneha",
    age: 24,
    location: "Kolkata",
    imageUrl:
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=500",
  ),
  GirlProfile(
    name: "Tanya",
    age: 21,
    location: "Lucknow",
    imageUrl:
    "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?q=80&w=500",
  ),
];

// class DiscoveryUser {
//   final int userId;
//   final String fullName;
//   final String gender;
//   final int age;
//   final String city;
//   final String bio;
//   final String profilePic;
//   final double distance;
//   final String jobTitle;
//   final String university;
//   final List<String> galleryImages;
//
//   DiscoveryUser({
//     required this.userId,
//     required this.fullName,
//     required this.gender,
//     required this.age,
//     required this.city,
//     required this.bio,
//     required this.profilePic,
//     required this.distance,
//     required this.jobTitle,
//     required this.university,
//     required this.galleryImages,
//   });
//
//   factory DiscoveryUser.fromJson(Map<String, dynamic> json) {
//     return DiscoveryUser(
//       userId: json['UserId'] ?? 0,
//       fullName: json['FullName'] ?? 'Unknown',
//       gender: json['Gender'] ?? '',
//       age: json['Age'] ?? 0,
//       city: json['City'] ?? 'Location Private',
//       bio: json['Bio'] == "" ? "No bio available." : json['Bio'],
//       profilePic: (json['ProfilePic'] != null && json['ProfilePic'] != "")
//           ? json['ProfilePic']
//           : "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1000", // Default Avatar
//       distance: (json['DistanceKm'] as num?)?.toDouble() ?? 0.0,
//       jobTitle: json['job_title'] == "" ? "Member" : json['job_title'],
//       university: json['university'] == "" ? "Education Private" : json['university'],
//       galleryImages: json['gallery_images'] != null
//           ? List<String>.from(json['gallery_images'].where((img) => img != "[null]" && img != null))
//           : [],
//     );
//   }
// }
class DiscoveryUser {
  final int userId;
  final String fullName;
  final String gender;
  final int age;
  final String city;
  final String bio;
  final double heightCm;
  final String lookingFor;
  final String profilePic;
  final double distance;
  final String smoking;
  final String drinking;
  final String zodiac;
  final String education;
  final String university;
  final String jobTitle;
  final String company;
  final String sexualOrientation;
  final String workout;
  final List<dynamic> galleryImages;

  DiscoveryUser({
    required this.userId,
    required this.fullName,
    required this.gender,
    required this.age,
    required this.city,
    required this.bio,
    required this.heightCm,
    required this.lookingFor,
    required this.profilePic,
    required this.distance,
    required this.smoking,
    required this.drinking,
    required this.zodiac,
    required this.education,
    required this.university,
    required this.jobTitle,
    required this.company,
    required this.sexualOrientation,
    required this.workout,
    required this.galleryImages,
  });

  factory DiscoveryUser.fromJson(Map<String, dynamic> json) {
    return DiscoveryUser(
      userId: json['UserId'] ?? 0,
      fullName: json['FullName'] ?? '',
      gender: json['Gender'] ?? '',
      age: json['Age'] ?? 0,
      city: json['City'] ?? '',
      bio: json['Bio'] ?? '',
      heightCm: (json['HeightCm'] ?? 0).toDouble(),
      lookingFor: json['LookingFor'] ?? '',
      profilePic: json['ProfilePic'] ?? '',
      distance: (json['DistanceKm'] ?? 0).toDouble(),
      smoking: json['smoking'] ?? '',
      drinking: json['drinking'] ?? '',
      zodiac: json['zodiac'] ?? '',
      education: json['education'] ?? '',
      university: json['university'] ?? '',
      jobTitle: json['job_title'] ?? '',
      company: json['company'] ?? '',
      sexualOrientation: json['sexual_orientation'] ?? '',
      workout: json['workout'] ?? '',
      galleryImages: json['gallery_images'] ?? [],
    );
  }
}