class CategoryResponse {
    bool? status;
    String? message;
    List<Category>? data;

    CategoryResponse({
        this.status,
        this.message,
        this.data,
    });

    factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Category>.from(json["data"]!.map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Category {
    String? name;
    String? slug;
    String? id;

    Category({
        this.name,
        this.slug,
        this.id,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        slug: json["slug"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "id": id,
    };
}



Map<String,dynamic> categoryResponseData={
    "status": true,
    "message": "",
    "data": [
        {
            "name": "News",
            "slug": "hot-news",
            "id": "80"
        },
        {
            "name": "Politics",
            "slug": "politics",
            "id": "82"
        },
        {
            "name": "Sports",
            "slug": "sports",
            "id": "83"
        },
        {
            "name": "Business",
            "slug": "business",
            "id": "142"
        },
        {
            "name": "Entertainment",
            "slug": "entertainment",
            "id": "86"
        },
        {
            "name": "Videos",
            "slug": "videos",
            "id": "87"
        },
        {
            "name": "Oil & Gas",
            "slug": "oil-gas",
            "id": "91"
        },
        {
            "name": "Tech",
            "slug": "tech",
            "id": "89"
        },
        {
            "name": "Opinion",
            "slug": "opinion",
            "id": "88"
        },
        {
            "name": "World",
            "slug": "world",
            "id": "141"
        },
        {
            "name": "Campus",
            "slug": "campus",
            "id": "96"
        },
        {
            "name": "Companies",
            "slug": "companies",
            "id": "92"
        },
        {
            "name": "Photo News",
            "slug": "photo-news-nigeria",
            "id": "201"
        },
        {
            "name": "Crime",
            "slug": "crime",
            "id": "161"
        },
        {
            "name": "Life",
            "slug": "life",
            "id": "199"
        },
        {
            "name": "Sponsored & Press Releases",
            "slug": "sponsored-articles-press",
            "id": "225"
        },
        {
            "name": "Diaspora",
            "slug": "nigeria-diaspora",
            "id": "249"
        },
        {
            "name": "Ask AllNews",
            "slug": "ask-allnews-nigeria",
            "id": "258"
        },
        {
            "name": "Features",
            "slug": "allnews-featured-stories",
            "id": "259"
        }
    ]
};