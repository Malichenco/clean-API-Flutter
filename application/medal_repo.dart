import 'dart:convert';

import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:Taillz/utills/prefs.dart';

import '../Dios/api_dio.dart';
import '../screens/medal/m/medal_response.dart';
import '../screens/polls/m/pole_response.dart';

Future<MedalResponse> ListenerMedal() async {
  String token= await getAuthToken();
  UserInfo user= await getSession();
  var response = await httpClientWithHeader(token).get("medals",);
  return MedalResponse.fromJson(response.data);
}

