import 'package:flutter/foundation.dart';

/// تسجيل الدخول. المسؤولة: سارة.
/// دلوقتي وهمي (أي إيميل وباسورد مش فاضيين يعدّي). لاحقاً Firebase Auth.
/// الأسماء دي متفق عليها مع باقي التيم، متغيّرهاش من غير ما تبلّغ.
class AuthProvider extends ChangeNotifier {
  String? _userName;
  String? _email;

  bool get isLoggedIn => _userName != null;
  String get userName => _userName ?? '';
  String get email => _email ?? '';

  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.trim().isEmpty || password.isEmpty) return false;
    _email = email.trim();
    _userName = email.trim().split('@').first;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (name.trim().isEmpty || email.trim().isEmpty || password.length < 6) {
      return false;
    }
    _email = email.trim();
    _userName = name.trim();
    notifyListeners();
    return true;
  }

  void signOut() {
    _userName = null;
    _email = null;
    notifyListeners();
  }
}
