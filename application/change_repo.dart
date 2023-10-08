import 'dart:convert';

import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:Taillz/utills/prefs.dart';

import '../Dios/api_dio.dart';
import '../screens/change/m/change_response.dart';

Future<ChangeResponse> ListenerGetVideos() async {
  String token= await getAuthToken();
  UserInfo info=await getSession();
  var response = await httpClientWithHeader(token).get("AChange/GetVideos",);
  return ChangeResponse.fromJson(response.data);
}
