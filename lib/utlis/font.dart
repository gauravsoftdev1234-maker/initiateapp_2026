// constants/text_styles.dart
import 'dart:ui';

import 'AppColors.dart';

class AppTextStyles {
  static final TextStyle displayLarge = TextStyle(
    fontFamily: 'Lufga',
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static final TextStyle headlineSemiBold = TextStyle(
    fontFamily: 'Lufga',
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static final TextStyle titleSemiBold = TextStyle(
    fontFamily: 'Lufga',
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static final TextStyle bodyRegular = TextStyle(
    fontFamily: 'Lufga',
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static final TextStyle captionRegular = TextStyle(
    fontFamily: 'Lufga',
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );
}