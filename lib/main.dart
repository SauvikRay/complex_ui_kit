import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ui_kit/controller.dart';
import 'subcategory_model.dart';

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
        useMaterial3: false,
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
  final _controller = DynamicController();
  @override
  void initState() {
    _controller.parseSubcategory();
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.subcategory.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 10);
                      },
                      itemBuilder: (context, index) {
                        SubCategory element = _controller.subcategory[index];
                        final isSelected = _controller.selectedChips.containsKey(element.subCateId);
                        return Animate(
                          effects: const [
                            SlideEffect(begin: Offset(1, 0), end: Offset(0, 0), duration: Duration(milliseconds: 600), curve: Curves.easeOutSine),
                            FadeEffect(begin: 0.0, end: 1.0, duration: Duration(milliseconds: 300), curve: Curves.easeOutSine)
                          ],
                          child: ChoiceChip(
                            avatar: isSelected
                                ? const Icon(
                                    CupertinoIcons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  )
                                : null,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            selectedColor: CupertinoColors.systemBlue,
                            labelStyle: TextStyle(fontSize: 14, color: isSelected ? Colors.white : CupertinoColors.activeBlue, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5)), side: BorderSide(color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray)),
                            label: Text("${element.subCateName}"),
                            selected: isSelected,
                            onSelected: (value) {
                              // log('Selected Chips value $value');
                              if (value) {
                                // isVisible = value;
                                // // log('allSubcategory length: ${allSubcategory.length}');
                                // _controller.selectedChips[element.subCateId ?? ''] = element;
                                // _controller.subcategory.removeWhere((item) => item.subCateId != element.subCateId);

                                // // _controller.allChildCategoryItem=element.child??[];
                                // // _controller.childCategory.value=element.child??[];
                                // _controller.childCategory.addAll(element.child ?? []);
                                _controller.ifSelectedSubCategory(value: value, element: element);

                                setState(() {});
                              } else {
                                _controller.elseSelectedSubCategory(value: value, element: element);
                                setState(() {});
                              }
                              //  selectedSubCategory.value = subcategory.elementAt(index);
                            },
                          ),
                        );
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: _controller.isVisible,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _controller.childCategory.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        ChildCategory item = _controller.childCategory[index];
                        final isChildSelected = _controller.selectedChildChips.containsKey(item.id);
                        return Animate(
                          effects: const [
                            SlideEffect(begin: Offset(1, 0), end: Offset(0, 0), duration: Duration(milliseconds: 600), curve: Curves.easeOutSine),
                            FadeEffect(begin: 0.0, end: 1.0, duration: Duration(milliseconds: 300), curve: Curves.easeOutSine)
                          ],
                          child: ChoiceChip(
                            avatar: isChildSelected
                                ? const Icon(
                                    CupertinoIcons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  )
                                : null,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            selectedColor: CupertinoColors.systemBlue,
                            labelStyle: TextStyle(fontSize: 14, color: isChildSelected ? Colors.white : CupertinoColors.activeBlue, fontWeight: isChildSelected ? FontWeight.bold : FontWeight.normal),
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5)), side: BorderSide(color: isChildSelected ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray)),
                            label: Text(item.name ?? ''),
                            selected: isChildSelected,
                            onSelected: (value) {
                              log('if length:${_controller.allChildCategoryItem.length}');
                              if (value) {
                                // log('if condition length:${allChildCategoryItem.length}');
                                _controller.selectedChildChips[item.id ?? ''] = item;
                                _controller.childCategory.removeWhere((element) => element.id != item.id);
                                setState(() {});
                              } else {
                                _controller.selectedChildChips.remove(item.id);
                                _controller.selectedChildChips.clear();
                                _controller.childCategory.remove(item);
                                Set<ChildCategory> uniqueItem = Set<ChildCategory>.from(_controller.allChildCategoryItem).union(Set<ChildCategory>.from(_controller.childCategory));
                                // log('Child Item length: ${uniqueItem.length}');

                                _controller.childCategory.addAll(uniqueItem.toList());

                                log('sdfsdd : ${_controller.allChildCategoryItem.length}');
                                setState(() {});

                                // for(var iiii in allChildCategoryItem){
                                //   log('All child Item: ${iiii.name}');
                                // }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),

// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
