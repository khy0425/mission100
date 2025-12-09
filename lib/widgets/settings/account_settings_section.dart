import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/auth/auth_service.dart';
import '../../models/user_subscription.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import 'elegant_settings_tile.dart';

/// 계정 설정 섹션 위젯
///
/// 계정 정보, 로그인/로그아웃 기능
class AccountSettingsSection extends StatelessWidget {
  final Function(String) showSnackBar;

  const AccountSettingsSection({
    super.key,
    required this.showSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 계정 정보
          Consumer<AuthService>(
            builder: (context, authService, child) {
              final user = authService.currentUser;
              String subtitle;
              if (user != null) {
                subtitle = user.email ?? user.displayName ?? 'User';
              } else {
                subtitle = l10n.guestMode;
              }

              return ElegantSettingsTile(
                icon: Icons.account_circle,
                iconColor: Colors.blue,
                title: l10n.accountInfo,
                subtitle: subtitle,
                onTap: () => _showAccountInfo(context),
              );
            },
          ),
          // 구글 연동 / 로그아웃 / 로그인
          Consumer<AuthService>(
            builder: (context, authService, child) {
              // 익명 사용자인 경우 구글 계정 연동 버튼 표시
              if (authService.isLoggedIn && authService.isAnonymous) {
                return Column(
                  children: [
                    ElegantSettingsTile(
                      icon: Icons.link,
                      iconColor: Colors.green,
                      title: l10n.linkGoogleAccount,
                      subtitle: l10n.linkGoogleAccountDesc,
                      onTap: () => _showGoogleLinkConfirmDialog(context, showSnackBar),
                    ),
                    ElegantSettingsTile(
                      icon: Icons.logout,
                      iconColor: Colors.orange,
                      title: l10n.logoutButton,
                      subtitle: l10n.logoutFromAccount,
                      showDivider: false,
                      onTap: () => _showLogoutConfirmDialog(context, showSnackBar),
                    ),
                  ],
                );
              }
              // 로그인된 경우(비익명)에만 로그아웃 버튼만 표시
              else if (authService.isLoggedIn) {
                return ElegantSettingsTile(
                  icon: Icons.logout,
                  iconColor: Colors.orange,
                  title: l10n.logoutButton,
                  subtitle: l10n.logoutFromAccount,
                  showDivider: false,
                  onTap: () => _showLogoutConfirmDialog(context, showSnackBar),
                );
              } else {
                // 게스트 모드일 때는 로그인 버튼 표시
                return ElegantSettingsTile(
                  icon: Icons.login,
                  iconColor: Colors.blue,
                  title: l10n.loginButton,
                  subtitle: l10n.loginToSaveProgress,
                  showDivider: false,
                  onTap: () => _navigateToLogin(context),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // 계정 정보 표시
  void _showAccountInfo(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.blue),
              const SizedBox(width: 8),
              Text(l10n.accountInfoTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                if (user.displayName != null)
                  _buildInfoRow(
                    l10n.nameLabel,
                    user.displayName!,
                  ),
                if (user.email != null)
                  _buildInfoRow(
                    l10n.emailLabel,
                    user.email!,
                  ),
                _buildInfoRow(
                  l10n.accountTypeLabel,
                  authService.currentSubscription?.type == SubscriptionType.premium
                      ? l10n.premiumAccountType
                      : l10n.freeAccountType,
                ),
                _buildInfoRow(
                  l10n.loginMethodLabel,
                  user.providerData.isNotEmpty
                      ? user.providerData.first.providerId.contains('google')
                          ? l10n.googleMethod
                          : l10n.emailMethod
                      : l10n.emailMethod,
                ),
              ] else ...[
                Text(l10n.guestModeMessage),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.closeButton),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // 구글 계정 연동 확인 다이얼로그
  void _showGoogleLinkConfirmDialog(BuildContext context, Function(String) showSnackBar) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.link, color: Colors.green),
              const SizedBox(width: 8),
              Text(l10n.linkGoogleAccountTitle),
            ],
          ),
          content: Text(l10n.linkGoogleAccountConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // 다이얼로그 닫기
                await _performGoogleLink(context, showSnackBar);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.linkButton),
            ),
          ],
        );
      },
    );
  }

  // 실제 구글 계정 연동 수행
  Future<void> _performGoogleLink(BuildContext context, Function(String) showSnackBar) async {
    final l10n = AppLocalizations.of(context);

    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.linkAnonymousWithGoogle();

      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      if (result.success) {
        showSnackBar(l10n.linkGoogleAccountSuccess);
      } else {
        showSnackBar(result.errorMessage ?? l10n.linkGoogleAccountError);
      }
    } catch (e) {
      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      showSnackBar(l10n.linkGoogleAccountError);
    }
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog(BuildContext context, Function(String) showSnackBar) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logoutTitle),
          content: Text(l10n.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // 다이얼로그 닫기
                await _performLogout(context, showSnackBar);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.logoutButton),
            ),
          ],
        );
      },
    );
  }

  // 실제 로그아웃 수행
  Future<void> _performLogout(BuildContext context, Function(String) showSnackBar) async {
    final l10n = AppLocalizations.of(context);

    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();

      // SharedPreferences 초기화 (선택적)
      final prefs = await SharedPreferences.getInstance();
      // 온보딩 완료 상태는 유지하되, 사용자 관련 데이터만 초기화
      await prefs.remove('user_profile');
      await prefs.remove('workout_history');

      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      // 온보딩 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (Route<dynamic> route) => false,
      );

      showSnackBar(l10n.logoutSuccessMessage);
    } catch (e) {
      if (!context.mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      showSnackBar(l10n.logoutErrorMessage(e.toString()));
    }
  }

  // 로그인 화면으로 이동
  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
