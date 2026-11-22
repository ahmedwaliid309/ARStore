// ══════════════════════════════════════════════════════════
//  الشاشة    : Product Details (تفاصيل المنتج)
//  المسؤول   : إيمان
//  الـ Branch  : feature/product-details
//  الملف     : lib/features/product_details/product_details_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - جلب المنتج بـ ProductRepository.byId(productId) في initState، مع تحميل وخطأ
//    - معرض صور (PageView) واسم وسعر ووصف
//    - الأبعاد والألوان المتاحة
//    - زر "شوف في أوضتك (AR)" ← AppRoutes.arPath (الـ AR مؤجل: اعرض رسالة "قريباً")
//    - أضف للسلة (CartProvider.add) وقلب المفضلة (FavoritesProvider.toggle)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/data/product_repository.dart';

import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

import '../../data/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    width: double.infinity.w,
                    height: 315.h,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                    ),

                    child: Image.network(
                        '',
                      fit: BoxFit.cover,
                    )
                ),


                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w , vertical: 10.h),
                  child:SizedBox(
                    width: double.infinity.w,
                    height: 295.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.surface,
                                  side: BorderSide(color: AppColors.border, width: 1.w),
                                  fixedSize: Size(40.w, 40.w),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: (){},
                                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 23.34.w,)
                            ),
                            Row(
                              children: [
                                IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surface,
                                      side: BorderSide(color: AppColors.border, width: 1.w),
                                      fixedSize: Size(40.w, 40.w),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: (){},
                                    icon: Icon(Icons.favorite_border_outlined, size: 23.34.w,)
                                ),
                                SizedBox(width: 8.w,),
                                IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surface,
                                      side: BorderSide(color: AppColors.border, width: 1.w),
                                      fixedSize: Size(40.w, 40.w),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: (){},
                                    icon: Icon(Icons.share_outlined, size: 23.34.w,)
                                ),
                              ],
                            ),


                          ],
                        ),
                        Positioned(
                          left: 10.w,
                          child:  SizedBox(
                            width: 112.w,
                            height: 34.h,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(112.w, 34.h),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: (){},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.view_in_ar_outlined, size: 23.34.w,),
                                    SizedBox(width: 10.w,),
                                    Transform.translate(
                                      offset: Offset(0, 1.8.h),
                                      child: Text('View in AR', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),),
                                    ),




                                  ],
                                )
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}


/*actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.arPath(widget.productId)),
          child: const Text('AR (مؤجل)'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.cart),
          child: const Text('السلة'),
        ),
        const SizedBox(height: 12),
      ], */