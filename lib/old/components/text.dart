import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final Color? decorationColor;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  const MyText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.decorationColor,
    this.maxLines,
    this.softWrap,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: softWrap,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none,
        decorationColor: decorationColor ?? Colors.black,
      ),
    );
  }
}
