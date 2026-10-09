import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';

/// Logo mark + typographic "NADA".
class NadaWordmark extends StatelessWidget {
  const NadaWordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'NADA',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_mark.png',
            width: size * 1.25,
            height: size * 1.25,
            excludeFromSemantics: true,
            // If the asset is ever missing, show the text alone, not a crash.
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
          SizedBox(width: size * 0.4),
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
        ],
      ),
    );
  }
}