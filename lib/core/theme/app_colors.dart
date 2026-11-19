import 'package:flutter/material.dart';

/// كل ألوان التطبيق هنا. ممنوع كتابة لون يدوي داخل الشاشات.
/// الألوان من هوية Decora: كريمي #F3EFE8 / زيتي غامق #17453C / أخضر فاتح #527C66.
/// ⚠️ راجعوا القيم الباقية (النص، الحدود، الخطأ) مع Dev Mode في Figma.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF17453C); // زيتي غامق
  static const Color secondary = Color(0xFF527C66); // أخضر فاتح
  static const Color accent = Color(0xFF527C66); // (نفس secondary، محفوظ للتوافق)
  static const Color background = Color(0xFFF3EFE8); // كريمي
  static const Color surface = Color(0xFFFFFFFF);
  static const Color chip = Color(0xFFE4EBE5); // خلفية خفيفة مائلة للأخضر
  static const Color border = Color(0xFFE2DCCF);
  static const Color textPrimary = Color(0xFF12211D);
  static const Color textSecondary = Color(0xFF7B8780);
  static const Color onPrimary = Color(0xFFF3EFE8);
  static const Color success = Color(0xFF2E7D4F);
  static const Color error = Color(0xFFC8553D);
}
