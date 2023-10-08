
import 'package:Taillz/screens/consult/consultProvider.dart';
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
class StoryCardNew extends StatefulWidget {
  StoryCardNew({
    Key? key,
    required this.story,
    required this.Index,
    required this.route,
    required this.img,
  }) : super(key: key);
  StoryModel story;
  final String route;
  final String img;
  final int Index;

  @override
  State<StoryCardNew> createState() => _StoryCardNewState();
}

class _StoryCardNewState extends State<StoryCardNew> {
  final localizationController = Get.find<LocalizationController>();
  bool? isExpanded = false;
  var box = GetStorage();

  @override
  Widget build(BuildContext context) {
    UserProvider localUserProvider = provider.Provider.of<UserProvider>(context);
    StoryProvider localStoryProvider =
        provider.Provider.of<StoryProvider>(context);
    var userColor = box.read('userColor');
    var userGender = box.read('userGender');
    UserProvider userProvider=provider.Provider.of<UserProvider>(context,listen: false);
    ConsultProvider consultProvider=provider.Provider.of<ConsultProvider>(context,listen: false);

    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.story.story.body.length >= 220 ? 54 : 42,
            child: Stack(
              children: [
                Container(
                  height: 58,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(''),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomUserAvatar(
                          imageUrl: widget.story.userGender == 'Male'
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          userColor: widget.story.userColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.story.userNick,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.fontFamilyName,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.story.story.publishDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: Constants.fontFamilyName,
                              ),
                            ),
                          ],
                        ),

                    const Spacer(),
                        PopupMenuButton<int>(
                          itemBuilder: (context) {
                            bool? isFollowed = false;
                            if (localUserProvider.followingUsers != null &&
                                localUserProvider
                                    .followingUsers!.isNotEmpty) {
                              for (var element
                                  in localUserProvider.followingUsers!) {
                                if (element.id == widget.story.userId) {
                                  isFollowed = true;
                                }
                              }
                            }
                            return <PopupMenuEntry<int>>[
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
                              !widget.story.myPost
                                  ? PopupMenuItem(
                                      value: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlockedUser(
                                                userId: widget.story.userId
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          TKeys.report_block
                                              .translate(context),
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
                                          localStoryProvider
                                              .myPublishedStories!
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
                                            myPendingStories:
                                                localStoryProvider
                                                    .myPendingStories!,
                                          );
                                        } else if (widget.route
                                            .contains('myDeclinedStories')) {
                                          localStoryProvider
                                              .myDeclinedStories!
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
                                            storiesByGroups:
                                                localStoryProvider
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
                                        !widget
                                            .story.story.isCommentsAllowed!;
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
                                              .myPublishedStories!
                                              .isNotEmpty) {
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
                                          myPublishedStories:
                                              localStoryProvider
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
                            color: Colors.black,
                            size: 28,
                          ),
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
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: box.read('lang') == 'en'
                      ? const EdgeInsets.only(left: 6, right: 6, top: 0)
                      : const EdgeInsets.only(left: 40, right: 6, top: 0),
                  child: Text(
                    isExpanded == true
                        ? widget.story.story.body
                            .replaceAll('<p>', '')
                            .replaceAll('</p>', '')
                        : widget.story.story.body.length >= 220
                            ? widget.story.story.body
                                .substring(0, 220)
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
                widget.story.story.body.length >= 220
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded!;
                          });
                        },
                        child: Padding(
                          padding: box.read('lang') == 'en'
                              ? const EdgeInsets.only(
                                  left: 6, right: 6, bottom: 8)
                              : const EdgeInsets.only(
                                  left: 40, right: 6, bottom: 8),
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
          const SizedBox(
            height: 5,
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    mainStoryIndex: widget.Index,
                    comments: widget.story.comments,
                    postId: box.read('userID'),
                    storyModel: widget.story,
                    route: widget.route,
                    color: userColor.isEmpty?userProvider.userInfo?.color:userColor,
                    male: userGender.isEmpty?userProvider.userInfo?.gender:userGender,
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
                      child: LikeButton(
                          likedByMe: widget.story.likedByMe, story: widget.story,route:widget.route,userColor: userColor,userGender: userGender,userProvider: userProvider,Index: widget.Index,consultProvider: consultProvider,),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 4,
          ),
         /* Padding(
            padding:
                const EdgeInsets.only(left: 7, right: 4, bottom: 9, top: 2),
            child: Row(
              children: [
                LikeButton(
                    likedByMe: widget.story.likedByMe, story: widget.story,likeButton: true,likeText: true,),
                const SizedBox(width: 5,),
                const Expanded(
                    child: Divider(thickness: 1, color: Colors.black87)),
                const SizedBox(width: 5,),
                widget.story.story.isCommentsAllowed!
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        */
          /*Icon(
                          Icons.chat_bubble_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),*/
          /*
                        GestureDetector(
                          onTap: () {
                            // _storyProvider.getSingleStoryComments(
                            //   context: context,
                            //   storyId: widget.story.story.id,
                            //   pageNumber: 0,
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                  comments: widget.story.comments,
                                  postId: box.read('userID'),
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
                          padding:
                          const EdgeInsetsDirectional.only(start: 5),
                          child: Text(
                            CounterFunction.countforInt(int.parse(widget
                                .story.totalComments
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
                    )
                    : Container(),
                const SizedBox(width: 5,),
                const Expanded(
                    child:
                    Divider(thickness: 1, color: Colors.black87)),
                const SizedBox(width: 5,),
                widget.story.story.isCommentsAllowed!
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // _storyProvider.getSingleStoryComments(
                        //   context: context,
                        //   storyId: widget.story.story.id,
                        //   pageNumber: 0,
                        // );
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
                    : Container()
              ],
            ),
          ),*/
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
                            child: UserCommentCard(
                              mainStoryIndex: widget.Index,
                              commentData: widget.story.comments,
                              storyModel: widget.story,
                              storyId: widget.story.story.id,
                              userProvider: userProvider,
                              isNextScreen: true,
                              myStoryUserId: widget.story.userId,
                              length: widget.story.comments.length,
                              mainPos: commentIndex,
                              comment: widget.story.comments[commentIndex],
                              route: widget.route,
                              myID: box.read('userID'),
                              storyUserId: widget.story.story.user != null
                                  ? widget.story.story.user!.id.toString()
                                  : widget.story.story.userId.toString(),
                              deleteCommentCallBack: () {
                                localUserProvider.deleteComment(
                                  context: context,
                                  commentId: widget.story.comments[commentIndex]
                                          .comment.id ??
                                      0,
                                );
                                if (widget.route.contains('thoughtScreen')) {
                                  int storyIndex = localStoryProvider
                                      .userStories!
                                      .indexWhere(
                                    (element) =>
                                        element.story == widget.story.story,
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
                        // _storyProvider.getSingleStoryComments(
                        //   context: context,
                        //   storyId: widget.story.story.id,
                        //   pageNumber: 0,
                        // );
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
                        decoration: BoxDecoration(
                          color: Constants.commentBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 0,
                            fontFamily: Constants.fontFamilyName,
                            color: Colors.black,
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
                  child: Text(
                    TKeys.disabledComments.translate(context),
                  ),
                ),
          widget.story.totalComments != 0
              ?GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    mainStoryIndex: widget.Index,
                    comments: widget.story.comments,
                    postId: box.read('userID'),
                    storyModel: widget.story,
                    route: widget.route,
                    color: userColor.isEmpty?userProvider.userInfo?.color:userColor,
                    male: userGender.isEmpty?userProvider.userInfo?.gender:userGender,
                  ),
                ),
              );
            },
            child: widget.story.totalComments >2
                ?Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 15),
              child: Text('View all ${CounterFunction.countforInt(
                  int.parse(widget.story.totalComments
                      .toString()))
                  .toString()} comments'),
            )
                :Container(),
          )
              :Container(),
          widget.story.story.isCommentsAllowed!
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  child: Center(
                    child: InkWell(
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
                        padding: const EdgeInsets.only(
                            left: 5, bottom: 7, top: 7, right: 5),
                        margin: const EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            color: const Color(0xffFAFAFA),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            CustomUserAvatar(
                              imageUrl: userGender.isEmpty
                                  ? userProvider.userInfo?.gender == 'Male'
                                      ? 'assets/images/male.png'
                                      : 'assets/images/female.png'
                                  : userGender == 'Male'
                                      ? 'assets/images/male.png'
                                      : 'assets/images/female.png',
                              userColor: userColor.isEmpty
                                  ? userProvider.userInfo?.color
                                  : userColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                // 'Comment',
                                //Comment text translate changes by OK
                                TKeys.comment_text.translate(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),


          Divider(
            color: Colors.grey.shade200,
            thickness: 10.0,
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
  int Index;
  String route;
  String userColor;
  String userGender;
  UserProvider userProvider;
  ConsultProvider consultProvider;
  LikeButton({Key? key,required this.story, this.likedByMe,required this.route,required this.userGender,required this.userColor,required this.userProvider,required this.Index,required this.consultProvider}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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
                 InkWell(
                     onTap: () {
                       Logger.w('${story.story.id} ${story.story.likes}');
                       if (!likedByMe!) {
                         ref.read(storyProvider.notifier).like(story.story.id,context,consultProvider,route);
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
                     )
                 ),
                 const SizedBox(width: 10,),
                 story.story.isCommentsAllowed!
                     ? GestureDetector(
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => CommentScreen(
                           mainStoryIndex:  Index,
                           comments: story.comments,
                           postId: box.read('userID'),
                           storyModel: story,
                           route: route,
                           color: userColor.isEmpty?userProvider.userInfo?.color:userColor,
                           male: userGender.isEmpty?userProvider.userInfo?.gender:userGender,
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
                     ?Padding(
                   padding: const EdgeInsetsDirectional.only(
                       start: 6.0),
                   child: Text(
                     // story.totalComments.toString(),
                     CounterFunction.countforInt(
                         int.parse(story.totalComments
                             .toString()))
                         .toString(),
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 14,
                       fontFamily: Constants.fontFamilyName,
                       color: const Color(0xff19334D),
                     ),
                   ),
                 )
                 :Container(),
                 const SizedBox(width: 10,),
                 const Icon(Icons.send_rounded,color: Colors.black,)
               ],
             ),
            const SizedBox(height: 5,),
            likes != 0
                ?Padding(
              padding: const EdgeInsetsDirectional.only(start: 6),
              child: Row(
                children: [
                  Text(
                    CounterFunction.countforInt(likes).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: Constants.fontFamilyName,
                      color: Constants.readMoreColor,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Text('likes'),
                ],
              ),
            )
                :Container()


          ],
        );
      }),
    );
  }
}
