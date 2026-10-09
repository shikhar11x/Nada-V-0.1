import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';

/// Typographic wordmark. Not an official logo, just styled text.
class NadaWordmark extends StatelessWidget {
  const NadaWordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'NADA',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NADA',
            style: TextStyle(
              fontFamily: AppTheme.serifFamily,
              fontSize: size,
              fontWeight: FontWeight.w800,
              letterSpacing: size * 0.18,
              height: 1,
              color: AppColors.cream,
            ),
          ),
          SizedBox(height: size * 0.28),
          Container(
            width: size * 1.1,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.plumLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}