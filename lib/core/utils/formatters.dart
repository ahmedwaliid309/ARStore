import 'package:flutter/material.dart';

/// دوال مشتركة للسعر والتاريخ واللون. استخدموها بدل ما كل شاشة تكتب نسختها.
///   Formatters.price(12500)   // 12,500 EGP
///   Formatters.date(order.createdAt)
///   '#2F5D50'.toColor()       // لتحويل ألوان Product.colors
class Formatters {
  Formatters._();

  static String price(double value) {
    final digits = value.round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '$buf EGP ';
  }

  static String date(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

extension HexColorX on String {
  /// '#9AA0A6' أو '9AA0A6' ← Color (رمادي لو القيمة غلط)
  Color toColor() {
    var h = replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    return Color(int.tryParse(h, radix: 16) ?? 0xFF9E9E9E);
  }
}
