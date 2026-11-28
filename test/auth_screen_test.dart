import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/features/auth/auth_screen.dart';
import 'package:decora/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// AuthProvider وهمي: مفيش Firebase في الاختبارات، بنتحكم في النتيجة بإيدينا.
class FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  bool loggedIn = false;
  bool signInResult = true;
  bool registerResult = true;
  bool resetResult = true;

  // آخر قيم وصلت للـ Provider (عشان نتأكد إن الشاشة بتبعت الصح).
  String? sentEmail;
  String? sentPassword;
  String? sentName;
  int signInCalls = 0;
  int registerCalls = 0;
  int resetCalls = 0;

  @override
  String? lastError;

  @override
  bool get isLoggedIn => loggedIn;

  @override
  String get uid => loggedIn ? 'test-uid' : '';

  @override
  String get userName => loggedIn ? 'Test User' : '';

  @override
  String get email => loggedIn ? 'test@email.com' : '';

  @override
  Future<bool> signIn(String email, String password) async {
    signInCalls++;
    sentEmail = email;
    sentPassword = password;
    return signInResult;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    registerCalls++;
    sentName = name;
    sentEmail = email;
    sentPassword = password;
    return registerResult;
  }

  @override
  Future<bool> sendPasswordReset(String email) async {
    resetCalls++;
    sentEmail = email;
    return resetResult;
  }

  @override
  void signOut() {
    loggedIn = false;
    notifyListeners();
  }
}

/// الخط الافتراضي في الاختبارات (Ahem) أعرض بكتير من الخط الحقيقي، فبعض الصفوف
/// (زرار Google والفوتر) بتطلع "Overflow" في الاختبار بس، ومش مشكلة في التطبيق.
/// عشان كده بنتجاهل أخطاء الـ overflow بس، وأي خطأ تاني بيفشّل الاختبار عادي.
void ignoreOverflowErrors() {
  final original = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

/// بيشغّل AuthScreen جوه Router صغير، وشاشة Home وهمية عشان نتأكد من التنقل.
Future<FakeAuthProvider> pumpAuthScreen(
    WidgetTester tester, {
      FakeAuthProvider? auth,
    }) async {
  ignoreOverflowErrors();
  final fake = auth ?? FakeAuthProvider();

  // مقاس موبايل زي تصميم Figma (390×844).
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutes.auth,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const Scaffold(body: Text('HOME_SCREEN')),
      ),
    ],
  );

  await tester.pumpWidget(
    ChangeNotifierProvider<AuthProvider>.value(
      value: fake,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (_, __) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}

/// بيدوّر على رسالة الخطأ الحمرا بس. الـ hint 'At least 8 characters' موجود
/// دايماً في الحقل، فـ find.text لوحدها هتلاقي الاتنين.
Finder validationError(String message) => find.byWidgetPredicate(
      (w) => w is Text && w.data == message && w.style?.color == AppColors.error,
);

/// بيكتب في الحقل رقم [index] (الترتيب من فوق لتحت).
Future<void> typeInField(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(TextFormField).at(index), text);
  await tester.pump();
}

