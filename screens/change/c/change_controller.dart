import 'package:Taillz/screens/change/m/change_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../application/change_repo.dart';
import '../../../application/karma_repo.dart';

class ChangeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ChangeResponse? response;
  void getVideos() {
    ListenerGetVideos().then((value){
      response=value;
      notifyListeners();
    });
  }
  _error(e){
    if(e is DioError){
      print(e.message);
    }
  }
}
