import 'package:get/get.dart';

import 'category_model.dart';
import 'subcategory_model.dart';

class DynamicController extends GetxController{

   RxList<Category> category=<Category>[].obs;
  RxList<SubCategory> subcategory=<SubCategory>[].obs;
  RxList<SubCategory> allSubcategory=<SubCategory>[].obs;
RxMap<String ,SubCategory> selectedChips=<String ,SubCategory>{}.obs;
RxMap<String ,ChildCategory> selectedChildChips=<String ,ChildCategory>{}.obs;
RxList<ChildCategory> childCategory=<ChildCategory>[].obs;
List<ChildCategory> allChildCategoryItem=<ChildCategory>[].obs;



  parseSubcategory(){
      CategoryResponse categoryResponse= CategoryResponse.fromJson(categoryResponseData);
      category.value=categoryResponse.data??[];
      SubcategoryResponse subcategoryResponse= SubcategoryResponse.fromJson(subcategoryResponseData);
      SubcategoryResponse subcategoryResponse2= SubcategoryResponse.fromJson(subcategoryResponseData);
      allSubcategory.value= subcategoryResponse2.data??[];
      subcategory.value= subcategoryResponse.data??[];

  }

}