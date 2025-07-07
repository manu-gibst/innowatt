import 'dart:math';
import 'package:flutter/material.dart';

class RoundedTrianglePainter extends CustomPainter {
  RoundedTrianglePainter({
    super.repaint,
    required this.radius,
    required double size,
    required this.color,
    required this.filled,
    required this.strokeWidth,
  }) : circleRadius = size;

  final double radius;
  final double circleRadius;
  final Color color;
  final bool filled;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // assume that width == height
    final width = size.width;
    final center = Offset(width / 2, width / 2);
    path.moveTo(
      center.dx + circleRadius - radius * sin(pi / 3) * tan(pi / 3),
      center.dy - radius * sin(pi / 3),
    );
    path.arcToPoint(
      Offset(
        center.dx + circleRadius - radius * sin(pi / 3) * tan(pi / 3),
        center.dy + radius * sin(pi / 3),
      ),
      radius: Radius.circular(radius),
    );
    path.lineTo(
      center.dx +
          circleRadius * cos(pi * 2 / 3) +
          radius * sin(pi / 3) / tan(pi / 6),
      center.dy +
          circleRadius * sin(pi * 2 / 3) -
          radius * cos(pi / 3) / tan(pi / 6),
    );
    path.arcToPoint(
      Offset(
        center.dx + circleRadius * cos(pi * 2 / 3),
        center.dy + circleRadius * sin(pi * 2 / 3) - radius / tan(pi / 6),
      ),
      radius: Radius.circular(radius),
    );
    path.lineTo(
      center.dx + circleRadius * cos(pi * 4 / 3),
      center.dy + circleRadius * sin(pi * 4 / 3) + radius / tan(pi / 6),
    );
    path.arcToPoint(
      Offset(
        center.dx +
            circleRadius * cos(pi * 4 / 3) +
            radius * sin(pi / 3) / tan(pi / 6),
        center.dy +
            circleRadius * sin(pi * 4 / 3) +
            radius * cos(pi / 3) / tan(pi / 6),
      ),
      radius: Radius.circular(radius),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
