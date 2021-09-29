import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spark_store/_enum.dart';
import 'package:spark_store/models/category_json.dart';
import 'package:spark_store/utils/dpkg.dart';
import 'package:spark_store/widget/_listItem.dart';

import '_appicon.dart';

class DetailPage extends StatefulWidget {
  final CategoryJson data;

  final double maxWidth;

  final void Function(AptCenterAction action) onAppTap;

  DetailPage({
    Key? key,
    required this.maxWidth,
    required this.data,
    required this.onAppTap,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double calcSwiperHeigth(Size size) {
    double _zoomFlag = .5;
    var _h = size.height;
    if (_h >= 1000) return 400;
    return _h * _zoomFlag;
  }

  List<String> get _banners {
    var _ = widget.data.imgUrls ?? "[]";
    List<String> _result = jsonDecode(_).cast<String>();
    return _result;
  }

  bool get _bannerCanbeRender {
    return _banners.length >= 1;
  }

  double get _appIconSize {
    double _m = 120;
    double _n = 40;
    double _w = widget.maxWidth;
    double _offset = _w / 8;
    if (_offset > _m) return _m;
    if (_offset < _n) return _n;
    return _offset;
  }

  bool _appCanInstall = false;

  @override
  void initState() {
    setState(() {
      _appCanInstall = DpkgUtil.appCanInstalled(widget.data.pkgname);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    AppIcon(
                      url: widget.data.icons,
                      width: _appIconSize,
                      height: _appIconSize,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    PushButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: Colors.blue,
                      child: Text(_appCanInstall ? 'Reinstall' : 'Install'),
                      buttonSize: ButtonSize.large,
                      onPressed: () {
                        var action = _appCanInstall ? AptCenterAction.Reinstall : AptCenterAction.Install;
                        widget.onAppTap(action);
                      },
                    ),
                    _appCanInstall
                        ? SizedBox(
                            height: 12,
                          )
                        : SizedBox.shrink(),
                    _appCanInstall
                        ? PushButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            color: Colors.black38,
                            child: Text('UnInstall'),
                            buttonSize: ButtonSize.large,
                            onPressed: () {
                              widget.onAppTap(AptCenterAction.Uninstall);
                            },
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(
                width: 42,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        widget.data.name ?? "",
                        style: TextStyle(
                          fontSize: 32,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ListSubItem(
                      title: 'PkgName',
                      content: widget.data.pkgname ?? "",
                    ),
                    ListSubItem(
                      title: 'Version',
                      content: widget.data.version ?? "",
                    ),
                    ListSubItem(
                      title: 'Author',
                      content: widget.data.author ?? "",
                    ),
                    ListSubItem(
                      title: 'Official Site',
                      content: widget.data.website ?? "",
                    ),
                    ListSubItem(
                      title: 'Contributor',
                      content: widget.data.contributor ?? "",
                    ),
                    ListSubItem(
                      title: 'Update Time',
                      content: widget.data.update ?? "",
                    ),
                    ListSubItem(
                      title: 'Installed Size',
                      content: widget.data.size ?? "",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 42,
          ),
          Text(
            "Info",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(widget.data.more ?? ""),
          SizedBox(
            height: 12,
          ),
          !_bannerCanbeRender
              ? SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Screenshots",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      height: calcSwiperHeigth(MediaQuery.of(context).size),
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          var _ = _banners[index];
                          return GestureDetector(
                            onTap: () {
                              // TODO preview image
                              // showScreenshot(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          );
                        },
                        itemCount: _banners.length,
                        pagination:
                            _banners.length >= 2 ? SwiperPagination() : null,
                        control: _banners.length >= 2
                            ? SwiperControl(
                                iconPrevious: CupertinoIcons.back,
                                iconNext: CupertinoIcons.forward,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// showScreenshot(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (_) => MacosAlertDialog(
//       appIcon: FlutterLogo(
//         size: 56,
//       ),
//       title: Text(
//         'Alert Dialog with Primary Action',
//         style: MacosTheme.of(context).typography.headline,
//       ),
//       message: Text(
//         'This is an alert dialog with a primary action and no secondary action',
//         textAlign: TextAlign.center,
//         style: MacosTheme.of(context).typography.headline,
//       ),
//       primaryButton: PushButton(
//         buttonSize: ButtonSize.large,
//         child: Text('Primary'),
//         onPressed: () {},
//       ),
//     ),
//   );
// }
