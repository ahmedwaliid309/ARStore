import 'package:decora/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/theme/app_theme.dart';
import 'package:decora/data/mock_products.dart';
import 'package:decora/data/models/product.dart';
import 'package:provider/provider.dart';
import 'package:decora/providers/favorites_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/features/products/widgets/products_filter_sheet.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
    this.category,
  });

  final String? category;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<String> categories = [
    'All',
    'Sofas',
    'Beds',
    'Tables',
    'Chairs',
  ];
  String selectedCategory = 'All';
  FilterOptions? appliedFilters;
  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductsFilterSheet(
        productCount: MockProducts.all.length,
        categories: [
          'All',
          'Sofas',
          'Beds',
          'Tables',
          'Chairs',
          'Lighting',
        ],
      ),
    );

    if (result != null) {
      setState(() {
        appliedFilters = result;
      });
    }
  }
  final TextEditingController searchController =
  TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = MockProducts.all;
    final favoritesProvider = context.watch<FavoritesProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 14.h),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.maybePop(context),
                  ),

                  Expanded(
                    child: Text(
                      'Shop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _circleButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: () {
                          context.go(AppRoutes.cart);
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 11.w,
                          height: 11.w,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        prefixIcon:  IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.search,
                                            size: 20.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        hintText: 'Search furniture',
                                        hintStyle: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 14.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 9.w),

                          // Filter Button
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(9.r),
                            ),
                            child: IconButton(
                              onPressed: _openFilters,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.tune,
                                color: AppColors.surface,
                                size: 19.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Categories
                    SizedBox(
                      height: 27.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: 7.w),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected =
                              selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                              alignment: Alignment.center,
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
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.surface
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 17.h),

                    // Section Header
                    ListTile(
                      title: Text(
                        'Featured',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${products.length} Pieces',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Products Grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return ProductCard(
                            product: product,
                            isFavorite: favoritesProvider.isFavorite(product.id),

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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 16.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}