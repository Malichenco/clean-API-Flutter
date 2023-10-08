import 'dart:convert';

import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class ConsultProvider extends ChangeNotifier{
  bool _isLoadedForConsult = false;
  List<StoryModel> _storiesByGroups = [];
  int _pageNumber = 0;
  var box = GetStorage();


  bool get isLoadedForConsult => _isLoadedForConsult;
  int get pageNumber => _pageNumber;
  List<StoryModel> get storiesByGroups => _storiesByGroups;

  pageNumberAdd(){
    _pageNumber++;
    notifyListeners();
  }

  getStories(String name,BuildContext context) async {
    Uri uri = Uri.tryParse(
      '${ApiNetwork.getStoriesByTopic}$name&page=$pageNumber',
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    pageNumber == 0 ? _storiesByGroups = [] : storiesByGroups;
    await widgetProvider
        .returnConnection()
        .get(
      uri,
      headers: Constants.authenticatedHeaders(
          context: context, userToken: box.read('userTokenForAuth')),
    )
        .catchError(
          (err) {
        throw err;
      },
    ).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        BotToast.showText(
          text: '${response['errors'][0]['message']}',
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      } else {
        Logger.e(response['payload'].length);
        if (response['payload'].length < 7) {
          _isLoadedForConsult = true;
        }
        response['payload'].forEach(
              (element) {
            storiesByGroups.add(StoryModel.fromMap(element));
          },
        );

        notifyListeners();
      }
    });
  }


}