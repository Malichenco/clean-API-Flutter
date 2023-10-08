import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<UserInfo> blockedUsers = [];
  bool isLoading = true;
  List<String> waitingMessages = [];
  List<bool> enableButtonsForUnblocking = [];
  @override
  void initState() {
    super.initState();
    getBlockedUser();
  }

  void getBlockedUser() async {
    var box = GetStorage();
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
        'Authorization': 'Bearer ${box.read('userTokenForAuth')}',
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
        for (var user in response['payload']) {
          blockedUsers.add(UserInfo.fromMap(user));
          waitingMessages.add(user['waitComment']);
          var sentence = user['waitComment'];
          List splited = sentence.split(' ');
          var finalResult = int.parse(splited.last) > 0 ? false : true;
          enableButtonsForUnblocking.add(finalResult);
          sentence = '';
          splited = [];
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void unBlockUser(int id) async {
    var box = GetStorage();
    Uri uri =
        Uri.tryParse('https://staging.taillz.com/api/v1/clients/$id/block')!;
    WidgetProvider widgetProvider = Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider.returnConnection().delete(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${box.read('userTokenForAuth')}',
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
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO
    // UserProvider _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Blocked Users',
        ),
        foregroundColor: const Color(0xff121556),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: SpinKitFadingFour(
                  size: 40,
                  color: Color(0xff52527a),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: blockedUsers.isNotEmpty
                        ? ListView.builder(
                            itemCount: blockedUsers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Card(
                                  elevation: 3.0,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          CustomUserAvatar(
                                            imageUrl: blockedUsers[index]
                                                        .gender ==
                                                    'Male'
                                                ? 'assets/images/male.png'
                                                : 'assets/images/female.png',
                                            userColor:
                                                blockedUsers[index].color,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            blockedUsers[index].name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 10),
                                        child: Text(
                                          waitingMessages[index],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 10),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 40,
                                            width: 169,
                                            decoration: BoxDecoration(
                                              color: enableButtonsForUnblocking[
                                                          index] ==
                                                      false
                                                  ? const Color(0xff52527a)
                                                      .withOpacity(0.4)
                                                  : const Color(0xff52527a),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child: TextButton(
                                              onPressed:
                                                  enableButtonsForUnblocking[
                                                              index] ==
                                                          false
                                                      ? null
                                                      : () {
                                                          unBlockUser(
                                                              blockedUsers[
                                                                      index]
                                                                  .id);
                                                        },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    TKeys.unblockUsesr
                                                        .translate(context),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No Blocked Users',
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
