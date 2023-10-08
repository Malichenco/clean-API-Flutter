import 'dart:convert';

import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:Taillz/utills/prefs.dart';

import '../Dios/api_dio.dart';
import '../screens/karma/m/karma_response.dart';

Future<KarmaResponse> ListenerKarma() async {
  String token= await getAuthToken();
  UserInfo info=await getSession();
  var response = await httpClientWithHeader(token).get("Karma/GetKarmaDataByUserID",
    queryParameters:{
    "userId":info.id
  },);
  return KarmaResponse.fromJson(response.data);
}
