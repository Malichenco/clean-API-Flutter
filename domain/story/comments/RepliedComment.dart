import 'dart:convert';

RepliedComment repliedCommentFromJson(String str) => RepliedComment.fromJson(json.decode(str));

String repliedCommentToJson(RepliedComment data) => json.encode(data.toJson());

class RepliedComment {
  ItemColor itemColor;
  int id;
  String publishDate;
  String body;
  int commentId;
  String likedUserIds;
  int storyId;
  int userId;
  int? likesCount;
  dynamic language;
  bool isPendingApproval;
  dynamic isDeniedApproval;

  RepliedComment({
    required this.itemColor,
    required this.id,
    required this.publishDate,
    required this.body,
    required this.commentId,
    required this.storyId,
    required this.userId,
    this.language,
    required this.isPendingApproval,
    this.isDeniedApproval,
    this.likesCount,
    required this.likedUserIds,
  });

  factory RepliedComment.fromJson(Map<String, dynamic> json) => RepliedComment(
    itemColor: ItemColor.fromJson(json["itemColor"] ?? {}),
    id: json["id"],
    publishDate: json["publishDate"],
    body: json["body"] ?? '',
    commentId: json["commentId"],
    storyId: json["storyId"],
    userId: json["userId"],
    language: json["language"],
    isPendingApproval: json["isPendingApproval"] ?? false,
    isDeniedApproval: json["isDeniedApproval"],
    likesCount: json["likesCount"] ?? 0,
    likedUserIds: json["likedUserIds"],
  );

  Map<String, dynamic> toJson() => {
    "itemColor": itemColor.toJson(),
    "id": id,
    "publishDate": publishDate,
    "body": body,
    "commentId": commentId,
    "storyId": storyId,
    "userId": userId,
    "language": language,
    "isPendingApproval": isPendingApproval,
    "isDeniedApproval": isDeniedApproval,
    "likesCount": likesCount,
    "likedUserIds": likedUserIds,
  };
}

class ItemColor {
  int id;
  int index;
  String value;
  String colorHex;
  String fatherName;
  bool isSpecial;
  int fatherId;

  ItemColor({
    required this.id,
    required this.index,
    required this.value,
    required this.colorHex,
    required this.fatherName,
    required this.isSpecial,
    required this.fatherId,
  });

  factory ItemColor.fromJson(Map<String, dynamic> json) => ItemColor(
    id: json["id"] ?? 0,
    index: json["index"] ?? 0,
    value: json["value"] ?? '',
    colorHex: json["colorHex"] ?? '',
    fatherName: json["fatherName"] ?? '',
    isSpecial: json["isSpecial"] ?? false,
    fatherId: json["fatherId"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "index": index,
    "value": value,
    "colorHex": colorHex,
    "fatherName": fatherName,
    "isSpecial": isSpecial,
    "fatherId": fatherId,
  };
}
