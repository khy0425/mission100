import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucid_dream_100/generated/l10n/app_localizations.dart';
import '../../widgets/settings/account_settings_section.dart';
import '../../widgets/settings/subscription_section.dart';
import '../../widgets/settings/app_info_section.dart';
import '../../services/localization/theme_service.dart';
import '../../utils/config/constants.dart';

class SimpleSettingsScreen extends StatefulWidget {
  const SimpleSettingsScreen({super.key});

  @override
  State<SimpleSettingsScreen> createState() => _SimpleSettingsScreenState();
}

class _SimpleSettingsScreenState extends State<SimpleSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 아름다운 그라데이션 앱바
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.settings,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF2D1F3D),
                            const Color(0xFF1A1625),
                          ]
                        : [
                            const Color(AppColors.primaryColor),
                            const Color(AppColors.secondaryColor),
                            const Color(AppColors.accentColor),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // 몽환적인 원형 장식들
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: -40,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 100,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // 달 아이콘
                    Positioned(
                      top: 50,
                      right: 30,
                      child: Icon(
                        Icons.nightlight_round,
                        size: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    // 별 아이콘들
                    Positioned(
                      top: 70,
                      right: 100,
                      child: Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    Positioned(
                      top: 90,
                      right: 60,
                      child: Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 설정 컨텐츠
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(AppColors.backgroundDark)
                      : const Color(AppColors.backgroundLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 헤더 카드
                      _buildProfileHeader(theme, isDark, l10n),

                      const SizedBox(height: 24),

                      // 외관 설정
                      _buildSectionTitle(l10n.appearanceSettings, Icons.palette, theme),
                      const SizedBox(height: 12),
                      _buildAppearanceSection(theme, isDark, l10n),

                      const SizedBox(height: 24),

                      // 계정 관리 섹션
                      _buildSectionTitle(l10n.accountSettings, Icons.person_outline, theme),
                      const SizedBox(height: 12),
                      _buildElegantCard(
                        child: AccountSettingsSection(
                          showSnackBar: _showSnackBar,
                        ),
                        theme: theme,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // 구독 관리
                      _buildSectionTitle(l10n.subscriptionManagement, Icons.workspace_premium_outlined, theme),
                      const SizedBox(height: 12),
                      _buildElegantCard(
                        child: const SubscriptionSection(),
                        theme: theme,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // 앱 정보
                      _buildSectionTitle(l10n.appInfo, Icons.info_outline, theme),
                      const SizedBox(height: 12),
                      _buildElegantCard(
                        child: AppInfoSection(
                          showSnackBar: _showSnackBar,
                        ),
                        theme: theme,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 40),

                      // 하단 정보
                      _buildFooter(l10n, theme, isDark),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 프로필 헤더 카드
  Widget _buildProfileHeader(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.primaryColor.withOpacity(0.3),
                  theme.primaryColor.withOpacity(0.1),
                ]
              : [
                  theme.primaryColor.withOpacity(0.15),
                  theme.primaryColor.withOpacity(0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.nights_stay_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.mission100Settings,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.customizeAppFeatures,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션 타이틀
  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// 세련된 카드 래퍼
  Widget _buildElegantCard({
    required Widget child,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]!.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : theme.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.grey[800]!
              : theme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  /// 하단 푸터
  Widget _buildFooter(AppLocalizations l10n, ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.copyrightMission100,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: theme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// 외관 설정 섹션 (세련된 디자인)
  Widget _buildAppearanceSection(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900]!.withValues(alpha: 0.5) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : theme.primaryColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.grey[800]!
                  : theme.primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // 다크 모드 토글
              _buildSettingsTile(
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF5C6BC0),
                title: l10n.darkMode,
                subtitle: l10n.darkModeDesc,
                trailing: Switch(
                  value: themeService.isDarkMode,
                  onChanged: (value) async {
                    await themeService.setDarkMode(value);
                    _showSnackBar(value ? l10n.darkModeEnabled : l10n.lightModeEnabled);
                  },
                  activeTrackColor: theme.primaryColor.withValues(alpha: 0.5),
                  activeThumbColor: theme.primaryColor,
                ),
                theme: theme,
                isDark: isDark,
              ),
              Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
              // 테마 색상
              _buildSettingsTile(
                icon: Icons.palette_rounded,
                iconColor: themeService.currentTheme.color,
                title: l10n.colorTheme,
                subtitle: _getThemeDisplayName(themeService.currentTheme),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: themeService.currentTheme.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeService.currentTheme.color.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ],
                ),
                onTap: () => _showThemeColorDialog(themeService, l10n, isDark),
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 세련된 설정 타일
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required ThemeData theme,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  String _getThemeDisplayName(ThemeColor themeColor) {
    switch (themeColor) {
      case ThemeColor.lavender:
        return '연보라 (Lavender)';
      case ThemeColor.purple:
        return '보라 (Purple)';
      case ThemeColor.blue:
        return '파랑 (Blue)';
      case ThemeColor.green:
        return '녹색 (Green)';
      case ThemeColor.orange:
        return '주황 (Orange)';
      case ThemeColor.red:
        return '빨강 (Red)';
      case ThemeColor.teal:
        return '청록 (Teal)';
      case ThemeColor.indigo:
        return '인디고 (Indigo)';
      case ThemeColor.pink:
        return '분홍 (Pink)';
    }
  }

  void _showThemeColorDialog(ThemeService themeService, AppLocalizations l10n, bool isDark) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1625) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들 바
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 타이틀
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.palette_rounded,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.selectColorTheme,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // 색상 그리드
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  children: ThemeColor.values.map((color) {
                    final isSelected = themeService.currentTheme == color;
                    return _buildColorOption(
                      color: color,
                      isSelected: isSelected,
                      themeService: themeService,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// 색상 선택 옵션
  Widget _buildColorOption({
    required ThemeColor color,
    required bool isSelected,
    required ThemeService themeService,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () async {
        await themeService.setThemeColor(color);
        if (mounted) {
          Navigator.pop(context);
          _showSnackBar('${_getThemeDisplayName(color)} 테마가 적용되었습니다');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? color.color.withValues(alpha: 0.15)
              : (isDark ? Colors.grey[850] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              color.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? color.color
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
