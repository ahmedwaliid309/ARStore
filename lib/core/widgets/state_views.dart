import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:decora/core/theme/app_colors.dart';

/// حالات الشاشة الثلاثة المشتركة (تحميل / خطأ / فاضي).
/// كل شاشة لازم تعرضهم، فاستخدموا دول بدل ما كل واحد يكتب نسخته:
///   const LoadingView()
///   ErrorView(message: 'تعذر تحميل المنتجات', onRetry: _load)
///   EmptyView(icon: Icons.favorite_border, title: 'المفضلة فاضية',
///             actionLabel: 'تصفح المنتجات', onAction: () => context.go(AppRoutes.home))
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.primary));
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message = 'حصل خطأ، حاول تاني', this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => _Centered(
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        title: message,
        actionLabel: onRetry == null ? null : 'إعادة المحاولة',
        onAction: onRetry,
      );
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => _Centered(
        icon: icon,
        iconColor: AppColors.textSecondary,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );
}

class _Centered extends StatelessWidget {
  const _Centered({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.sp, color: iconColor),
            SizedBox(height: 12.h),
            Text(title, textAlign: TextAlign.center, style: text.titleMedium),
            if (subtitle != null) ...[
              SizedBox(height: 6.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 20.h),
              SizedBox(
                width: 200.w,
                child: ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
