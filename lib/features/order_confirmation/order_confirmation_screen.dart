// ══════════════════════════════════════════════════════════
//  الشاشة    : Order Confirmation (تأكيد الطلب)
//  المسؤول   : معاذ منصور
//  الـ Branch  : feature/order-confirmation
//  الملف     : lib/features/order_confirmation/order_confirmation_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - رسالة نجاح بحركة بسيطة
//    - رقم الطلب (orderId)
//    - زر "طلباتي" ← Orders، وزر "الرئيسية" ← Home
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:decora/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // الدايرة الكبيرة
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                    ),

                    // الدايرة الى ف النص
                    Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),

                    // الدايرة الصغيرة
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),

                    // علامة الصح
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 55,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Column(
                children: [
                  Container(
                    child: Text(
                      ' Order confirmed !',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), Container(
                    child:

                    Text( textAlign: TextAlign.center,
                      'Thank you,We’ll get your furniture ready \n for delivery.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w100,

                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child:Stack(
                      children: [
                        Positioned(
                          child:  Container(
                            height: 258,

                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                          ,
                        ),
                        Positioned(child: Padding(
                          padding: const EdgeInsets.only(top: 14.0 ,left: 14.0),
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                              ),SizedBox(width: 12,),

                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),

                        )),

                        Positioned(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0,  right: 16.0,top: 14),
                              child: Image.asset('assets/images/Line 13.png',height: 180,),
                            )),
                        Positioned(
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 120.0, left: 12.0, right: 12.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order number',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                      Text(
                                        '#DC-2048 1',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Estimated delivery',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                      Text(
                                        'Thu, 20 Nov',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                      Text(
                                        'Card •••• 4242',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.primary.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'EGP 27,150',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),


                  )


                ],
              )
              ,
              SizedBox(height: 32,),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Container(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push(AppRoutes.orders),
                        child: const Text('View my orders'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(

                        onPressed: () => context.go(AppRoutes.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.primary,
                        ),
                        child:  Text('Continue shopping'),

                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),


            ],
          ),
        ),
      );


  }
}