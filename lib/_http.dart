import 'dart:async';

import 'package:dio/dio.dart';
import 'package:spark_store/_dio.dart';

import 'models/app_once_item.dart';
import 'models/category_json.dart';

class HttpSend {
  /// get once category
  ///
  /// the [keyword] is [CategoryData] once item ['icon']
  static Future<List<CategoryJson>> getCategoryByKeyword(
    String keyword,
    // void Function(List<CategoryJson> _) data,
  ) async {
    // print("search category: $keyword");
    // dio.get('/store/$keyword/applist.json').then((value) {
    //   List<dynamic> _d = value.data;
    //   var _list = _d.map((e) => CategoryJson.fromJson(e)).toList();
    //   data(_list);
    // }).onError((error, stackTrace) {
    //   data([]);
    //   print(error);
    // });
    var _ = await dio.get('/store/$keyword/applist.json');
    List<dynamic> _d = _.data;
    var _list = _d.map((e) => CategoryJson.fromJson(e)).toList();
    return _list;
  }

  /// get once app item desc
  ///
  /// [pkgName] => package name
  ///
  /// [category] => is category
  static Future<AppOnceItem> getAppItemDesc(
    String category,
    String pkgName,
  ) async {
    try {
      var _ = await dio.get('/store/$category/$pkgName/app.json');
      AppOnceItem data = AppOnceItem.fromJson(_.data);
      return data;
    } on DioError catch (e) {
      print(e);
      return AppOnceItem();
    }
  }
}
