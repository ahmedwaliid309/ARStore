// ══════════════════════════════════════════════════════════
//  الشاشة    : Settings (الإعدادات)
//  المسؤول   : إيمان
//  الـ Branch  : feature/settings
//  الملف     : lib/features/settings/settings_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - اللغة والوضع الليلي (حسب Figma)
//    - عن التطبيق والإصدار
//    - تسجيل الخروج ← AuthProvider.signOut ثم Auth
//    - ضبط شكل Bottom Nav على Figma بالاتفاق مع وليد (main_shell.dart)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

import '../../core/theme/app_colors.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool isDarkMode = false;
  bool isNotificationsEnabled = false;
  bool saveAR = false;
  bool isEnglish = true;
  String selectedUnit = 'CM';
  List<String> units = ['CM', 'M', 'IN'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 28.h,
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
                        onPressed: () => context.go(AppRoutes.profile),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 23.34.w,)
                    ),
                    Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 40.w,height: 40.h,)
                  ],
                ),
                Column(
                  spacing: 16.h,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        Text(
                          'APPEARANCE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                            width: double.infinity.w,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(color: AppColors.border, width: 0.5.w),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                spacing: 10.h,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.dark_mode_outlined, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'Dark mode',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: isDarkMode,
                                        activeTrackColor: AppColors.primary,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: AppColors.background,
                                        trackOutlineColor: WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            isDarkMode = value;
                                          });
                                        },
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
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.language_outlined, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'Language',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 140.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Stack(
                                          children: [
                                            AnimatedAlign(
                                              alignment: isEnglish
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                              duration: Duration(milliseconds: 40),
                                              child: Container(
                                                width: 70.w,
                                                height: 32.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: GestureDetector(
                                                      child: Center(
                                                        child: Text(
                                                          'English',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: isEnglish
                                                                ?AppColors.surface
                                                                :AppColors.textPrimary,
                                                            fontSize: 14.sp,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () => setState(() {
                                                        isEnglish = true;
                                                      }),
                                                    )
                                                ),
                                                Expanded(
                                                    child: GestureDetector(
                                                      child: Center(
                                                        child: Text(
                                                          'العربية',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: isEnglish
                                                                ?AppColors.textPrimary
                                                                :AppColors.surface,
                                                            fontSize: 14.sp,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () => setState(() {
                                                        isEnglish = false;
                                                      }),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        Text(
                          'AR EXPERIENCE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                            width: double.infinity.w,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(color: AppColors.border, width: 0.5.w),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                spacing: 10.h,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.image_outlined, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'Save AR shots to gallery',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: saveAR,
                                        activeTrackColor: AppColors.primary,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: AppColors.background,
                                        trackOutlineColor: WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            saveAR = value;
                                          });
                                        },
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
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.straighten_outlined, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'Units',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      DropdownButton(
                                        underline: const SizedBox(),
                                        value: selectedUnit,
                                        items: units.map((units){
                                          return DropdownMenuItem<String>(
                                            value: units,
                                            child: Text(units),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedUnit = value!;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        Text(
                          'GENERAL',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                            width: double.infinity.w,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(color: AppColors.border, width: 0.5.w),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                spacing: 10.h,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.notifications_none, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'Notifications',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: isNotificationsEnabled,
                                        activeTrackColor: AppColors.primary,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: AppColors.background,
                                        trackOutlineColor: WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            isNotificationsEnabled = value;
                                          });
                                        },
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
                                      Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(45.r),
                                            ),
                                            child: Icon(Icons.help_outline_rounded, color: AppColors.primary,size: 23.34.w,),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Text(
                                            'About Decora',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'V1.0.0',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(
                        color: Color(0xFF9D1313),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    onPressed: () => context.go(AppRoutes.auth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.logout, size: 23.34.w,color: Color(0xFF9D1313),),
                        Text(
                          'Log out',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9D1313),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                ),

              ],
            ),

          ),
        )
      ),
    );
  }
}




/*actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.auth),
          child: const Text('تسجيل خروج (تجريبي)'),
        ),
        const SizedBox(height: 12),
      ], */