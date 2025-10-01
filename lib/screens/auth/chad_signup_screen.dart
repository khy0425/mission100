import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/chad_onboarding_service.dart';
import '../../widgets/chad_onboarding_widget.dart';
import '../../utils/constants.dart';
import '../permission_screen.dart';
import 'chad_login_screen.dart';

class ChadSignupScreen extends StatefulWidget {
  const ChadSignupScreen({super.key});

  @override
  State<ChadSignupScreen> createState() => _ChadSignupScreenState();
}

class _ChadSignupScreenState extends State<ChadSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      _showErrorSnackBar('이용약관에 동의해주세요.');
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        // Chad 개인화 데이터 적용
        final chadService =
            Provider.of<ChadOnboardingService>(context, listen: false);
        await chadService.applyPersonalizationImmediately();

        _showSuccessSnackBar('Chad와 함께하는 Mission: 100에 오신 것을 환영합니다!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      } else {
        _showErrorSnackBar(result.errorMessage!);
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signInWithGoogle();

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        // Chad 개인화 데이터 적용
        final chadService =
            Provider.of<ChadOnboardingService>(context, listen: false);
        await chadService.applyPersonalizationImmediately();

        _showSuccessSnackBar('Chad와 함께하는 Mission: 100에 오신 것을 환영합니다!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      } else {
        _showErrorSnackBar(result.errorMessage ?? '구글 회원가입에 실패했습니다.');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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
          child: SingleChildScrollView(
            child: Consumer<ChadOnboardingService>(
              builder: (context, chadService, child) {
                return ChadOnboardingWidget(
                  stepType: 'goalSetupComplete',
                  title: 'Chad AI 트레이너 가입하기',
                  description: chadService.getSignupMotivationMessage(),
                  customContent: _buildSignupContent(context),
                  onNext: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate() &&
                              _agreeTerms) {
                            await _handleSignUp();
                          } else if (!_agreeTerms) {
                            _showErrorSnackBar('이용약관에 동의해주세요.');
                          }
                        },
                  buttonText: _isLoading ? '가입 중...' : 'Chad와 1개월 무료 시작!',
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupContent(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Chad 무료 체험 혜택 강조
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  '🎉 런칭 기념 특가!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Chad AI 개인 트레이너 1개월 무료\n• 개인 맞춤 운동 계획\n• Chad 회복 관리 시스템\n• 언제든 취소 가능',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // 구글 회원가입 (우선 배치)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleSignUp,
              icon: Image.asset(
                'assets/images/google_logo.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.login, size: 24);
                },
              ),
              label: const Text('구글로 3초만에 시작하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppColors.primaryColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 또는 구분선
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[400])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '또는 이메일로 가입',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[400])),
            ],
          ),

          const SizedBox(height: 20),

          // 이름 입력
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '이름',
              prefixIcon: const Icon(Icons.person_outlined),
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
                return '이름을 입력해주세요';
              }
              if (value.length < 2) {
                return '이름은 2자 이상이어야 합니다';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

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

          // 비밀번호 확인
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
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
                return '비밀번호를 다시 입력해주세요';
              }
              if (value != _passwordController.text) {
                return '비밀번호가 일치하지 않습니다';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // 이용약관 동의
          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeTerms = value ?? false;
                  });
                },
                activeColor: const Color(AppColors.primaryColor),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _agreeTerms = !_agreeTerms;
                    });
                  },
                  child: const Text(
                    '이용약관 및 개인정보처리방침에 동의합니다',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 이미 계정이 있는 경우 로그인 링크
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('이미 Chad 계정이 있나요?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ChadLoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    color: Color(AppColors.primaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
