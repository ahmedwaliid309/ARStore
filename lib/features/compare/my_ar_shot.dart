import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/data/models/product.dart';
import 'package:decora/data/product_repository.dart';
import 'package:decora/features/compare/compare.dart';

enum _ShotsStatus { loading, error, ready }

class MyArShotsScreen extends StatefulWidget {
  const MyArShotsScreen({super.key});

  @override
  State<MyArShotsScreen> createState() => _MyArShotsScreenState();
}

class _MyArShotsScreenState extends State<MyArShotsScreen> {
  _ShotsStatus _status = _ShotsStatus.loading;
  List<Product> _shots = const [];
  final List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = _ShotsStatus.loading);
    try {
      final list = await context.read<ProductRepository>().all();
      if (!mounted) return;
      setState(() {
        _shots = list;
        _selected.clear();
        _status = _ShotsStatus.ready;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _ShotsStatus.error);
    }
  }

  void _toggle(Product p) {
    setState(() {
      if (_selected.contains(p.id)) {
        _selected.remove(p.id);
      } else if (_selected.length < 2) {
        _selected.add(p.id);
      }
    });
  }

  void _remove(Product p) {
    setState(() {
      _shots = _shots.where((e) => e.id != p.id).toList();
      _selected.remove(p.id);
    });
  }

  void _compare() {
    if (_selected.length != 2) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompareScreen(idA: _selected[0], idB: _selected[1]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_status == _ShotsStatus.loading) {
      body = const LoadingView();
    } else if (_status == _ShotsStatus.error) {
      body = ErrorView(message: "Couldn't load your AR shots", onRetry: _load);
    } else if (_shots.isEmpty) {
      body = EmptyView(
        icon: Icons.photo_library_outlined,
        title: 'No AR shots yet',
        subtitle: 'Place furniture in your room with AR to see it here',
        actionLabel: 'Browse products',
        onAction: () => context.go(AppRoutes.home),
      );
    } else {
      body = Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.8,
              ),
              itemCount: _shots.length,
              itemBuilder: (_, i) {
                final p = _shots[i];
                final index = _selected.indexOf(p.id);
                final isSelected = index >= 0;
                final dimmed = !isSelected && _selected.length == 2;
                return _ShotTile(
                  product: p,
                  order: isSelected ? index + 1 : null,
                  dimmed: dimmed,
                  onTap: dimmed ? null : () => _toggle(p),
                  onRemove: () => _remove(p),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 54.h),
                disabledBackgroundColor: AppColors.textSecondary,
                disabledForegroundColor: AppColors.surface,
              ),
              onPressed: _selected.length == 2 ? _compare : null,
              child: const Text('Compare selected'),
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
              title: 'My AR Shots',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── كارت اللقطة ─────────────────────────
class _ShotTile extends StatelessWidget {
  const _ShotTile({
    required this.product,
    required this.order,
    required this.dimmed,
    required this.onTap,
    required this.onRemove,
  });

  final Product product;
  final int? order;
  final bool dimmed;
  final VoidCallback? onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final selected = order != null;

    return Opacity(
      opacity: dimmed ? 0.55 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      child: SizedBox.expand(child: CompareImage(product: product)),
                    ),
                    if (selected)
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
                            '$order',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: InkWell(
                        onTap: onRemove,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 8.h),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}