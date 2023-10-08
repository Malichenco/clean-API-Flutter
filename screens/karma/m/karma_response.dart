class KarmaResponse {
  KarmaResponse({
      this.success, 
      this.payload, 
      this.errors,});

  KarmaResponse.fromJson(dynamic json) {
    success = json['success'];
    if (json['payload'] != null) {
      payload = [];
      json['payload'].forEach((v) {
        payload?.add(Payload.fromJson(v));
      });
    }
    errors = json['errors'].toString();
  }
  bool? success;
  List<Payload>? payload;
  String? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (payload != null) {
      map['payload'] = payload?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }

}

class Payload {
  Payload({
      this.id, 
      this.userId, 
      this.totalComments, 
      this.totalCommentPoints, 
      this.totalLikes, 
      this.totalLikesPoints, 
      this.karmaPoints,});

  Payload.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    totalComments = json['totalComments'];
    totalCommentPoints = json['totalCommentPoints'];
    totalLikes = json['totalLikes'];
    totalLikesPoints = json['totalLikesPoints'];
    karmaPoints = json['karmaPoints']??0;
  }
  int? id;
  int? userId;
  int? totalComments;
  int? totalCommentPoints;
  int? totalLikes;
  int? totalLikesPoints;
  int? karmaPoints;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['totalComments'] = totalComments;
    map['totalCommentPoints'] = totalCommentPoints;
    map['totalLikes'] = totalLikes;
    map['totalLikesPoints'] = totalLikesPoints;
    map['karmaPoints'] = karmaPoints;
    return map;
  }

}