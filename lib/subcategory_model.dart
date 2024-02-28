
class SubcategoryResponse {
    bool? status;
    String? message;
    List<SubCategory>? data;

    SubcategoryResponse({
        this.status,
        this.message,
        this.data,
    });

    factory SubcategoryResponse.fromJson(Map<String, dynamic> json) => SubcategoryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<SubCategory>.from(json["data"]!.map((x) => SubCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class SubCategory {
    String? subCateId;
    String? subCateName;
    String? subCateSlug;
    List<ChildCategory>? child;

    SubCategory({
        this.subCateId,
        this.subCateName,
        this.subCateSlug,
        this.child,
    });

    factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        subCateId: json["sub_cate_id"],
        subCateName: json["sub_cate_name"],
        subCateSlug: json["sub_cate_slug"],
        child: json["child"] == null ? [] : List<ChildCategory>.from(json["child"]!.map((x) => ChildCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "sub_cate_id": subCateId,
        "sub_cate_name": subCateName,
        "sub_cate_slug": subCateSlug,
        "child": child == null ? [] : List<dynamic>.from(child!.map((x) => x.toJson())),
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


Map<String,dynamic> subcategoryResponseData={
    "status": true,
    "message": "",
    "data": [
        {
            "sub_cate_id": "165",
            "sub_cate_name": "Football",
            "sub_cate_slug": "football-news",
            "child": [
                {
                    "id": "264",
                    "name": "Leagues Cups",
                    "slug": "leagues-cups"
                },
                {
                    "id": "265",
                    "name": "Players",
                    "slug": "players"
                },
                {
                    "id": "269",
                    "name": "National Team",
                    "slug": "national-team"
                },
                {
                    "id": "166",
                    "name": "Scores & Fixtures",
                    "slug": "football-scores"
                },
                {
                    "id": "167",
                    "name": "Tables",
                    "slug": "football-tables"
                },
                {
                    "id": "168",
                    "name": "Videos",
                    "slug": "football-videos"
                },
                {
                    "id": "169",
                    "name": "All Teams",
                    "slug": "football-teams"
                },
                {
                    "id": "170",
                    "name": "Gossips",
                    "slug": "football-gossips"
                },
                {
                    "id": "171",
                    "name": "Transfers",
                    "slug": "football-transfers"
                },
                {
                    "id": "172",
                    "name": "Nigerian Leagues",
                    "slug": "football-nigerian-leagues"
                }
            ]
        },
        {
            "sub_cate_id": "173",
            "sub_cate_name": "Tennis",
            "sub_cate_slug": "sport-tennis",
            "child": [
                {
                    "id": "176",
                    "name": "Standings",
                    "slug": "tennis-standings"
                },
                {
                    "id": "177",
                    "name": "Videos",
                    "slug": "tennis-videos"
                },
                {
                    "id": "178",
                    "name": "Gossips",
                    "slug": "tennis-gossips"
                },
                {
                    "id": "179",
                    "name": "All Teams",
                    "slug": "tennis-all-teams"
                },
                {
                    "id": "175",
                    "name": "Fixtures & Results",
                    "slug": "tennis-fixtures"
                }
            ]
        },
        {
            "sub_cate_id": "174",
            "sub_cate_name": "Formula 1",
            "sub_cate_slug": "sport-formula1",
            "child": [
                {
                    "id": "183",
                    "name": "Fixtures & Results",
                    "slug": "formula1-results"
                },
                {
                    "id": "184",
                    "name": "Standings",
                    "slug": "formula1-standings"
                },
                {
                    "id": "185",
                    "name": "Videos",
                    "slug": "formula1-videos"
                },
                {
                    "id": "186",
                    "name": "Gossips",
                    "slug": "formula1-gossips"
                },
                {
                    "id": "187",
                    "name": "All Teams",
                    "slug": "formula1-all-teams"
                }
            ]
        },
        {
            "sub_cate_id": "180",
            "sub_cate_name": "Boxing",
            "sub_cate_slug": "sports-boxing",
            "child": [
                {
                    "id": "188",
                    "name": "Fixtures & Results",
                    "slug": "boxing-results"
                },
                {
                    "id": "189",
                    "name": "Standings",
                    "slug": "boxing-standings"
                },
                {
                    "id": "190",
                    "name": "Videos",
                    "slug": "boxing-videos"
                },
                {
                    "id": "191",
                    "name": "Gossips",
                    "slug": "boxing-gossips"
                },
                {
                    "id": "192",
                    "name": "All Teams",
                    "slug": "boxing-all-teams"
                },
                {
                    "id": "268",
                    "name": "Boxer",
                    "slug": "boxer-player"
                }
            ]
        },
        {
            "sub_cate_id": "181",
            "sub_cate_name": "Basketball",
            "sub_cate_slug": "sports-basketball",
            "child": [
                {
                    "id": "193",
                    "name": "Fixtures & Results",
                    "slug": "basketball-results-fixture"
                },
                {
                    "id": "194",
                    "name": "Standings",
                    "slug": "basketball-standings"
                },
                {
                    "id": "195",
                    "name": "Videos",
                    "slug": "basketball-videos"
                },
                {
                    "id": "196",
                    "name": "Gossips",
                    "slug": "basketball-gossips"
                },
                {
                    "id": "197",
                    "name": "All Teams",
                    "slug": "basketball-all-teams"
                },
                {
                    "id": "266",
                    "name": "Players",
                    "slug": "basketball-players"
                },
                {
                    "id": "267",
                    "name": "Cup/League",
                    "slug": "cup-or-league"
                },
                {
                    "id": "270",
                    "name": "All Nation Team",
                    "slug": "all-national-team"
                }
            ]
        },
        {
            "sub_cate_id": "182",
            "sub_cate_name": "Other Sports",
            "sub_cate_slug": "other-sports",
            "child": []
        }
    ]
};