import 'package:decora/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../favorites/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
bool isSelected = false;
bool isFavorite = false;
int selectedIndex = 0;
int index=0;
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: AppColors.background,
      body:
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0 , left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "GOOD MORNING ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                            color: AppColors.primary.withOpacity(.5)
                        ),),Text(
                          "Moaz Mansor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                            color: AppColors.primary
                        ),),
                      ],
                    ), //Text
                    Padding(padding:  EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: () => context.push(AppRoutes.orders),
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),SizedBox(width: 10,),

                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: () => context.push(AppRoutes.orders),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          )

                        ],
                      ) , //notifcation , cart
                    ), // row icons

                  ],
                ),

              ),// الجزء بتاع الاسم والايقونات
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search sofas, beds, lamps...',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    GestureDetector(

                      onTap: () {
                        double maxPrice = 16000;
                        String selectedCategory = 'All';
                        Color? selectedColor;
                        int count = 48; // رقم الى ف اخر زرار ف البوتوم شيت

                        final categories = ['All', 'Sofas', 'Beds', 'Tables', 'Chairs', 'Lighting'];
                        final colors = [
                          Color(0xFFDCC8A8),
                          Color(0xFF6F7F66),
                          Color(0xFFA0523F),
                          Color(0xFF222222),
                          Color(0xFFE8E6E0),
                        ];

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setSheetState) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Filters',
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close, color: AppColors.primary),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ],
                                        ), // كلمه فلتر و X
                                        SizedBox(height: 24),


                                        Text('Price range', style: TextStyle(fontSize: 16)),
                                        Slider(
                                          value: maxPrice,
                                          min: 1000,
                                          max: 16000,
                                          activeColor: AppColors.primary,
                                          inactiveColor: Colors.white,
                                          onChanged: (value) {
                                            setSheetState(() {
                                              maxPrice = value;
                                            });
                                          },
                                        ), // الفلوس
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('1000 .EGP',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                                              Text('${maxPrice.round()} .EGP',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 24),

                                        Text('Categories', style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 16),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: categories.map((cat) {
                                            final isSelected = cat == selectedCategory;
                                            return GestureDetector(
                                              onTap: () {
                                                setSheetState(() {
                                                  selectedCategory = cat;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: isSelected ? AppColors.primary : Colors.white,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  cat,
                                                  style: TextStyle(
                                                    color: isSelected ? Colors.white : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 24),

                                        Text('Available colors', style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 16),
                                        Row(
                                          children: colors.map((c) {
                                            final isSelected = c == selectedColor;
                                            return GestureDetector(
                                              onTap: () {
                                                setSheetState(() {
                                                  selectedColor = c;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(right: 12),
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 32),


                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: () {
                                              // نفيجيشن الزرار الاخير
                                            },
                                            child: Text(
                                              'Show $count products',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ), //الزرار الاخير
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },

                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.tune, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Stack(
                children: [

                  Positioned(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0 , bottom: 12.0),
                        child: Container(
                                            child: Image.asset('assets/images/banarrr.png'),
                                          ),
                      )),
                  Positioned(
                      left: 28,
                      top: 110,
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.orders),
                        child: Container(height: 40,width: 130,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0),
                                            borderRadius: BorderRadius.circular(8),
                                          ),),
                      ))

                ],
              ),//  الصوره الكبيره

              SingleChildScrollView( ////1
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: [

                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                        context.push(AppRoutes.home);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 0
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    ///////////////////////////////////////////////////////////////////////////222
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                        context.push(AppRoutes.orderConfirmation);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sofas',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 1
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    ///////////////////////////////////////////////////////////////33
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                        context.push(AppRoutes.orderConfirmation);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 2
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Beds',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 2
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////44
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                        context.push(AppRoutes.orderConfirmation);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 3
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tables',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 3
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    //////////////////////////////////////555
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 4;
                        });
                        context.push(AppRoutes.orderConfirmation);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 4
                              ? AppColors.primary
                              :AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Chairs',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 4
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 5;
                        });
                        context.push(AppRoutes.orderConfirmation);
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == 5
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'lighting',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedIndex == 5
                                ? AppColors.surface
                                : const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), // ال 6 زراير بتوع التقليب
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle onTap for 'Featured'
                      },
                      child: Text('Featured', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: AppColors.primary)
                          ,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle onTap for 'See all'
                      },
                      child: Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: AppColors.primary.withOpacity(.8)))
                    )
                  ],
                ),
              ),//see alllll



              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 11,),
                    Container(

                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                            right: 4,
                              top: 3,
                              child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              // onTap: () => context.push(AppRoutes.FavoritesScreen),
                              onTap: () {
                                setState(() {


                                  isFavorite = !isFavorite;
                                });
                              },
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                color: isFavorite ? Colors.red : AppColors.primary,
                                size: 24,
                              ),
                            ),
                          )), //القلب
                          Positioned(
                            top: 80,
                              left: 6,
                              child:
                          Stack(children: [
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.orders),
                              child:
                                Container(
                                  height: 20,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    children: [
                                     Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                      SizedBox(width: 5,),
                                      Text(
                                        'AR',
                                        style: TextStyle(
                                      color: AppColors.surface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                            ),
                          ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 170,
                margin: const EdgeInsets.only(left: 12,right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [

                      AppColors.primary,
                      AppColors.accent,
                    ],
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'CURATED FOR YOU',
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Soft modern,\nnaturally yours',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Shop the look',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/images/Image (Modern living room).png',
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle onTap for 'Featured'
                      },
                      child: Text('Best sellers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: AppColors.primary)
                        ,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          // Handle onTap for 'See all'
                        },
                        child: Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: AppColors.primary.withOpacity(.8)))
                    )
                  ],
                ),
              ),//see alllll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 11,),
                    Container(

                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              color: AppColors.border,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              'assets/images/Generated Image.png',
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ), // صوره المنتج
                          Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  // onTap: () => context.push(AppRoutes.FavoritesScreen),
                                  onTap: () {
                                    setState(() {


                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                    color: isFavorite ? Colors.red : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )), //القلب
                          Positioned(
                              top: 80,
                              left: 6,
                              child:
                              Stack(children: [
                                GestureDetector(
                                    onTap: () => context.push(AppRoutes.orders),
                                    child:
                                    Container(
                                      height: 20,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_box,size: 16,color: AppColors.surface,),
                                          SizedBox(width: 5,),
                                          Text(
                                            'AR',
                                            style: TextStyle(
                                              color: AppColors.surface,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                ),
                              ],)), //ar
                          Positioned(
                            top: 105,
                            left: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // الإضافة دي
                              children: [
                                Text(
                                  'Nordic Sofa',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sofas',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'EGP 18,500',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),//الارقام والاسعار
                        ],
                      ),
                    ), SizedBox(width: 10,),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle onTap for 'Featured'
                      },
                      child: Text('Recommended for you', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.black)
                        ,
                      ),
                    ),

                  ],
                ),
              ),//Recommended for you

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // الكرسى الاخضر
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset('assets/images/green chair.png'),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complements your style',
                                style: TextStyle(color: AppColors.success, fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text('Noma Lounge Chair', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 4),
                              Text(
                                'EGP 6,900',
                                style: TextStyle(color: AppColors.success, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.chevron_right, size: 30),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // ===== المنتج التاني =====
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset('assets/images/Generated Image.png'),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complements your style',
                                style: TextStyle(color: AppColors.success, fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text('Sora Reading Chair', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 4),
                              Text(
                                'EGP 18,500',
                                style: TextStyle(color: AppColors.success, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.orders),
                          child: const Icon(Icons.chevron_right, size: 30),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    //الكرسى الابيض


                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset('assets/images/white chair.png'),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complements your style',
                                style: TextStyle(color: AppColors.success, fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text('Elara Accent Chair', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 4),
                              Text(
                                'EGP 6,900',
                                style: TextStyle(color: AppColors.success, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.chevron_right, size: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              )









            ],
          ),
        ),

      ),


    );
  }
}