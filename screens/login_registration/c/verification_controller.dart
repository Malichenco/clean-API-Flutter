import 'package:Taillz/screens/polls/m/pole_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../application/pole_repo.dart';

class VerificationController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


void opted(option){
  ListenerOpted(option).then((value){
  });
}
  onError(e){
    if(e is DioError){
      print(e.message);
    }
  }
}
