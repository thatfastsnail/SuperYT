import 'package:flutter/material.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    required this.height,
    required this.width,
    this.borderRadius,
    this.margin,
    this.aspectRatio,
    Key? key
  }) : super(key: key);
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final double? aspectRatio;
  @override
  Widget build(BuildContext context) {
    return aspectRatio != null
      ? AspectRatio(
          aspectRatio: aspectRatio!,
          child: Container(
            height: height,
            width: width,
            margin: margin ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.zero,
              color: Theme.of(context).scaffoldBackgroundColor
            ),
          ),
        )
      : Container(
          height: height,
          width: width,
          margin: margin ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.zero,
            color: Theme.of(context).scaffoldBackgroundColor
          ),
        );
  }
}