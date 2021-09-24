import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spark_store/config.dart';
import 'package:spark_store/utils/loadsh.dart';

class AppIcon extends StatefulWidget {
  final String? url;

  /// TODO impl the option
  /// [cache] use [CachedNetworkImage]
  ///
  /// if app icon ext is `svg` the option is not `work`!
  final bool cache;

  final double width;

  final double height;

  final BoxFit fit;

  /// render svg the options it `work`!!
  // final Color color;

  AppIcon({
    Key? key,
    required this.url,
    this.cache = true,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.fitHeight,
    // this.color = Colors.white,
  }) : super(key: key);

  @override
  _AppIconState createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  String get _appIcon {
    var url = widget.url;
    if (url == null) return DefaultAppIcon;
    if (url == '' || !isURL(url) || !url.startsWith("http")) {
      return DefaultAppIcon;
    }
    return url;
  }

  bool get canBeRenderSVG {
    var url = widget.url ?? DefaultAppIcon;
    return url.endsWith(".svg");
  }

  @override
  Widget build(BuildContext context) {
    if (canBeRenderSVG) {
      return SvgPicture.network(
        widget.url ?? DefaultAppIcon,
        width: widget.width,
        // height: 40, //widget.height,
      );
    }
    return CachedNetworkImage(
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      imageUrl: _appIcon,
      placeholder: (context, url) => CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        size: 42,
      ),
    );
  }
}
