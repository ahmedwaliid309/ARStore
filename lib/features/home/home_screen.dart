import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/theme/app_theme.dart';
import 'package:decora/core/utils/formatters.dart';
import 'package:decora/data/mock_products.dart';
import 'package:decora/data/models/product.dart';
import 'package:decora/features/products/widgets/products_filter_sheet.dart';
import 'package:decora/providers/auth_provider.dart';
import 'package:decora/providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // التصنيفات اللي فوق (الأول "All" بيفضل في الهوم، الباقي بيفتح Products بالتصنيف)
  static const _categories = ['All', 'Sofas', 'Beds', 'Tables', 'Chairs', 'Lighting'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthProvider>().userName;
    final favorites = context.watch<FavoritesProvider>();

    // الداتا من MockProducts بدل الكروت الثابتة
    final featured = MockProducts.all.take(4).toList();
    final bestSellers = MockProducts.all.skip(4).take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(userName), // الاسم والايقونات
              SizedBox(height: 5.h),
              _searchRow(), // البحث + الفلتر
              SizedBox(height: 10.h),
              _banner(), // الصورة الكبيرة
              _categoryChips(), // زراير التقليب
              SizedBox(height: 20.h),
              _sectionHeader('Featured', onSeeAll: () => context.push(AppRoutes.products)),
              _productsRow(featured, favorites),
              SizedBox(height: 20.h),
              _curatedBanner(),
              SizedBox(height: 20.h),
              _sectionHeader('Best sellers', onSeeAll: () => context.push(AppRoutes.products)),
              _productsRow(bestSellers, favorites),
              SizedBox(height: 20.h),
              _sectionHeader('Recommended for you'),
              _recommended(),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Header ─────────────────────────
  Widget _header(String userName) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOOD MORNING',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary.withValues(alpha: .5),
                ),
              ),
              Text(
                userName.isEmpty ? 'Guest' : userName,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // الجرس: مفيش شاشة إشعارات في الـ Router لسه
              _circleIcon(Icons.notifications_none_outlined, () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  );
              }),
              SizedBox(width: 10.w),
              // السلة: تاب السلة
              _circleIcon(
                Icons.shopping_cart_outlined,
                    () => context.go(AppRoutes.cart),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.w,
        width: 50.w,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 24.sp),
      ),
    );
  }

  // ───────────────────────── Search + Filter ─────────────────────────
  Widget _searchRow() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search sofas, beds, lamps...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _openFilters,
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(Icons.tune, color: AppColors.surface, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  // نفس الـ ProductsFilterSheet المستخدم في Products (بدل النسخة المكررة)
  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductsFilterSheet(
        productCount: MockProducts.all.length,
        categories: _categories,
      ),
    );

    if (result == null || !mounted) return;

    // لو اختار تصنيف واحد بس نفتح Products بيه، غير كدا نفتح Products كلها
    final picked = result.categories.where((c) => c != 'All').toList();
    context.push(
      AppRoutes.products,
      extra: picked.length == 1 ? picked.first : null,
    );
  }

  // ───────────────────────── Banner ─────────────────────────
  Widget _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 12.h),
      child: Stack(
        children: [
          Image.asset('assets/images/banarrr.png'),
          // منطقة ضغط شفافة فوق كلمة "Open AR" في الصورة (بالنسبة لحجم الصورة
          // عشان تفضل في مكانها على أي شاشة). بتفتح صفحة ar_view
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, c) => Stack(
                children: [
                  Positioned(
                    left: c.maxWidth * 0.04,
                    top: c.maxHeight * 0.57,
                    width: c.maxWidth * 0.34,
                    height: c.maxHeight * 0.24,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push(
                        AppRoutes.arPath(MockProducts.all.first.id),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Category chips ─────────────────────────
  Widget _categoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          for (var i = 0; i < _categories.length; i++)
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = i);
                  if (i != 0) {
                    context.push(AppRoutes.products, extra: _categories[i]);
                  }
                },
                child: Container(
                  height: 45.h,
                  width: 70.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == i ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _categories[i],
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: selectedIndex == i
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ───────────────────────── Sections ─────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary.withValues(alpha: .8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _productsRow(List<Product> products, FavoritesProvider favorites) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(11.w, 10.h, 0, 0),
      child: Row(
        children: [
          for (final p in products)
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: SizedBox(
                width: 160.w,
                height: 220.h,
                child: _HomeProductCard(
                  product: p,
                  isFavorite: favorites.isFavorite(p.id),
                  onTap: () => context.push(AppRoutes.productPath(p.id)),
                  onFavoriteTap: () => context.read<FavoritesProvider>().toggle(p),
                  onArTap: () => context.push(AppRoutes.arPath(p.id)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _curatedBanner() {
    return Container(
      height: 170.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CURATED FOR YOU',
                    style: TextStyle(
                      color: AppColors.onPrimary.withValues(alpha: .6),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Soft modern,\nnaturally yours',
                    style: TextStyle(color: AppColors.onPrimary, fontSize: 20.sp),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.products),
                    child: Text(
                      'Shop the look',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/Image (Modern living room).png',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Recommended ─────────────────────────
  Widget _recommended() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          _recommendedTile(
            id: '4',
            image: 'assets/images/green chair.png',
            name: 'Noma Lounge Chair',
            price: 'EGP 6,900',
          ),
          Divider(height: 32.h),
          _recommendedTile(
            id: '15',
            image: 'assets/images/Generated Image.png',
            name: 'Sora Reading Chair',
            price: 'EGP 18,500',
          ),
          Divider(height: 32.h),
          _recommendedTile(
            id: '17',
            image: 'assets/images/white chair.png',
            name: 'Elara Accent Chair',
            price: 'EGP 6,900',
          ),
        ],
      ),
    );
  }

  Widget _recommendedTile({
    required String id,
    required String image,
    required String name,
    required String price,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(AppRoutes.productPath(id)),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.asset(image),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complements your style',
                  style: TextStyle(color: AppColors.success, fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                Text(name, style: TextStyle(fontSize: 18.sp)),
                SizedBox(height: 4.h),
                Text(
                  price,
                  style: TextStyle(color: AppColors.success, fontSize: 16.sp),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 30.sp),
        ],
      ),
    );
  }
}

/// كارت المنتج بتاع الهوم: الصورة فوق زي ما هي، واسم المنتج وسعره على خلفية بيضا،
/// وبوردر خفيف بيلم الاتنين مع بعض. (خاص بالهوم، ProductCard المشترك متعدلش)
class _HomeProductCard extends StatelessWidget {
  const _HomeProductCard({
    required this.product,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteTap,
    this.onArTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onArTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الجزء اللي فوق (الصورة + القلب + AR)
            Expanded(
              child: Container(
                color: AppColors.chip,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _image(),
                    PositionedDirectional(
                      top: 6.h,
                      end: 6.w,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 17.sp,
                            color: isFavorite
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    // زرار الـ AR: بيفتح صفحة ar_view بتاعة المنتج
                    PositionedDirectional(
                      bottom: 6.h,
                      start: 6.w,
                      child: GestureDetector(
                        onTap: onArTap,
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
                              Icon(
                                Icons.view_in_ar,
                                size: 14.sp,
                                color: AppColors.onPrimary,
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
                    ),
                  ],
                ),
              ),
            ),

            // الجزء اللي تحت (الاسم والسعر) خلفية بيضا
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
    final placeholder = Icon(
      Icons.chair_outlined,
      size: 40.sp,
      color: AppColors.textSecondary,
    );

    if (product.images.isEmpty) return Center(child: placeholder);

    final src = product.images.first;

    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.cover,
        placeholder: (_, __) => Center(child: placeholder),
        errorWidget: (_, __, ___) => Center(child: placeholder),
      );
    }

    return Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Center(child: placeholder),
    );
  }
}