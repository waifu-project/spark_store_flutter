import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github_loading/github_loading.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spark_store/_enum.dart';
import 'package:spark_store/_http.dart';
import 'package:spark_store/widget/_app.dart';
import 'config.dart';
import 'models/category_json.dart';
import 'widget/_detail.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'spark_store',
      theme: MacosThemeData.dark(),
      darkTheme: MacosThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
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

  @override
  void initState() {
    updateCategoryUI();
    super.initState();
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
                  color: Colors.white,
                  semanticsLabel: 'A red up arrow',
                ),
                onPressed: () {},
              ),
              SizedBox(width: 4.2),
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.black45,
                child: SvgPicture.asset(
                  "assets/icons/category_active.svg",
                  fit: BoxFit.fill,
                  color: Colors.white,
                  semanticsLabel: 'A red up arrow',
                ),
                onPressed: () {},
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
                        GithubLoading()
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                          ),
                        ][currentPagePoint.index];
                      },
                    ),
                  ),
          ),
        ],
      ),
      sidebar: Sidebar(
        minWidth: 200,
        bottom: Padding(
          padding: const EdgeInsets.all(16.0),
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
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: currentCategory,
            onChanged: (index) {
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
                      semanticsLabel: 'A red up arrow'),
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
