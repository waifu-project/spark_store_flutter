import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github_loading/github_loading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spark_store/_enum.dart';
import 'package:spark_store/_http.dart';
import 'package:spark_store/utils/dd.dart';
import 'package:spark_store/widget/_app.dart';
import 'package:spark_store/widget/_download.dart';
import 'config.dart';
import 'models/category_json.dart';
import 'widget/_detail.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

autoCreateTempDir() async {
  // TODO only run linux
  var dir = Directory("/tmp/_store");
  if (!dir.existsSync()) {
    await dir.create();
  }
}

void main() async {
  await autoCreateTempDir();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('download_task');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          return MacosApp(
            title: 'spark_store',
            theme: MacosThemeData.dark(),
            darkTheme: MacosThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(
              local: storage,
            ),
          );
        } else {
          return Center(
            child: Image.asset(
              "assets/mona-loading-default.gif",
              package: 'github_loading',
              width: 120,
            ),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final LocalStorage local;

  MyHomePage({
    Key? key,
    required this.local,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  int currentCategory = 0;

  PagePoint currentPagePoint = PagePoint.category;

  set _currentPagePoint(PagePoint point) {
    setState(() {
      currentPagePoint = point;
    });
    // TODO http get app detail
  }

  CategoryJson currentDetailData = CategoryJson();

  List<CategoryJson> _data = [];

  String get _categoryKeyword {
    var _id = CategoryData[currentCategory]['category'] ?? "";
    return _id;
  }

  set _currentCategory(int index) {
    setState(() {
      isLoading = true;
      currentCategory = index;
      updateCategoryUI();
    });
  }

  updateCategoryUI() async {
    var _ = await HttpSend.getCategoryByKeyword(_categoryKeyword);
    setState(() {
      isLoading = false;
      _data = _;
    });
  }

  /// NOTE:
  ///  => 因为应用信息在 `app.json` 都已经存在
  ///  => 所以并不需要重新通过 [HttpSend.getAppItemDesc] 接口获取到信息
  bool get doRefreshButton {
    return currentPagePoint == PagePoint.category;
  }

  /// NOTE:
  ///  => 只在详情页会有作用
  ///  => TODO `url Scheme`
  bool get doBackButton {
    return currentPagePoint == PagePoint.detail;
  }

  handleRefreshCurrentCategory() {
    setState(() {
      isLoading = true;
      updateCategoryUI();
    });
  }

  handleBackCurrentCateggory() {
    setState(() {
      currentPagePoint = PagePoint.category;
      _scrollController.animateTo(
        _oldScrollOffsetSize,
        duration: Duration(milliseconds: 800),
        curve: Curves.ease,
      );
    });
  }

  ScrollController _scrollController = ScrollController(
    debugLabel: "scroll",
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  double _oldScrollOffsetSize = 0;

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    // NOTE: AUTO DEBUG
    // widget.local.clear();
    // var x = widget.local.getItem("task");
    // print(x);

    mergeGetLocalDataTask().then((_) {
      setState(() {
        _tasks = _;
      });
    });

    _scrollController.addListener(() {
      if (currentPagePoint == PagePoint.detail) return;
      var offset = _scrollController.offset;
      setState(() {
        _oldScrollOffsetSize = offset;
      });
    });
    updateCategoryUI();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  handleAptAction(AptCenterAction action) {
    if (action != AptCenterAction.Install) return;
    var _ = createNewDownloadManger();

    /// NOTE:
    ///  该方法会push一个新的下载对象,
    ///  但是需要提前判断其是否已经在当前 [tasks] 中
    var taskExists = _tasks.any((element) {
      return currentDetailData.pkgname == element['pkgName'];
    });
    if (taskExists) return;
    if (_ == null) return;
    asyncAddDownloadItem(_);
  }

  final _DMkey = "task";

  asyncAddDownloadItem(Map<String, dynamic>? item) {
    if (item == null) return;

    List<Map<String, dynamic>> dm = [];
    var _tmp = widget.local
        .getItem(_DMkey)
        .cast<Map<String, dynamic>>(); // List<String, dynamic> || null
    var taskExist = false;
    if (_tmp != null) {
      taskExist = (_tmp as List<Map<String, dynamic>>)
          .any((element) => element['pkgName'] == item['pkgName']);
      dm = _tmp;
    }
    if (!taskExist) {
      dm.add(item);
      setState(() {
        _tasks.add(item);
        handleDownloadManaer(DownloadRightAction.download, _tasks.length - 1);
      });
      widget.local.setItem(_DMkey, dm);
    }
  }

  asyncSaveDownloadCache() async {
    return await widget.local.setItem(_DMkey, _tasks);
  }

  List<Map<String, dynamic>> getAllDownloadTask() {
    var _ = widget.local.getItem(_DMkey).cast<Map<String, dynamic>>();
    if (_ != null) return (_ as List<Map<String, dynamic>>);
    return [];
  }

  Future<List<Map<String, dynamic>>> mergeGetLocalDataTask() async {
    var _ = getAllDownloadTask();
    List<Map<String, dynamic>> _r = [];
    for (var i = 0; i < _.length; i++) {
      var _item = _[i];
      var f = _item['filepath'];
      File file = File(f);
      double _size = 0;
      if (file.existsSync()) {
        _size = (await file.length()) / 1024 / 1024;
      }
      _item['download_size'] = _size;
      _item['is_download'] = _item['total_size'] == _size;
      _r.add(_item);
    }
    return _r;
  }

  Map<String, dynamic>? createNewDownloadManger() {
    var name = currentDetailData.name;
    var pkgName = currentDetailData.pkgname;
    var filename = currentDetailData.filename;
    var download_url =
        '$DefaultMirrorBaseURL/store/$_categoryKeyword/$pkgName/$filename';
    var filepath = '/tmp/_store/$filename';
    var s = currentDetailData.size;
    if (s == null) return null;
    var _ = s.split(" ");
    if (_.length <= 1) return null;
    var _s = double.parse(_[0]);
    var _k = _[1];
    if (_k == 'KB') _s = _s / 1024;
    if (_k == 'GB') _s = _s * 1024;
    Map<String, dynamic> data = {
      "name": name,
      "pkgName": pkgName,
      "icon": currentDetailData.icons,
      "download_url": download_url,
      "filepath": filepath,
      "total_size": _s,
      "download_size": 0,
      "is_download": false
    };
    return data;
  }

  handleRemoveOnceDownloadItem(int index) {
    try {
      Map<String, dynamic> _item = _tasks[index];
      File file = File(_item['filepath']);
      if (file.existsSync()) {
        file.deleteSync();
      }
      setState(() {
        _tasks.removeAt(index);
      });
      asyncSaveDownloadCache();
    } catch (e) {}
  }

  handleDownloadManaer(DownloadRightAction action, int index) {
    if (action == DownloadRightAction.remove) {
      handleRemoveOnceDownloadItem(index);
      return;
    }
    var item = _tasks[index];
    var url = item['download_url'];
    if (item['start_download'] ?? false) {
      DownloadFile.cancelDownload(url);
      setState(() {
        _tasks[index]['start_download'] = false;
      });
      return;
    }
    DownloadFile.download(
      url: url,
      savePath: item['filepath'],
      onReceiveProgress: (count, total) {
        // print("count: $count, total: $total");
        setState(() {
          _tasks[index]['total_size'] = total / 1024 / 1024;
          _tasks[index]['download_size'] = count / 1024 / 1024;
          _tasks[index]['start_download'] = true;
        });
      },
      done: () {
        setState(() {
          _tasks[index]['is_download'] = true;
          _tasks[index]['start_download'] = false;
          asyncSaveDownloadCache();
        });
      },
      failed: (dio) {
        _tasks[index]['start_download'] = false;
        // TODO show dio error message
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      child: MacosScaffold(
        titleBar: TitleBar(
          centerTitle: true,
          title: Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.black45,
                child: SvgPicture.asset(
                  "assets/icons/refresh-page.svg",
                  fit: BoxFit.fill,
                  color: doRefreshButton ? Colors.white : Colors.white12,
                  semanticsLabel: 'A red up arrow',
                ),
                onPressed:
                    doRefreshButton ? handleRefreshCurrentCategory : null,
              ),
              SizedBox(width: 4.2),
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.black45,
                child: SvgPicture.asset(
                  "assets/icons/category_active.svg",
                  fit: BoxFit.fill,
                  color: doBackButton ? Colors.white : Colors.white12,
                  semanticsLabel: 'A red up arrow',
                ),
                onPressed: doBackButton ? handleBackCurrentCateggory : null,
              ),
              SizedBox(width: 4.2),
              Expanded(
                child: MacosTextField(
                  placeholder: "search",
                ),
              ),
              SizedBox(
                width: 42,
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.4, vertical: 4.2),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      "assets/icons/menu.svg",
                      fit: BoxFit.fill,
                      color: Colors.white,
                      semanticsLabel: 'A red up arrow',
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        children: [
          ContentArea(
            builder: (ctx, _) => (isLoading)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GithubLoading(),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        return [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              ..._data
                                  .map(
                                    (e) => AppCardView(
                                      data: e,
                                      maxWidth: constraints.maxWidth,
                                      onTap: (_data) {
                                        setState(() {
                                          currentDetailData = _data;
                                        });
                                        _currentPagePoint = PagePoint.detail;
                                      },
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                          DetailPage(
                            data: currentDetailData,
                            maxWidth: constraints.maxWidth,
                            onAppTap: handleAptAction,
                          ),
                          Dmanaer(
                            width: constraints.maxWidth,
                            height: MediaQuery.of(context).size.height - 52.00,
                            tasks: _tasks,
                            onTap: handleDownloadManaer,
                          ),
                        ][currentPagePoint.index];
                      },
                    ),
                  ),
          ),
        ],
      ),
      sidebar: Sidebar(
        topOffset: 12,
        minWidth: 200,
        isResizable: false,
        bottom: GestureDetector(
          onTap: () {
            _currentPagePoint = PagePoint.download;
          },
          child: AnimatedContainer(
            margin:
                EdgeInsets.all(currentPagePoint == PagePoint.download ? 12 : 0),
            decoration: BoxDecoration(
              color: currentPagePoint == PagePoint.download
                  ? Colors.blue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            duration: Duration(
              milliseconds: 210,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 9,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/download.svg",
                    width: 24,
                    height: 24,
                    color: Colors.white,
                    semanticsLabel: 'A red up arrow',
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text('Download'),
                ],
              ),
            ),
          ),
        ),
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: currentCategory,
            selectedColor: currentPagePoint == PagePoint.category
                ? Colors.blue
                : Colors.transparent,
            onChanged: (index) {
              if (currentCategory == index &&
                  currentPagePoint != PagePoint.download) return;
              _currentCategory = index;
              _currentPagePoint = PagePoint.category;
            },
            scrollController: controller,
            items: [
              ...CategoryData.map(
                (e) => SidebarItem(
                  leading: SvgPicture.asset(
                    "assets/icons/category_${e['icon']}.svg",
                    width: 18,
                    height: 18,
                    color: Colors.white,
                    semanticsLabel: 'A red up arrow',
                  ),
                  label: Text((e['title'] ?? "").capitalize()),
                ),
              ).toList(),
            ],
          );
        },
      ),
    );
  }
}
