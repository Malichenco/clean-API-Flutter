import 'dart:convert';

import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:Taillz/utills/prefs.dart';

import '../Dios/api_dio.dart';
import '../screens/polls/m/pole_response.dart';

Future<PoleResponse> ListenerPole() async {
  String token= await getAuthToken();
  UserInfo user= await getSession();
  var response = await httpClientWithHeader(token).get("QuestionPoll/GetQuestionPollID?id=1&UserId=${user.id}",);
  return PoleResponse.fromJson(response.data);
}
Future<PoleResponse> ListenerOpted(Opted) async {
  String token= await getAuthToken();
  UserInfo user= await getSession();
  var response = await httpClientWithHeader(token).put("QuestionPoll/VoteQuestionPoll?ID=1&Opted=$Opted&UserId=${user.id}",);
  return PoleResponse.fromJson(response.data);
}
