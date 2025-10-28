import 'package:flutter/material.dart';

/// Chad 진화 단계 아이템 위젯
class ChadStageItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final String requirement;
  final bool isUnlocked;
  final bool isCurrent;
  final bool showConnector;

  const ChadStageItem({
    super.key,
    required this.name,
    required this.imagePath,
    required this.requirement,
    required this.isUnlocked,
    required this.isCurrent,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Chad 이미지
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent
                      ? const Color(0xFFFFD43B)
                      : isUnlocked
                          ? const Color(0xFF51CF66)
                          : Colors.grey,
                  width: 3,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: (isCurrent
                                  ? const Color(0xFFFFD43B)
                                  : const Color(0xFF51CF66))
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: ColorFiltered(
                  colorFilter: isUnlocked
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCurrent
                              ? const Color(0xFFFFD43B)
                              : isUnlocked
                                  ? const Color(0xFF51CF66)
                                  : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCurrent) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD43B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ko'
                                ? '현재'
                                : 'Current',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] else if (isUnlocked) ...[
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF51CF66),
                          size: 16,
                        ),
                      ] else ...[
                        const Icon(Icons.lock, color: Colors.grey, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    requirement,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showConnector) ...[
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 2,
            height: 20,
            color: isUnlocked
                ? const Color(0xFF51CF66).withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
        ] else ...[
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
