import 'dart:developer';

import 'package:get/get.dart';
import 'package:ui_kit/dummy_data.dart';

import 'model/subcategory_response.dart';

class AnimatedCategoryControler extends GetxController{
List<SubcategoryResponse> subcategoryResponseListItem = <SubcategoryResponse>[];
List<Subcategory> subctList=[];


    Future<List<Subcategory>> loadSubcategoryResponse(String categoryID) async {
 
      SubcategoryResponse subCategoryResponse = SubcategoryResponse.fromJson(subcategoryJsonResponseData);
      subctList=subCategoryResponse.data??[];
      return subCategoryResponse.data ?? [];
 

  }


  loadChildCategoryListById(String id){

  }
}