import 'package:Taillz/screens/consult/consultProvider.dart';
import 'package:Taillz/screens/my_screens/my_stories_provider.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/story/get/story_provider.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/screens/blocked_users/block_user.dart';
import 'package:Taillz/screens/comment_screen/comment_screen.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/utills/counter_function.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';
import 'package:Taillz/widgets/user_comment.dart';

// ignore: must_be_immutable
class StoryCard extends StatefulWidget {
  UserInfo? userInfo;
  String? consultGroupName;
  VoidCallback? draftCallbackPublish;
  bool? isMyStories;
  int? isFalse;

  StoryCard(
      {Key? key,
      required this.Index,
      required this.story,
      required this.route,
      this.isMyStories,
      this.isFalse,
      required this.img,
      this.userInfo,
      this.consultGroupName,
      this.draftCallbackPublish})
      : super(key: key);
  StoryModel story;
  final String route;
  final int Index;
  final String img;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  final localizationController = Get.find<LocalizationController>();
  bool? isExpanded = false;
  var box = GetStorage();
  List<bool> isLikeData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.isFalse!; i++) {
      isLikeData.add(false);
    }

    //userProvider.setDefaultReplayLikeFalse(context);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider localUserProvider =
        provider.Provider.of<UserProvider>(context);
    StoryProvider localStoryProvider =
        provider.Provider.of<StoryProvider>(context);
    var userColor = box.read('userColor');
    var userGender = box.read('userGender');
    UserProvider userProvider =
        provider.Provider.of<UserProvider>(context, listen: false);
    ConsultProvider consultProvider =
        provider.Provider.of<ConsultProvider>(context, listen: false);
    String? categoryName;

    List<String> consultGroupNames = [
      'Relationship',
      'Women Talk',
      'Motherhood',
      'Divorced',
      'LGBT',
      'Humanity',
      'Discrimination',
      'Vegan',
    ];

    List<String> translatedName = [
      TKeys.Relationship_text.translate(context),
      TKeys.Women_talk_text.translate(context),
      TKeys.Motherhood_text.translate(context),
      TKeys.Divorced_text.translate(context),
      TKeys.LGBT_text.translate(context),
      TKeys.Humanity_text.translate(context),
      TKeys.Discrimination_text.translate(context),
      TKeys.Vegan_text.translate(context),
    ];

    final Map consultGroupNamesMap = {
      'Relationship': TKeys.Relationship_text.translate(context),
      'women talk': TKeys.Women_talk_text.translate(context),
      'motherhood': TKeys.Motherhood_text.translate(context),
      'Divorced': TKeys.Divorced_text.translate(context),
      'LGBT': TKeys.LGBT_text.translate(context),
      'Humanity': TKeys.Humanity_text.translate(context),
      'Discrimination': TKeys.Discrimination_text.translate(context),
      'Vegan': TKeys.Vegan_text.translate(context),
    };

    if (widget.story.category != null) {
      categoryName = consultGroupNamesMap[widget.story.category!.toLowerCase()];
    }
    return widget.route == 'myPublishedStories' ||
            widget.route == 'myPendingStories'
        ? Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 108,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 108,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          widget.img,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: box.read('lang') == 'he'
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: PopupMenuButton<int>(
                          itemBuilder: (context) {
                            // TODO
                            bool? isFollowed = false;
                            if (localUserProvider.followingUsers != null &&
                                localUserProvider.followingUsers!.isNotEmpty) {
                              for (var element
                                  in localUserProvider.followingUsers!) {
                                if (element.id == widget.story.userId) {
                                  isFollowed = true;
                                  debugPrint(isFollowed.toString());
                                }
                              }
                            }
                            return <PopupMenuEntry<int>>[
                              !widget.story.myPost
                                  ? PopupMenuItem(
                                      value: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlockedUser(
                                                userId: widget.story.userId
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          TKeys.report_block.translate(context),
                                        ),
                                      ),
                                    )
                                  : PopupMenuItem(
                                      onTap: () {
                                        localUserProvider.deleteStory(
                                          context: context,
                                          storyId: widget.story.story.id,
                                        );
                                        if (widget.route
                                            .contains('myPublishedStories')) {
                                          localStoryProvider.myPublishedStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyPublishedStories(
                                            myPublishedStories:
                                                localStoryProvider
                                                    .myPublishedStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myDraftStories')) {
                                          localStoryProvider.myDraftStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyDraftStories(
                                            myDraftStories: localStoryProvider
                                                .myDraftStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myPendingStories')) {
                                          localStoryProvider.myPendingStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyPendingStories(
                                            myPendingStories: localStoryProvider
                                                .myPendingStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myDeclinedStories')) {
                                          localStoryProvider.myDeclinedStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyRejectedStories(
                                            myRejectedStories:
                                                localStoryProvider
                                                    .myDeclinedStories!,
                                          );
                                        } else {
                                          localStoryProvider
                                              .storiesByGroups![widget.route]!
                                              .removeWhere((element) =>
                                                  element.story.id ==
                                                  widget.story.story.id);
                                          localStoryProvider
                                              .changeStoriesByGroups(
                                            storiesByGroups: localStoryProvider
                                                .storiesByGroups!,
                                          );
                                        }
                                      },
                                      value: 1,
                                      child: Text(
                                        TKeys.delete_post.translate(context),
                                      ),
                                    ),
                              if (widget.story.myPost)
                                PopupMenuItem(
                                  onTap: () {
                                    widget.story.story.isCommentsAllowed =
                                        !widget.story.story.isCommentsAllowed!;
                                    setState(() {});
                                    localStoryProvider.disableComments(
                                      context: context,
                                      story: widget.story,
                                      allow: widget.story.story.isCommentsAllowed!
                                    );

                                    if (widget.route
                                        .contains('myPublishedStories')) {
                                      if (localStoryProvider.userStories !=
                                              null &&
                                          localStoryProvider
                                              .userStories!.isNotEmpty) {
                                        int storyIndex = localStoryProvider
                                            .userStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story.id ==
                                              widget.story.story.id,
                                        );
                                        if (storyIndex != -1) {
                                          localStoryProvider
                                                  .userStories![storyIndex] =
                                              widget.story;
                                        }
                                        localStoryProvider.changeUserStories(
                                          userStories:
                                              localStoryProvider.userStories!,
                                        );
                                      }
                                    } else {
                                      if (localStoryProvider
                                                  .myPublishedStories !=
                                              null &&
                                          localStoryProvider
                                              .myPublishedStories!.isNotEmpty) {
                                        int storyIndex = localStoryProvider
                                            .myPublishedStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story.id ==
                                              widget.story.story.id,
                                        );
                                        if (storyIndex != -1) {
                                          localStoryProvider
                                                  .myPublishedStories![
                                              storyIndex] = widget.story;
                                        }
                                        localStoryProvider
                                            .changeMyPublishedStories(
                                          myPublishedStories: localStoryProvider
                                              .myPublishedStories!,
                                        );
                                      }
                                    }
                                  },
                                  value: 0,
                                  child: Text(
                                    widget.story.story.isCommentsAllowed!
                                        ? TKeys.disable_comment
                                            .translate(context)
                                        : TKeys.enable_comment
                                            .translate(context),
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
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              CustomUserAvatar(
                                imageUrl: widget.story.userGender == 'Male'
                                    ? 'assets/images/male.png'
                                    : 'assets/images/female.png',
                                userColor: widget.story.userColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.story.userNick,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.fontFamilyName,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.story.story.publishDate,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: Constants.fontFamilyName,
                                        ),
                                      ),
                                      Text(
                                        widget.story.story.title == ''
                                            ? ' - $categoryName'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Constants.fontFamilyName,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              /*Text(
                            "119",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: Constant.fontFamilyName,
                              color: Constant.readMoreColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SvgPicture.asset(
                              "assets/icons/story_view.svg",
                              height: 22,
                            ),
                          )*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.story.story.title.isEmpty ||
                              widget.story.story.title == ''
                          ? Container()
                          : widget.route == 'myPublishedStories'
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            localizationController.directionRTL
                                                ? 10
                                                : 20,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 7.0),
                                          child: Text(
                                            widget.story.story.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff19334D),
                                              fontFamily:
                                                  Constants.fontFamilyName,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      //By OK
                                      CounterFunction.countforInt(int.parse(
                                              widget.story.story.views
                                                  .toString()))
                                          .toString(),
                                      // story.story.views.toString()
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        fontFamily: Constants.fontFamilyName,
                                        color: Constants.readMoreColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Logger.e(widget.story.story.views
                                              .toString());
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/Views.svg',
                                          height: 22,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    right: box.read('lang') == 'he' ? 10 : 20,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7.0),
                                      child: Text(
                                        widget.story.story.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff19334D),
                                          fontFamily: Constants.fontFamilyName,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      const SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: box.read('lang') == 'he' ? 7 : 35,
                          left: box.read('lang') == 'he' ? 35 : 7,
                        ),
                        child: Text(
                          isExpanded == true
                              ? widget.story.story.body
                                  .replaceAll('<p>', '')
                                  .replaceAll('</p>', '')
                              : widget.story.story.body.length >= 150
                                  ? widget.story.story.body
                                      .substring(0, 150)
                                      .replaceAll('<p>', '')
                                      .replaceAll('</p>', '')
                                  : widget.story.story.body
                                      .replaceAll('<p>', '')
                                      .replaceAll('</p>', ''),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constants.fontFamilyName,
                            color: Constants.textTitleColor,
                          ),
                        ),
                      ),
                      widget.story.story.body.length >= 150
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded!;
                                });
                              },
                              child: Padding(
                                padding: localizationController.directionRTL
                                    ? const EdgeInsets.only(left: 7, right: 7)
                                    : const EdgeInsets.only(left: 7, right: 7),
                                child: Text(
                                  isExpanded! ? 'Read less' : 'Read more',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: Constants.fontFamilyName,
                                    color: Constants.readMoreColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                widget.story.story.title.isEmpty ||
                        widget.story.story.title == ''
                    ? const SizedBox(
                        height: 30,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                GestureDetector(
                  onTap: () {
                    localStoryProvider.getSingleStoryComments(
                      context: context,
                      storyId: widget.story.story.id,
                      pageNumber: 0,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          mainStoryIndex: widget.Index,
                          comments: widget.story.comments,
                          postId: widget.story.story.id,
                          storyModel: widget.story,
                          route: widget.route,
                          color: userColor.isEmpty
                              ? userProvider.userInfo?.color
                              : userColor,
                          male: userGender.isEmpty
                              ? userProvider.userInfo?.gender
                              : userGender,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 10, 17, 4),
                          child: SizedBox(
                            child: SizedBox(
                              child: LikeButton(
                                Index: widget.Index,
                                story: widget.story,
                                likedByMe: widget.story.likedByMe,
                                route: widget.route,
                                userProvider: userProvider,
                                userGender: userGender,
                                userColor: userColor,
                                consultProvider: consultProvider,
                                isFalse: isLikeData,
                                myStories: widget.isMyStories ?? false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(
                      left: 7, right: 4, bottom: 9, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: LikeButton(
                          story: widget.story,
                          likedByMe: widget.story.likedByMe,
                          likeText: true,
                          likeButton: true,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(
                          child:
                          Divider(thickness: 1, color: Colors.black87)),
                      SizedBox(
                        child: widget.story.story.isCommentsAllowed!
                            ? Container(
                                margin: const EdgeInsetsDirectional.only(
                                  start: 10,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        localStoryProvider
                                            .getSingleStoryComments(
                                          context: context,
                                          storyId: widget.story.story.id,
                                          pageNumber: 0,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                              comments: widget.story.comments,
                                              postId: widget.story.story.id,
                                              storyModel: widget.story,
                                              route: widget.route,
                                              color: userColor.isEmpty?userProvider.userInfo?.color:userColor,
                                              male: userGender.isEmpty?userProvider.userInfo?.gender:userGender,
                                            ),
                                          ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/Comment.svg',
                                        height: 20,
                                        color: Constants.heartColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 6),
                                      child: Text(
                                        CounterFunction.countforInt(int.parse(
                                                widget.story.totalComments
                                                    .toString()))
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: Constants.fontFamilyName,
                                          color: Constants.readMoreColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(
                          child:
                          Divider(thickness: 1, color: Colors.black87)),
                      const SizedBox(width: 5,),
                      SizedBox(
                        child: widget.story.story.isCommentsAllowed!
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      localStoryProvider.getSingleStoryComments(
                                        context: context,
                                        storyId: widget.story.story.id,
                                        pageNumber: 0,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                            comments: widget.story.comments,
                                            postId: widget.story.story.id,
                                            storyModel: widget.story,
                                            route: widget.route,
                                            color: userColor.isEmpty?userProvider.userInfo?.color:userColor,
                                            male: userGender.isEmpty?userProvider.userInfo?.gender:userGender,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      TKeys.comment_text.translate(context),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: Constants.fontFamilyName,
                                        color: Constants.readMoreColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),*/

                const SizedBox(
                  height: 0,
                ),
                widget.story.story.isCommentsAllowed!
                    ? widget.story.comments.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.story.comments.length > 2
                                ? 2
                                : widget.story.comments.length,
                            itemBuilder: (context, commentIndex) {
                              return Card(
                                elevation: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    localStoryProvider.getSingleStoryComments(
                                      context: context,
                                      storyId: widget.story.story.id,
                                      pageNumber: 0,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          mainStoryIndex: widget.Index,
                                          comments: widget.story.comments,
                                          postId: widget.story.story.id,
                                          storyModel: widget.story,
                                          route: widget.route,
                                          color: widget.story.userColor,
                                          male: widget.story.userGender,
                                        ),
                                      ),
                                    );
                                  },
                                  child: UserCommentCard(
                                    mainStoryIndex: widget.Index,
                                    commentData: widget.story.comments,
                                    storyModel: widget.story,
                                    storyId: widget.story.story.id,
                                    userProvider: userProvider,
                                    isNextScreen: true,
                                    userColor: widget.story.userColor,
                                    userGender: widget.story.userGender,
                                    myStoryUserId: widget.story.userId,
                                    length: widget.story.comments.length,
                                    mainPos: commentIndex,
                                    comment:
                                        widget.story.comments[commentIndex],
                                    route: widget.route,
                                    myID: box.read('userID'),
                                    storyUserId: widget.story.story.user != null
                                        ? widget.story.story.user!.id.toString()
                                        : widget.story.story.userId.toString(),
                                    deleteCommentCallBack: () {
                                      localUserProvider.deleteComment(
                                        context: context,
                                        commentId: widget
                                                .story
                                                .comments[commentIndex]
                                                .comment
                                                .id ??
                                            0,
                                      );
                                      if (widget.route
                                          .contains('thoughtScreen')) {
                                        int storyIndex = localStoryProvider
                                            .userStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story ==
                                              widget.story.story,
                                        );
                                        localStoryProvider
                                            .userStories![storyIndex].comments
                                            .remove(
                                          widget.story.comments[commentIndex],
                                        );
                                        localStoryProvider.changeUserStories(
                                          userStories:
                                              localStoryProvider.userStories!,
                                        );
                                      }
                                    },
                                    likeCommentCallBack: () {},
                                  ),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              localStoryProvider.getSingleStoryComments(
                                context: context,
                                storyId: widget.story.story.id,
                                pageNumber: 0,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    mainStoryIndex: widget.Index,
                                    comments: widget.story.comments,
                                    postId: widget.story.story.id,
                                    storyModel: widget.story,
                                    route: widget.route,
                                    color: widget.story.userColor,
                                    male: widget.story.userGender,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.commentBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 0,
                                    fontFamily: Constants.fontFamilyName,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                    : Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: const Color(0xffFAFAFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          TKeys.disabledComments.translate(context),
                        ),
                      ),
                widget.story.totalComments != 0
                    ? GestureDetector(
                        onTap: () {
                          localStoryProvider.getSingleStoryComments(
                            context: context,
                            storyId: widget.story.story.id,
                            pageNumber: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                mainStoryIndex: widget.Index,
                                comments: widget.story.comments,
                                postId: widget.story.story.id,
                                storyModel: widget.story,
                                route: widget.route,
                                color: widget.story.userColor,
                                male: widget.story.userGender,
                              ),
                            ),
                          );
                        },
                        child: widget.story.totalComments > 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 8, 25, 15),
                                child: Text(
                                    'View all ${CounterFunction.countforInt(int.parse(widget.story.totalComments.toString())).toString()} comments'),
                              )
                            : Container(),
                      )
                    : Container(),
                const SizedBox(height: 10),
                widget.story.story.isCommentsAllowed!
                    ? GestureDetector(
                        onTap: () {
                          localStoryProvider.getSingleStoryComments(
                            context: context,
                            storyId: widget.story.story.id,
                            pageNumber: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                mainStoryIndex: widget.Index,
                                comments: widget.story.comments,
                                postId: widget.story.story.id,
                                storyModel: widget.story,
                                route: widget.route,
                                color: widget.story.userColor,
                                male: widget.story.userGender,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 7, top: 7, right: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xffFAFAFA),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              CustomUserAvatar(
                                imageUrl: widget.userInfo!.gender == 'Male'
                                    ? 'assets/images/male.png'
                                    : 'assets/images/female.png',
                                userColor: widget.userInfo!.color,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                  // 'Comment',
                                  //by OK comment translate changes
                                  TKeys.comment_text.translate(context)),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const Divider(
                  color: Color(0xffFAFAFA),
                  thickness: 2.8,
                ),
              ],
            ),
          )
        : Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 108,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 108,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          widget.img,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: box.read('lang') == 'he'
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: PopupMenuButton<int>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          itemBuilder: (context) {
                            bool? isFollowed = false;
                            if (localUserProvider.followingUsers != null &&
                                localUserProvider.followingUsers!.isNotEmpty) {
                              for (var element
                                  in localUserProvider.followingUsers!) {
                                if (element.id == widget.story.userId) {
                                  isFollowed = true;
                                }
                              }
                            }
                            return <PopupMenuEntry<int>>[
                              if (widget.route.contains('myDraftStories'))
                                PopupMenuItem(
                                  onTap: widget.draftCallbackPublish,
                                  value: 6,
                                  child: Text(
                                    TKeys.publishText.translate(context),
                                  ),
                                ),
                              !widget.story.myPost
                                  ? PopupMenuItem(
                                      value: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlockedUser(
                                                userId: widget.story.userId
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          TKeys.report_block.translate(context),
                                        ),
                                      ),
                                    )
                                  : PopupMenuItem(
                                      onTap: () {
                                        localUserProvider.deleteStory(
                                          context: context,
                                          storyId: widget.story.story.id,
                                        );
                                        if (widget.route
                                            .contains('myPublishedStories')) {
                                          localStoryProvider.myPublishedStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyPublishedStories(
                                            myPublishedStories:
                                                localStoryProvider
                                                    .myPublishedStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myDraftStories')) {
                                          localStoryProvider.myDraftStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyDraftStories(
                                            myDraftStories: localStoryProvider
                                                .myDraftStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myPendingStories')) {
                                          localStoryProvider.myPendingStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyPendingStories(
                                            myPendingStories: localStoryProvider
                                                .myPendingStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myDeclinedStories')) {
                                          localStoryProvider.myDeclinedStories!
                                              .removeWhere(
                                            (element) =>
                                                element.story.id ==
                                                widget.story.story.id,
                                          );
                                          localStoryProvider
                                              .changeMyRejectedStories(
                                            myRejectedStories:
                                                localStoryProvider
                                                    .myDeclinedStories!,
                                          );
                                        } else {
                                          localStoryProvider
                                              .storiesByGroups![widget.route]!
                                              .removeWhere((element) =>
                                                  element.story.id ==
                                                  widget.story.story.id);
                                          localStoryProvider
                                              .changeStoriesByGroups(
                                            storiesByGroups: localStoryProvider
                                                .storiesByGroups!,
                                          );
                                        }
                                      },
                                      value: 1,
                                      child: Text(
                                        TKeys.delete_post.translate(context),
                                      ),
                                    ),
                              if (!widget.story.myPost)
                                PopupMenuItem(
                                  onTap: () {
                                    if (!isFollowed!) {
                                      localUserProvider.followUser(
                                        context: context,
                                        userId: widget.story.userId,
                                      );
                                      UserInfo user = UserInfo(
                                        totalPending: 0,
                                        totalDrafts: 0,
                                        totalApproval: 0,
                                        totalImTailing: 0,
                                        deniedPublished: 0,
                                        name: widget.story.userNick,
                                        color: widget.story.userColor,
                                        count: 0,
                                        id: widget.story.userId,
                                        gender: widget.story.userGender,
                                        inboxCount: 0,
                                        newImTailingCount: 0,
                                        unreadNotifsNo: 0,
                                        yearOfBirth: 1983,
                                      );
                                      localUserProvider.followingUsers ??= [];
                                      localUserProvider.followingUsers!
                                          .add(user);
                                    } else {
                                      localUserProvider.unfollowUser(
                                        context: context,
                                        userId: widget.story.userId,
                                      );
                                      localUserProvider.followingUsers!
                                          .removeWhere(
                                        (element) =>
                                            element.id == widget.story.userId,
                                      );
                                      localUserProvider.changeFollowingUsers(
                                        localUserProvider.followingUsers,
                                      );
                                    }
                                  },
                                  value: 0,
                                  child: Text(
                                    isFollowed!
                                        ? 'UnFollow'
                                        : TKeys.follow.translate(context),
                                  ),
                                ),
                              if (widget.story.myPost)
                                PopupMenuItem(
                                  onTap: () {
                                    widget.story.story.isCommentsAllowed =
                                        !widget.story.story.isCommentsAllowed!;
                                    setState(() {});
                                    localStoryProvider.disableComments(
                                      context: context,
                                      story: widget.story,
                                      allow: widget.story.story.isCommentsAllowed!
                                    );

                                    if (widget.route
                                        .contains('myPublishedStories')) {
                                      if (localStoryProvider.userStories !=
                                              null &&
                                          localStoryProvider
                                              .userStories!.isNotEmpty) {
                                        int storyIndex = localStoryProvider
                                            .userStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story.id ==
                                              widget.story.story.id,
                                        );
                                        if (storyIndex != -1) {
                                          localStoryProvider
                                                  .userStories![storyIndex] =
                                              widget.story;
                                        }
                                        localStoryProvider.changeUserStories(
                                          userStories:
                                              localStoryProvider.userStories!,
                                        );
                                      }
                                    } else {
                                      if (localStoryProvider
                                                  .myPublishedStories !=
                                              null &&
                                          localStoryProvider
                                              .myPublishedStories!.isNotEmpty) {
                                        int storyIndex = localStoryProvider
                                            .myPublishedStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story.id ==
                                              widget.story.story.id,
                                        );
                                        if (storyIndex != -1) {
                                          localStoryProvider
                                                  .myPublishedStories![
                                              storyIndex] = widget.story;
                                        }
                                        localStoryProvider
                                            .changeMyPublishedStories(
                                          myPublishedStories: localStoryProvider
                                              .myPublishedStories!,
                                        );
                                      }
                                    }
                                  },
                                  value: 0,
                                  child: Text(
                                    widget.story.story.isCommentsAllowed!
                                        ? TKeys.disable_comment
                                            .translate(context)
                                        : TKeys.enable_comment
                                            .translate(context),
                                  ),
                                ),
                            ];
                          },
                          child: Container(
                            height: 36,
                            width: 48,
                            margin: const EdgeInsets.only(
                                top: 3, right: 6, left: 6),
                            alignment: AlignmentDirectional.centerEnd,
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              // AvatarView(
                              //   radius: 16,
                              //   avatarType: AvatarType.CIRCLE,
                              //   borderColor: fromRGBColor(widget.story.userColor),
                              //   imagePath: widget.story.userGender == "Male"
                              //       ? "assets/images/male.png"
                              //       : "assets/images/female.png",
                              // ),
                              const SizedBox(
                                width: 4,
                              ),
                              CustomUserAvatar(
                                imageUrl: widget.story.userGender == 'Male'
                                    ? 'assets/images/male.png'
                                    : 'assets/images/female.png',
                                userColor: widget.story.userColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.story.userNick,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.fontFamilyName,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.story.story.publishDate,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: Constants.fontFamilyName,
                                        ),
                                      ),
                                      Text(
                                        widget.story.story.title == ''
                                            ? ' - $categoryName'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Constants.fontFamilyName,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              /*Text(
                            "119",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: Constant.fontFamilyName,
                              color: Constant.readMoreColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SvgPicture.asset(
                              "assets/images/Views.svg",
                              height: 22,
                            ),
                          )*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.story.story.title.isEmpty ||
                              widget.story.story.title == ''
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(
                                right: box.read('lang') == 'he' ? 10 : 20,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Text(
                                    widget.story.story.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff19334D),
                                      fontFamily: Constants.fontFamilyName,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: box.read('lang') == 'he' ? 7 : 35,
                          left: box.read('lang') == 'he' ? 35 : 7,
                        ),
                        child: Text(
                          isExpanded == true
                              ? widget.story.story.body
                                  .replaceAll('<p>', '')
                                  .replaceAll('</p>', '')
                              : widget.story.story.body.length >= 150
                                  ? widget.story.story.body
                                      .substring(0, 150)
                                      .replaceAll('<p>', '')
                                      .replaceAll('</p>', '')
                                  : widget.story.story.body
                                      .replaceAll('<p>', '')
                                      .replaceAll('</p>', ''),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constants.fontFamilyName,
                            color: Constants.textTitleColor,
                          ),
                        ),
                      ),
                      widget.story.story.body.length >= 150
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded!;
                                });
                              },
                              child: Padding(
                                padding: localizationController.directionRTL
                                    ? const EdgeInsets.only(left: 7, right: 7)
                                    : const EdgeInsets.only(left: 7, right: 7),
                                child: Text(
                                  isExpanded! ? 'Read less' : 'Read more',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: Constants.fontFamilyName,
                                    color: Constants.readMoreColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                widget.story.story.title.isEmpty ||
                        widget.story.story.title == ''
                    ? const SizedBox(
                        height: 30,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                GestureDetector(
                  onTap: () {
                    localStoryProvider.getSingleStoryComments(
                      context: context,
                      storyId: widget.story.story.id,
                      pageNumber: 0,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          mainStoryIndex: widget.Index,
                          comments: widget.story.comments,
                          postId: widget.story.story.id,
                          storyModel: widget.story,
                          route: widget.route,
                          color: widget.story.userColor,
                          male: widget.story.userGender,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
                          child: SizedBox(
                            child: SizedBox(
                              child: LikeButton(
                                Index: widget.Index,
                                story: widget.story,
                                likedByMe: widget.story.likedByMe,
                                route: widget.route,
                                userColor: userColor,
                                userGender: userGender,
                                userProvider: userProvider,
                                consultProvider: consultProvider,
                                isFalse: isLikeData,
                                myStories: widget.isMyStories ?? false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                widget.story.story.isCommentsAllowed!
                    ? widget.story.comments.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.story.comments.length > 2
                                ? 2
                                : widget.story.comments.length,
                            itemBuilder: (context, commentIndex) {
                              return Card(
                                elevation: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    localStoryProvider.getSingleStoryComments(
                                      context: context,
                                      storyId: widget.story.story.id,
                                      pageNumber: 0,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          mainStoryIndex: widget.Index,
                                          comments: widget.story.comments,
                                          postId: widget.story.story.id,
                                          storyModel: widget.story,
                                          route: widget.route,
                                          color: widget.story.userColor,
                                          male: widget.story.userGender,
                                        ),
                                      ),
                                    );
                                  },
                                  child: UserCommentCard(
                                    mainStoryIndex: widget.Index,
                                    commentData: widget.story.comments,
                                    storyModel: widget.story,
                                    storyId: widget.story.story.id,
                                    userProvider: userProvider,
                                    userGender: widget.story.userGender,
                                    userColor: widget.story.userColor,
                                    isNextScreen: true,
                                    myStoryUserId: widget.story.userId,
                                    length: widget.story.comments.length,
                                    mainPos: commentIndex,
                                    comment:
                                        widget.story.comments[commentIndex],
                                    /*myID: box.read('myID'),*/
                                    myID: box.read('myID') ?? 0,
                                    route: widget.route,
                                    storyUserId: widget.story.story.user != null
                                        ? widget.story.story.user!.id.toString()
                                        : widget.story.story.userId.toString(),
                                    deleteCommentCallBack: () {
                                      localUserProvider.deleteComment(
                                        context: context,
                                        commentId: widget
                                                .story
                                                .comments[commentIndex]
                                                .comment
                                                .id ??
                                            0,
                                      );
                                      if (widget.route
                                          .contains('thoughtScreen')) {
                                        int storyIndex = localStoryProvider
                                            .userStories!
                                            .indexWhere(
                                          (element) =>
                                              element.story ==
                                              widget.story.story,
                                        );
                                        localStoryProvider
                                            .userStories![storyIndex].comments
                                            .remove(
                                          widget.story.comments[commentIndex],
                                        );
                                        localStoryProvider.changeUserStories(
                                          userStories:
                                              localStoryProvider.userStories!,
                                        );
                                      }
                                    },
                                    likeCommentCallBack: () {},
                                  ),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              localStoryProvider.getSingleStoryComments(
                                context: context,
                                storyId: widget.story.story.id,
                                pageNumber: 0,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    mainStoryIndex: widget.Index,
                                    comments: widget.story.comments,
                                    postId: widget.story.story.id,
                                    storyModel: widget.story,
                                    route: widget.route,
                                    color: widget.story.userColor,
                                    male: widget.story.userGender,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.commentBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 0,
                                    fontFamily: Constants.fontFamilyName,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                    : Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: const Color(0xffFAFAFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          TKeys.disabledComments.translate(context),
                        ),
                      ),
                widget.story.totalComments != 0
                    ? GestureDetector(
                        onTap: () {
                          localStoryProvider.getSingleStoryComments(
                            context: context,
                            storyId: widget.story.story.id,
                            pageNumber: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                mainStoryIndex: widget.Index,
                                comments: widget.story.comments,
                                postId: widget.story.story.id,
                                storyModel: widget.story,
                                route: widget.route,
                                color: widget.story.userColor,
                                male: widget.story.userGender,
                              ),
                            ),
                          );
                        },
                        child: widget.story.totalComments > 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 8, 25, 15),
                                child: Text(
                                    'View all ${CounterFunction.countforInt(int.parse(widget.story.totalComments.toString())).toString()} comments'),
                              )
                            : Container(),
                      )
                    : Container(),
                const SizedBox(height: 10),
                widget.story.story.isCommentsAllowed!
                    ? GestureDetector(
                        onTap: () {
                          localStoryProvider.getSingleStoryComments(
                            context: context,
                            storyId: widget.story.story.id,
                            pageNumber: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                mainStoryIndex: widget.Index,
                                comments: widget.story.comments,
                                postId: widget.story.story.id,
                                storyModel: widget.story,
                                route: widget.route,
                                color: widget.story.userColor,
                                male: widget.story.userGender,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 7, top: 7, right: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xffFAFAFA),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              CustomUserAvatar(
                                imageUrl: widget.userInfo!.gender == 'Male'
                                    ? 'assets/images/male.png'
                                    : 'assets/images/female.png',
                                userColor: widget.userInfo!.color,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                  // 'Comment',
                                  //by OK comment translate changes
                                  TKeys.comment_text.translate(context)),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const Divider(
                  color: Color(0xffFAFAFA),
                  thickness: 2.8,
                ),
              ],
            ),
          );
  }
}

