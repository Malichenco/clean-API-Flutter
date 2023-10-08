import 'dart:convert';
import 'package:Taillz/providers/user_provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart' as provider;
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/post_background_image_controller.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/screens/thoughts/components/story_card.dart';
import 'package:Taillz/screens/thoughts/create_thought_post/create_thought_post.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:provider/provider.dart';

import '../../Localization/t_keys.dart';

class ThoughtsScreen extends StatefulWidget {
  bool isFavourite;
  ThoughtsScreen({Key? key, required this.isFavourite}) : super(key: key);
  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  ScrollController? _scrollController;
  int pageNumber = 0;
  String? lang;
  int imageIndex = 0;
  int index = 0;
  List<StoryModel> userStories = [];
  bool hideBottomLoader = false;
  final localizationController = Get.find<LocalizationController>();

  bool isLoadedAll = false;

  int randomNumber = 0;
  final box = GetStorage();
  @override
  void initState() {
    // bgImages.forEach((element) {
    //   listRandom.add(Random().nextInt(bgImages.length));
    // });
    var userProvider=Provider.of<UserProvider>(context,listen: false);
    userProvider.setFirstTimeCallTrue();

    _scrollController = ScrollController();
    getThoughts();
    _scrollController!.addListener(() {
      if (_scrollController!.position.pixels ==
          _scrollController!.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
        });
        getThoughts();
      }
    });

    super.initState();
  }

  getThoughts() async {
    Uri uri = Uri.tryParse(
      widget.isFavourite == false
          ? '${ApiNetwork.getStories}?page=$pageNumber'
          : '${ApiNetwork.getFavourite}?page=$pageNumber',
    )!;
    WidgetProvider localWidgetProvider = provider.Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    pageNumber == 0 ? userStories = [] : userStories;
    if (pageNumber == 0) {
      index = 0;
      imageIndex = 0;
    }
    await localWidgetProvider
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
    ).then(
      (value) {
        // if(value != null)

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
          Logger.w(
              '$pageNumber  ${response['payload'].length} =====================================');
          response['payload'].forEach((e) {
            userStories.add(StoryModel.fromMap(e));
            userStories[index].image =
                PostBackgroundImageController.bgImages[imageIndex];
            index++;
            if (imageIndex ==
                PostBackgroundImageController.bgImages.length - 1) {
              imageIndex = -1;
            }
            imageIndex++;
          });

          if (pageNumber >= 0 && response['payload'].length == 0 ||
              response['payload'].length < 8) {
            Logger.i(response['payload']);
            hideBottomLoader = true;
          }
          setState(() {
            isLoadedAll = true;
          });
          // changeUserStories(userStories: userStories!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    lang = box.read('lang');
    var userProvider=Provider.of<UserProvider>(context,listen: false);
    return Scaffold(
      body: isLoadedAll == false && userStories.isEmpty && userProvider.isMainComment.isEmpty
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SpinKitFadingFour(
                    size: 60,
                    color: Color(0xff52527a),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            )
          : isLoadedAll && widget.isFavourite && userStories.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child:
                        Text(TKeys.favorite_no_stories_message.translate(context)),
                  ),
                )
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: userStories.length + 1,
                        itemBuilder: (context, index) {
                          userProvider.setMainLikeLength(userStories.length + 1,context);
                          if (index < userStories.length) {
                            Logger.e(userStories[index].userId);
                            return StoryCard(
                              isFollowed: widget.isFavourite,
                              Index:index,
                              image: userStories[index].image!,
                              item: userStories[index].image!,
                              story: userStories[index],
                              route: 'thoughtScreen',
                            );
                          } else {
                            return hideBottomLoader
                                ? Container()
                                : const Center(
                                    child: SpinKitFadingFour(
                                      size: 40,
                                      color: Color(0xff52527a),
                                    ),
                                  );
                          }
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff19334D),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => CreateThoughtPostScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
