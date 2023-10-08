// import 'dart:async';

import 'dart:async';
import 'dart:convert';

import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:Taillz/application/auth/auth_provider.dart';
import 'package:Taillz/application/auth/auth_state.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/presentation/screens/main_screen.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/utills/prefs.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../login_registration/login_prompt_screen.dart';
import '../login_registration/login_screen.dart';

// ignore: must_be_immutable
class SplashScreen extends HookConsumerWidget {
  String? isUserCreated;

  SplashScreen({Key? key, this.isUserCreated}) : super(key: key);

  final box = GetStorage();
  var globalKey = GlobalKey();
  var PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=YOUR-APP-ID';



  @override
  Widget build(BuildContext context, ref) {
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);
    StoryProvider storyProvider = provider.Provider.of<StoryProvider>(context);

    navigatorToMainScreen()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('current_user_info');

      if(action==null){
        checkVersion(context: context, ref: ref);
      }
      else{
        if(action.isEmpty){
          checkVersion(context: context, ref: ref);
        }else{
         Future.delayed(Duration(seconds: 2),(){ provider.Provider.of<UserProvider>(context,listen: false).getUserInfo(context: context);});
        }
      }
    }

    if(userProvider.isOneCall == false) {
      navigatorToMainScreen();
      userProvider.setOneCall(true);
    }



    ref.listen<AuthState>(authProvider, (p, c) async {
      if (p?.loading != c.loading && !c.loading) {
        // if (userProvider.authToken != null) {
        Logger.w(
            '${userProvider.authToken}  =================================================================================');
        Logger.d(
            '${c.userInfo}  =================================================================================');
        if (c.userInfo != UserInfo.empty()) {
          io.Socket socket = io.io(
            ApiNetwork.notifications,
          );
          socket.onConnect((_) {
            debugPrint('connect');
            socket.emit('msg', 'test');
          });
          socket.on('event', (data) => debugPrint(data));
          socket.onDisconnect((_) => debugPrint('disconnect'));
          socket.on('fromServer', (_) => debugPrint(_));
          String authToken = await getAuthToken();
          userProvider.changeAuthToken(authToken: authToken);
          userProvider.getUserInfo(context: context);
          userProvider.getNotifications(
            context: context,
            pageNumber: 0,
          );
          userProvider.getTopics(context: context);
          storyProvider.getStoriesbyGroup(context: context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (builder) => MainScreen(),
            ),
          );
        } else {
          io.Socket socket = io.io(
            ApiNetwork.notifications,
          );
          socket.io.options['extraHeaders'] = Constants.authenticatedHeaders(
              context: context, userToken: box.read('userTokenForAuth'));
          socket.onConnect((_) {
            debugPrint('connect');
            socket.emit('msg', 'test');
          });
          socket.on('event', (data) => debugPrint(data));
          socket.onDisconnect((_) => debugPrint('disconnect'));
          socket.on('fromServer', (_) => debugPrint(_));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // builder: (builder) => LoginScreen(demo: isUserCreated),
              builder: (builder) => LoginPromptScreen(demo: isUserCreated),
            ),
          );
        }
      }
    });

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/splash.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: const Center(),
    );
  }

  Future checkVersion({required BuildContext context, required var ref}) async {
    Uri uri = Uri.tryParse(ApiNetwork.getAppVersion)!;
    WidgetProvider widgetProvider = provider.Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().get(uri, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }).catchError((e) {
      throw e;
    }).then((value) async {

      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        useEffect(() {
          Future.delayed(const Duration(seconds: 3), () async {

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPromptScreen()));

            /*ref.read(authProvider.notifier).tryLogin();
            ref.read(authProvider.notifier).getLanguage();*/
          });

          return null;
        }, []);
      } else {
        if (response["payload"][0]["isNewUpdateAvailable"]) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String buildNumber = packageInfo.buildNumber;

          if (int.parse(response["payload"][0]["currentVerion"]) <= int.parse(buildNumber)) {
            Future.delayed(const Duration(seconds: 3), () async {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPromptScreen()));
             /* ref.read(authProvider.notifier).tryLogin();
              ref.read(authProvider.notifier).getLanguage();*/
            });
          } else {
            return _showVersionDialog(context);
          }
        } else {
          Future.delayed(const Duration(seconds: 3), () async {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPromptScreen()));
            /*ref.read(authProvider.notifier).tryLogin();
            ref.read(authProvider.notifier).getLanguage();*/
          });
        }
      }
    });
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = TKeys.version_title.translate(context);
        String message =
        TKeys.version_desc.translate(context);
        String btnLabel = TKeys.version_now.translate(context);
        String btnLabelCancel = TKeys.version_cancel.translate(context);
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel),
                onPressed: () => _launchURL(
                    'https://play.google.com/store/apps/details?id=com.taillz'),
              ),
            ],
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
