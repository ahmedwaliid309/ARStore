import 'package:go_router/go_router.dart';

import '../../features/ar_view/ar_view_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/compare/my_ar_shot.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/order_confirmation/order_confirmation_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/product_details/product_details_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../widgets/main_shell.dart';

/// كل المسارات في مكان واحد. استخدمها بدل كتابة النص يدوي:
///   context.go(AppRoutes.home);                    // انتقال (يمسح اللي قبله)
///   context.push(AppRoutes.productPath('1'));      // فتح شاشة فوق اللي قبلها
///   context.push(AppRoutes.products, extra: 'كنب'); // قايمة المنتجات بتصنيف
///   context.pop();                                 // رجوع
/// ⚠️ الملف ده بتاع وليد بس. لو محتاج Route جديد ابعتله.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const auth = '/auth';

  // التابات الأربعة (جوه الـ Bottom Nav)
  static const home = '/home';
  static const favorites = '/favorites';
  static const cart = '/cart';
  static const profile = '/profile';

  // شاشات بتتفتح فوق التابات
  static const products = '/products'; // extra: اسم التصنيف (اختياري)
  static const productDetails = '/product/:id';
  static const ar = '/ar/:id';
  static const checkout = '/checkout';
  static const orderConfirmation = '/order-confirmation/:id';
  static const orders = '/orders';
  static const settings = '/settings';
  static const arShots = '/ar-shots';

  static String productPath(String id) => '/product/$id';
  static String arPath(String id) => '/ar/$id';
  static String orderConfirmationPath(String id) => '/order-confirmation/$id';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) {
          final extra = state.extra;
          return ProductsScreen(category: extra is String ? extra : null);
        },
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) =>
            ProductDetailsScreen(productId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.ar,
        builder: (context, state) =>
            ArViewScreen(productId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmation,
        builder: (context, state) => OrderConfirmationScreen(
          orderId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.arShots,
        builder: (context, state) => const MyArShotsScreen(),
      ),

      // التابات الأربعة. ترتيب الـ Branches = ترتيب الـ destinations في main_shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}