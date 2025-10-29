import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/config/constants.dart';
import '../../../services/localization/theme_service.dart';
import '../../../services/localization/locale_service.dart';

/// 앱 외관 설정을 관리하는 위젯
///
/// 기능:
/// - 다크 모드 토글
/// - 색상 테마 선택
/// - 고대비 모드 설정
/// - 언어 설정
class AppearanceSettingsWidget extends StatelessWidget {
  final bool darkMode;
  final bool adaptiveTheme;
  final bool highContrastMode;
  final String currentTheme;
  final Locale currentLocale;
  final VoidCallback? onLanguageDialogPressed;

  const AppearanceSettingsWidget({
    super.key,
    required this.darkMode,
    required this.adaptiveTheme,
    required this.highContrastMode,
    required this.currentTheme,
    required this.currentLocale,
    this.onLanguageDialogPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return _buildSettingsSection(
      AppLocalizations.of(context).appearanceSettings,
      [
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return _buildSwitchSetting(
              AppLocalizations.of(context).darkMode,
              AppLocalizations.of(context).darkModeDesc,
              themeService.isDarkMode,
              Icons.dark_mode,
              (value) async {
                await themeService.setDarkMode(value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? AppLocalizations.of(context).darkModeEnabled
                            : AppLocalizations.of(context).lightModeEnabled,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          },
        ),
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return _buildSwitchSetting(
              AppLocalizations.of(context).adaptiveTheme,
              AppLocalizations.of(context).adaptiveThemeDesc,
              themeService.isAdaptiveTheme,
              Icons.brightness_auto,
              (value) async {
                await themeService.setAdaptiveTheme(value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? AppLocalizations.of(context).followingSystemSettings
                            : AppLocalizations.of(context).manualSettingsEnabled,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          },
        ),
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return _buildTapSetting(
              AppLocalizations.of(context).colorTheme,
              _getThemeDisplayName(themeService.currentTheme.name),
              Icons.palette,
              () => _showThemeDialog(context, themeService),
            );
          },
        ),
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return _buildSwitchSetting(
              AppLocalizations.of(context).highContrastMode,
              AppLocalizations.of(context).highContrastModeDesc,
              themeService.isHighContrastMode,
              Icons.contrast,
              (value) async {
                await themeService.setHighContrastMode(value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? AppLocalizations.of(context).highContrastEnabled
                            : AppLocalizations.of(context).highContrastDisabled,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          },
        ),
        _buildTapSetting(
          AppLocalizations.of(context).languageSettings,
          AppLocalizations.of(
            context,
          ).currentLanguage(LocaleService.getLocaleName(currentLocale)),
          Icons.language,
          onLanguageDialogPressed ?? () {},
        ),
      ],
    );
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

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? const Color(AppColors.primaryColor) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: enabled ? Colors.grey[600] : Colors.grey[400],
            fontSize: 13,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeThumbColor: const Color(AppColors.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'blue':
        return 'Blue';
      case 'green':
        return 'Green';
      case 'orange':
        return 'Orange';
      case 'purple':
        return 'Purple';
      case 'red':
        return 'Red';
      default:
        return 'Blue';
    }
  }

  ThemeColor _getThemeColorFromString(String theme) {
    switch (theme) {
      case 'blue':
        return ThemeColor.blue;
      case 'green':
        return ThemeColor.green;
      case 'orange':
        return ThemeColor.orange;
      case 'purple':
        return ThemeColor.purple;
      case 'red':
        return ThemeColor.red;
      default:
        return ThemeColor.blue;
    }
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    ThemeService themeService,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        final themes = ['blue', 'green', 'orange', 'purple', 'red'];
        final themeNames = {
          'blue': l10n.themeBlue,
          'green': l10n.themeGreen,
          'orange': l10n.themeOrange,
          'purple': l10n.themePurple,
          'red': l10n.themeRed,
        };

        return AlertDialog(
          title: Text(l10n.selectColorTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themes.map((theme) {
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getThemeColor(theme),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                title: Text(themeNames[theme] ?? theme),
                trailing: themeService.currentTheme.name.toLowerCase() == theme
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  final themeColor = _getThemeColorFromString(theme);
                  await themeService.setTheme(themeColor);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).themeApplied(themeNames[theme]!),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
