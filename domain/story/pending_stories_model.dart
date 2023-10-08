import 'dart:convert';

PendingStoriesModel pendingStoriesModelFromJson(String str) => PendingStoriesModel.fromJson(json.decode(str));

String pendingStoriesModelToJson(PendingStoriesModel data) => json.encode(data.toJson());

class PendingStoriesModel {
  String? image;
  dynamic category;
  String? consultImage;
  int? id;
  int? storyStatus;
  bool? isCommentsAlowed;
  String? title;
  String? description;
  String? body;
  int? userId;
  String? publishDate;
  String? approvedDate;
  List<dynamic>? storyTopic;
  dynamic likedUserStory;
  dynamic viewedUserStory;
  int? views;
  int? likes;
  dynamic subCategory;
  String? language;
  dynamic isPoll;
  dynamic pollData;
  dynamic isNew;
  dynamic user;

  PendingStoriesModel({
    this.image,
    this.category,
    this.consultImage,
    this.id,
    this.storyStatus,
    this.isCommentsAlowed,
    this.title,
    this.description,
    this.body,
    this.userId,
    this.publishDate,
    this.approvedDate,
    this.storyTopic,
    this.likedUserStory,
    this.viewedUserStory,
    this.views,
    this.likes,
    this.subCategory,
    this.language,
    this.isPoll,
    this.pollData,
    this.isNew,
    this.user,
  });

  factory PendingStoriesModel.fromJson(Map<String, dynamic> json) => PendingStoriesModel(
    image: json["image"],
    category: json["category"],
    consultImage: json["consultImage"],
    id: json["id"],
    storyStatus: json["storyStatus"],
    isCommentsAlowed: json["isCommentsAlowed"],
    title: json["title"],
    description: json["description"],
    body: json["body"],
    userId: json["userID"],
    publishDate: json["publishDate"],
    approvedDate: json["approvedDate"],
    storyTopic: List<dynamic>.from(json["storyTopic"].map((x) => x)),
    likedUserStory: json["likedUserStory"],
    viewedUserStory: json["viewedUserStory"],
    views: json["views"],
    likes: json["likes"],
    subCategory: json["subCategory"],
    language: json["language"],
    isPoll: json["isPoll"],
    pollData: json["pollData"],
    isNew: json["isNew"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "category": category,
    "consultImage": consultImage,
    "id": id,
    "storyStatus": storyStatus,
    "isCommentsAlowed": isCommentsAlowed,
    "title": title,
    "description": description,
    "body": body,
    "userID": userId,
    "publishDate": publishDate,
    "approvedDate": approvedDate,
    "storyTopic": List<dynamic>.from(storyTopic?.map((x) => x) ?? {}),
    "likedUserStory": likedUserStory,
    "viewedUserStory": viewedUserStory,
    "views": views,
    "likes": likes,
    "subCategory": subCategory,
    "language": language,
    "isPoll": isPoll,
    "pollData": pollData,
    "isNew": isNew,
    "user": user,
  };
}
