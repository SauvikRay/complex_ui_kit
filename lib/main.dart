import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ui_kit/controller.dart';
import 'package:ui_kit/custom_icons.dart';
import 'package:ui_kit/ic_over_view_icons.dart';

import 'animated_category.dart';
import 'bidduit/my_first_screen.dart';
import 'dummy_data.dart';
import 'model/subcategory_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home:const MyFirstScreen(appbarName: "My Appbar",) //const MyHomePage(title: 'Flutter Demo Home Page'),
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

          // DropdownButtonFormField<Subcategory>(
          //   hint: Text('Dropdown'),
          //       onChanged: (value) {
          //         log('Ón change val ${value?.subCateName}');
          //       },
          //        decoration: const InputDecoration(
          //           contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          //           border: OutlineInputBorder(),
          //           enabledBorder:OutlineInputBorder(),
          //           fillColor: Colors.transparent,
          //           filled: true,
          //           focusedBorder: OutlineInputBorder(),
          //           floatingLabelBehavior: FloatingLabelBehavior.always),

          //       items: _controller.subctList.map((item){
          //         return DropdownMenuItem(
          //           value: item,
          //           child: ,
          //         );
          //       }).toList(),
          //     ),

          const SizedBox(
            height: 20,
          ),
          Icon(IcOverView.ic_overview,color: CupertinoColors.activeBlue,),
          Icon(Icons.abc),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(IcNews.ic_news),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        onTap: (value) {},
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.home,
                    color: Colors.red,
                  )),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              label: ''),
        ],
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

const double _kMenuItemHeight = 48.0;

class ChipItem<T> extends _ChipItemContainer {
  const ChipItem({
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    super.alignment,
    required super.child,
  });

  final VoidCallback? onTap;

  final T? value;

  final bool enabled;
}

class _ChipItemContainer extends StatelessWidget {
  const _ChipItemContainer({
    super.key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  });

  final Widget child;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: child,
    );
  }
}