/// بيدوس على زرار Login/Register الأساسي.
Future<void> tapPrimary(WidgetTester tester, String label) async {
  final button = find.widgetWithText(ElevatedButton, label);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

/// بيضغط على لينك نصي (زي Register أو Forgot password) من غير ما يعتمد على
/// مكانه في الشاشة: بننادي onTap بتاع أقرب GestureDetector مباشرة. (بسبب الخط
/// العريض في الاختبارات، الفوتر ممكن يطلع برّه الشاشة فالضغطة العادية ما توصلوش.)
Future<void> tapLink(WidgetTester tester, String text) async {
  final detector = find.ancestor(
    of: find.text(text),
    matching: find.byType(GestureDetector),
  );
  tester.widget<GestureDetector>(detector.first).onTap!();
  await tester.pumpAndSettle();
}

/// بينتقل من Login لـ Register (بالضغط على "Register" في الفوتر).
Future<void> goToRegister(WidgetTester tester) async {
  await tapLink(tester, 'Register');
}

void main() {
  group('Login screen', () {
    testWidgets('shows the Login texts and Forgot password', (tester) async {
      await pumpAuthScreen(tester);

      expect(find.text('Make yourself at home'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
    });

    testWidgets('empty fields show validation errors and do not call signIn',
            (tester) async {
          final auth = await pumpAuthScreen(tester);

          await tapPrimary(tester, 'Login');

          expect(find.text('Please enter your email'), findsOneWidget);
          expect(find.text('Please enter your password'), findsOneWidget);
          expect(auth.signInCalls, 0);
        });

    testWidgets('invalid email shows an error', (tester) async {
      final auth = await pumpAuthScreen(tester);

      await typeInField(tester, 0, 'not-an-email');
      await typeInField(tester, 1, '12345678');
      await tapPrimary(tester, 'Login');

      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(auth.signInCalls, 0);
    });

    testWidgets('password shorter than 8 characters is rejected',
            (tester) async {
          final auth = await pumpAuthScreen(tester);

          await typeInField(tester, 0, 'sara@email.com');
          await typeInField(tester, 1, 'a');
          await tapPrimary(tester, 'Login');

          expect(validationError('At least 8 characters'), findsOneWidget);
          expect(auth.signInCalls, 0);
        });

    testWidgets('successful login trims the email and goes to Home',
            (tester) async {
          final auth = await pumpAuthScreen(tester);

          await typeInField(tester, 0, '  sara@email.com  ');
          await typeInField(tester, 1, 'password123');
          await tapPrimary(tester, 'Login');

          expect(auth.signInCalls, 1);
          expect(auth.sentEmail, 'sara@email.com');
          expect(auth.sentPassword, 'password123');
          expect(find.text('HOME_SCREEN'), findsOneWidget);
        });

    testWidgets('failed login shows the provider error and stays here',
            (tester) async {
          final auth = FakeAuthProvider()
            ..signInResult = false
            ..lastError = 'Email or password is incorrect.';
          await pumpAuthScreen(tester, auth: auth);

          await typeInField(tester, 0, 'sara@email.com');
          await typeInField(tester, 1, 'wrongpass123');
          await tapPrimary(tester, 'Login');

          expect(find.text('Email or password is incorrect.'), findsOneWidget);
          expect(find.text('HOME_SCREEN'), findsNothing);
        });

    testWidgets('an already logged in user goes straight to Home',
            (tester) async {
          final auth = FakeAuthProvider()..loggedIn = true;
          await pumpAuthScreen(tester, auth: auth);

          expect(find.text('HOME_SCREEN'), findsOneWidget);
        });
  });

  group('Register screen', () {
    testWidgets('has the right texts and no Forgot password', (tester) async {
      await pumpAuthScreen(tester);
      await goToRegister(tester);

      expect(find.text('Create your account'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Forgot password?'), findsNothing);
    });

    testWidgets('Login link in the footer goes back to Login',
            (tester) async {
          await pumpAuthScreen(tester);
          await goToRegister(tester);

          await tapLink(tester, 'Login');

          expect(find.text('Make yourself at home'), findsOneWidget);
        });

    testWidgets('passwords that do not match are rejected', (tester) async {
      final auth = await pumpAuthScreen(tester);
      await goToRegister(tester);

      await typeInField(tester, 0, 'Sara');
      await typeInField(tester, 1, 'sara@email.com');
      await typeInField(tester, 2, 'password123');
      await typeInField(tester, 3, 'different123');
      await tapPrimary(tester, 'Register');

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(auth.registerCalls, 0);
    });

    testWidgets('password shorter than 8 characters is rejected',
            (tester) async {
          final auth = await pumpAuthScreen(tester);
          await goToRegister(tester);

          await typeInField(tester, 0, 'Sara');
          await typeInField(tester, 1, 'sara@email.com');
          await typeInField(tester, 2, 'short');
          await typeInField(tester, 3, 'short');
          await tapPrimary(tester, 'Register');

          expect(validationError('At least 8 characters'), findsOneWidget);
          expect(auth.registerCalls, 0);
        });

    testWidgets('empty name is rejected', (tester) async {
      final auth = await pumpAuthScreen(tester);
      await goToRegister(tester);

      await typeInField(tester, 1, 'sara@email.com');
      await typeInField(tester, 2, 'password123');
      await typeInField(tester, 3, 'password123');
      await tapPrimary(tester, 'Register');

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(auth.registerCalls, 0);
    });

    testWidgets('valid data registers (trimmed) and goes to Home',
            (tester) async {
          final auth = await pumpAuthScreen(tester);
          await goToRegister(tester);

          await typeInField(tester, 0, '  Sara  ');
          await typeInField(tester, 1, '  sara@email.com ');
          await typeInField(tester, 2, 'password123');
          await typeInField(tester, 3, 'password123');
          await tapPrimary(tester, 'Register');

          expect(auth.registerCalls, 1);
          expect(auth.sentName, 'Sara');
          expect(auth.sentEmail, 'sara@email.com');
          expect(find.text('HOME_SCREEN'), findsOneWidget);
        });

    testWidgets('failed register shows the provider error', (tester) async {
      final auth = FakeAuthProvider()
        ..registerResult = false
        ..lastError = 'This email is already registered. Try logging in.';
      await pumpAuthScreen(tester, auth: auth);
      await goToRegister(tester);

      await typeInField(tester, 0, 'Sara');
      await typeInField(tester, 1, 'sara@email.com');
      await typeInField(tester, 2, 'password123');
      await typeInField(tester, 3, 'password123');
      await tapPrimary(tester, 'Register');

      expect(
        find.text('This email is already registered. Try logging in.'),
        findsOneWidget,
      );
      expect(find.text('HOME_SCREEN'), findsNothing);
    });
  });

  group('Forgot password', () {
    Future<void> openForgot(WidgetTester tester) async {
      await tapLink(tester, 'Forgot password?');
    }

    testWidgets('opens the reset screen without OTP steps', (tester) async {
      await pumpAuthScreen(tester);
      await openForgot(tester);

      expect(find.text('Reset your password'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Back to sign in'), findsOneWidget);
    });

    testWidgets('invalid email is rejected', (tester) async {
      final auth = await pumpAuthScreen(tester);
      await openForgot(tester);

      await typeInField(tester, 0, 'nope');
      await tapPrimary(tester, 'Send Reset Link');

      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(auth.resetCalls, 0);
    });

    testWidgets('valid email sends the link and shows a success message',
            (tester) async {
          final auth = await pumpAuthScreen(tester);
          await openForgot(tester);

          await typeInField(tester, 0, ' sara@email.com ');
          await tapPrimary(tester, 'Send Reset Link');

          expect(auth.resetCalls, 1);
          expect(find.text('Reset link sent. Please check your inbox.'),
              findsOneWidget);
        });

    testWidgets('failure shows the provider error', (tester) async {
      final auth = FakeAuthProvider()
        ..resetResult = false
        ..lastError =
            'No internet connection. Please check your network and try again.';
      await pumpAuthScreen(tester, auth: auth);
      await openForgot(tester);

      await typeInField(tester, 0, 'sara@email.com');
      await tapPrimary(tester, 'Send Reset Link');

      expect(
        find.text(
            'No internet connection. Please check your network and try again.'),
        findsOneWidget,
      );
    });

    testWidgets('Back to sign in returns to Login', (tester) async {
      await pumpAuthScreen(tester);
      await openForgot(tester);

      await tapLink(tester, 'Back to sign in');

      expect(find.text('Make yourself at home'), findsOneWidget);
    });
  });
}