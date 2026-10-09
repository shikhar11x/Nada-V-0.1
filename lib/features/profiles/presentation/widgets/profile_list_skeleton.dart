import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';

/// Pulsing placeholder cards shown while profiles load.
class ProfileListSkeleton extends StatefulWidget {
  const ProfileListSkeleton({super.key, this.count = 5});

  final int count;

  @override
  State<ProfileListSkeleton> createState() => _ProfileListSkeletonState();
}

class _ProfileListSkeletonState extends State<ProfileListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _opacity = Tween<double>(begin: 0.4, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the system "remove animations" setting.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading profiles',
      excludeSemantics: true,
      child: FadeTransition(
        opacity: _opacity,
        child: Column(
          children: [
            for (var i = 0; i < widget.count; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              const _SkeletonCard(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bone(width: 52, height: 52, radius: 16),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bone(width: 160, height: 18),
                    SizedBox(height: 10),
                    _Bone(width: 110, height: 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Divider(),
          SizedBox(height: AppSpacing.md),
          _Bone(width: 120, height: 11),
          SizedBox(height: 10),
          _Bone(width: double.infinity, height: 13),
          SizedBox(height: 6),
          _Bone(width: 200, height: 13),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({required this.width, required this.height, this.radius = 8});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardRaised,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}