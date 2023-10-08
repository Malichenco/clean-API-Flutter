import 'dart:convert';
import 'package:Taillz/screens/login_registration/login_prompt_screen.dart';
import 'package:Taillz/screens/login_registration/login_screen.dart';
import 'package:Taillz/screens/login_registration/otp_verification_screen.dart';
import 'package:Taillz/widgets/custom_flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';


import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/models/notification.dart';
import 'package:Taillz/presentation/screens/main_screen.dart';
import 'package:Taillz/providers/chat_provider.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/utills/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dios/api_dio.dart';
import '../domain/auth/models/registration.dart';
import '../session/session_repo.dart';

class UserProvider with ChangeNotifier {
  String? authToken;
  bool _isLoginLoading=false;
  bool _isOneCall = false;
  bool _isLikeCall = false;
  bool _isShowOneCall = false;
  bool _isRepliedOneCall = false;
  int _mainCommentLength = 0;
  int _mainLikeLength = 0;
  int _mainStoryIndex = 0;
  int? _indexChangeTrue;
  int? _indexMainPos;
  int? _indexRepliedPos;
  int _count =0;
  int _mainRepliedCommentLength = 0;
  final List<List<List<bool>>> _isTrueMainComment = [];
  final List<List<List<int>>> _isTrueRepliedCount = [];
  List<List<bool>> _isMainComment = [];

  List<bool> _isMainLike = [];
  List<int> _isMainLikeCount = [];
  final List<List<bool>> _isTrueComment = [];
  List<List<int>> _isMainCommentCount = [];
  bool _isFirstTimeCall = false;


  bool get isFirstTmeCall => _isFirstTimeCall;

  bool get isLoginLoading => _isLoginLoading;

  bool get isOneCall => _isOneCall;

  bool get isShowOneCall => _isShowOneCall;

  bool get isLikeCall => _isLikeCall;

  bool get isRepliedOneCall => _isRepliedOneCall;

  int? get indexChangeTrue => _indexChangeTrue;

  int? get indexMainPos => _indexMainPos;

  int? get mainLikeLength => _mainLikeLength;

  int? get indexRepliedPos => _indexRepliedPos;

  List<List<List<bool>>> get isTrueMainComment => _isTrueMainComment;

  List<List<List<int>>> get isTrueRepliedCount => _isTrueRepliedCount;

  List<List<bool>> get isMainComment => _isMainComment;

  List<List<int>> get isMainCommentCount => _isMainCommentCount;

  List<bool> get isMainLike => _isMainLike;

  List<int> get isMainLikeCount => _isMainLikeCount;

  List<List<bool>> get isTrueComment => _isTrueComment;

  int get mainCommentLength => _mainCommentLength;
  int get count => _count;

  int get mainRepliedCommentLength => _mainRepliedCommentLength;

  var box = GetStorage();

  void setLoginLoading(bool value){
    _isLoginLoading =value;
  }

  void setOneCall(bool isValue) {
    _isOneCall = isValue;
  }

  void setLikeCall(bool isValue) {
    _isLikeCall = isValue;
  }

  void setReliedOneCall(bool isValue) {
    _isRepliedOneCall = isValue;
  }

  void setIndexChange(int isValue,int value,BuildContext context) {
    _indexChangeTrue = isValue;
    _mainStoryIndex = value;
    setApiMainCommentTrue(context);
  }

  void setRepliedCountAdd(int mainLikePos, int mainPos, int pos) {
    _isTrueRepliedCount[mainLikePos][mainPos][pos]= _isTrueRepliedCount[mainLikePos][mainPos][pos] + 1;
    notifyListeners();
  }

  void setRepliedCountRemove(int mainLikePos, int mainPos, int pos) {
    _isTrueRepliedCount[mainLikePos][mainPos][pos]= _isTrueRepliedCount[mainLikePos][mainPos][pos] - 1;
    notifyListeners();
  }

  void setFirstTimeCallTrue() {
    _isFirstTimeCall = true;
    //notifyListeners();
  }

  void setFirstTimeCallFalse() {
    _isFirstTimeCall = false;
    //notifyListeners();
  }

  void setIndexMainPos(int isMainPos, int isRepliedPos,int count,int value) {
    _indexMainPos = isMainPos;
    _indexRepliedPos = isRepliedPos;
    _count =count;
    _mainStoryIndex=value;
    //notifyListeners();
  }

  void setShowOneCall(bool isValue) {
    _isShowOneCall = isValue;
    notifyListeners();
  }

  void setMainCommentLength(int value, BuildContext context) {
    _mainCommentLength = value;
    //notifyListeners();
  }

