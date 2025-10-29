import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 페이지 헤더
class PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PageHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 60,
          color: const Color(AppColors.primaryColor),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
