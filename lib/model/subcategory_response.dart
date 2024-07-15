class SubcategoryResponse {
  bool? status;
  String? message;
  ParentCategory? parentCategory;
  List<Subcategory>? data;

  SubcategoryResponse({
    this.status,
    this.message,
    this.parentCategory,
    this.data,
  });

  factory SubcategoryResponse.fromJson(Map<String, dynamic> json) => SubcategoryResponse(
        status: json["status"],
        message: json["message"],
        parentCategory: json["parentCategory"] == null ? null : ParentCategory.fromJson(json["parentCategory"]),
        data: json["data"] == null ? [] : List<Subcategory>.from(json["data"]!.map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ParentCategory {
  String? parentId;
  String? parentName;
  String? parentSlug;
  ParentCategory({this.parentId, this.parentName, this.parentSlug});

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
        parentId: json["id"],
        parentName: json["name"],
        parentSlug: json["slug"],
      );
}

class Subcategory {
  String? subCateId;
  String? subCateName;
  String? subCateSlug;
  List<ChildCategory>? menuCategory;

  Subcategory({
    this.subCateId,
    this.subCateName,
    this.subCateSlug,
    this.menuCategory,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subCateId: json["sub_cate_id"],
        subCateName: json["sub_cate_name"],
        subCateSlug: json["sub_cate_slug"],
        menuCategory: json["child"] == null ? [] : List<ChildCategory>.from(json["child"]!.map((x) => ChildCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sub_cate_id": subCateId,
        "sub_cate_name": subCateName,
        "sub_cate_slug": subCateSlug,
        "child": menuCategory == null ? [] : List<dynamic>.from(menuCategory!.map((x) => x.toJson())),
      };
}

class ChildCategory {
  String? id;
  String? name;
  String? slug;

  ChildCategory({
    this.id,
    this.name,
    this.slug,
  });

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}
