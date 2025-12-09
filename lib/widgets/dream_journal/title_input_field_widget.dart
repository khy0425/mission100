import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 제목 입력 필드 위젯
///
/// 꿈 일기 제목을 입력하는 선택적 필드
class TitleInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const TitleInputFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.dreamTitleLabel,
        hintText: l10n.dreamTitleHint,
        prefixIcon: const Icon(Icons.title),
        border: const OutlineInputBorder(),
      ),
      maxLength: 100,
    );
  }
}
