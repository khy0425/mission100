import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 꿈 내용 입력 필드 위젯
///
/// 꿈의 내용을 입력하는 필수 필드 (멀티라인 텍스트)
class ContentInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const ContentInputFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.dreamContentLabel,
        hintText: l10n.dreamContentHint,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 10,
      maxLength: 5000,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.dreamContentRequired;
        }
        return null;
      },
    );
  }
}
