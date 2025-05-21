import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamzabooking/utils/colors.dart';

class CachedImageWidget extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  const CachedImageWidget(
    this.image,
    this.width,
    this.height,
    this.fit, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
      errorWidget:
          (context, url, error) => Image.asset(
            "assets/images/logo.png",
            height: height,
            width: width,
            fit: fit,
          ),
    );
  }
}
