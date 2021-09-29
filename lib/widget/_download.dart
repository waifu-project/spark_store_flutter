import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spark_store/_enum.dart';
import 'package:spark_store/utils/loadsh.dart';

import '_download_item.dart';

class Dmanaer extends StatefulWidget {
  final String tmpFolder;

  final double width;

  final double height;

  final List<Map<String, dynamic>> tasks;

  final void Function(DownloadRightAction action, int index) onTap;

  Dmanaer({
    Key? key,
    this.tmpFolder = "/tmp/_store",
    required this.width,
    required this.height,
    required this.tasks,
    required this.onTap,
  }) : super(key: key);

  @override
  _DmanaerState createState() => _DmanaerState();
}

class _DmanaerState extends State<Dmanaer> {
  // List<DownloadTask> _tasks = [];

  bool get _rootCacheFolderIf {
    var _ = Directory(widget.tmpFolder);
    return _.existsSync();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(widget.tasks.length, (index) {
                    return DownloadTaskItem(
                      data: widget.tasks[index],
                      onTap: (tap) {
                        widget.onTap(tap, index);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!_rootCacheFolderIf) return;
              var _target = "file://${widget.tmpFolder}";
              wrapperXdgOpen(_target);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              child: Text(
                "open download directory",
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
