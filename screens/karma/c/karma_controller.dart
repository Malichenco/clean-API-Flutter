import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../application/karma_repo.dart';
import '../m/karma_response.dart';

class KarmaController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  KarmaResponse? response;
  void getKarma() {
    ListenerKarma().then((value){
      response=value;
      notifyListeners();
    }).catchError(onError);
  }
  onError(e){
    if(e is DioError){
      print(e.message);
    }
  }
  String getTotal(){
   double total=0;
   if(response!=null) {
     response!.payload!.forEach((element) {
     total=total+element.karmaPoints!;
   });
   }
   return total.toStringAsFixed(0);
  }
}
