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
import 'package:decora/core/widgets/state_views.dart';

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


  Product? _product;
  bool loadingState = true;
  String? _error;
  bool isEmpty = false;
  bool isFavorite = false;
  int counter = 1;
  int selectedColorIndex = 0;

  Future<void> _loadProduct()async{
    loadingState = true;
    try{
      final product = await ProductRepository().byId(widget.productId);
      if(product == null){
        setState(() {
          isEmpty = true;
          loadingState = false;
        });
        return;
      }
      setState(() {
        _product = product;
        loadingState = false;
      });
    }catch(e){
      setState(() {
        _error = e.toString();
        loadingState = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: loadingState
        ? LoadingView()
        : _error != null
          ?ErrorView(
            message: _error!,
            onRetry: _loadProduct,
          )
          : isEmpty
            ? EmptyView(title: 'Product Not Found',
                subtitle: 'This product is currently unavailable.',
                actionLabel: 'Back to Home',
                onAction: () => context.go(AppRoutes.home)
            )
            : SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: double.infinity.w,
                            height: 315.h,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                            ),

                            child: _product!.images.isEmpty
                              ? Center(
                                child: Text('No image available'),
                                )
                              :Image.network(
                                _product!.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace){
                                  print('Image error: $error');
                                  return Center(
                                    child: Text('No image available'),
                                  );
                                },
                               ),
                        ),
                        Padding(
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w , vertical: 10.h),
                            child:SizedBox(
                              width: double.infinity.w,
                              height: 300.h,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          onPressed: () => context.go(AppRoutes.home),
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
                                              onPressed: (){
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                });
                                              },
                                              icon: Icon( isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                                size: 23.34.w,
                                                color: isFavorite ? AppColors.error : AppColors.textPrimary,)
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
                                  Spacer(),
                                  SizedBox(
                                    width: 112.w,
                                    height: 34.h,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(112.w, 34.h),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () => context.push(AppRoutes.arPath(widget.productId)),
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
                                  SizedBox(height: 16.h,)

                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    Positioned(
                      top: 305.h,
                      left: 0.w,
                      right: 0.w,
                      bottom: 54.h,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            spacing: 16.h,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                     _product!.name,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 28.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 3.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 5.w,
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 20.w,),
                                          Text(
                                            '4.8',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text('(126 reviews)',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          width: 81.w,
                                          height: 19.h,
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            spacing: 4.w,
                                            children: [
                                              Icon(Icons.view_in_ar_outlined, size: 12.w, color: AppColors.primary,),
                                              Transform.translate(
                                                offset: Offset(0, -1.5.h),
                                                child: Text(
                                                  'AR ready',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 11,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )

                                      )
                                    ],
                                  ),

                                  SizedBox(height: 32.h,),
                                  Text(
                                    _product!.description,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.46,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                width: double.infinity.w,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: AppColors.border,
                                        width: 0.5.w,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    )
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4.h,
                                    children: [
                                      Text(
                                        'Colors',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Sage',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    spacing: 12.w,
                                    children: List.generate(
                                        _product!.colors.length,
                                        (index){
                                          final color = Color(
                                            int.parse(
                                              _product!.colors[index].replaceFirst('#', '0xFF'),
                                            ),
                                          );
                                          final isSelected = selectedColorIndex == index;
                                          return GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                selectedColorIndex = index;
                                              });
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 28.h,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.circular(14.r),
                                                border: Border.all(color: AppColors.background, width: 2.71.w),
                                                boxShadow: isSelected
                                                  ? [
                                                    BoxShadow(
                                                      color: AppColors.textPrimary,
                                                      spreadRadius: 1.5.r,
                                                      blurRadius: 0,
                                                      offset: Offset.zero,
                                                    ),
                                                    ]
                                                  : [],
                                              ),
                                            )
                                          );
                                        }
                                    ),
                                      
                                      // Container(
                                      //   width: 28.w,
                                      //   height: 28.h,
                                      //   clipBehavior: Clip.antiAlias,
                                      //   decoration: BoxDecoration(
                                      //     color: Color(
                                      //       int.parse(_product!.colors[0].replaceFirst('#', '0xFF')),
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(14.r),
                                      //     border: Border.all(color: AppColors.background, width: 2.71.w),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: AppColors.textPrimary,
                                      //         spreadRadius: 1.5.r,
                                      //         blurRadius: 0,
                                      //         offset: Offset(0, 0),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // Container(
                                      //   width: 28.w,
                                      //   height: 28.h,
                                      //   clipBehavior: Clip.antiAlias,
                                      //   decoration: BoxDecoration(
                                      //     color: Color(
                                      //       int.parse(_product!.colors[1].replaceFirst('#', '0xFF')),
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(14.r),
                                      //     border: Border.all(color: AppColors.background, width: 2.71.w),
                                      //   ),
                                      // ),
                                      // Container(
                                      //   width: 28.w,
                                      //   height: 28.h,
                                      //   clipBehavior: Clip.antiAlias,
                                      //   decoration: BoxDecoration(
                                      //     color: Color(
                                      //       int.parse(_product!.colors[2].replaceFirst('#', '0xFF')),
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(14.r),
                                      //     border: Border.all(color: AppColors.background, width: 2.71.w),
                                      //   ),
                                      // ),
                                      // Container(
                                      //   width: 28.w,
                                      //   height: 28.h,
                                      //   clipBehavior: Clip.antiAlias,
                                      //   decoration: BoxDecoration(
                                      //     color: Color(
                                      //       int.parse(_product!.colors[0].replaceFirst('#', '0xFF')),
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(14.r),
                                      //     border: Border.all(color: AppColors.background, width: 2.71.w),
                                      //   ),
                                      // ),
                                    
                                  ),
                                ],
                              ),

                              Container(
                                width: double.infinity.w,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: AppColors.border,
                                        width: 0.5.w,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    )
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Size',
                                    style: TextStyle(
                                      color: const Color(0xFF12211D) /* dark-text */,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      Container(
                                          width: 142.w,
                                          height: 36.h,
                                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(20.r),
                                            border: Border.all(color: AppColors.border, width: 1.w),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '2-seater · 160 cm',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                      ),
                                      Container(
                                          width: 142.w,
                                          height: 36.h,
                                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '3-seater · 210 cm',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.surface,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 14.h,),

                                  SizedBox(
                                    width: double.infinity.w,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10.w,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 66.h,
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14.r),
                                                color: AppColors.background
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              spacing: 1.h,
                                              children: [
                                                Text(
                                                  'Width',
                                                  style: TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: 11,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${_product!.widthCm}',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 16,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 111.33.w,
                                            height: 66.h,
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14.r),
                                                color: AppColors.background
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              spacing: 1.h,
                                              children: [
                                                Text(
                                                  'Depth',
                                                  style: TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: 11,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${_product!.depthCm}',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 16,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 111.33.w,
                                            height: 66.h,
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14.r),
                                                color: AppColors.background
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              spacing: 1.h,
                                              children: [
                                                Text(
                                                  'Height',
                                                  style: TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: 11,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${_product!.heightCm}',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 16,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),

                              Container(
                                width: double.infinity.w,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: AppColors.border,
                                        width: 0.5.w,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    )
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4.h,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          color: const Color(0xFF12211D) /* dark-text */,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'In stock · ships in 3–5 days',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    spacing: 8,
                                    children: [
                                      SizedBox(
                                        width: 26.w,
                                        height: 26.w,
                                        child: IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor: AppColors.surface,
                                              side: BorderSide(color: AppColors.border, width: 0.8.w),
                                              padding: EdgeInsets.all(2.w),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                if(counter>1){
                                                  counter--;
                                                }
                                              });
                                            },
                                            icon: Transform.translate(
                                                offset: Offset(0, -7.h),
                                                child: Icon(Icons.minimize_rounded,size: 23.34,color: AppColors.textPrimary,)
                                            )
                                        ),
                                      ),
                                      Text(
                                        counter.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 26.w,
                                        height: 26.w,
                                        child: IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding: EdgeInsets.all(2.w),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                counter++;
                                              });
                                            },
                                            icon:  Icon(Icons.add,size: 23.34,color: AppColors.surface,)
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0.w,
                        right: 0.w,
                        bottom: 0.h,
                        child: Container(
                          width: double.infinity.w,
                          color: AppColors.surface,
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w),
                            child: SizedBox(
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4.h,
                                    children: [
                                      Text(
                                        'Total price',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${_product!.price * counter}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 179.34.w,
                                    height: 54.h,
                                    child: ElevatedButton(
                                        onPressed: () => context.go(AppRoutes.cart),
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            Icon(Icons.shopping_cart_outlined, size: 23.34.w,),
                                            Text(
                                              'Add to cart',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.surface,
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                )
            ),
          ],
        )
    ),

    );
  }
}
