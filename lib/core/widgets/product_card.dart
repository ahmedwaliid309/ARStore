import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/theme/app_theme.dart';
import 'package:decora/core/utils/formatters.dart';
import 'package:decora/data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _image(),

                  // Favorite Button
                  PositionedDirectional(
                    top: 6.h,
                    end: 6.w,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onFavoriteTap,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 17.sp,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  // AR Badge
                  PositionedDirectional(
                    bottom: 6.h,
                    start: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Icon(
                              Icons.view_in_ar,
                              size: 14.sp,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'AR',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary,

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Information
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
                vertical: 6.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Category
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Price
                  Text(
                    Formatters.price(product.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final placeholder = Container(
      color: AppColors.chip,
      child: Icon(
        Icons.chair_outlined,
        size: 40.sp,
        color: AppColors.textSecondary,
      ),
    );

    if (product.images.isEmpty) return placeholder;

    final src = product.images.first;

    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      );
    }

    return Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}