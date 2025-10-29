import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/chad_onboarding_service.dart';
import '../../widgets/chad_onboarding_widget.dart';
import '../../utils/constants.dart';
import '../../generated/app_localizations.dart';
import 'chad_signup_screen.dart';
import '../misc/permission_screen.dart';

class ChadLoginScreen extends StatefulWidget {
  const ChadLoginScreen({super.key});

  @override
  State<ChadLoginScreen> createState() => _ChadLoginScreenState();
}

class _ChadLoginScreenState extends State<ChadLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      } else {
        _showErrorSnackBar(result.errorMessage!);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signInWithGoogle();

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      } else {
        _showErrorSnackBar(result.errorMessage ?? '구글 로그인에 실패했습니다.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: ChadOnboardingWidget(
            stepType: 'goalSetupComplete',
            title: 'Chad와 함께 시작할 준비 완료!',
            description: '이제 Chad AI 개인 트레이너와 함께\nMission: 100을 시작해보세요!',
            customContent: _buildLoginContent(context),
            onNext: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChadSignupScreen(),
                ),
              );
            },
            buttonText: 'Chad와 함께 시작하기',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        // Chad 특별 혜택 박스
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            ),
          ),
          child: const Column(
            children: [
              Text(
                '🎉 Chad 런칭 특가!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Chad AI 트레이너 1개월 무료 체험\n지금 가입하면 무료로 시작!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 이미 계정이 있다면
        Text(
          '이미 Chad 계정이 있다면?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),

        const SizedBox(height: 16),

        // 로그인 폼
        Form(
          key: _formKey,
          child: Column(
            children: [
              // 이메일 입력
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: '이메일',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요';
                  }
                  if (!value.contains('@')) {
                    return '올바른 이메일 주소를 입력해주세요';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 비밀번호 입력
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 6자 이상이어야 합니다';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // 구글 로그인
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.login, size: 20);
                    },
                  ),
                  label: const Text('구글로 로그인'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
