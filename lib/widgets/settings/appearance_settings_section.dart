import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import 'settings_card_widget.dart';

/// 외관 설정 섹션 위젯
///
/// 다크 모드, 언어, 난이도 설정
class AppearanceSettingsSection extends StatelessWidget {
  final bool darkMode;
  final Function(bool) onDarkModeChanged;
  final Function(String) showSnackBar;

  const AppearanceSettingsSection({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.showSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsCardWidget(
      children: [
        SwitchListTile(
          title: Text(l10n.darkMode),
          subtitle: Text(l10n.useDarkTheme),
          value: darkMode,
          onChanged: onDarkModeChanged,
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.languageSettings),
          subtitle: Text(l10n.korean),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showSnackBar(l10n.languageSettingsComingSoon);
          },
        ),
      ],
    );
  }
}
