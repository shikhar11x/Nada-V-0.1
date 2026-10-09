import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';

/// Small plum pill such as "1st" or "2nd".
class DegreeBadge extends StatelessWidget {
  const DegreeBadge({super.key, required this.degree});

  final int degree;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${ordinal(degree)} degree',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.plum,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          ordinal(degree),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}