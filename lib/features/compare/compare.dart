import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/data/models/product.dart';
import 'package:decora/data/product_repository.dart';
import 'package:decora/features/cart/cart_screen.dart' show egpPrice;
import 'package:decora/providers/cart_provider.dart';

enum _CompareStatus { loading, error, ready }

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key, required this.idA, required this.idB});

  final String idA;
  final String idB;

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  _CompareStatus _status = _CompareStatus.loading;
  Product? _a;
  Product? _b;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = _CompareStatus.loading);
    try {
      final repo = context.read<ProductRepository>();
      final res = await Future.wait([repo.byId(widget.idA), repo.byId(widget.idB)]);
      if (!mounted) return;
      setState(() {
        _a = res[0];
        _b = res[1];
        _status = _CompareStatus.ready;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _CompareStatus.error);
    }
  }

  void _addToCart(Product p) {
    context.read<CartProvider>().add(p);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = _a;
    final b = _b;

    Widget body;
    if (_status == _CompareStatus.loading) {
      body = const LoadingView();
    } else if (_status == _CompareStatus.error) {
      body = ErrorView(message: "Couldn't load the products", onRetry: _load);
    } else if (a == null || b == null) {
      body = EmptyView(
        icon: Icons.compare_arrows,
        title: 'Products not found',
        subtitle: 'Pick two products to compare',
        actionLabel: 'Go back',
        onAction: () => Navigator.of(context).maybePop(),
      );
    } else {
      body = Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 16.h),
              children: [
                Text(
                  'Same room, two options — pick the one that fits.',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CompareCard(
                        label: 'A',
                        product: a,
                        highlighted: true,
                        onRemove: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _CompareCard(
                        label: 'B',
                        product: b,
                        highlighted: false,
                        onRemove: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _SpecsTable(a: a, b: b),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 48.h),
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textPrimary,
                    ),
                    onPressed: () => _addToCart(a),
                    icon: Icon(Icons.shopping_cart_outlined, size: 18.sp),
                    label: const Text('Add A'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(minimumSize: Size(0, 48.h)),
                    onPressed: () => _addToCart(b),
                    icon: Icon(Icons.shopping_cart_outlined, size: 18.sp),
                    label: const Text('Add B'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CompareHeader(
              title: 'Compare',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Header + صورة المنتج ─────────────────────────
class CompareHeader extends StatelessWidget {
  const CompareHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_left, color: AppColors.primary, size: 26.sp),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

class CompareImage extends StatelessWidget {
  const CompareImage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.chip,
      child: Icon(Icons.chair_outlined, size: 40.sp, color: AppColors.textSecondary),
    );

    if (product.images.isEmpty) return placeholder;

    final src = product.images.first;
    return src.startsWith('http')
        ? CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    )
        : Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}

// ───────────────────────── كروت المنتجين ─────────────────────────
class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.label,
    required this.product,
    required this.highlighted,
    required this.onRemove,
  });

  final String label;
  final Product product;
  final bool highlighted;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: SizedBox.expand(child: CompareImage(product: product)),
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  product.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 4.h),
                Text(
                  egpPrice(product.price),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 32.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 32.h),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () =>
                              context.push(AppRoutes.productPath(product.id)),
                          child: Text('View product', style: TextStyle(fontSize: 11.sp)),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: onRemove,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── جدول المقارنة ─────────────────────────
class _SpecsTable extends StatelessWidget {
  const _SpecsTable({required this.a, required this.b});

  final Product a;
  final Product b;

  String _size(Product p) {
    if (p.widthCm <= 0 || p.depthCm <= 0 || p.heightCm <= 0) return '—';
    return '${p.widthCm.round()} × ${p.depthCm.round()} × ${p.heightCm.round()}';
  }

  String _floor(Product p) {
    if (p.widthCm <= 0 || p.depthCm <= 0) return '—';
    return '${(p.widthCm * p.depthCm / 10000).toStringAsFixed(1)} m²';
  }

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String va, String vb) => Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 76.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              va,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              vb,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    const divider = Divider(height: 1, color: AppColors.border);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          row('Price', egpPrice(a.price), egpPrice(b.price)),
          divider,
          row('Size', _size(a), _size(b)),
          divider,
          row('Floor space', _floor(a), _floor(b)),
        ],
      ),
    );
  }
}
