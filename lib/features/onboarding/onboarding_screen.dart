// ══════════════════════════════════════════════════════════
//  الشاشة    : Onboarding (شاشات التعريف)
//  المسؤول   : أحمد وليد
//  الـ Branch  : feature/onboarding
//  الملف     : lib/features/onboarding/onboarding_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - 3 صفحات PageView مع مؤشر نقاط
//    - زر تخطي وزر ابدأ ← Auth
//    - حفظ إن الـ Onboarding خلص (shared_preferences)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:decora/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
            height: 840.h,
            width: double.infinity,
            color: AppColors.background,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      height: 30.h,
                      width: 35.w,
                      'assets/images/Group 47.png',
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.auth);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Stack(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(80.r),
                      ),
                      child: Image.asset(
                        height: 400.h,
                        width: double.infinity,
                        'assets/images/banner.jpeg',
                        fit: BoxFit.cover,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20.h, left: 20.w),
                    height: 32.h,
                    width: 179.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.view_in_ar_outlined,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                        Text(
                          'Place . Rotate . Resize',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 20.h),
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: const WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Color(0xFF17453C),
                    dotColor: Color(0xFFD6D0C5),
                  ),
                ),
                SizedBox(height: 30.h),
         
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'See it in your room \n before you buy',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ),
              
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Point your camera, drop the furniture in your space and check size and colour in real life.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120.w,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
