import 'package:Taillz/screens/medal/m/medal_response.dart';
import 'package:Taillz/screens/polls/m/pole_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../application/medal_repo.dart';

class MedalController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MedalResponse? response;
  void getMedal() {
    ListenerMedal().then((value){
      response=value;
      notifyListeners();
    }).catchError(onError);
  }
  onError(e){
    if(e is DioError){
      print(e.message);
    }
  }
}