  void setMainLikeLength(int value, BuildContext context) {
    _mainLikeLength = value;
    //notifyListeners();
  }

  void setMainCommentFalse(
    BuildContext context,
  ) {
    _isMainComment.clear();

    StoryProvider storyProvider =
        Provider.of<StoryProvider>(context, listen: false);

    if (_isMainComment.isEmpty) {
      for (int i = 0; i < _mainLikeLength; i++) {
        for (int j = 0; j < _mainCommentLength; j++) {
          _isMainLike.add(false);
        }
        _isMainComment.add(_isMainLike);
      }
    }

    setFirstTimeCallFalse();
    setRepliedCommentFalse(context);
  }

  void setApiMainCommentTrue(
    BuildContext context,
  ) {
    if (_indexChangeTrue != null) {
      _isMainComment[_mainStoryIndex][_indexChangeTrue!] = true;
      //notifyListeners();
    }
  }

  void setApiRepliedCommentTrue(
    BuildContext context,
  ) {
    if (_indexMainPos != null) {
      _isTrueMainComment[_mainStoryIndex][_indexMainPos!][_indexRepliedPos!] =
          true;
    }
  }

  void setRepliedCommentFalse(
    BuildContext context,
  ) {
    StoryProvider storyProvider =
        Provider.of<StoryProvider>(context, listen: false);

    _isTrueComment.clear();
    _isMainCommentCount.clear();
    _isTrueMainComment.clear();

    for (int i = 0; i < _mainLikeLength; i++) {
      _isMainLike.add(false);
      _isMainLikeCount.add(0);
      for (int i = 0; i < _mainCommentLength; i++) {
        _isTrueComment.add(_isMainLike);
        _isMainCommentCount.add(_isMainLikeCount);
        _isTrueMainComment.add(isTrueComment);
        _isTrueRepliedCount.add(_isMainCommentCount);

      }
    }
  }

  void chnageReplayLikestatus(int mainLikePos, int mainPos, int pos) {
    List<bool> isData = [];
    for (int i = 0; i < _isTrueMainComment[mainLikePos][mainPos].length; i++) {
      if (pos == i) {
        if (_isTrueMainComment[mainLikePos][mainPos][pos] == false) {
          isData.add(true);

        } else {
          isData.add(false);
        }
      } else {
        isData.add(_isTrueMainComment[mainLikePos][mainPos][i]);
      }
    }
    _isTrueMainComment[mainLikePos][mainPos] = isData;

    notifyListeners();
  }

  void changeMainLikeStatus(int mainLikePos, int mainPos) {
    List<bool> isData = [];
    for (int j = 0; j < _isMainComment[mainLikePos].length; j++) {
      if (mainPos == j) {
        if (_isMainComment[mainLikePos][j] == false) {
          isData.add(true);
        } else {
          isData.add(false);
        }
      } else {
        isData.add(_isMainComment[mainLikePos][j]);
      }
    }

    _isMainComment[mainLikePos] = isData;
    notifyListeners();
  }

  changeAuthToken({required String authToken}) {
    this.authToken = authToken;
    notifyListeners();
  }

