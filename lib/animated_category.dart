import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'model/subcategory_response.dart';


class AnimatedCategory<T> extends StatefulWidget {
  const AnimatedCategory({super.key, required this.subcategoryList, required this.onCallBack});
  final List<Subcategory> subcategoryList;
  final Function(Map data) onCallBack;
  @override
  State<AnimatedCategory<T>> createState() => _AnimatedCategoryState<T>();
}

class _AnimatedCategoryState<T> extends State<AnimatedCategory<T>> with TickerProviderStateMixin {
  late AnimationController _subCatAnimController;
  bool isVisible = false;
  final ScrollController _scrollController = ScrollController();

  List<Subcategory> subcategoryList = <Subcategory>[];
  List<Subcategory> allSubcategory = <Subcategory>[];
//After Subcategory clicked added to this list
  Map<String, Subcategory> selectedSubCategory = <String, Subcategory>{};

//ChildCategory Data
  Map<String, ChildCategory> selectedChildChips = <String, ChildCategory>{};
  List<ChildCategory> childCategory = <ChildCategory>[];
  List<ChildCategory> allChildCategoryItem = <ChildCategory>[];
  bool categoryDirection = false;
  Subcategory? _selectSubcat;

  List<GlobalKey>childKey =[];
  
  @override
  void initState() {
    _subCatAnimController = AnimationController(vsync: this);
    if (kDebugMode) {
      log('widget subcategory length ${widget.subcategoryList.length}');
      log('All subcategory length ${allSubcategory.length}');
    }

    allSubcategory.addAll(widget.subcategoryList);
    subcategoryList.addAll(widget.subcategoryList);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        categoryDirection = true;
      } else {
        categoryDirection = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (kDebugMode) {
      log('All subcategory didChange ${allSubcategory.length}');
    }
  }

  @override
  void didUpdateWidget(AnimatedCategory<T> oldWidget) {
    // log('DidUpdate Widget Called');
    super.didUpdateWidget(oldWidget);
  }

  onTabPressed({required Subcategory? subcategory, required ChildCategory? childCategory}) async {
    // log('Index of subcategory${index} ${subcategory.subCateName}');
    if (childCategory != null) {
      widget.onCallBack({
        'type': 'child-category',
        'subCategory': {
          'id': subcategory != null ? subcategory.subCateId : '',
          'slug': subcategory != null ? subcategory.subCateSlug : '',
          'name': subcategory != null ? subcategory.subCateName : '',
        },
        'id': childCategory.id,
        'slug': childCategory.slug,
        'name': childCategory.name,
      });
    } else {
      // log('Subcategory:  ${subcategory.subCateName} ${subcategory.subCateId}  ${subcategory.subCateSlug}');
      widget.onCallBack({
        ' type': 'subCategory',
        'id': subcategory != null ? subcategory.subCateId : '',
        'slug': subcategory != null ? subcategory.subCateSlug : '',
        'name': subcategory != null ? subcategory.subCateName : '',
      });
    }
  }

