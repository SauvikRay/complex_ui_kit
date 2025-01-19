import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_kit/controller.dart';
import 'package:ui_kit/ic_over_view_icons.dart';
import 'animated_category.dart';
import 'circle_wave.dart';
import 'model/subcategory_response.dart';
import 'phyllotaxisPainterWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AnimatedCategoryControler _controller = Get.put(AnimatedCategoryControler());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          const Icon(
            IcOverView.ic_overview,
            color: CupertinoColors.activeBlue,
          ),
          FutureBuilder(
              future: _controller.loadSubcategoryResponse('80'),
              builder: ((context, snapshot) {
                List<Subcategory> subcategoryList = snapshot.data ?? [];
                if (subcategoryList.isEmpty) {
                  return const SizedBox.shrink();
                }
                return AnimatedCategory(
                  subcategoryList: subcategoryList,
                  onCallBack: (data) {
                    // setState(() {
                    //   _controller.newsList = [];
                    //   _controller.trendingList = [];
                    //   isClicked = true;
                    // });
                    if (data['type'] == 'child-category') {
                      // childCategoryId = int.tryParse(data['id']) ?? 0;

                      // subCategoryId = int.tryParse(data['subCategory']['id']) ?? 0;
                      // topicsName = data['name'];
                      // showLoader();
                      // _controller.getNewsByCategory(super.widget.selectedTopic.id, subCategoryId, childCategoryId, 0, (isSuccess) {
                      //   Get.back();

                      //   isClicked = false;
                      //   setState(() {});
                      // });
                    } else {
                      // childCategoryId = 0;
                      // subCategoryId = int.tryParse(data['id']) ?? 0;
                      // topicsName = data['name'];
                      // showLoader();
                      // _controller.getNewsByCategory(super.widget.selectedTopic.id, subCategoryId, 0, 0, (isSuccess) {
                      //   Get.back();

                      //   isClicked = false;
                      //   setState(() {});
                      // });
                    }
                  },
                );
              })),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return PhyllotaxisPainterWidget();
                },
              ));
            },
            child: Text("Phyllotaxis Painter"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return CircularWaveProgress();
                },
              ));
            },
            child: Text("CircularWaveProgress"),
          )
        ],
      ),
    );
  }
}
