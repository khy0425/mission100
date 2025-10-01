import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../screens/legal_document_screen.dart';

/// 앱 정보 및 기타 설정을 담당하는 위젯
///
/// 기능:
/// - 버전 정보 표시
/// - 개발자 정보 및 연락처
/// - 라이선스 정보
/// - 개인정보 처리방침
/// - 서비스 이용약관
/// - 피드백 보내기
class AboutSettingsWidget extends StatelessWidget {
  const AboutSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSettingsSection(AppLocalizations.of(context).aboutSettings, [
      _buildTapSetting(
        AppLocalizations.of(context).versionInfo,
        AppLocalizations.of(context).versionInfoDesc,
        Icons.info,
        () => _showVersionDialog(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).developerInfo,
        AppLocalizations.of(context).developerInfoDesc,
        Icons.code,
        () => _showDeveloperDialog(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).licenseInfo,
        AppLocalizations.of(context).licenseInfoDesc,
        Icons.description,
        () => _showLicensePage(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).privacyPolicy,
        AppLocalizations.of(context).privacyPolicyDesc,
        Icons.privacy_tip,
        () => _openPrivacyPolicy(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).termsOfService,
        AppLocalizations.of(context).termsOfServiceDesc,
        Icons.article,
        () => _openTermsOfService(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).sendFeedback,
        AppLocalizations.of(context).sendFeedbackDesc,
        Icons.feedback,
        () => _sendFeedback(context),
      ),
    ]);
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.primaryColor),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTapSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isDestructive ? Colors.red : const Color(AppColors.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }

  void _showVersionDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(AppColors.primaryColor),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).versionInfo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(
                  AppColors.primaryColor,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💪 ${packageInfo.appName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Localizations.localeOf(context).languageCode == 'ko'
                        ? '버전: ${packageInfo.version}'
                        : 'Version: ${packageInfo.version}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Localizations.localeOf(context).languageCode == 'ko'
                        ? '빌드: ${packageInfo.buildNumber}'
                        : 'Build: ${packageInfo.buildNumber}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Localizations.localeOf(context).languageCode == 'ko'
                        ? '패키지: ${packageInfo.packageName}'
                        : 'Package: ${packageInfo.packageName}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(AppLocalizations.of(context).joinChadJourney),
            const SizedBox(height: 8),
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? '6주 만에 100개 푸쉬업 달성!\n차드가 되는 여정을 함께하세요! 🔥'
                  : 'Achieve 100 pushups in 6 weeks!\nJoin the Chad journey! 🔥',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // 기술 스택 정보
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? '기술 스택:'
                  : 'Tech Stack:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('• Flutter 3.8.0+'),
            const Text('• Dart 3.0+'),
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? '• SQLite 로컬 데이터베이스'
                  : '• SQLite Local Database',
            ),
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? '• Provider 상태 관리'
                  : '• Provider State Management',
            ),
            const Text('• Google Mobile Ads'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).confirm),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showLicensePage(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primaryColor),
              foregroundColor: Colors.white,
            ),
            child: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? '라이선스'
                  : 'Licenses',
            ),
          ),
        ],
      ),
    );
  }

  void _showDeveloperDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Color(AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).developerInfo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(
                  AppColors.primaryColor,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💪 Mission: 100',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context).appVersion}: ${packageInfo.version}',
                  ),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context).builtWithFlutter),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(AppLocalizations.of(context).madeWithLove),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).supportChadJourney),
            const SizedBox(height: 16),

            // 개발자 연락처
            Text(
              AppLocalizations.of(context).developerContact,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // GitHub 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openGitHub(context),
                icon: const Icon(Icons.code, size: 20),
                label: Text(AppLocalizations.of(context).githubRepository),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 피드백 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _sendFeedback(context),
                icon: const Icon(Icons.email, size: 20),
                label: Text(AppLocalizations.of(context).sendFeedback),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppColors.primaryColor),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  void _showLicensePage(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Mission: 100 Chad Pushup',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(AppColors.primaryColor),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.fitness_center, size: 32, color: Colors.white),
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final locale = Localizations.localeOf(context).languageCode;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocumentScreen(
          title: '개인정보처리방침',
          documentPath: 'assets/legal/privacy_policy_$locale.md',
        ),
      ),
    );
  }

  Future<void> _openTermsOfService(BuildContext context) async {
    final locale = Localizations.localeOf(context).languageCode;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocumentScreen(
          title: '이용약관',
          documentPath: 'assets/legal/terms_of_service_$locale.md',
        ),
      ),
    );
  }

  /// GitHub 저장소 열기
  Future<void> _openGitHub(BuildContext context) async {
    const githubUrl = 'https://github.com/khy0425';
    final uri = Uri.parse(githubUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).cannotOpenGithub),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('GitHub 열기 실패: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).cannotOpenGithub),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 피드백 이메일 보내기
  Future<void> _sendFeedback(BuildContext context) async {
    const email = 'osu355@gmail.com';
    final subject = Localizations.localeOf(context).languageCode == 'ko'
        ? 'Mission 100 Chad Pushup 피드백'
        : 'Mission 100 Chad Pushup Feedback';
    final body = Localizations.localeOf(context).languageCode == 'ko'
        ? '안녕하세요! Mission 100 Chad Pushup 앱에 대한 피드백을 보내드립니다.\n\n'
        : 'Hello! I am sending feedback about the Mission 100 Chad Pushup app.\n\n';

    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).cannotOpenEmail),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('이메일 열기 실패: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).cannotOpenEmail),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
