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
              fontWeight: FontWeight.w700,
              letterSpacing: size * 0.2,
              height: 1,
              color: AppColors.burgundy,
            ),
          ),
          SizedBox(height: size * 0.25),
          Container(width: size * 1.4, height: 2, color: AppColors.gold),
        ],
      ),
    );
  }
}