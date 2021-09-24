import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spark_store/models/category_json.dart';
import 'package:spark_store/widget/_listItem.dart';

class DetailPage extends StatefulWidget {
  final CategoryJson data;

  DetailPage({
    Key? key,
    required this.data,
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
                    Image.network(
                      widget.data.icons ?? "",
                      width: 120,
                    ),
                    SizedBox(height: 12,),
                    PushButton(
                      color: Colors.blue,
                      child: Text('install'),
                      buttonSize: ButtonSize.large,
                      onPressed: () {
                        print('button pressed');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 42,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.name ?? "",
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 12,),
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
              )
            ],
          ),
          SizedBox(height: 42,),
          Text(
            "Info",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 12,),
          Text(widget.data.more ?? ""),
          SizedBox(height: 12,),
          Text(
            "Screenshots",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 12,),
          Container(
            width: double.infinity,
            height: calcSwiperHeigth(MediaQuery.of(context).size),
            // padding: EdgeInsets.symmetric(
            //   horizontal: 42,
            //   vertical: 12,
            // ),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                var _ = _banners[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _,
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
              itemCount: _banners.length,
              pagination: SwiperPagination(),
              control: SwiperControl(
                  iconPrevious: CupertinoIcons.back,
                  iconNext: CupertinoIcons.forward),
            ),
          )
        ],
      ),
    );
  }
}
