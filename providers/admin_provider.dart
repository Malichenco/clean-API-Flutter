import 'dart:convert';

import 'package:Taillz/domain/story/pending_stories_model.dart';
import 'package:Taillz/post_background_image_controller.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class AdminProvider extends ChangeNotifier {
  List<PendingStoriesModel> _myPendingStoriesList = [];

  int _pageNumber = 0;

  final int _limit = 16;

  bool _isLoading = false;
  bool _isApiLoading = false;
  List<bool> _isExpanded = [];

  bool _isFabVisible = true;

  final ScrollController _scrollController = ScrollController();

  List<PendingStoriesModel> get myPendingStoriesList => _myPendingStoriesList;

  int get pageNumber => _pageNumber;

  List<bool> get isExpanded => _isExpanded;

  int get limit => _limit;

  bool get isFabVisible => _isFabVisible;
  bool get isApiLoading => _isApiLoading;

  bool get isLoading => _isLoading;

  ScrollController get scrollController => _scrollController;

  void setIsLoading(bool isValue) {
    _isLoading = isValue;
    notifyListeners();
  }

  void setVisible(bool isValue) {
    _isFabVisible = isValue;
    notifyListeners();
  }

  void scrollUp() {
    const double start = 0;

    _scrollController.animateTo(start,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }

  getMyPublication(BuildContext context) async {
    var box = GetStorage();
    _isApiLoading = true;


    Uri uri = Uri.tryParse(
      '${ApiNetwork.getStories}/pending-stories?page=$_pageNumber&limit=10',
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
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
      _myPendingStoriesList = [];
      _isExpanded = [];
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
        _isApiLoading = false;
        notifyListeners();
      } else {
        Logger.e(response['payload']);
        for (int i = 0; i < response['payload'].length; i++) {
          _myPendingStoriesList.add(PendingStoriesModel.fromJson(response['payload'][i]));
          _isExpanded.add(false);
          notifyListeners();
        }

        for (int i = 0; i < _myPendingStoriesList.length; i++) {
          _myPendingStoriesList[i].image =
              PostBackgroundImageController.bgImages[i];
          notifyListeners();
        }

        _isApiLoading = false;
        notifyListeners();
      }
    });
  }

  Future loadData(BuildContext context) async {
    var box = GetStorage();
    await Future.delayed(const Duration(seconds: 2));

    _pageNumber +=1;

    try{

      Uri uri = Uri.tryParse(
        '${ApiNetwork.getStories}/pending-stories?page=$_pageNumber&limit=10',
      )!;
      WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
        context,
        listen: false,
      );
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
          notifyListeners();
        } else {
          Logger.e(response['payload']);
          for (int i = 0; i < response['payload'].length; i++) {
            _myPendingStoriesList
                .add(PendingStoriesModel.fromJson(response['payload'][i]));
            _isExpanded.add(false);
            notifyListeners();
          }

          for (int i = 0; i < _myPendingStoriesList.length; i++) {
            _myPendingStoriesList[i].image =
            PostBackgroundImageController.bgImages[i];

            notifyListeners();
          }

          _isLoading=false;
          notifyListeners();
        }
      });
    }catch(error){
      if(kDebugMode){
        print("Something went wrong");
      }
    }
  }
}
