// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'category_model.dart';
// import 'subcategory_model.dart';

// class DynamicController<T> extends ChangeNotifier {
//   List<Category> category = <Category>[];
//   List<SubCategory> subcategory = <SubCategory>[];
//   List<SubCategory> allSubcategory = <SubCategory>[];
//   Map<String, SubCategory> selectedChips = <String, SubCategory>{};
//   Map<String, ChildCategory> selectedChildChips = <String, ChildCategory>{};
//   List<ChildCategory> childCategory = <ChildCategory>[];
//   List<ChildCategory> allChildCategoryItem = <ChildCategory>[];
//   bool isVisible = false;

//   parseSubcategory() {
//     CategoryResponse categoryResponse = CategoryResponse.fromJson(categoryResponseData);
//     category = categoryResponse.data ?? [];
//     notifyListeners();
//     SubcategoryResponse subcategoryResponse = SubcategoryResponse.fromJson(subcategoryResponseData);
//     SubcategoryResponse subcategoryResponse2 = SubcategoryResponse.fromJson(subcategoryResponseData);
//     allSubcategory = subcategoryResponse2.data ?? [];
//     notifyListeners();
//     subcategory = subcategoryResponse.data ?? [];
//     notifyListeners();
//   }

//   ifSelectedSubCategory({required bool value, required SubCategory element}) {
//     isVisible = value;
//     // log('allSubcategory length: ${allSubcategory.length}');
//     selectedChips[element.subCateId ?? ''] = element;
//     subcategory.removeWhere((item) => item.subCateId != element.subCateId);
//     childCategory.addAll(element.child ?? []);
//     allChildCategoryItem.clear();
//     allChildCategoryItem.addAll(childCategory);
//     notifyListeners();
//   }

//   elseSelectedSubCategory({required bool value, required SubCategory element}) {
//     isVisible = value;
//     selectedChips.remove(element.subCateId);
//     subcategory.remove(element);

//     // log('allSubcategory length: ${allSubcategory.length}');
//     Set<SubCategory> uniqueItem = Set<SubCategory>.from(allSubcategory).union(Set<SubCategory>.from(subcategory));
//     // log('Item length: ${uniqueItem.length}');

//     subcategory.addAll(uniqueItem.toList());

//     childCategory.clear();
//     if (selectedChildChips.isNotEmpty) {
//       selectedChildChips.clear();
//     }

//     log('Selected Child :${selectedChildChips.length}');

//     allChildCategoryItem.clear();
//     allChildCategoryItem.addAll(childCategory);

//     notifyListeners();
//   }

// getSubCategoryResponse(List<T> itemList){

//   for (int i = 0; i<itemList.length;i++){
//     T response=itemList[i];
//     final keys= json.decode(response.);
//     log('Subcategory List: $keys');
//   }

// }

// getChildCategory(List<T> childList){
//   for (int i = 0; i<childList.length;i++){
//     T response=childList[i];
//     log('Child List: $response');
//   }
// }
     
// }
