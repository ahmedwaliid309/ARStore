
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/state_views.dart';
import 'package:decora/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/core/utils/formatters.dart';
// عدّل مسار الاستيراد حسب مكان الملف عندك

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // الفلتر المختار
  String selectedFilter = 'All';

  // قائمة الفلاتر
  final List<String> filters = [
    'All',
    'Active',
    'Delivered',
    'Cancelled',
  ];

  // تحديد الطلبات حسب الفلتر
  List<AppOrder> filterOrders(List<AppOrder> orders) {
    if (selectedFilter == 'All') {
      return orders;
    }

    return orders.where((order) {
      final status = order.status.trim().toLowerCase();

      if (selectedFilter == 'Delivered') {
        return status == 'delivered' ||
            status == 'تم التسليم' ||
            status == 'مكتمل';
      }

      if (selectedFilter == 'Cancelled') {
        return status == 'cancelled' ||
            status == 'canceled' ||
            status == 'ملغي' ||
            status == 'ملغى';
      }

      if (selectedFilter == 'Active') {
        return status != 'delivered' &&
            status != 'تم التسليم' &&
            status != 'مكتمل' &&
            status != 'cancelled' &&
            status != 'canceled' &&
            status != 'ملغي' &&
            status != 'ملغى';
      }

      return true;
    }).toList();
  }

  // تحويل التاريخ لشكل مناسب
  String formatOrderDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // الاستماع لأي تغيير في الطلبات
    final ordersProvider = context.watch<OrdersProvider>();

    final orders = ordersProvider.orders;
    final filteredOrders = filterOrders(orders);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          child: Column(
            children: [
              SizedBox(height: 15.h),

              // ================= HEADER =================

              SizedBox(
                height: 44.h,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 36.w,
                          width: 36.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            size: 24.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              // ================= FILTERS =================

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;

                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(30.r),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : const Color(0xFFE5E0D8),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 25.h),

              // ================= ORDERS BODY =================

              Expanded(
                child: filteredOrders.isEmpty
                    ? EmptyView(
                        icon: Icons.shopping_bag_outlined,
                        title: orders.isEmpty
                            ? 'No orders yet'
                            : 'No orders found',
                        subtitle: orders.isEmpty
                            ? 'Your orders will appear here'
                            : 'Try selecting another filter',
                      )
                    : ListView.separated(
                        itemCount: filteredOrders.length,
                        padding: EdgeInsets.only(bottom: 20.h),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];

                          return OrderCard(
                            order: order,
                            formattedDate:
                                formatOrderDate(order.createdAt),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================
// ORDER CARD
// ========================================================

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.formattedDate,
  });

  final AppOrder order;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رقم الطلب والتاريخ والحالة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              OrderStatusBadge(status: order.status),
            ],
          ),

          SizedBox(height: 14.h),

          // صور / عناصر المنتجات
          Row(
            children: [
              ...List.generate(
                order.items.length > 2 ? 2 : order.items.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.chip,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.chair_outlined,
                        color: AppColors.primary,
                        size: 30.sp,
                      ),
                    ),
                  );
                },
              ),

              if (order.items.length > 2)
                Container(
                  width: 60.w,
                  height: 60.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    '+${order.items.length - 2}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 18.h),

          // الإجمالي والتفاصيل
          Row(
            children: [
              Expanded(
                child: Text(
                  Formatters.price(order.total),
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  AppRouter.router.go(
                    AppRoutes.productDetails,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'View details',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Icon(
                      Icons.chevron_right,
                      size: 25.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// ORDER STATUS BADGE

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.trim().toLowerCase();

    Color backgroundColor;
    Color textColor;
    String label;

    if (normalizedStatus == 'delivered' ||
        normalizedStatus == 'تم التسليم' ||
        normalizedStatus == 'مكتمل') {
      backgroundColor = const Color(0xFFD9E9DF);
      textColor = const Color(0xFF54816A);
      label = 'Delivered';
    } else if (normalizedStatus == 'cancelled' ||
        normalizedStatus == 'canceled' ||
        normalizedStatus == 'ملغي' ||
        normalizedStatus == 'ملغى') {
      backgroundColor = const Color(0xFFF4DDDD);
      textColor = const Color(0xFFB34D4D);
      label = 'Cancelled';
    } else if (normalizedStatus == 'on the way' ||
        normalizedStatus == 'جاري التوصيل') {
      backgroundColor = const Color(0xFFE1EAE3);
      textColor = const Color(0xFF174D43);
      label = 'On the way';
    } else {
      backgroundColor = const Color(0xFFF6EBD2);
      textColor = const Color(0xFF9A741D);
      label = 'Processing';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
