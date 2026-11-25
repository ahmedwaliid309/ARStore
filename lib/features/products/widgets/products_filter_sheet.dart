import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/theme/app_theme.dart';

class FilterOptions {
  final double minPrice;
  final double maxPrice;
  final Set<String> categories;
  final Set<String> colors;

  const FilterOptions({
    required this.minPrice,
    required this.maxPrice,
    required this.categories,
    required this.colors,
  });
}

class ProductsFilterSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final int productCount;
  final List<String> categories;

  const ProductsFilterSheet({
    super.key,
    this.minPrice = 1000,
    this.maxPrice = 19000,
    required this.productCount,
    required this.categories,
  });

  @override
  State<ProductsFilterSheet> createState() =>
      _ProductsFilterSheetState();
}

class _ProductsFilterSheetState extends State<ProductsFilterSheet> {
  late RangeValues priceRange;

  final Set<String> selectedCategories = {'All'};
  final Set<String> selectedColors = {};

  final Map<String, Color> availableColors = {
    'Beige': const Color(0xFFD8C5A5),
    'Green': const Color(0xFF71836D),
    'Brown': const Color(0xFF9B5945),
    'Black': const Color(0xFF252525),
    'White': const Color(0xFFECEAE3),
  };

  @override
  void initState() {
    super.initState();

    priceRange = RangeValues(
      widget.minPrice,
      widget.maxPrice,
    );
  }

  void toggleCategory(String category) {
    setState(() {
      if (category == 'All') {
        selectedCategories
          ..clear()
          ..add('All');
        return;
      }

      selectedCategories.remove('All');

      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }

      if (selectedCategories.isEmpty) {
        selectedCategories.add('All');
      }
    });
  }

  void resetFilters() {
    setState(() {
      priceRange = RangeValues(
        widget.minPrice,
        widget.maxPrice,
      );

      selectedCategories
        ..clear()
        ..add('All');

      selectedColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // Price Range
            _sectionTitle('Price range'),

            SizedBox(height: 8.h),

            RangeSlider(
              values: priceRange,
              min: widget.minPrice,
              max: widget.maxPrice,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.border,
              onChanged: (values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _priceText(priceRange.start),
                _priceText(priceRange.end),
              ],
            ),

            SizedBox(height: 22.h),

            // Categories
            _sectionTitle('Categories'),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 7.w,
              runSpacing: 8.h,
              children: widget.categories.map((category) {
                final isSelected =
                selectedCategories.contains(category);

                return GestureDetector(
                  onTap: () => toggleCategory(category),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 25.h),

            // Available Colors
            _sectionTitle('Available colors'),

            SizedBox(height: 13.h),

            Wrap(
              spacing: 12.w,
              children: availableColors.entries.map((entry) {
                final isSelected =
                selectedColors.contains(entry.key);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedColors.remove(entry.key);
                      } else {
                        selectedColors.add(entry.key);
                      }
                    });
                  },
                  child: Container(
                    width: 29.w,
                    height: 29.w,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30.h),

            // Reset and Apply
            Row(
              children: [
                SizedBox(width: 8.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          FilterOptions(
                            minPrice: priceRange.start,
                            maxPrice: priceRange.end,
                            categories: Set.from(selectedCategories),
                            colors: Set.from(selectedColors),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                      ),
                      child: Text(
                        'Show ${widget.productCount} products',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _priceText(double price) {
    return Text(
      '${price.toStringAsFixed(0)} EGP',
      style: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 14.sp,
        color: AppColors.textSecondary,
      ),
    );
  }
}