import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8d4d2d),
      surfaceTint: Color(0xff8d4d2d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdbcc),
      onPrimaryContainer: Color(0xff351000),
      secondary: Color(0xff765749),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdbcc),
      onSecondaryContainer: Color(0xff2c160b),
      tertiary: Color(0xff8f4c37),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdbd0),
      onTertiaryContainer: Color(0xff3a0b00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff221a16),
      onSurfaceVariant: Color(0xff52443d),
      outline: Color(0xff85736c),
      outlineVariant: Color(0xffd7c2ba),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2a),
      inversePrimary: Color(0xffffb694),
      primaryFixed: Color(0xffffdbcc),
      onPrimaryFixed: Color(0xff351000),
      primaryFixedDim: Color(0xffffb694),
      onPrimaryFixedVariant: Color(0xff703718),
      secondaryFixed: Color(0xffffdbcc),
      onSecondaryFixed: Color(0xff2c160b),
      secondaryFixedDim: Color(0xffe6bead),
      onSecondaryFixedVariant: Color(0xff5c4033),
      tertiaryFixed: Color(0xffffdbd0),
      onTertiaryFixed: Color(0xff3a0b00),
      tertiaryFixedDim: Color(0xffffb59f),
      onTertiaryFixedVariant: Color(0xff723522),
      surfaceDim: Color(0xffe8d6d0),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffceae3),
      surfaceContainerHigh: Color(0xfff6e5de),
      surfaceContainerHighest: Color(0xfff0dfd8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6c3314),
      surfaceTint: Color(0xff8d4d2d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa86341),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff583c30),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8e6d5e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff6d311e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffaa614b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff221a16),
      onSurfaceVariant: Color(0xff4e4039),
      outline: Color(0xff6c5c55),
      outlineVariant: Color(0xff897770),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2a),
      inversePrimary: Color(0xffffb694),
      primaryFixed: Color(0xffa86341),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8a4b2b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8e6d5e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff745547),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffaa614b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff8c4935),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d0),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffceae3),
      surfaceContainerHigh: Color(0xfff6e5de),
      surfaceContainerHighest: Color(0xfff0dfd8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff401500),
      surfaceTint: Color(0xff8d4d2d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6c3314),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff331d11),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff583c30),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff431203),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6d311e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2d211c),
      outline: Color(0xff4e4039),
      outlineVariant: Color(0xff4e4039),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2a),
      inversePrimary: Color(0xffffe7de),
      primaryFixed: Color(0xff6c3314),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4f1e02),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff583c30),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3f271b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6d311e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff511c0b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d0),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffceae3),
      surfaceContainerHigh: Color(0xfff6e5de),
      surfaceContainerHighest: Color(0xfff0dfd8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme customDarkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // Primary Colors
      primary: Color.fromARGB(255, 187, 77, 33),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color.fromARGB(255, 218, 96, 47),
      onPrimaryContainer: Color.fromARGB(255, 33, 9, 6),
      // Other Primary variations
      primaryFixed: Color.fromARGB(255, 233, 79, 13),
      onPrimaryFixed: Color.fromARGB(255, 20, 9, 4),
      primaryFixedDim: Color.fromARGB(255, 156, 14, 14),
      onPrimaryFixedVariant: Color.fromARGB(255, 26, 9, 9),
      // Secondary colors
      secondary: Color.fromARGB(255, 174, 123, 172),
      onSecondary: Color.fromARGB(255, 14, 10, 17),
      secondaryContainer: Color.fromARGB(255, 100, 71, 89),
      onSecondaryContainer: Color(0xfff5e6ff),
      // Other Secondary variations
      secondaryFixed: Color(0xffecddf8),
      onSecondaryFixed: Color(0xff20182b),
      secondaryFixedDim: Color(0xffd0c1db),
      onSecondaryFixedVariant: Color(0xff4d4358),
      // Tertiary colors
      tertiary: Color(0xffd3c1d5),
      onTertiary: Color(0xff382c3c),
      tertiaryContainer: Color(0xff3d3040),
      onTertiaryContainer: Color(0xffd1bed2),
      // Other Tertiary variations
      tertiaryFixed: Color(0xfff0dcf1),
      onTertiaryFixed: Color(0xff231826),
      tertiaryFixedDim: Color(0xffd3c1d5),
      onTertiaryFixedVariant: Color(0xff504253),
      // Error colors
      error: Color.fromARGB(255, 234, 86, 70),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      // Surface colors
      surfaceDim: Color(0xff141313),
      surface: Color.fromARGB(255, 23, 22, 22),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0f0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2b2a2a),
      surfaceContainerHighest: Color(0xff363434),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color.fromARGB(255, 141, 132, 136),
      // Other Surface variations
      outline: Color(0xff978e93),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      onInverseSurface: Color.fromARGB(255, 43, 42, 41),
      inversePrimary: Color(0xff9b4513),
      outlineVariant: Color(0xff4b4549),
      surfaceTint: Color(0xffffb694),
      scrim: Color(0xff000000),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb694),
      surfaceTint: Color(0xffffb694),
      onPrimary: Color(0xff542104),
      primaryContainer: Color(0xff703718),
      onPrimaryContainer: Color(0xffffdbcc),
      secondary: Color(0xffe6bead),
      onSecondary: Color(0xff432a1e),
      secondaryContainer: Color(0xff5c4033),
      onSecondaryContainer: Color(0xffffdbcc),
      tertiary: Color(0xffffb59f),
      onTertiary: Color(0xff561f0e),
      tertiaryContainer: Color(0xff723522),
      onTertiaryContainer: Color(0xffffdbd0),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a120e),
      onSurface: Color(0xfff0dfd8),
      onSurfaceVariant: Color(0xffd7c2ba),
      outline: Color(0xffa08d85),
      outlineVariant: Color(0xff52443d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd8),
      inversePrimary: Color(0xff8d4d2d),
      primaryFixed: Color(0xffffdbcc),
      onPrimaryFixed: Color(0xff351000),
      primaryFixedDim: Color(0xffffb694),
      onPrimaryFixedVariant: Color(0xff703718),
      secondaryFixed: Color(0xffffdbcc),
      onSecondaryFixed: Color(0xff2c160b),
      secondaryFixedDim: Color(0xffe6bead),
      onSecondaryFixedVariant: Color(0xff5c4033),
      tertiaryFixed: Color(0xffffdbd0),
      onTertiaryFixed: Color(0xff3a0b00),
      tertiaryFixedDim: Color(0xffffb59f),
      onTertiaryFixedVariant: Color(0xff723522),
      surfaceDim: Color(0xff1a120e),
      surfaceBright: Color(0xff423732),
      surfaceContainerLowest: Color(0xff140c09),
      surfaceContainerLow: Color(0xff221a16),
      surfaceContainer: Color(0xff271e1a),
      surfaceContainerHigh: Color(0xff322824),
      surfaceContainerHighest: Color(0xff3d332e),
    );
  }

  ThemeData dark() {
    return theme(customDarkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffbb9d),
      surfaceTint: Color(0xffffb694),
      onPrimary: Color(0xff2c0c00),
      primaryContainer: Color(0xffc97e5a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffebc2b1),
      onSecondary: Color(0xff251107),
      secondaryContainer: Color(0xffad8979),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffbba6),
      onTertiary: Color(0xff310700),
      tertiaryContainer: Color(0xffcb7c64),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120e),
      onSurface: Color(0xfffff9f8),
      onSurfaceVariant: Color(0xffdcc6be),
      outline: Color(0xffb39f97),
      outlineVariant: Color(0xff927f78),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd8),
      inversePrimary: Color(0xff723819),
      primaryFixed: Color(0xffffdbcc),
      onPrimaryFixed: Color(0xff240900),
      primaryFixedDim: Color(0xffffb694),
      onPrimaryFixedVariant: Color(0xff5c2709),
      secondaryFixed: Color(0xffffdbcc),
      onSecondaryFixed: Color(0xff1f0c04),
      secondaryFixedDim: Color(0xffe6bead),
      onSecondaryFixedVariant: Color(0xff4a3024),
      tertiaryFixed: Color(0xffffdbd0),
      onTertiaryFixed: Color(0xff280500),
      tertiaryFixedDim: Color(0xffffb59f),
      onTertiaryFixedVariant: Color(0xff5d2513),
      surfaceDim: Color(0xff1a120e),
      surfaceBright: Color(0xff423732),
      surfaceContainerLowest: Color(0xff140c09),
      surfaceContainerLow: Color(0xff221a16),
      surfaceContainer: Color(0xff271e1a),
      surfaceContainerHigh: Color(0xff322824),
      surfaceContainerHighest: Color(0xff3d332e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f8),
      surfaceTint: Color(0xffffb694),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffbb9d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffebc2b1),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffbba6),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f8),
      outline: Color(0xffdcc6be),
      outlineVariant: Color(0xffdcc6be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd8),
      inversePrimary: Color(0xff4c1b01),
      primaryFixed: Color(0xffffe1d4),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffbb9d),
      onPrimaryFixedVariant: Color(0xff2c0c00),
      secondaryFixed: Color(0xffffe1d4),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffebc2b1),
      onSecondaryFixedVariant: Color(0xff251107),
      tertiaryFixed: Color(0xffffe0d8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffbba6),
      onTertiaryFixedVariant: Color(0xff310700),
      surfaceDim: Color(0xff1a120e),
      surfaceBright: Color(0xff423732),
      surfaceContainerLowest: Color(0xff140c09),
      surfaceContainerLow: Color(0xff221a16),
      surfaceContainer: Color(0xff271e1a),
      surfaceContainerHigh: Color(0xff322824),
      surfaceContainerHighest: Color(0xff3d332e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
