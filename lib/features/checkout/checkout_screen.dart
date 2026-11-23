// ══════════════════════════════════════════════════════════
//  الشاشة    : Checkout (إتمام الشراء)
//  المسؤول   : السيد أسامة
//  الـ Branch  : feature/checkout
//  الملف     : lib/features/checkout/checkout_screen.dart
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/providers/cart_provider.dart';
import 'package:decora/providers/orders_provider.dart';


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

class _Address {
  const _Address({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
  });

  final String name;
  final String phone;
  final String street;
  final String city;
}

enum _Pay { visa, paypal }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  _Address _address = const _Address(
    name: 'Decora Customer',
    phone: '+20 100 000 0000',
    street: '12 Nile Corniche St, Apt 5',
    city: 'Cairo',
  );
  _Pay _pay = _Pay.visa;
  bool _placing = false;

  Future<void> _editAddress() async {
    final result = await showModalBottomSheet<_Address>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddressSheet(initial: _address),
    );
    if (result != null && mounted) setState(() => _address = result);
  }

  Future<void> _placeOrder() async {
    if (_placing) return;
    final cart = context.read<CartProvider>();
    if (cart.isEmpty) return;

    setState(() => _placing = true);

    final order = context.read<OrdersProvider>().placeOrder(
      items: List.of(cart.items),
      total: cart.total + _deliveryFee,
    );
    cart.clear();
    if (!mounted) return;
    context.go(AppRoutes.orderConfirmationPath(order.id));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => context.pop()),
            Expanded(
              child: cart.isEmpty
                  ? EmptyView(
                icon: Icons.shopping_bag_outlined,
                title: 'Your cart is empty',
                actionLabel: 'Back to cart',
                onAction: () => context.go(AppRoutes.cart),
              )
                  : ListView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
                children: [
                  const _Stepper(),
                  SizedBox(height: 16.h),
                  _AddressCard(address: _address, onEdit: _editAddress),
                  SizedBox(height: 14.h),
                  _PaymentCard(
                    selected: _pay,
                    onChanged: (v) => setState(() => _pay = v),
                  ),
                  SizedBox(height: 14.h),
                  const _OrderSummary(),
                ],
              ),
            ),
            if (!cart.isEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                child: ElevatedButton(
                  onPressed: _placing ? null : _placeOrder,
                  child: Text('Place Order · ${_egp(cart.total + _deliveryFee)}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Header + Stepper ─────────────────────────
class _Header extends StatelessWidget {
  const _Header({required this.onBack});

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
              'Checkout',
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

class _Stepper extends StatelessWidget {
  const _Stepper();

  @override
  Widget build(BuildContext context) {

    Widget dot(String label, Widget child, Color bg, {bool dim = false}) => Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: child,
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: dim ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      ],
    );

    Widget line() => Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 22.h),
        child: Container(height: 2, color: AppColors.border),
      ),
    );

    TextStyle stepNum(Color c) =>
        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: c);

    return Row(
      children: [
        dot('Address', Icon(Icons.check, color: AppColors.onPrimary, size: 22.sp),
            AppColors.primary),
        line(),
        dot('Payment', Text('2', style: stepNum(AppColors.onPrimary)), AppColors.primary),
        line(),
        dot('Done', Text('3', style: stepNum(AppColors.textPrimary)), AppColors.surface,
            dim: true),
      ],
    );
  }
}

// ───────────────────────── كروت الشاشة ─────────────────────────
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: child,
  );
}

class _IconBadge extends StatelessWidget {
  const _IconBadge(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 44.w,
    height: 44.w,
    decoration: const BoxDecoration(
      color: AppColors.chip,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: AppColors.primary, size: 22.sp),
  );
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onEdit});

  final _Address address;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBadge(Icons.location_on_outlined),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery address',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text(
                  '${address.name}\n${address.street}\n${address.city} · ${address.phone}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text('Edit',
                style: TextStyle(fontSize: 13.sp, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.selected, required this.onChanged});

  final _Pay selected;
  final ValueChanged<_Pay> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(Icons.credit_card_outlined),
              SizedBox(width: 12.w),
              Text('Payment method',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 14.h),
          _PayOption(
            label: 'VISA',
            title: '•••• 4242',
            subtitle: 'Expires 08/28',
            selected: selected == _Pay.visa,
            onTap: () => onChanged(_Pay.visa),
          ),
          SizedBox(height: 10.h),
          _PayOption(
            label: 'PayPal',
            title: '•••• 4242',
            subtitle: 'Expires 08/28',
            selected: selected == _Pay.paypal,
            onTap: () => onChanged(_Pay.paypal),
          ),
        ],
      ),
    );
  }
}

class _PayOption extends StatelessWidget {
  const _PayOption({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    Widget row(String l, String v, {bool bold = false}) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l,
                style: TextStyle(
                  fontSize: bold ? 16.sp : 13.sp,
                  fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                  color: bold ? AppColors.textPrimary : AppColors.textSecondary,
                )),
            Text(v,
                style: TextStyle(
                  fontSize: bold ? 18.sp : 14.sp,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: bold ? AppColors.primary : AppColors.textPrimary,
                )),
          ],
        );

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(Icons.inventory_2_outlined),
              SizedBox(width: 12.w),
              Text('Order summary',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 14.h),
          for (final item in cart.items)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500)),
                        Text('Q ${item.quantity}',
                            style: TextStyle(
                                fontSize: 12.sp, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text(_egp(item.subtotal),
                      style: TextStyle(fontSize: 13.sp, color: AppColors.primary)),
                ],
              ),
            ),
          SizedBox(height: 4.h),
          row('Subtotal', _egp(cart.total)),
          SizedBox(height: 6.h),
          row('Delivery', _egp(_deliveryFee)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          row('Total', _egp(cart.total + _deliveryFee), bold: true),
        ],
      ),
    );
  }
}

// ───────────────────────── فورم العنوان ─────────────────────────
class _AddressSheet extends StatefulWidget {
  const _AddressSheet({required this.initial});

  final _Address initial;

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial.name);
  late final _phone = TextEditingController(text: widget.initial.phone);
  late final _street = TextEditingController(text: widget.initial.street);
  late final _city = TextEditingController(text: widget.initial.city);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _street.dispose();
    _city.dispose();
    super.dispose();
  }

  String? _required(String? v, String what) =>
      (v == null || v.trim().isEmpty) ? 'Please enter $what' : null;

  String? _phoneCheck(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'[\s\-+]'), '');
    if (digits.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^\d{10,13}$').hasMatch(digits)) return 'Enter a valid phone number';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _Address(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        street: _street.text.trim(),
        city: _city.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.w,
        0,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery address',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) => _required(v, 'your name'),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: _phoneCheck,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _street,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Street address'),
                validator: (v) => _required(v, 'your address'),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _city,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) => _required(v, 'your city'),
                onFieldSubmitted: (_) => _save(),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(onPressed: _save, child: const Text('Save address')),
            ],
          ),
        ),
      ),
    );
  }
}
