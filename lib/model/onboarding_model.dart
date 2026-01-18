import 'package:flutter/material.dart';
// DATA MODEL
// ------------------------------------------------------------------
class OnboardingContent {
  final String title;
  final String description;
  final String? imagePath; // Changed from imageUrl to imagePath for local assets
  final IconData iconPlaceholder; // Keep as fallback

  OnboardingContent({
    required this.title,
    required this.description,
    this.imagePath,
    required this.iconPlaceholder,
  });
}