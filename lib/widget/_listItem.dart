import 'package:flutter/material.dart';
import 'package:spark_store/utils/loadsh.dart';

class ListSubItem extends StatefulWidget {
  final String title;

  final String content;

  bool get contentIsURL {
    return isURL(content);
  }

  final Color titleColor;

  final Color contentColor;

  final EdgeInsets margin;

  ListSubItem({
    required this.title,
    required this.content,

    // TODO auto dark color change
    this.titleColor = Colors.white54,
    this.contentColor = Colors.white,
    this.margin = const EdgeInsets.symmetric(
      vertical: 2,
    ),
  });

  @override
  _ListSubItemState createState() => _ListSubItemState();
}

class _ListSubItemState extends State<ListSubItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: RichText(
        text: TextSpan(
            text: '${widget.title}: ',
            style: TextStyle(
              color: widget.titleColor,
            ),
            children: [
              TextSpan(
                text: widget.content,
                style: TextStyle(
                  color: widget.contentColor,
                ),
              ),
            ]),
      ),
    );
  }
}
