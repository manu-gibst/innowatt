import 'package:flutter/material.dart';

const double bigRadius = 20;
const double smallRadius = 10;

class ChatBubbleClipWithTail extends CustomClipper<Path> {
  const ChatBubbleClipWithTail({
    required this.rightRadius,
    required this.leftRadius,
    required this.tailRadiusAndOffset,
    this.upperLeftRadius,
    this.upperRightRadius,
    this.tailOnRight = true,
    this.showTail = false,
  });
  final double leftRadius;
  final double rightRadius;

  /// Functions as a tail radius and offset
  final double tailRadiusAndOffset;
  final double? upperLeftRadius;
  final double? upperRightRadius;
  final bool tailOnRight;
  final bool showTail;

  @override
  Path getClip(Size size) {
    if (showTail) {
      return !tailOnRight
          ? getLeftPathWithTail(size)
          : getRightPathWithTail(size);
    }
    return getPathWithoutTail(size);
  }

  Path getRightPathWithTail(Size size) {
    return Path()
      ..moveTo(leftRadius, 0)
      ..lineTo(
          size.width - (upperRightRadius ?? rightRadius) - tailRadiusAndOffset,
          0)
      ..arcToPoint(
        Offset(
            size.width - tailRadiusAndOffset, upperRightRadius ?? rightRadius),
        radius: Radius.circular(upperRightRadius ?? rightRadius),
      )
      ..lineTo(size.width - tailRadiusAndOffset, size.height - rightRadius)
      ..arcToPoint(
        Offset(size.width, size.height),
        radius: Radius.circular(tailRadiusAndOffset),
        clockwise: false,
      )
      ..lineTo(leftRadius, size.height)
      ..arcToPoint(
        Offset(0, size.height - leftRadius),
        radius: Radius.circular(leftRadius),
      )
      ..lineTo(0, leftRadius)
      ..arcToPoint(
        Offset(leftRadius, 0),
        radius: Radius.circular(leftRadius),
      );
  }

  Path getLeftPathWithTail(Size size) {
    return Path()
      ..moveTo(upperLeftRadius ?? leftRadius, 0)
      ..lineTo(size.width - rightRadius, 0)
      ..arcToPoint(
        Offset(size.width, rightRadius),
        radius: Radius.circular(rightRadius),
      )
      ..lineTo(size.width, size.height - rightRadius)
      ..arcToPoint(
        Offset(size.width - rightRadius, size.height),
        radius: Radius.circular(rightRadius),
      )
      ..lineTo(0, size.height)
      ..arcToPoint(
        Offset(tailRadiusAndOffset, size.height - tailRadiusAndOffset),
        radius: Radius.circular(tailRadiusAndOffset),
        clockwise: false,
      )
      ..lineTo(tailRadiusAndOffset, upperLeftRadius ?? leftRadius)
      ..arcToPoint(
        Offset((upperLeftRadius ?? leftRadius) + tailRadiusAndOffset, 0),
        radius: Radius.circular(upperLeftRadius ?? leftRadius),
      );
  }

  Path getPathWithoutTail(Size size) {
    return Path()
      ..moveTo(tailRadiusAndOffset + (upperLeftRadius ?? leftRadius), 0)
      ..lineTo(
          size.width - (upperRightRadius ?? rightRadius) - tailRadiusAndOffset,
          0)
      ..arcToPoint(
        Offset(size.width - tailRadiusAndOffset,
            (upperRightRadius ?? rightRadius)),
        radius: Radius.circular(upperRightRadius ?? rightRadius),
      )
      ..lineTo(size.width - tailRadiusAndOffset, size.height - rightRadius)
      ..arcToPoint(
        Offset(size.width - rightRadius - tailRadiusAndOffset, size.height),
        radius: Radius.circular(rightRadius),
      )
      ..lineTo(tailRadiusAndOffset + leftRadius, size.height)
      ..arcToPoint(
        Offset(tailRadiusAndOffset, size.height - leftRadius),
        radius: Radius.circular(leftRadius),
      )
      ..lineTo(tailRadiusAndOffset, (upperLeftRadius ?? leftRadius))
      ..arcToPoint(
        Offset(tailRadiusAndOffset + (upperLeftRadius ?? leftRadius), 0),
        radius: Radius.circular(upperLeftRadius ?? leftRadius),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
