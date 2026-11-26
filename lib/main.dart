import 'package:decora/data/seed_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/product_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/orders_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ⚠️ الملف ده بتاع وليد بس. كل الـ Providers متسجلة هنا من الأول،
// فمحدش يحتاج يعدّل فيه (ده بيمنع الـ Conflicts).

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider<ProductRepository>(create: (_) => ProductRepository()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const DecoraApp(),
    ),
  );
}

class DecoraApp extends StatelessWidget {
  const DecoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // TODO(وليد): حجم الـ Frame في Figma (غيّره لو مختلف)
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Decora',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // عربي RTL. لو التصميم إنجليزي: Locale('en') في الاتنين تحت.
          locale: const Locale('en'),
          supportedLocales: const [Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
