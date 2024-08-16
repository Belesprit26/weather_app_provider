import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherIconImage extends StatelessWidget {
  const WeatherIconImage({
    Key? key,
    required this.iconUrl,
    required this.size,
  }) : super(key: key);

  final String iconUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: iconUrl,
      width: size,
      height: size,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
