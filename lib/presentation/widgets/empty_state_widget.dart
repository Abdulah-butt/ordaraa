import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/extensions/theme_extension.dart';

class EmptyStateWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorTheme;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = 0.98 + (_pulse.value * 0.04);
        final translateY = -3 + (_pulse.value * 6);
        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withValues(alpha: 0.12),
              ),
              child: Icon(
                widget.icon,
                color: colorScheme.secondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
