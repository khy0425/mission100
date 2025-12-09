import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 날짜 선택 필드 위젯
///
/// 날짜 선택 다이얼로그를 표시하는 카드형 ListTile
class DatePickerFieldWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerFieldWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(l10n.dreamDate),
        subtitle: Text(
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
        ),
        trailing: const Icon(Icons.edit),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onDateChanged(picked);
          }
        },
      ),
    );
  }
}
