import 'package:Taillz/screens/polls/m/pole_response.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../Localization/t_keys.dart';
import '../../../application/pole_repo.dart';
import '../polls_screen.dart';

class PoleController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ChartData> data = [];

  PoleResponse? response;
  void getPole() {
    data.clear();
    ListenerPole().then((value) {
      response = value;
      data.addAll([
        ChartData(
          Container(
            height: 32,
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: Color(0xFFbdf1a7),
            ),
            alignment: Alignment.center,
            child: Text(TKeys.yes.translate(scaffoldKey.currentContext),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white)),
          ),
          TKeys.yes.translate(scaffoldKey.currentContext),
          double.tryParse(response!.payload!.first.votesYes.toString()) ?? 0,
        ),
        ChartData(
          Container(
            height: 32,
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: Color(0xFFff944d),
            ),
            alignment: Alignment.center,
            child: Text(TKeys.no.translate(scaffoldKey.currentContext),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white)),
          ),
          TKeys.no.translate(scaffoldKey.currentContext),
          double.tryParse(response!.payload!.first.votedNo.toString()) ?? 0,
        ),
        ChartData(
          Container(
            height: 32,
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: Color(0xFFd1b3ff),
            ),
            alignment: Alignment.center,
            child: Text(TKeys.irrelevant.translate(scaffoldKey.currentContext),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white)),
          ),
          TKeys.irrelevant.translate(scaffoldKey.currentContext),
          double.tryParse(
                  response!.payload!.first.votedIrrelavent.toString()) ??
              0,
        ),
      ]);
      notifyListeners();
    }).catchError(onError);
  }

  Future<PoleResponse> opted(option) async {
    var response = await ListenerOpted(option);
    if (!response.success!) {
      getPole();
    }
    return response;
  }

  onError(e) {
    if (e is DioError) {
      print(e.message);
    }
  }
}
