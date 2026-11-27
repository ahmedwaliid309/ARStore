import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/utils/formatters.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/data/models/product.dart';
import 'package:decora/providers/cart_provider.dart';

const double kDeliveryFee = 250;

String egpPrice(double value) =>
    'EGP ${Formatters.price(value).replaceAll('EGP', '').trim()}';

const Map<String, String> _colorNames = {
  'C98B5B': 'Caramel',
  '1F2421': 'Black',
  'FFFFFF': 'White',
  '9AA0A6': 'Grey',
  'C9B79C': 'Beige',
  '6B4F3A': 'Walnut',
  '2F5D50': 'Green',
  '17453C': 'Forest',
  '8FA396': 'Sage',
  '527C66': 'Moss',
  '3E2C1F': 'Espresso',
};

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    Widget body;
    if (cart.isEmpty) {
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
        child: Icon(Icons.delete_outline, color: AppColors.surface, size: 26.sp),
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
                  _ItemMeta(product: p),
                  SizedBox(height: 6.h),
                  Text(
                    egpPrice(p.price),
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

class _ItemMeta extends StatelessWidget {
  const _ItemMeta({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final p = product;
    final colorName = p.colors.isEmpty
        ? null
        : _colorNames[p.colors.first.replaceAll('#', '').toUpperCase()];
    final parts = <String>[
      if (colorName != null) colorName,
      if (p.widthCm > 0) '${p.widthCm.round()} cm' else p.category,
    ];
    final size = parts.join(' · ');

    return Row(
      children: [
        if (p.colors.isNotEmpty) ...[
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: p.colors.first.toColor(),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
          ),
          SizedBox(width: 6.w),
        ],
        Expanded(
          child: Text(
            size,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ),
      ],
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
          _Row('Subtotal', egpPrice(cart.total)),
          SizedBox(height: 10.h),
          _Row('Delivery', egpPrice(kDeliveryFee)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          _Row('Total', egpPrice(cart.total + kDeliveryFee), bold: true),
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