// ignore: must_be_immutable
class LikeButton extends HookConsumerWidget {
  StoryModel story;
  bool? likedByMe;
  String route;
  List<bool> isFalse;
  bool myStories;
  String userColor;
  String userGender;
  UserProvider userProvider;
  ConsultProvider consultProvider;
  int Index;

  LikeButton(
      {Key? key,
      required this.story,
      this.likedByMe,
      required this.route,
      required this.userColor,
      required this.isFalse,
      required this.myStories,
      required this.userProvider,
      required this.userGender,
      required this.consultProvider,
      required this.Index})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    MyStoriesProvider myStoriesProvider =
        provider.Provider.of<MyStoriesProvider>(context, listen: false);
    int likes = int.parse(story.story.likes.toString());
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 9),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                myStoriesProvider.isLikeData.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          Logger.w('${story.story.id} ${story.story.likes}');
                          if (!likedByMe!) {
                            ref.read(storyProvider.notifier).like(
                                story.story.id, context, consultProvider, '');
                            likes++;
                            likedByMe = true;
                            myStoriesProvider.isLikeDataTrue(Index);
                            setState(() {});
                          }
                        },
                        child: myStoriesProvider.isLikeData[Index]
                            ? SvgPicture.asset(
                                'assets/images/Liked.svg',
                                height: 20,
                                color: Colors.red,
                              )
                            : SvgPicture.asset(
                                'assets/images/Unliked.svg',
                                height: 20,
                                color: const Color(0xff19334D),
                              ))
                    : InkWell(
                        onTap: () {
                          Logger.w('${story.story.id} ${story.story.likes}');
                          if (!likedByMe!) {
                            ref.read(storyProvider.notifier).like(
                                story.story.id, context, consultProvider, '');
                            likes++;
                            likedByMe = true;
                            setState(() {});
                          }
                        },
                        child: likedByMe!
                            ? SvgPicture.asset(
                                'assets/images/Liked.svg',
                                height: 20,
                                color: Colors.red,
                              )
                            : SvgPicture.asset(
                                'assets/images/Unliked.svg',
                                height: 20,
                                color: const Color(0xff19334D),
                              )),
                const SizedBox(
                  width: 10,
                ),
                story.story.isCommentsAllowed!
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                mainStoryIndex: Index,
                                comments: story.comments,
                                postId: box.read('userID'),
                                storyModel: story,
                                route: route,
                                color: userColor.isEmpty
                                    ? userProvider.userInfo?.color
                                    : userColor,
                                male: userGender.isEmpty
                                    ? userProvider.userInfo?.gender
                                    : userGender,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/Comment.svg',
                          height: 20,
                          color: Colors.black87,
                        ),
                      )
                    : Container(),
                story.totalComments != 0
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(start: 6.0),
                        child: Text(
                          // story.totalComments.toString(),
                          CounterFunction.countforInt(
                                  int.parse(story.totalComments.toString()))
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: Constants.fontFamilyName,
                            color: const Color(0xff19334D),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            likes != 0
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(start: 6),
                    child: Row(
                      children: [
                        myStoriesProvider.isLikeData[Index]
                            ? likes == 0 ?Text(
                          CounterFunction.countforInt(likes +1).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: Constants.fontFamilyName,
                            color: Constants.readMoreColor,
                          ),
                        ): Text(
                                CounterFunction.countforInt(likes).toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: Constants.fontFamilyName,
                                  color: Constants.readMoreColor,
                                ),
                              )
                            : Text(
                                CounterFunction.countforInt(likes).toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: Constants.fontFamilyName,
                                  color: Constants.readMoreColor,
                                ),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('likes'),
                      ],
                    ),
                  )
                : Container()
          ],
        );
      }),
    );
  }
}
