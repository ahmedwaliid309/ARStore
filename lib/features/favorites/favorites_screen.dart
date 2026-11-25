import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/theme/app_theme.dart';
import 'package:decora/core/widgets/product_card.dart';
import 'package:decora/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Sofas',
    'Beds',
    'Tables',
    'Chairs',
  ];

  List<Product> _filterProducts(List<Product> favorites) {
    if (selectedCategory == 'All') {
      return favorites;
    }

    return favorites.where((product) {
      return product.category.toLowerCase() ==
          selectedCategory.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();

    final products = _filterProducts(favoritesProvider.items);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildCategories(),
            SizedBox(height: 20.h),
            Expanded(
              child: products.isEmpty
                  ? _buildEmptyState()
                  : _buildProductsGrid(products),
            ),
          ],
        ),
      ),
    );
  }

// Header
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          _buildHeaderButton(
            icon: Icons.chevron_left,
            onTap: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: Text(
              'Favorites',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          _buildHeaderButton(
            icon: Icons.search,
            onTap: () {
// Search navigation will be connected later.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: AppColors.secondary,
        ),
      ),
    );
  }

// Categories
  Widget _buildCategories() {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Products Grid
  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(
          product: product,
          isFavorite: true,
          onTap: () {
            context.push(
              AppRoutes.productPath(product.id),
            );
          },
          onFavoriteTap: () {
            context.read<FavoritesProvider>().toggle(product);
          },
        );
      },
    );
  }

// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 55.sp,
            color: AppColors.secondary,
          ),
          SizedBox(height: 12.h),
          Text(
            'No products found',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
