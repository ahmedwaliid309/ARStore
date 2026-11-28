import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// تسجيل الدخول على Firebase Auth. المسؤولة: سارة.
/// الأسماء دي متفق عليها مع باقي التيم، متغيّرهاش من غير ما تبلّغ:
/// isLoggedIn / userName / email / signIn / register / signOut.
/// الإضافات الجديدة (مش بتكسر حاجة قديمة): uid / lastError / sendPasswordReset.
class AuthProvider extends ChangeNotifier {
  /// الـ auth و firestore اختياريين عشان نقدر نبدّلهم بنسخة تجريبية في الـ Tests.
  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance {
    _user = _auth.currentUser;
    // بنسمع لأي تغيير في حالة المستخدم، عشان يفضل مسجّل لما نقفل التطبيق ونفتحه.
    _sub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  StreamSubscription<User?>? _sub;

  User? _user;
  String? _lastError;

  bool get isLoggedIn => _user != null;

  /// الـ uid بتاع المستخدم (باقي التيم بيستخدمه في الطلبات والمفضلة). فاضي لو مفيش مستخدم.
  String get uid => _user?.uid ?? '';

  String get userName {
    final user = _user;
    if (user == null) return '';
    final name = user.displayName?.trim() ?? '';
    if (name.isNotEmpty) return name;
    // لو مفيش اسم متسجل نعرض الجزء اللي قبل @ من الإيميل.
    return (user.email ?? '').split('@').first;
  }

  String get email => _user?.email ?? '';

  /// آخر رسالة خطأ واضحة للمستخدم (null لو العملية الأخيرة نجحت).
  String? get lastError => _lastError;

  void _onAuthChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _lastError = null;
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      _lastError = 'Please enter your email and password.';
      return false;
    }
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      _user = cred.user;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = _messageFor(e);
      return false;
    } catch (_) {
      _lastError = 'Something went wrong. Please try again.';
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _lastError = null;
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    if (cleanName.isEmpty || cleanEmail.isEmpty || password.length < 8) {
      _lastError = 'Please check your details. Password must be at least 8 characters.';
      return false;
    }
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        _lastError = 'Something went wrong. Please try again.';
        return false;
      }

      // تسجيل الاسم في حساب Firebase.
      await user.updateDisplayName(cleanName);
      await user.reload();
      _user = _auth.currentUser;

      // كتابة users/{uid}. لو فشلت الكتابة الحساب نفسه اتعمل، فمنفشلش التسجيل.
      try {
        await _db.collection('users').doc(user.uid).set({
          'name': cleanName,
          'email': cleanEmail,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('AuthProvider: could not write users/${user.uid}: $e');
      }

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = _messageFor(e);
      return false;
    } catch (_) {
      _lastError = 'Something went wrong. Please try again.';
      return false;
    }
  }

  /// بعت لينك إعادة الباسورد على الإيميل.
  Future<bool> sendPasswordReset(String email) async {
    _lastError = null;
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) {
      _lastError = 'Please enter your email.';
      return false;
    }
    try {
      await _auth.sendPasswordResetEmail(email: cleanEmail);
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = _messageFor(e, forReset: true);
      return false;
    } catch (_) {
      _lastError = 'Something went wrong. Please try again.';
      return false;
    }
  }

  void signOut() {
    // بنمسح الحالة فوراً عشان أي شاشة تتبنى بعدها تشوف إنه خرج.
    _user = null;
    _lastError = null;
    notifyListeners();
    unawaited(_auth.signOut());
  }

  /// رسائل الأخطاء الواضحة للمستخدم.
  String _messageFor(FirebaseAuthException e, {bool forReset = false}) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email.';
    // Firebase الجديد ممكن يرجّع invalid-credential للإيميل الغلط والباسورد الغلط.
      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'wrong-password':
        return 'Email or password is incorrect.';
      case 'user-not-found':
        return forReset
            ? 'No account found with this email.'
            : 'Email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'Email sign-in is not enabled yet. Please contact the team.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
