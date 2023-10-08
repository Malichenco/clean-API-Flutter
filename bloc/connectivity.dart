import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Taillz/utills/constant.dart';

class BlocClass extends Bloc<MyEvents, bool> {
  BlocClass(bool initalState) : super(initalState) {
    initialState();
  }
  var box = GetStorage();

  initialState() {
    Stream.periodic(
      const Duration(seconds: 5),
    ).listen((event) async {
      mapEventToState();
    });

    return true;
  }

  internetConnectionAvailabilty() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!state) {
          mapEventToState();
        }
      }
    } on SocketException catch (_) {
      if (state) {
        mapEventToState();
      }
    }
  }

  mapEventToState() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {

      Future.delayed(
        const Duration(seconds: 2),
        () {
          BotToast.showText(
            text: box.read('lang') == 'he'
                ? 'מחפשים רשת'
                : 'Searching for Network',
            duration: const Duration(seconds: 3),
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            contentColor: Constants.blueColor,
          );
        },
      );
    } else {
      /*BotToast.showText(
        text: box.read('lang') == 'he' ? 'מחפשים רשת' : 'Searching for Network',
        duration: const Duration(seconds: 3),
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        contentColor: Constants.blueColor,
      );*/
     /* BotToast.closeAllLoading();*/
    }
  }
}

enum MyEvents {
  connnectionLost,
  connectionAvailable,
}
