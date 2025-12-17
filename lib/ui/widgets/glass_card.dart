import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final String glow; // 'none', 'teal', 'blue', etc.

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.opacity = 0.08,
    this.glow = 'none',
  });

  @override
  Widget build(BuildContext context) {
    BoxShadow? shadow;
    if (glow == 'teal') {
      shadow = BoxShadow(
        color: Color(0xFF00F5D4).withValues(alpha: 0.18),
        blurRadius: 38,
        spreadRadius: 0,
        offset: Offset(0, 0),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: shadow != null ? [shadow] : null,
      ),
      child: child,
    );
  }
}
