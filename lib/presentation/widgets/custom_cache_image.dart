import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCacheImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  const CustomCacheImage({
    super.key,
    required this.imgUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      height: height,
      width: width,
      fit: fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      errorWidget: (child, url, obj) => Icon(Icons.broken_image_outlined),
      progressIndicatorBuilder:
          (child, url, progress) => Skeletonizer(
            enabled: true,
            child: Container(
              width: width,
              height: height,
              color: Colors.grey[300],
            ),
          ),
    );
  }
}