  Future userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    Uri uri = Uri.tryParse(ApiNetwork.userLogin)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    StoryProvider storyProvider = Provider.of<StoryProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().post(uri,
        body: json.encode({
          'Email': email,
          'Password': password,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }).catchError((e) {
      throw e;
    }).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {

        showflushbar(
          context,
          response['errors'][0]['message'],
        );
      } else {
        changeAuthToken(authToken: response['payload']);
        saveAuthToken(authToken!);

        Future.delayed(Duration(milliseconds: 100), () {
          storyProvider.getStories(context: context);
          getNotifications(context: context, pageNumber: 0);
          getTopics(context: context);
          storyProvider.getStoriesbyGroup(context: context);
          storyProvider.getMyPublishedStories(context: context);
          storyProvider.getMyDraftStories(context: context);
          storyProvider.getMyPendingStories(context: context);
          storyProvider.getMyRejectedStories(context: context);
          getUserInfo(context: context);
          Provider.of<ChatProvider>(context, listen: false).getUserChatList(context: context,);
        });

        /* Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        ), (route) => false);*/
      }
    });
  }

  void showflushbar(BuildContext context, String title) {
    Flushbar(
      isDismissible: true,
      messageSize: 16,
      messageText: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: const Color(0xff5c5c8a),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1300),
    ).show(context);
  }

  Future userSignup(
      {required Registration registration,
      required BuildContext context}) async {
    Uri uri = Uri.tryParse(ApiNetwork.registration)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider
        .returnConnection()
        .post(uri, body: registration.toJson(), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }).catchError((e) {
      throw e;
    }).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        var errorMessage = response['errors'][0]['message'];
        if (response['errors'][0]['key'] == 'CantUseEmail') {
          errorMessage = TKeys.email_taken_error_message.translate(context);
        } else if (response['errors'][0]['key'] == 'NickNameTaken') {
          errorMessage = TKeys.nickname_used_error_message.translate(context);
        }
        showflushbar(
          context,
          errorMessage,
        );
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return LoginPromptScreen();
          },
        ), (route) => false);
        showFlushBar(context, 'Great Having you!');
      }
    });
  }

  Future sendForgetPasswordOtp(
      {required String email, required BuildContext context}) async {
    Uri uri = Uri.tryParse(ApiNetwork.passwordRecovery)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider
        .returnConnection()
        .post(uri, body: jsonEncode({'email': email}), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }).catchError((e) {
      throw e;
    }).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            response['errors'][0]['message'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
      } else {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            'otp send successfully',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OtpVerificationScreen();
            },
          ),
        );
      }
    });
  }

  Future sendForgetPassword(
      {required String email,
      required int code,
      required String password,
      required BuildContext context}) async {
    Uri uri = Uri.tryParse(
        '${ApiNetwork.baseUrl}clients/PassRecoveryUpdate/$email?code=${code}&password=${password}')!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().put(uri, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }).catchError((e) {
      throw e;
    }).then((value) {
      var response = json.decode(value.body);

      if (response['errors'] != null && response['errors'].isNotEmpty) {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            response['errors'][0]['message'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
      } else {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            'otp send successfully',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      }
    });
  }

  Future likeAndDislike(
      {required int videoId,
      required int userId,
      required BuildContext context}) async {
    Uri uri = Uri.tryParse('${ApiNetwork.baseUrl}AChange/AddVideoLikes')!;
    String token = await getAuthToken();
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().put(uri,
        body: jsonEncode({'videoID': videoId, 'userId': userId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        }).catchError((e) {
      throw e;
    }).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            response['errors'][0]['message'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
      } else {
        Flushbar(
          isDismissible: true,
          messageSize: 16,
          messageText: Text(
            'otp send successfully',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xff121556),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(milliseconds: 2600),
        ).show(context);
      }
    });
  }

  UserInfo? userInfo;

  changeUserInfo({required UserInfo userInfo}) {
    this.userInfo = userInfo;
    notifyListeners();
  }

  Future getUserInfo({required BuildContext context}) async {
    // String authToken = await getAuthToken();
    // changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.getUserInfo)!;
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
        .catchError((e) {
      debugPrint(e);
    }).then((value) async {
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
        changeUserInfo(userInfo: UserInfo.fromMap(response['payload']));
        box.write('userID', response['payload']['id']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user_info', userInfo!.name);
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ), (route) => false);
        });
        Logger.e(box.read('userID'));
      }
    });
  }

  Future getTopics({required BuildContext context}) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.getTopics)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(uri, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    }).catchError(
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
      } else {}
    });
  }

  Future deleteComment({
    required BuildContext context,
    required int commentId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.deleteComment + commentId.toString())!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().delete(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.commentDeleted.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future deleteStory({
    required BuildContext context,
    required int storyId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.deleteStory + storyId.toString())!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().delete(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.storyDelete.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future blockUser({
    required BuildContext context,
    required int userId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.blockUser)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().post(
      uri,
      body: json.encode({
        'Id': userId,
        'Reason': '',
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.userBlcoked.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future reportUser({
    required BuildContext context,
    required int userId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(ApiNetwork.reportUser)!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().post(
      uri,
      body: json.encode({
        'Id': userId,
        'Reason': '',
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
      (err) {
        throw err;
      },
    ).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        BotToast.showText(
          text: 'You have already reported this user',
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      } else {
        BotToast.showText(
          text: TKeys.userReport.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future followUser({
    required BuildContext context,
    required int userId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse('${ApiNetwork.followUser}$userId/tail')!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.userFollow.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future unfollowUser({
    required BuildContext context,
    required int userId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse('${ApiNetwork.unfollowUser}$userId/tail')!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().delete(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.unFollowUser.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Future unBlockUser({
    required BuildContext context,
    required int userId,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(
      ApiNetwork.blockUser,
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        BotToast.showText(
          text: TKeys.unBlock.translate(context),
          contentColor: Constants.blueColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      }
    });
  }

  List<UserInfo>? followingUsers;

  changeFollowingUsers(List<UserInfo>? followingUsers) {
    this.followingUsers = followingUsers;
    notifyListeners();
  }

  Future getFollowingUsers({
    required BuildContext context,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(
      ApiNetwork.getFollowingUsers,
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        List<UserInfo> followingUsers = [];
        for (var user in response['payload']) {
          followingUsers.add(UserInfo.fromMap(user));
        }
        changeFollowingUsers(followingUsers);
      }
    });
  }

  List<UserInfo>? followers;

  changeFollowers(List<UserInfo>? followers) {
    this.followers = followers;
    notifyListeners();
  }

  Future getFollowers({
    required BuildContext context,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(
      ApiNetwork.getFollowers,
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
      (err) {
        throw err;
      },
    ).then(
      (value) {
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
          List<UserInfo> followers = [];
          for (var user in response['payload']) {
            followers.add(UserInfo.fromMap(user));
          }
          changeFollowers(followers);
        }
      },
    );
  }

  List<UserInfo>? blockedUsers;

  changeBlockedUsers(List<UserInfo>? blockedUsers) {
    this.blockedUsers = blockedUsers;
    notifyListeners();
  }

  Future getBlockedUsers({
    required BuildContext context,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(
      ApiNetwork.getBlockedUsers,
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        List<UserInfo> blockedUsers = [];
        for (var user in response['payload']) {
          blockedUsers.add(UserInfo.fromMap(user));
        }
        changeBlockedUsers(blockedUsers);
      }
    });
  }

  List<UserInfo>? hiddenUsers;

  changeHiddenUsers(List<UserInfo>? hiddenUsers) {
    this.hiddenUsers = hiddenUsers;
    notifyListeners();
  }

  Future getHiddenUsers({
    required BuildContext context,
  }) async {
    String authToken = await getAuthToken();
    changeAuthToken(authToken: authToken);
    Uri uri = Uri.tryParse(
      ApiNetwork.getHiddenUsers,
    )!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    ).catchError(
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
        List<UserInfo> hiddenUsers = [];
        for (var user in response['payload']) {
          hiddenUsers.add(UserInfo.fromMap(user));
        }
        changeHiddenUsers(hiddenUsers);
      }
    });
  }

  List<NotificationModel>? notifications;

  changeNotifications(List<NotificationModel>? notifications) {
    this.notifications = notifications;
    notifyListeners();
  }

  int? unReadNotificationCount;

  changeNotificationsCount(int notificationsCount) {
    unReadNotificationCount = notificationsCount;
    notifyListeners();
  }

  Future getNotifications({
    required BuildContext context,
    int pageNumber = 0,
  }) async {
    // await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);

    Uri uri = Uri.tryParse(
      ApiNetwork.getNotification + pageNumber.toString(),
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
        .then(
      (value) {
        Logger.w(value.body);
        pageNumber == 0 ? notifications = [] : null;
        notifications ??= [];
        pageNumber == 0 ? unReadNotificationCount = 0 : null;
        var response = json.decode(value.body);
        changeNotificationsCount(response['payload']['unread_notifs_no']);
        if (response['payload']['notifs_on_this_page'] != null &&
            response['payload']['notifs_on_this_page']!.isNotEmpty) {
          response['payload']['notifs_on_this_page'].forEach(
            (e) {
              notifications!.add(NotificationModel.fromMap(e));
            },
          );
        }
        changeNotifications(notifications);
      },
    );
    return null;
  }

  //Todo:============Like crud===========
  Future<Map<String, dynamic>> addLike(commentID,userId) async {
    String token = await getAuthToken();
    Map<String, dynamic> map = Map();

    map['userId'] = userId;
    map['commentID'] = commentID;
    final data = await httpClientWithHeader(token)
        .put("Comments/AddLikes", data: jsonEncode(map));
    return data.data;
  }

  removeLike(commentID,userId) async {
    String token = await getAuthToken();
    Map<String, dynamic> map = Map();
    map['userId'] = userId;
    map['commentID'] = commentID;
    final data = await httpClientWithHeader(token)
        .put("Comments/RemoveLikes", data: jsonEncode(map));
  }

  addLikeOnReplay(commentID,userId) async {
    String token = await getAuthToken();
    UserInfo user = await getSession();
    Map<String, dynamic> map = Map();
    map['userId'] = userId;
    map['commentID'] = commentID;
    final data = await httpClientWithHeader(token)
        .put("RepliedComments/AddLikes", data: jsonEncode(map));
  }

  removeLikeOnReplay(commentID) async {
    String token = await getAuthToken();
    UserInfo user = await getSession();
    Map<String, dynamic> map = Map();
    map['userId'] = user.id;
    map['commentID'] = commentID;
    final data = await httpClientWithHeader(token)
        .put("RepliedComments/RemoveLikes", data: jsonEncode(map));
  }
}
