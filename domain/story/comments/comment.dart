import 'dart:convert';

import 'RepliedComment.dart';

class Comment {
  List<RepliedComment> repliedComment;
  final int id;
  final String publishDate;
  final String body;
  final String likedUserIds;
  final int userId;
  final int storyId;
  final int likesCount;

  Comment({
    required this.repliedComment,
    required this.id,
    required this.publishDate,
    required this.body,
    required this.likedUserIds,
    required this.userId,
    required this.storyId,
    required this.likesCount,
  });

  Comment copyWith({
    List<RepliedComment>? repliedComment,
    int? id,
    String? publishDate,
    String? body,
    String? likedUserIds,
    int? userId,
    int? storyId,
    int? likesCount,
  }) {
    return Comment(
      repliedComment: repliedComment ?? this.repliedComment,
      id: id ?? this.id,
      publishDate: publishDate ?? this.publishDate,
      body: body ?? this.body,
      likedUserIds: likedUserIds ?? this.likedUserIds,
      userId: userId ?? this.userId,
      storyId: storyId ?? this.storyId,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'repliedComment': repliedComment,
      'id': id,
      'publishDate': publishDate,
      'body': body,
      'likedUserIds': likedUserIds,
      'userId': userId,
      'storyId': storyId,
      'likesCount': likesCount,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    List<RepliedComment> repliedCommentList = [];

    if (map['repliedComment'] != null) {
      repliedCommentList = [];

      map['repliedComment'].forEach((v) {
        repliedCommentList.add(RepliedComment.fromJson(v));
      });
    }

    return Comment(
      repliedComment: repliedCommentList,
      id: map['id']?.toInt() ?? 0,
      publishDate: map['publishDate'] ?? '',
      body: map['body'] ?? '',
      likedUserIds: map['likedUserIds'] ?? '',
      userId: map['userId']?.toInt() ?? 0,
      storyId: map['storyId']?.toInt() ?? 0,
      likesCount: map['likesCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(repliedComment: $repliedComment,id: $id, publishDate: $publishDate, body: $body, likedUserIds: $likedUserIds, userId: $userId, storyId: $storyId, likesCount: $likesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.repliedComment == repliedComment &&
        other.id == id &&
        other.publishDate == publishDate &&
        other.body == body &&
        other.likedUserIds == likedUserIds &&
        other.userId == userId &&
        other.storyId == storyId &&
        other.likesCount == likesCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        repliedComment.hashCode ^
        publishDate.hashCode ^
        body.hashCode ^
        likedUserIds.hashCode ^
        userId.hashCode ^
        storyId.hashCode ^
        likesCount.hashCode;
  }
}
