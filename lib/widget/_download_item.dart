import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../_enum.dart';
import '_appicon.dart';
import '_pbar.dart';

class DownloadTaskItem extends StatefulWidget {
  final Map<String, dynamic> data;

  final void Function(DownloadRightAction Action) onTap;
  DownloadTaskItem({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  _DownloadTaskItemState createState() => _DownloadTaskItemState();
}

class _DownloadTaskItemState extends State<DownloadTaskItem> {
  Map<String, dynamic> get item {
    return widget.data;
  }

  String get humanTotalSizeAndDownloadSize {
    double t = item['total_size'] * 1.0;
    double d = item['download_size'] * 1.0;
    if (t == d) return 'Downloaded';
    var _beforeT = 'MB';
    var _beforeD = 'MB';
    if (t >= 1024) {
      t = t / 1024;
      _beforeT = 'GB';
    }
    if (d >= 1024) {
      d = d / 1024;
      _beforeD = 'GB';
    }
    var _t = t.toStringAsFixed(2);
    if (d == 0) return '${_t} ${_beforeT}';
    var _d = d.toStringAsFixed(2);
    return '${_d} ${_beforeD}/${_t} ${_beforeT}';
  }

  double get percentage {
    var _ = ((100 / item['total_size']) * item['download_size']) / 100;
    return _;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Center(
              child: AppIcon(
                fit: BoxFit.cover,
                width: 42,
                height: 42,
                url: item['icon'],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 160,
                    child: Text(
                      item['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    children: [
                      CupertinoProgressBar(
                        value: percentage,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        humanTotalSizeAndDownloadSize,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          !(item['is_download'] ?? false)
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.onTap(DownloadRightAction.download);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (item['start_download'] ?? false)
                            ? CupertinoIcons.pause_circle
                            : CupertinoIcons.cloud_download,
                        semanticLabel: 'download',
                      ),
                    ],
                  ),
                )
              : PushButton(
                  child: Text('Copy Code'),
                  buttonSize: ButtonSize.large,
                  onPressed: () async {
                    await FlutterClipboard.copy(
                        'sudo dpkg -i ${item['filepath']} || apt install -yf || dpkg -P ${item['filepath']}');
                  },
                ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              widget.onTap(DownloadRightAction.remove);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.delete,
                  semanticLabel: 'download',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
