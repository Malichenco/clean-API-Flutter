import 'dart:convert';

import 'package:Taillz/Dios/api_dio.dart';
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/domain/story/pending_stories_model.dart';
import 'package:Taillz/post_background_image_controller.dart';
import 'package:Taillz/providers/admin_provider.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/screens/writerPage/writer_screen.dart';
import 'package:Taillz/utills/counter_function.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AllPendingStoriesScreen extends StatefulWidget {
  UserInfo? userInfo;
  BuildContext context;
  bool isFollowed;

  AllPendingStoriesScreen({Key? key, this.userInfo, required this.context,required this.isFollowed})
      : super(key: key);

  @override
  State<AllPendingStoriesScreen> createState() =>
      _AllPendingStoriesScreenState();
}

class _AllPendingStoriesScreenState extends State<AllPendingStoriesScreen> {
  int? currentIndex;
  List<PendingStoriesModel> myAllPendingStories = [];
  bool isLoaded = false;
  List<bool> isExpanded = [];
  var box = GetStorage();
  var userGender;
  var userColor;
  int index = 0;
  int pageNumber = 0;
  int imageIndex = 0;
  bool hideBottomLoader = false;
  final localizationController = Get.find<LocalizationController>();

  final ScrollController _scrollController = ScrollController();

  var globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.getMyPublication(context);
  }

  getMyPublication() async {
    var box = GetStorage();
    setState(() {
      isLoaded = true;
    });
    Logger.e(box.read('userTokenForAuth'));
    Uri uri = Uri.tryParse(
      '${ApiNetwork.getStories}/pending-stories?page=$pageNumber&limit=10',
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
      myAllPendingStories = [];
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
        setState(() {
          isLoaded = false;
        });
      } else {
        Logger.e(response['payload']);
        for (int i = 0; i < response['payload'].length; i++) {
          myAllPendingStories
              .add(PendingStoriesModel.fromJson(response['payload'][i]));
          isExpanded.add(false);
          setState(() {});
        }

        for (int i = 0; i < myAllPendingStories.length; i++) {
          setState(() {
            myAllPendingStories[i].image =
                PostBackgroundImageController.bgImages[i];
            isLoaded = false;
          });
        }

        setState(() {
          isLoaded = false;
        });
      }
    });
  }

  putMyPost(String storyId, String method) async {
    var box = GetStorage();
    Logger.e(box.read('userTokenForAuth'));
    String uri = "/StoryUpdateStatus/$storyId/$method";
    var response =
        await httpClientWithHeader(box.read('userTokenForAuth')).put(uri);
    if (response.data['success']) {
      BotToast.showText(
        text: '${response.data['payload']}',
        contentColor: Constants.blueColor,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      );
    } else {
      BotToast.showText(
        text: '${response.data['errors'][0]['message']}',
        contentColor: Constants.blueColor,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider localUserProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          TKeys.admin_text.translate(context),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff19334D),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff19334D),
            size: 25,
          ),
        ),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, _) {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: adminProvider.isApiLoading
                ? const Center(
                    child: SpinKitFadingFour(
                      size: 60,
                      color: Color(0xff52527a),
                    ),
                  )
                : adminProvider.myPendingStoriesList.isEmpty
                    ? Expanded(
                        child: Center(
                        child:
                            Text(TKeys.pending_stories_post.translate(context)),
                      ))
                    : Column(
                        children: [
                          Expanded(child: NotificationListener<UserScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (!adminProvider.isLoading &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                adminProvider.loadData(context);
                                adminProvider.setIsLoading(true);
                              }

                              return true;
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              shrinkWrap: true,
                              controller: adminProvider.scrollController,
                              itemCount: adminProvider.myPendingStoriesList.length,
                              itemBuilder: (context, index) {
                                if (index < adminProvider.myPendingStoriesList.length) {
                                  return Card(
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height:130,
                                          child: Card(
                                            elevation: 0,
                                            clipBehavior: Clip.antiAlias,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 148,
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Image.asset(
                                                      adminProvider.myPendingStoriesList[index].image ?? '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: const BoxDecoration(color: Color(0x4B000000)),
                                                  ),
                                                  Padding(
                                                    padding:   const EdgeInsetsDirectional.only(start: 5, end: 0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                          box.read('lang') == 'he'
                                                              ? Alignment.topLeft
                                                              : Alignment.topRight,
                                                          child: PopupMenuButton<int>(
                                                            itemBuilder: (context) {
                                                              return <PopupMenuEntry<
                                                                  int>>[
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    putMyPost(
                                                                        adminProvider.myPendingStoriesList[
                                                                        index]
                                                                            .id
                                                                            .toString() ??
                                                                            '',
                                                                        '1');
                                                                  },
                                                                  value: 1,
                                                                  child: Text(
                                                                    TKeys
                                                                        .approved_stories_post
                                                                        .translate(
                                                                        context),
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    putMyPost(
                                                                        adminProvider.myPendingStoriesList[
                                                                        index]
                                                                            .id
                                                                            .toString() ??
                                                                            '',
                                                                        '3');
                                                                  },
                                                                  value: 2,
                                                                  child: Text(
                                                                    TKeys
                                                                        .declined_stories_post
                                                                        .translate(
                                                                        context),
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    putMyPost(
                                                                        adminProvider.myPendingStoriesList[
                                                                        index]
                                                                            .id
                                                                            .toString() ??
                                                                            '',
                                                                        '0');
                                                                  },
                                                                  value: 3,
                                                                  child: Text(
                                                                    TKeys
                                                                        .pending_stories_post
                                                                        .translate(
                                                                        context),
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    localUserProvider
                                                                        .deleteStory(
                                                                      context:
                                                                      context,
                                                                      storyId: adminProvider.myPendingStoriesList[
                                                                      index]
                                                                          .id ??
                                                                          0,
                                                                    )
                                                                        .then((value) =>
                                                                    getMyPublication);
                                                                  },
                                                                  value: 4,
                                                                  child: Text(
                                                                    TKeys.delete_post
                                                                        .translate(
                                                                        context),
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  onTap: () {
                                                                    localUserProvider
                                                                        .blockUser(
                                                                      context: context,
                                                                      userId: int.parse(
                                                                          adminProvider.myPendingStoriesList[
                                                                          index]
                                                                              .userId
                                                                              .toString() ??
                                                                              ''),
                                                                    );
                                                                  },
                                                                  value: 4,
                                                                  child: Text(
                                                                    TKeys.block_User
                                                                        .translate(
                                                                        context),
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0),
                                                              ),
                                                            ),

                                                            icon: const Icon(
                                                              Icons.more_vert,
                                                              color: Colors.black,
                                                              size: 28,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 26,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              const CustomUserAvatar(
                                                                imageUrl: 'assets/images/male.png',
                                                                userColor: "rgb(0, 0, 0)",
                                                              ),
                                                              // CustomProfileAvatar(story: story),
                                                              Padding(
                                                                padding: const EdgeInsetsDirectional.only(
                                                                  start: 8,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.of(context).push(
                                                                          MaterialPageRoute(
                                                                            builder: (builder) =>
                                                                                WriterScreen(
                                                                                  isFollowed: widget.isFollowed,
                                                                                  item: adminProvider.myPendingStoriesList[index].image ?? '',
                                                                                  image: adminProvider.myPendingStoriesList[index].image ?? '',
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: adminProvider.myPendingStoriesList[index].viewedUserStory != null
                                                                          ?Text(
                                                                        adminProvider.myPendingStoriesList[index].viewedUserStory ?? 'Null',
                                                                        style: GoogleFonts.montserrat(
                                                                            fontSize: 18,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            shadows: [
                                                                              BoxShadow(
                                                                                blurRadius: 5,
                                                                                color: Colors.grey
                                                                                    .withOpacity(0.5),
                                                                              )
                                                                            ]),
                                                                      )
                                                                      :Container(),
                                                                    ),
                                                                    Text(
                                                                      adminProvider.myPendingStoriesList[index].publishDate ?? '',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14,
                                                                        fontFamily: Constants.fontFamilyName,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  box.read('lang') == 'he'
                                                      ? Align(
                                                      alignment: const Alignment(-1.1, 1.42),
                                                      child: GestureDetector(
                                                        onTap: () => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => WriterScreen(
                                                              isFollowed: widget.isFollowed,
                                                              item: adminProvider.myPendingStoriesList[index].image ?? '',
                                                              image: adminProvider.myPendingStoriesList[index].image ?? '',
                                                            ),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/PageWriterRTLview.png',
                                                          height: 45,
                                                        ),
                                                      ))
                                                      : Align(
                                                      alignment: const Alignment(1.1, 1.42),
                                                      child: GestureDetector(
                                                        onTap: () => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => WriterScreen(
                                                              isFollowed: widget.isFollowed,
                                                              item: adminProvider.myPendingStoriesList[index].image ?? '',
                                                              image: adminProvider.myPendingStoriesList[index].image ?? '',
                                                            ),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/PageWriterENView.png',
                                                          height: 45,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        adminProvider.myPendingStoriesList[index].category != null?Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          child: Text(
                                            '${adminProvider.myPendingStoriesList[index].category ?? 'Null'}',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: const Color(0xff19334D),
                                                shadows: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  )
                                                ]),
                                          ),
                                        ):Container(),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              adminProvider.myPendingStoriesList[index]
                                                  .title!
                                                  .isEmpty ||
                                                  adminProvider.myPendingStoriesList[index]
                                                      .title ==
                                                      ''
                                                  ? Container()
                                                  : Padding(
                                                padding: EdgeInsets.only(
                                                  right:
                                                  box.read('lang') ==
                                                      'he'
                                                      ? 10
                                                      : 20,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 7.0),
                                                    child: Text(
                                                      adminProvider.myPendingStoriesList[
                                                      index]
                                                          .title ??
                                                          '',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: const Color(
                                                            0xff19334D),
                                                        fontFamily: Constants
                                                            .fontFamilyName,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right:
                                                  box.read('lang') == 'he'
                                                      ? 7
                                                      : 35,
                                                  left: box.read('lang') == 'he'
                                                      ? 35
                                                      : 7,
                                                ),
                                                child: Text(
                                                  adminProvider.isExpanded[index] == true
                                                      ? adminProvider.myPendingStoriesList[
                                                  index]
                                                      .body!
                                                      .replaceAll('<p>', '')
                                                      .replaceAll(
                                                      '</p>', '')
                                                      : adminProvider.myPendingStoriesList[
                                                  index]
                                                      .body!
                                                      .length >=
                                                      150
                                                      ? adminProvider.myPendingStoriesList[
                                                  index]
                                                      .body!
                                                      .substring(0, 150)
                                                      .replaceAll(
                                                      '<p>', '')
                                                      .replaceAll(
                                                      '</p>', '')
                                                      : adminProvider.myPendingStoriesList[
                                                  index]
                                                      .body!
                                                      .replaceAll(
                                                      '<p>', '')
                                                      .replaceAll(
                                                      '</p>', ''),
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: Constants
                                                        .fontFamilyName,
                                                    color: Constants
                                                        .textTitleColor,
                                                  ),
                                                ),
                                              ),
                                              adminProvider.myPendingStoriesList[index]
                                                  .body!
                                                  .length >=
                                                  150
                                                  ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    adminProvider.isExpanded[index] =
                                                    !adminProvider.isExpanded[
                                                    index];
                                                  });
                                                },
                                                child: Padding(
                                                  padding: localizationController
                                                      .directionRTL
                                                      ? const EdgeInsets
                                                      .only(
                                                      left: 7,
                                                      right: 7)
                                                      : const EdgeInsets
                                                      .only(
                                                      left: 7,
                                                      right: 7),
                                                  child: Text(
                                                    adminProvider.isExpanded[index]
                                                        ? 'Read less'
                                                        : 'Read more',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: Constants
                                                          .fontFamilyName,
                                                      color: Constants
                                                          .readMoreColor,
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),),
                          Visibility(
                            visible: adminProvider.isLoading,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: const Center(
                                  child: SpinKitFadingFour(
                                    size: 40,
                                    color: Color(0xff52527a),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
