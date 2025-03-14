import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

class ShimmerImage extends StatelessWidget {
  final String filePath;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const ShimmerImage({
    Key? key,
    required this.filePath,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(filePath),
          fit: BoxFit.cover,
          width: width,
          height: height,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else if (frame == null) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                  width: width,
                  height: height,
                ),
              );
            } else {
              return child;
            }
          },
        ),
      ),
    );
  }
}
