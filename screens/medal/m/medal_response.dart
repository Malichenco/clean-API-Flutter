class MedalResponse {
  MedalResponse({
      this.success, 
      this.payload, 
      this.errors,});

  MedalResponse.fromJson(dynamic json) {
    success = json['success'];
    payload = json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v);
      });
    }
  }
  bool? success;
  Payload? payload;
  List<dynamic>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (payload != null) {
      map['payload'] = payload?.toJson();
    }
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Payload {
  Payload({
      this.topWrites, 
      this.supportives,});

  Payload.fromJson(dynamic json) {
    if (json['topWrites'] != null) {
      topWrites = [];
      json['topWrites'].forEach((v) {
        topWrites?.add(TopWrites.fromJson(v));
      });
    }
    if (json['supportives'] != null) {
      supportives = [];
      json['supportives'].forEach((v) {
        supportives?.add(Supportives.fromJson(v));
      });
    }
  }
  List<TopWrites>? topWrites;
  List<Supportives>? supportives;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (topWrites != null) {
      map['topWrites'] = topWrites?.map((v) => v.toJson()).toList();
    }
    if (supportives != null) {
      map['supportives'] = supportives?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Supportives {
  Supportives({
      this.username, 
      this.points,});

  Supportives.fromJson(dynamic json) {
    username = json['username'];
    points = json['points'];
  }
  String? username;
  int? points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['points'] = points;
    return map;
  }

}

class TopWrites {
  TopWrites({
      this.username, 
      this.points,});

  TopWrites.fromJson(dynamic json) {
    username = json['username'];
    points = json['points'];
  }
  String? username;
  int? points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['points'] = points;
    return map;
  }

}