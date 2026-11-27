import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/providers/auth_provider.dart';
import 'package:decora/providers/favorites_provider.dart';
import 'package:decora/providers/orders_provider.dart';

/// شاشة Profile. الاسم والإيميل من AuthProvider، والأعداد من Providers الموجودة.
/// الأجزاء اللي لسه مفيش لها Route أو مصدر بيانات (UI بس) بتعرض "Coming soon".
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ───────── Actions ─────────

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  /// الرجوع: لو مفيش شاشة قبلها نروح Home (لأن Profile تاب أساسي).
  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  /// Here we sign out then go to the Auth screen.
  void _logout(BuildContext context) {
    context.read<AuthProvider>().signOut();
    context.go(AppRoutes.auth);
  }

  /// الحروف الأولى من الاسم (AW). لو الاسم كلمة واحدة بنعرض حرف واحد.
  String _initials(String name) {
    final parts =
    name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  // ───────── Build ─────────

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // حالة: مش مسجّل دخول.
    if (!auth.isLoggedIn) {
      return Scaffold(
        body: SafeArea(
          child: EmptyView(
            icon: Icons.person_outline,
            title: 'You are not logged in',
            subtitle: 'Login to see your profile',
            actionLabel: 'Login',
            onAction: () => context.go(AppRoutes.auth),
          ),
        ),
      );
    }

    final ordersCount = context.watch<OrdersProvider>().orders.length;
    final savedCount = context.watch<FavoritesProvider>().items.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, auth),
              SizedBox(height: 20.h),
              _buildStats(ordersCount, savedCount),
              SizedBox(height: 16.h),
              _buildMenu(context),
              SizedBox(height: 16.h),
              _buildLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── Sections ─────────

  /// الشريط العلوي + الأفاتار + الاسم والإيميل.
  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleButton(Icons.chevron_left, () => _back(context)),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 24.sp,
                height: 29 / 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            // UI بس: Edit Profile مش مطلوب دلوقتي.
            _circleButton(Icons.edit_outlined, () => _comingSoon(context)),
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          width: 84.r,
          height: 84.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            _initials(auth.userName),
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimary,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          auth.userName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            height: 29 / 24,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          auth.email,
          style: TextStyle(
            fontSize: 14.sp,
            height: 17 / 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46.r,
          height: 46.r,
          child: Icon(icon, size: 23.sp, color: AppColors.primary),
        ),
      ),
    );
  }

  /// كارت الإحصائيات (Orders / Saved / AR shots).
  Widget _buildStats(int orders, int saved) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stat('$orders', 'Orders'),
          _statDivider(),
          _stat('$saved', 'Saved'),
          _statDivider(),
          // TODO(اللوجيك): AR shots مفيش لها مصدر بيانات لسه، قيمة مؤقتة.
          _stat('0', 'AR shots'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            height: 29 / 24,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            height: 15 / 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _statDivider() =>
      Container(width: 1, height: 44.h, color: AppColors.border);

  /// كارت القايمة (My orders / My AR shots / Settings / Help & support).
  Widget _buildMenu(BuildContext context) {
    final rows = <Widget>[
      _menuRow(
        icon: Icons.inventory_2_outlined,
        label: 'My orders',
        onTap: () => context.push(AppRoutes.orders),
      ),
      _menuRow(
        icon: Icons.photo_camera_outlined,
        label: 'My AR shots',
        onTap: () => context.push(AppRoutes.arShots),
      ),
      _menuRow(
        icon: Icons.settings_outlined,
        label: 'Settings',
        onTap: () => context.push(AppRoutes.settings),
      ),
      _menuRow(
        icon: Icons.help_outline,
        label: 'Help & support',
        onTap: () => _comingSoon(context),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) ...[
              SizedBox(height: 10.h),
              Container(height: 1, color: AppColors.border),
              SizedBox(height: 10.h),
            ],
          ],
        ],
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 40.h,
        child: Row(
          children: [
            _iconCircle(icon, AppColors.primary),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 19 / 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 24.sp, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  /// دايرة الأيقونة (40×40) بلون فاتح من نفس لون الأيقونة.
  Widget _iconCircle(IconData icon, Color color) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 23.sp, color: color),
    );
  }

  /// كارت تسجيل الخروج.
  Widget _buildLogout(BuildContext context) {
    return InkWell(
      onTap: () => _logout(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            _iconCircle(Icons.logout, AppColors.error),
            SizedBox(width: 16.w),
            Text(
              'Log out',
              style: TextStyle(
                fontSize: 16.sp,
                height: 19 / 16,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.surface,
    border: Border.all(color: AppColors.border, width: 0.5),
    borderRadius: BorderRadius.circular(20.r),
  );
}
