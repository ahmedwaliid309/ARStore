import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/data/mock_products.dart';
import 'package:decora/data/models/product.dart';
import 'package:decora/providers/cart_provider.dart';

String _egp(double value) {
  final digits = value.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return 'EGP $buf';
}

const double _deliveryFee = 250;

const bool _debugFailLoad = false;

enum _CartStatus { loading, error, ready }

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  _CartStatus _status = _CartStatus.loading;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = context.read<CartProvider>();
      if (cart.isEmpty) {
        for (final p in MockProducts.all.take(3)) {
          cart.add(p);
        }
      }
    });
  }

  Future<void> _load() async {
    setState(() => _status = _CartStatus.loading);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (_debugFailLoad) throw Exception('debug load error');
      if (!mounted) return;
      setState(() => _status = _CartStatus.ready);
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _CartStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    Widget body;
    if (_status == _CartStatus.loading) {
      body = const LoadingView();
    } else if (_status == _CartStatus.error) {
      body = ErrorView(message: "Couldn't load your cart", onRetry: _load);
    } else if (cart.isEmpty) {
      body = EmptyView(
        icon: Icons.shopping_bag_outlined,
        title: 'Your cart is empty',
        subtitle: 'Add some furniture to get started',
        actionLabel: 'Browse products',
        onAction: () => context.go(AppRoutes.home),
      );
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 24.h),
        children: [
          for (final item in cart.items) ...[
            _CartItemTile(item: item),
            SizedBox(height: 12.h),
          ],
          SizedBox(height: 16.h),
          const _PromoBox(),
          SizedBox(height: 12.h),
          const _SummaryCard(),
          SizedBox(height: 28.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 54.h)),
            onPressed: () => context.push(AppRoutes.checkout),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Checkout'),
                SizedBox(width: 8.w),
                Icon(Icons.chevron_right, size: 22.sp),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(body: SafeArea(child: body));
  }
}

// ───────────────────────── عنصر السلة ─────────────────────────
class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final p = item.product;
    final text = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(p.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cart.remove(p.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 26.sp),
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            _Thumb(product: p),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    p.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _egp(p.price),
                    style: text.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            _QtyControls(
              quantity: item.quantity,
              onAdd: () => cart.setQuantity(p.id, item.quantity + 1),
              onRemove: () => cart.setQuantity(p.id, item.quantity - 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.chip,
      child: Icon(Icons.chair_outlined, size: 32.sp, color: AppColors.textSecondary),
    );

    Widget img = placeholder;
    if (product.images.isNotEmpty) {
      final src = product.images.first;
      img = src.startsWith('http')
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(width: 96.w, height: 96.w, child: img),
    );
  }
}

class _QtyControls extends StatelessWidget {
  const _QtyControls({
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundBtn(icon: Icons.add, filled: true, onTap: onAdd),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '$quantity',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
        _RoundBtn(icon: Icons.remove, filled: false, onTap: onRemove),
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({required this.icon, required this.filled, required this.onTap});

  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.primary : AppColors.surface,
          border: filled ? null : Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: filled ? AppColors.onPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ───────────────────────── Promo code ─────────────────────────
class _PromoBox extends StatefulWidget {
  const _PromoBox();

  @override
  State<_PromoBox> createState() => _PromoBoxState();
}

class _PromoBoxState extends State<_PromoBox> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _apply() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promo codes coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => _apply(),
              decoration: InputDecoration(
                hintText: 'Promo code',
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(
            height: 40.h,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80.w, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('Apply', style: TextStyle(fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── ملخص السعر ─────────────────────────
class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _Row('Subtotal', _egp(cart.total)),
          SizedBox(height: 10.h),
          _Row('Delivery', _egp(_deliveryFee)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          _Row('Total', _egp(cart.total + _deliveryFee), bold: true),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16.sp : 14.sp,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: bold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18.sp : 14.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
