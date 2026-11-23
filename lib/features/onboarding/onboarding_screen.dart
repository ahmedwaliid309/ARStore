
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// بيانات صفحات الـ Onboarding
final List<Map<String, String>> onboardingData = [
  {
    "image": 'assets/images/AR_green_armchair_in_room_6f9df1bd_2K.jpg',
    "title": "See it in your room\nbefore you buy",
    "description":
        "Point your camera, drop the furniture in your space and check size and colour in real life.",
  },
  {
    "image": 'assets/images/Emerald Armchair Living Room Retreat.webp',
    "title": "Find Your Perfect\nFurniture",
    "description":
        "Explore thoughtfully curated pieces that match your style and the way you live.",
  },
  {
    "image": 'assets/images/Serene Green Scandinavian Bedroom.webp',
    "title": "Create Your Dream\nSpace",
    "description":
        "Discover, customize, and bring home furniture you will love for years.",
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // بناء محتوى كل صفحة
  Widget buildOnboardingPage(int index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(80.r),
                ),
                child: Image.asset(
                  onboardingData[index]['image']!,
                  height: 400.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Badge
              Container(
                margin: EdgeInsets.only(
                  top: 20.h,
                  left: 20.w,
                ),
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
            ],
          ),

          // Indicator تحت الصورة مباشرة
          SizedBox(height: 20.h),

          Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: onboardingData.length,
              effect: const WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Color(0xFF17453C),
                dotColor: Color(0xFFD6D0C5),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          // العنوان
          Text(
            onboardingData[index]['title']!,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 30.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 15.h),

          // الوصف
          Text(
            onboardingData[index]['description']!,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // حفظ انتهاء الـ Onboarding
  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboardingCompleted', true);

    if (!mounted) return;

    context.go(AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.only(
            top: 10.h,
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/Group 47.png',
                    height: 30.h,
                    width: 35.w,
                  ),

                  TextButton(
                    onPressed: finishOnboarding,
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

              // صفحات الـ Onboarding
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return buildOnboardingPage(index);
                  },
                ),
              ),

              SizedBox(height: 20.h),

              // زر Next / Get Started
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: currentPage == onboardingData.length - 1
                      ? 150.w
                      : 120.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (currentPage < onboardingData.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await finishOnboarding();
                      }
                    },
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
                          currentPage == onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
