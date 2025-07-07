import 'package:flutter/material.dart';

class LightBulb extends StatelessWidget {
  const LightBulb({
    super.key,
    required this.size,
    required this.brightness,
  });

  final double size;
  final double brightness;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Base of Light Bulb
        Padding(
          padding: EdgeInsets.only(top: size * 2 / 5),
          child: Container(
            width: size / 2,
            height: size,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(getAlpha()),
              borderRadius: BorderRadius.circular(size),
            ),
          ),
        ),
        // Glowing Light
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xffffdfca),
            borderRadius: BorderRadius.circular(size),
            boxShadow: [
              if (brightness > 0.8)
                BoxShadow(
                  blurRadius: 64,
                  color: colorScheme.primaryFixed.withAlpha(getAlpha()),
                ),
              if (brightness > 0.5)
                BoxShadow(
                  blurRadius: 32,
                  color: colorScheme.primaryFixed.withAlpha(getAlpha()),
                ),
              if (brightness > 0.3)
                BoxShadow(
                  blurRadius: 16,
                  color: colorScheme.primaryFixed.withAlpha(getAlpha()),
                ),
              if (brightness > 0.01)
                BoxShadow(
                  blurRadius: 8,
                  color: colorScheme.primaryFixed.withAlpha(getAlpha()),
                ),
            ],
          ),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.surface.withAlpha(255 - getAlpha()),
            borderRadius: BorderRadius.circular(size),
          ),
        ),
      ],
    );
  }

  int getAlpha([int minimum = 10]) {
    return (255 * brightness + minimum).round().clamp(0, 255);
  }
}

extension on Color {
  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
