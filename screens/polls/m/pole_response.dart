class PoleResponse {
  PoleResponse({
      this.success, 
      this.payload, 
  });

  PoleResponse.fromJson(dynamic json) {
    success = json['success'];
    if (json['payload'] != null) {
      payload = [];
      if(json['payload'] is String){
        errors=json['payload'];
      }else {
        json['payload'].forEach((v) {
          payload?.add(Payload.fromJson(v));
        });
      }
    }

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

    return map;
  }

}

class Payload {
  Payload({
      this.id, 
      this.pollTopic, 
      this.pollQuestion, 
      this.pollPublishedDate, 
      this.pollEndingDate, 
      this.votesYes, 
      this.votedNo, 
      this.votedIrrelavent, 
      this.totalVotes,});

  Payload.fromJson(dynamic json) {
    id = json['id'];
    pollTopic = json['pollTopic'];
    pollQuestion = json['pollQuestion'];
    pollPublishedDate = json['pollPublishedDate'];
    pollEndingDate = json['pollEndingDate'];
    votesYes = json['votesYes'];
    votedNo = json['votedNo'];
    votedIrrelavent = json['votedIrrelavent'];
    totalVotes = json['totalVotes'];
  }
  int? id;
  String? pollTopic;
  String? pollQuestion;
  String? pollPublishedDate;
  String? pollEndingDate;
  int? votesYes;
  int? votedNo;
  int? votedIrrelavent;
  int? totalVotes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollTopic'] = pollTopic;
    map['pollQuestion'] = pollQuestion;
    map['pollPublishedDate'] = pollPublishedDate;
    map['pollEndingDate'] = pollEndingDate;
    map['votesYes'] = votesYes;
    map['votedNo'] = votedNo;
    map['votedIrrelavent'] = votedIrrelavent;
    map['totalVotes'] = totalVotes;
    return map;
  }

}