    findPosition(GlobalKey globalKey){
      final currenCtx= globalKey.currentContext;
      RenderBox box =currenCtx?.findRenderObject() as RenderBox; 
 Offset position = box.localToGlobal(Offset.zero);
 double y = position.dy;
 double x = position.dx;
 log('Positions ${x},${y}');
    }
  @override
  void dispose() {
    _subCatAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      // decoration: const BoxDecoration(color: Colors.green),
      padding: EdgeInsets.symmetric(horizontal: categoryDirection ? 0 : 10),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: subcategoryList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  Subcategory subcategory = subcategoryList[index];
                  final isSelected = selectedSubCategory.containsKey(subcategory.subCateId);
                  return Animate(
                    effects: const [
                      SlideEffect(begin: Offset(1.5, 0), end: Offset(0, 0), duration: Duration(milliseconds: 1000), curve: Curves.easeOutSine),
                      FadeEffect(begin: 0.0, end: 1.0, duration: Duration(milliseconds: 1000), curve: Curves.easeOutSine)
                    ],
                    child: ChoiceChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 5),
                      backgroundColor: Colors.transparent,
                      selectedColor: CupertinoColors.systemBlue,
                      labelStyle: TextStyle(fontSize: 14, color: isSelected ? Colors.white : CupertinoColors.activeBlue, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      shape: StadiumBorder(side: BorderSide(color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey3, width: .5)),
                      label: isSelected
                          ? Row(
                              children: [
                                Text("${subcategory.subCateName}".toLowerCase()),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  CupertinoIcons.clear,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Text("${subcategory.subCateName}".toLowerCase()),
                      selected: isSelected,
                      onSelected: (value) {
                        // log('Selected Chips value $value');

                        if (value) {
                          _selectSubcat = subcategory;
                          onTabPressed(subcategory: subcategory, childCategory: null);
                          isVisible = value && subcategory.menuCategory != null && subcategory.menuCategory!.isNotEmpty;
                          // log('allSubcategory length: ${allSubcategory.length}');
                          selectedSubCategory[subcategory.subCateId ?? ''] = subcategory;
                          subcategoryList.removeWhere((item) => item.subCateId != subcategory.subCateId);

                          //Update Menucategory List
                          subcategory.menuCategory != null && subcategory.menuCategory!.isNotEmpty ? childCategory.addAll(subcategory.menuCategory ?? []) : [];

                          // setState(() {});
                        } else {
                          _selectSubcat = null;
                          isVisible = value && subcategory.menuCategory != null && subcategory.menuCategory!.isNotEmpty;
                          onTabPressed(subcategory: null, childCategory: null);
                          selectedSubCategory.remove(subcategory.subCateId);
                          subcategoryList.remove(subcategory);

                          // log('allSubcategory length: ${allSubcategory.length}');
                          Set<Subcategory> uniqueItem = Set<Subcategory>.from(allSubcategory).union(Set<Subcategory>.from(subcategoryList));
                          // log('Item length: ${uniqueItem.length}');

                          subcategoryList.addAll(uniqueItem.toList());

                          childCategory = [];
                          if (selectedChildChips.isNotEmpty) {
                            selectedChildChips = {};
                          }
                          // log('Selected Child :${selectedChildChips.length}')            ;
                          // setState(() {});
                        }
                        allChildCategoryItem.clear();
                        allChildCategoryItem.addAll(childCategory);
                        childKey=List.generate(childCategory.length,(index)=>GlobalKey(debugLabel: '${childCategory[index]}'));

                        setState(() {});
                      },
                    ),
                  );
                }),
            const SizedBox(
              width: 10,
            ),
            Visibility(
              visible: isVisible,
              child: Animate(
                controller: _subCatAnimController,
                effects: const [
                  SlideEffect(begin: Offset(2, 0), end: Offset(0, 0), duration: Duration(milliseconds: 1000), curve: Curves.easeOutSine),
                  FadeEffect(begin: 0.0, end: 1.0, duration: Duration(milliseconds: 1000), curve: Curves.easeOutSine)
                ],
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: childCategory.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    ChildCategory childElement = childCategory[index];
                    final isChildSelected = selectedChildChips.containsKey(childElement.id);
                    return ChoiceChip(
                      key: childKey[index],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 5),
                      backgroundColor: Colors.transparent,
                      selectedColor: CupertinoColors.systemBlue,
                      labelStyle: TextStyle(fontSize: 14, color: isChildSelected ? Colors.white : CupertinoColors.activeBlue, fontWeight: isChildSelected ? FontWeight.bold : FontWeight.normal),
                      shape: StadiumBorder(side: BorderSide(color: isChildSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey3, width: .5)),
                      label: Row(
                        children: [
                          Text(childElement.name?.toLowerCase() ?? ''),
                          isChildSelected
                              ? const SizedBox(
                                  width: 5,
                                )
                              : const SizedBox(
                                  width: 0,
                                ),
                          isChildSelected
                              ? const Icon(
                                  CupertinoIcons.clear,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      // : Text(childElement.name?.toLowerCase() ?? ''),
                      selected: isChildSelected,
                      onSelected: (value) {
                        findPosition(childKey[index]);
                        //  log('if length:${allChildCategoryItem.length}');
                        if (value) {
                          // log('if condition length:${allChildCategoryItem.length}');
                          onTabPressed(subcategory: _selectSubcat, childCategory: childElement);
                          selectedChildChips[childElement.id ?? ''] = childElement;
                          childCategory.removeWhere((element) => element.id != childElement.id);
                          _subCatAnimController.reset();
                          _subCatAnimController.forward();
                          // setState(() {});
                        } else {
                          onTabPressed(subcategory: _selectSubcat, childCategory: null);
                          selectedChildChips.remove(childElement.id);
                          selectedChildChips = {};
                          childCategory.remove(childElement);
                          childCategory = [];
                          Set<ChildCategory> uniqueItem = Set<ChildCategory>.from(allChildCategoryItem).union(Set<ChildCategory>.from(childCategory));
                          // log('Child Item length: ${uniqueItem.length}');

                          childCategory.addAll(uniqueItem.toList());
                          // childCategory.addAll(_selectSubcat?.menuCategory ?? []);

                          // setState(() {});

                          // log('else : ${allChildCategoryItem.length}');

                          // for(var iiii in allChildCategoryItem){
                          //   log('All child Item: ${iiii.name}');
                          // }
                          _subCatAnimController.reset();
                          _subCatAnimController.forward();
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SubcategoryButton<T> extends StatefulWidget {
  const SubcategoryButton({super.key});

  @override
  State<SubcategoryButton<T>> createState() => _SubcategoryButtonState<T>();
}

class _SubcategoryButtonState<T> extends State<SubcategoryButton<T>>{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}