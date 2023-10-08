class ChangeResponse {
  ChangeResponse({
      this.success, 
      this.payload, 
      this.errors,});

  ChangeResponse.fromJson(dynamic json) {
    success = json['success'];
    if (json['payload'] != null) {
      payload = [];
      json['payload'].forEach((v) {
        payload?.add(Payload.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v);
      });
    }
  }
  bool? success;
  List<Payload>? payload;
  List<dynamic>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (payload != null) {
      map['payload'] = payload?.map((v) => v.toJson()).toList();
    }
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Payload {
  Payload({
      this.id, 
      this.userId, 
      this.pathLocation, 
      this.videoTopic, 
      this.views, 
      this.totalLikes, 
      this.totalComments, 
      this.publisherName,});

  Payload.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    pathLocation = json['pathLocation'];
    videoTopic = json['videoTopic'];
    views = json['views'];
    totalLikes = json['totalLikes'];
    totalComments = json['totalComments'];
    publisherName = json['publisherName'];
  }
  int? id;
  int? userId;
  String? pathLocation;
  String? videoTopic;
  int? views;
  int? totalLikes;
  int? totalComments;
  String? publisherName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['pathLocation'] = pathLocation;
    map['videoTopic'] = videoTopic;
    map['views'] = views;
    map['totalLikes'] = totalLikes;
    map['totalComments'] = totalComments;
    map['publisherName'] = publisherName;
    return map;
  }

}