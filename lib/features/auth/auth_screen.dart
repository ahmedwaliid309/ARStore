import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/theme/app_colors.dart';
import 'package:decora/providers/auth_provider.dart';

/// خطوات الشاشة (كل خطوة = فريم في Figma).
enum _AuthStep { login, register, forgotEmail }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Form key منفصل لكل خطوة عشان الحقول ما تتلخبطش لما نبدّل بينهم.
  final Map<_AuthStep, GlobalKey<FormState>> _formKeys = {
    for (final s in _AuthStep.values) s: GlobalKey<FormState>(),
  };

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  _AuthStep _step = _AuthStep.login;
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirm = true;
  String? _errorMessage;
  String? _infoMessage;

  bool get _isLogin => _step == _AuthStep.login;

  @override
  void initState() {
    super.initState();
    // لو المستخدم لسه مسجّل (Firebase فاكره) ندخّله على الـ Home بدل ما يسجّل تاني.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<AuthProvider>().isLoggedIn) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ───────── Logic ─────────

  /// Here we move between steps and clear sensitive fields and old errors.
  void _goTo(_AuthStep step) {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    _passwordController.clear();
    _confirmController.clear();
    setState(() {
      _step = step;
      _errorMessage = null;
      _infoMessage = null;
      _hidePassword = true;
      _hideConfirm = true;
    });
  }

  /// Here we validate, call AuthProvider, then handle Loading / Error / Success.
  Future<void> _submitAuth() async {
    FocusScope.of(context).unfocus();
    if (!_formKeys[_step]!.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthProvider>();
    bool success = false;
    try {
      final email = _emailController.text.trim();
      success = _isLogin
          ? await auth.signIn(email, _passwordController.text)
          : await auth.register(
        _nameController.text.trim(),
        email,
        _passwordController.text,
      );
    } catch (_) {
      success = false;
    }

    // مهم: بعد أي await لازم نتأكد إن الشاشة لسه موجودة قبل استخدام context.
    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = auth.lastError ??
            (_isLogin
                ? 'Could not log in. Please check your email and password.'
                : 'Could not create your account. Please check your details.');
      });
    }
  }

  /// Forgot password: بنبعت لينك على الإيميل (Firebase)، من غير OTP.
  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();
    if (!_formKeys[_AuthStep.forgotEmail]!.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    final auth = context.read<AuthProvider>();
    final ok = await auth.sendPasswordReset(_emailController.text);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (ok) {
        _infoMessage = 'Reset link sent. Please check your inbox.';
      } else {
        _errorMessage =
            auth.lastError ?? 'Could not send the link. Please try again.';
      }
    });
  }

  /// زرار لسه مفيش له Backend (Google).
  void _comingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  // ───────── Validators ─────────

  String? _validateName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Please enter your name' : null;

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Please enter a valid email';
  }

  /// الباسورد 8 حروف على الأقل (Login و Register و Reset).
  static const int _minPasswordLength = 8;

  String? _validateLoginPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter your password';
    return v.length < _minPasswordLength ? 'At least 8 characters' : null;
  }

  String? _validateNewPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter a password';
    return v.length < _minPasswordLength ? 'At least 8 characters' : null;
  }

  String? _validateConfirm(String? v) =>
      v != _passwordController.text ? 'Passwords do not match' : null;

  // ───────── Build ─────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(23.w, 16.h, 23.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogo(),
              SizedBox(height: 24.h),
              _buildStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _AuthStep.login:
        return _buildLogin();
      case _AuthStep.register:
        return _buildRegister();
      case _AuthStep.forgotEmail:
        return _buildForgotEmail();
    }
  }

  // ───────── Steps ─────────

  Widget _buildLogin() {
    return Form(
      key: _formKeys[_AuthStep.login],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            eyebrow: 'WELCOME BACK',
            title: 'Make yourself at home',
            subtitle: 'Sign in to continue your design journey.',
          ),
          SizedBox(height: 32.h),
          _emailField(),
          SizedBox(height: 16.h),
          _labeledField(
            label: 'Password',
            labelColor: AppColors.textPrimary,
            controller: _passwordController,
            hint: 'At least 8 characters',
            icon: Icons.lock_outline,
            validator: _validateLoginPassword,
            obscure: _hidePassword,
            onToggleObscure: () =>
                setState(() => _hidePassword = !_hidePassword),
          ),
          SizedBox(height: 14.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () => _goTo(_AuthStep.forgotEmail),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 17 / 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 12.h),
            _buildError(_errorMessage!),
          ],
          SizedBox(height: 24.h),
          _primaryButton(
            label: 'Login',
            onPressed: _isLoading ? null : _submitAuth,
            loading: _isLoading,
          ),
          SizedBox(height: 16.h),
          _buildDivider(),
          SizedBox(height: 16.h),
          _googleButton(),
          SizedBox(height: 40.h),
          _buildFooter(
            text: "Don't have an account?",
            action: 'Register',
            onTap: () => _goTo(_AuthStep.register),
          ),
        ],
      ),
    );
  }

  Widget _buildRegister() {
    return Form(
      key: _formKeys[_AuthStep.register],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            eyebrow: 'JOIN DECORA',
            title: 'Create your account',
            subtitle: 'Start designing a space that feels like you.',
          ),
          SizedBox(height: 32.h),
          _labeledField(
            label: 'Full name',
            controller: _nameController,
            hint: 'your name',
            icon: Icons.person_outline,
            validator: _validateName,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16.h),
          _emailField(),
          SizedBox(height: 16.h),
          _labeledField(
            label: 'Password',
            controller: _passwordController,
            hint: 'At least 8 characters',
            icon: Icons.lock_outline,
            validator: _validateNewPassword,
            obscure: _hidePassword,
            onToggleObscure: () =>
                setState(() => _hidePassword = !_hidePassword),
          ),
          SizedBox(height: 16.h),
          _labeledField(
            label: 'Confirm Password',
            controller: _confirmController,
            hint: 'At least 8 characters',
            icon: Icons.lock_outline,
            validator: _validateConfirm,
            obscure: _hideConfirm,
            onToggleObscure: () =>
                setState(() => _hideConfirm = !_hideConfirm),
          ),
          // موجودة في فريم Register في Figma.
          SizedBox(height: 14.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () => _goTo(_AuthStep.forgotEmail),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 17 / 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 12.h),
            _buildError(_errorMessage!),
          ],
          SizedBox(height: 24.h),
          // النصوص زي فريم Figma حرفيًا (الزرار "Login" والفوتر "Register").
          _primaryButton(
            label: 'Login',
            onPressed: _isLoading ? null : _submitAuth,
            loading: _isLoading,
          ),
          SizedBox(height: 16.h),
          _buildDivider(),
          SizedBox(height: 16.h),
          _googleButton(),
          SizedBox(height: 40.h),
          // الضغطة هنا بترجّع لـ Login عشان المستخدم ما يتحبسش في Register.
          _buildFooter(
            text: "Don't have an account?",
            action: 'Register',
            onTap: () => _goTo(_AuthStep.login),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotEmail() {
    return Form(
      key: _formKeys[_AuthStep.forgotEmail],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            eyebrow: 'ACCOUNT RECOVERY',
            title: 'Reset your password',
            subtitle: "Enter your email and we'll send you a secure reset link.",
            subtitleSize: 12,
            subtitleWeight: FontWeight.w400,
          ),
          SizedBox(height: 32.h),
          _emailField(),
          if (_errorMessage != null) ...[
            SizedBox(height: 12.h),
            _buildError(_errorMessage!),
          ],
          if (_infoMessage != null) ...[
            SizedBox(height: 12.h),
            _buildInfo(_infoMessage!),
          ],
          SizedBox(height: 24.h),
          _primaryButton(
            label: 'Send Reset Link',
            onPressed: _isLoading ? null : _sendResetLink,
            loading: _isLoading,
          ),
          SizedBox(height: 18.h),
          Center(
            child: GestureDetector(
              onTap: () => _goTo(_AuthStep.login),
              child: Text(
                'Back to sign in',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 17 / 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Reusable pieces ─────────

  // لوجو Decora الكامل (100×52 زي Figma). لو الملف مش موجود بنرجع للأيقونة
  // القديمة، ولو دي كمان مش موجودة بنعرض نص.
  Widget _buildLogo() {
    return SizedBox(
      height: 52.h,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 100.w,
          height: 52.h,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/Group 47.png',
            height: 52.h,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              'decora',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// العنوان الصغير + العنوان الكبير + الوصف (متكرر في كل الفريمات).
  Widget _buildHeader({
    required String eyebrow,
    required String title,
    required String subtitle,
    double subtitleSize = 14,
    FontWeight subtitleWeight = FontWeight.w500,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: TextStyle(
            fontSize: 11.sp,
            height: 13 / 11,
            letterSpacing: 0.44,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 28.sp,
            height: 34 / 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: subtitleSize.sp,
            fontWeight: subtitleWeight,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
    return _labeledField(
      label: 'Email address',
      controller: _emailController,
      hint: 'you@email.com',
      icon: Icons.mail_outline,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  /// Label صغير فوق الحقل (12) وبعده Gap 6 زي Figma.
  Widget _labeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    Color labelColor = AppColors.primary,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, height: 15 / 12, color: labelColor),
        ),
        SizedBox(height: 6.h),
        _field(
          controller: controller,
          hint: hint,
          icon: icon,
          validator: validator,
          keyboardType: keyboardType,
          obscure: obscure,
          onToggleObscure: onToggleObscure,
        ),
      ],
    );
  }

  /// Input بمقاسات Figma: ارتفاع 56 و Radius 12 و Border 0.5.
  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: 0.5),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscure,
      enabled: !_isLoading,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w, end: 10.w),
          child: Icon(icon, size: 23.sp, color: AppColors.textSecondary),
        ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: onToggleObscure == null
            ? null
            : GestureDetector(
          onTap: onToggleObscure,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w, end: 16.w),
            // Figma بيعرض العين العادية والباسورد مخفي.
            child: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 23.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(),
        contentPadding: EdgeInsetsDirectional.only(
          end: 16.w,
          top: 16.h,
          bottom: 16.h,
        ),
        errorStyle: TextStyle(fontSize: 12.sp, color: AppColors.error),
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        disabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error),
      ),
    );
  }

  Widget _buildError(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 18.sp, color: AppColors.error),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 13.sp, color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, size: 18.sp, color: AppColors.success),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 13.sp, color: AppColors.success),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        // أثناء Loading بنخلي اللون زي ما هو، وفي غير كده الزرار باهت.
        disabledBackgroundColor:
        loading ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4),
        disabledForegroundColor: AppColors.onPrimary,
        minimumSize: Size(double.infinity, 54.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
      child: loading
          ? SizedBox(
        width: 22.r,
        height: 22.r,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.onPrimary,
        ),
      )
          : Text(label),
    );
  }

  // أيقونة Google من assets/images/google_icon.png. لو الملف لسه مش موجود
  // بنعرض حرف G بلون الهوية بدالها.
  Widget _googleButton() {
    return OutlinedButton(
      onPressed: _isLoading ? null : _comingSoon,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        minimumSize: Size(double.infinity, 54.h),
        side: const BorderSide(color: AppColors.primary, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google_icon.png',
            width: 23.sp,
            height: 23.sp,
            errorBuilder: (_, __, ___) => Text(
              'G',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          const Text('Continue with Google'),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final line = Expanded(
      child: Container(height: 1, color: AppColors.border),
    );
    return Row(
      children: [
        line,
        SizedBox(width: 12.w),
        Text(
          'or continue with',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
        SizedBox(width: 12.w),
        line,
      ],
    );
  }

  Widget _buildFooter({
    required String text,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}