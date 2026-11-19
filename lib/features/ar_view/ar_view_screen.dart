// ══════════════════════════════════════════════════════════
//  الشاشة    : AR View (الواقع المعزز (مؤجل))
//  المسؤول   : أحمد وليد
//  الـ Branch  : feature/ar-view
//  الملف     : lib/features/ar_view/ar_view_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - ⏸ مؤجل لحد ما نخلص باقي التطبيق
//    - تجربة model_viewer_plus و ar_flutter_plugin على موبايل حقيقي
//    - المجسمات .glb في assets/models (كل واحد أقل من 5MB)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class ArViewScreen extends StatelessWidget {
  const ArViewScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'AR View',
      owner: 'أحمد وليد',
      branch: 'feature/ar-view',
      tasks: const [
        '⏸ مؤجل لحد ما نخلص باقي التطبيق',
        'تجربة model_viewer_plus و ar_flutter_plugin على موبايل حقيقي',
        'المجسمات .glb في assets/models (كل واحد أقل من 5MB)',
      ],
      actions: [

      ],
    );
  }
}
