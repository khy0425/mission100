import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// Dream Signs 카드 위젯
///
/// 꿈 심볼, 등장 인물, 장소 표시
class DreamSignsCardWidget extends StatelessWidget {
  final List<String> symbols;
  final List<String> characters;
  final List<String> locations;

  const DreamSignsCardWidget({
    super.key,
    required this.symbols,
    required this.characters,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, size: 20),
                SizedBox(width: 8),
                Text(
                  'Dream Signs',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (symbols.isNotEmpty) ...[
              Text(
                l10n.dreamSymbolsLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.paddingS),
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: symbols
                    .map((symbol) => Chip(
                          label: Text(symbol),
                          avatar: const Icon(Icons.auto_awesome, size: 16),
                          backgroundColor: Colors.purple.shade100,
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],
            if (characters.isNotEmpty) ...[
              Text(
                l10n.dreamCharactersLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.paddingS),
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: characters
                    .map((character) => Chip(
                          label: Text(character),
                          avatar: const Icon(Icons.person, size: 16),
                          backgroundColor: Colors.green.shade100,
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],
            if (locations.isNotEmpty) ...[
              Text(
                l10n.dreamLocationsLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.paddingS),
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: locations
                    .map((location) => Chip(
                          label: Text(location),
                          avatar: const Icon(Icons.location_on, size: 16),
                          backgroundColor: Colors.orange.shade100,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
