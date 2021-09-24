import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_store/models/category_json.dart';

class AppCardView extends StatefulWidget {
  final CategoryJson data;

  final double maxWidth;

  final String defaultAppIconURL;

  final int colSize;

  final double borderRadiusSize;

  final Color bgColor;

  final double boxPadding;

  final double height;

  final EdgeInsetsGeometry margin;

  final void Function(CategoryJson) onTap;

  AppCardView({
    required this.data,
    required this.maxWidth,
    required this.onTap,
    this.defaultAppIconURL =
        "https://d.store.deepinos.org.cn//store/tools/dde-dock-graphics-plugin/icon.png",
    this.colSize = 3,
    this.borderRadiusSize = 12,
    this.bgColor = Colors.black38,
    this.boxPadding = 4.2,
    this.height = 82,
    this.margin = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 18,
    ),
  });

  @override
  _AppCardViewState createState() => _AppCardViewState();
}

class _AppCardViewState extends State<AppCardView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.data);
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadiusSize),
          ),
        ),
        height: widget.height,
        padding: EdgeInsets.all(widget.boxPadding),
        margin: widget.margin,
        width:
            widget.maxWidth / widget.colSize - (widget.margin.horizontal * 1),
        child: Row(
          children: [
            CachedNetworkImage(
              width: widget.maxWidth / widget.colSize / 3,
              height: double.infinity,
              fit: BoxFit.fitHeight,
              imageUrl: widget.data.icons ?? widget.defaultAppIconURL,
              placeholder: (context, url) => CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                size: 42,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.data.name ?? "",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 32,
                    width: double.infinity,
                    child: Text(
                      widget.data.more ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
