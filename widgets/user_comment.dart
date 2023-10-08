import 'dart:developer';

import 'package:Taillz/application/story/get/story_provider.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/domain/story/comments/comment_model.dart';
import 'package:Taillz/screens/blocked_users/block_user.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';

import '../Localization/localization_service.dart';
import '../domain/auth/models/user_info.dart';
import '../providers/user_provider.dart';
import '../screens/comment_screen/comment_screen.dart';
import '../screens/comment_screen/replay_comment_screen.dart';

// ignore: must_be_immutable
class UserCommentCard extends StatefulWidget {
  UserCommentCard({
    Key? key,
    required this.comment,
    required this.route,
    required this.storyUserId,
    required this.myID,
    required this.deleteCommentCallBack,
    required this.likeCommentCallBack,
    required this.mainPos,
    required this.mainStoryIndex,
    this.myStoryUserId,
    this.commentData,
    this.isNextScreen,
    this.mainLikeLength,
    this.storyModel,
    this.likeCount,
    this.indexData,
    this.likeCountIds,
    this.userProvider,
    this.storyId,
    this.userGender,
    this.userColor,
    this.length,
    this.newComment = true,
    this.recursiveComment = false,
  }) : super(key: key);

  final CommentModel comment;
  final String route, storyUserId;
  final VoidCallback deleteCommentCallBack;
  final VoidCallback likeCommentCallBack;
  final int myID;
  final bool newComment;
  final bool recursiveComment;
  final int mainPos;
  int? length;
  int? myStoryUserId;
  int? mainLikeLength;
  int? likeCount;
  int? storyId;
  int? indexData;
  bool? isNextScreen;
  String? userColor;
  String? userGender;
  UserProvider? userProvider;
  int mainStoryIndex;
  String? likeCountIds;
  List<CommentModel>? commentData;
  StoryModel? storyModel;

  @override
  State<UserCommentCard> createState() => _UserCommentCardState();
}

class _UserCommentCardState extends State<UserCommentCard> {
  Offset _tapPosition = Offset.zero;
  int mainLikeCount = 0;

  final localizationController = Get.find<LocalizationController>();

  List<String> listData = [];
  bool isLike = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainLikeCount = widget.likeCount ?? 0;
    var userProvider = Provider.of<UserProvider>(context, listen: false);


    if (userProvider.isFirstTmeCall) {
      userProvider.setMainCommentLength(widget.length ?? 0, context);
      userProvider.setMainCommentFalse(context);
    }

    if (widget.likeCountIds != null) {
      listData = widget.likeCountIds!.split(',');
      listData.contains(widget.myID.toString()) == true
          ? userProvider.setIndexChange(
              widget.mainPos, widget.mainStoryIndex, context)
          : false;
    }
    userProvider.setApiMainCommentTrue(context);
  }

  @override
  Widget build(BuildContext context) {
    /* if (!widget.newComment) {
      return Container(
        margin: const EdgeInsets.only(bottom: 22),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(15)),
              child: ReadMoreText(
                widget.comment.comment.body,
                textAlign: TextAlign.justify,
                trimCollapsedText: TKeys.read_more
                    .translate(context)
                    .capitalizeFirst
                    .toString(),
                trimExpandedText: TKeys.read_less
                    .translate(context)
                    .capitalizeFirst
                    .toString(),
                trimLines: 2,
                trimMode: TrimMode.Line,
                colorClickableText: Constants.vertIconColor,
                style: TextStyle(
                  fontSize: 13,
                  color: Constants.userCommentColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: Constants.fontFamilyName,
                ),
              ),
            ),
            Positioned(
              top: -30,
              left: 15,
              child: CustomUserAvatar(
                imageUrl: widget.comment.user.gender == 1
                    ? 'assets/icons/male.png'
                    : 'assets/icons/female.png',
                userColor: widget.comment.itemColor.colorHex,
                size: 18,
              ),
            ),
            Positioned(
              top: -20,
              left: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomUserAvatar(
                    imageUrl: widget.comment.user.gender == 1
                        ? 'assets/icons/male.png'
                        : 'assets/icons/female.png',
                    userColor: widget.comment.itemColor.colorHex,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.comment.user.nickName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.textTitleColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                  const SizedBox(width: 100),
                  Text(
                    widget.comment.comment.publishDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -8,
              right: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 16),
                  Text(
                    'view previous replies',
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '135',
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                  const SizedBox(width: 3),
                  SvgPicture.asset(
                    'assets/images/Unliked.svg',
                    height: 14,
                    color: Constants.commentDateColor,
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReplayCommentScreen(
                            comments: widget.comment,
                            storyID: widget.comment.comment.storyId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      TKeys.reply_text.translate(context),
                      style: TextStyle(
                        fontSize: 13,
                        color: Constants.commentDateColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: Constants.fontFamilyName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }*/
    if (!widget.newComment) {
      return Container(
        margin: const EdgeInsets.only(bottom: 22),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /* GestureDetector(
              // onTapDown: (details) => _getTapPosition(details),
              onLongPress: () => _showMenu(context),
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(15)),
                child: ReadMoreText(
                  widget.comment.comment.body,
                  textAlign: TextAlign.justify,
                  trimCollapsedText: TKeys.read_more
                      .translate(context)
                      .capitalizeFirst
                      .toString(),
                  trimExpandedText: TKeys.read_less
                      .translate(context)
                      .capitalizeFirst
                      .toString(),
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  colorClickableText: Constants.vertIconColor,
                  style: TextStyle(
                    fontSize: 13,
                    color: Constants.userCommentColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: Constants.fontFamilyName,
                  ),
                ),
              ),
            ),*/
            Positioned(
              top: -20,
              left: localizationController.directionRTL ? null : 20,
              right: localizationController.directionRTL ? 20 : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomUserAvatar(
                        imageUrl: widget.comment.user.gender == 1
                            ? 'assets/images/male.png'
                            : 'assets/images/female.png',
                        userColor: widget.comment.itemColor.colorHex,
                      ),
                      Text(
                        widget.comment.user.nickName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Constants.textTitleColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.fontFamilyName,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.comment.comment.publishDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -8,
              right: localizationController.directionRTL ? null : 45,
              left: localizationController.directionRTL ? 45 : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 16),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.commentDateColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontFamilyName,
                    ),
                  ),
                  const SizedBox(width: 3),
                  InkWell(
                    child: SvgPicture.asset(
                      'assets/images/Unliked.svg',
                      height: 14,
                      color: Constants.commentDateColor,
                    ),
                    onTap: () {
                      widget.likeCommentCallBack.call();
                    },
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReplayCommentScreen(
                              mainStoryIndex: widget.mainStoryIndex,
                              comments: widget.comment,
                              storyID: widget.comment.comment.storyId,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        TKeys.reply_text.translate(context),
                        style: TextStyle(
                          fontSize: 13,
                          color: Constants.commentDateColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: Constants.fontFamilyName,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      );
    }
    /*return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 1),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomUserAvatar(
                  size: 35,
                  imageUrl: widget.comment.user.gender == 1
                      ? 'assets/images/male.png'
                      : 'assets/images/female.png',
                  userColor: widget.comment.itemColor.colorHex,
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.comment.user.nickName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Constants.blackColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.fontFamilyName,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              widget.comment.comment.publishDate ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: Constants.commentDateColor,
                                fontWeight: FontWeight.normal,
                                fontFamily: Constants.fontFamilyName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        ReadMoreText(
                          widget.comment.comment.body ?? '',
                          textAlign: TextAlign.justify,
                          trimCollapsedText: TKeys.read_more
                              .translate(context)
                              .capitalizeFirst
                              .toString(),
                          trimExpandedText: TKeys.read_less
                              .translate(context)
                              .capitalizeFirst
                              .toString(),
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          colorClickableText: Constants.vertIconColor,
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.blackColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: Constants.fontFamilyName,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),

                      ],
                    ),
                  ),
                ),
                Consumer<UserProvider>(builder: (context, userPro, child) {

                  int totalL=userPro.isMainComment.length;
                  int reqL=(widget.mainLikeLength ?? 0)+1;
                  int reqI=(widget.mainLikeLength ?? 0);
                  if(reqL>totalL){
                    reqI=0;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: SvgPicture.asset(
                          userPro.isMainComment[reqI?? 0]
                          [widget.mainPos]
                              ? 'assets/images/Liked.svg'
                              : 'assets/images/Unliked.svg',
                          height: 14,
                          color:  userPro.isMainComment[reqI?? 0][widget.mainPos]?Colors.red:Constants.commentDateColor,
                        ),
                        onTap: () {


                          //widget.likeCommentCallBack.call();
                          userPro.changeMainLikeStatus(
                              reqI?? 0, widget.mainPos);
                          if(userPro.isMainComment[reqI?? 0][widget.mainPos]){
                            setState(() {
                              mainLikeCount = mainLikeCount + 1;
                            });
                            userPro.addLike(
                              widget.comment.comment.id,
                            );
                          }else{
                            setState(() {
                              mainLikeCount = mainLikeCount - 1;
                            });
                            userPro.removeLike(
                              widget.comment.comment.id,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        mainLikeCount.toString(),
                        style: const TextStyle(color: Colors.black,fontSize: 11),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );*/
    return Container(
      child: PopupMenuButton<int>(
        onSelected: (value) {},
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        itemBuilder: (ctx) {

          int userId = box.read('userID');
          log(widget.storyUserId.toString());
          return <PopupMenuEntry<int>>[
            if(widget.myID == widget.comment.comment.userId)
                 PopupMenuItem(
                    onTap: widget.deleteCommentCallBack,
                    value: 0,
                    child: Text(
                      TKeys.delete_comment.translate(ctx),
                    ),
                  ),
                if(widget.myID != widget.comment.comment.userId)
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BlockedUser(
                                userId: widget.comment.user.id.toString()),
                          ));
                    },
                    value: 1,

                    //by OK delete comment
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => BlockedUser(
                                  userId: widget.comment.user.id.toString()),
                            ));
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(TKeys.report_User.translate(context)),
                      ),
                    ),
                  ),
          ];
        },
        child: InkWell(
          onTap: () {
            if (widget.isNextScreen ?? false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    mainStoryIndex: widget.mainStoryIndex,
                    mystoriesId: widget.myStoryUserId,
                    comments: widget.commentData,
                    mainLikeLength: widget.indexData,
                    postId: widget.storyId ?? 0,
                    storyModel: widget.storyModel,
                    route: widget.route,
                    color: widget.userColor?.isEmpty ?? false
                        ? widget.userProvider?.userInfo?.color
                        : widget.userColor,
                    male: widget.userGender?.isEmpty ?? false
                        ? widget.userProvider?.userInfo?.gender
                        : widget.userGender,
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 0, bottom: 1),
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomUserAvatar(
                        size: 35,
                        imageUrl: widget.comment.user.gender == 1
                            ? 'assets/images/male.png'
                            : 'assets/images/female.png',
                        userColor: widget.comment.itemColor.colorHex,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.comment.user.nickName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Constants.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.fontFamilyName,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    widget.comment.comment.publishDate ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Constants.commentDateColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Constants.fontFamilyName,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              ReadMoreText(
                                widget.comment.comment.body ?? '',
                                textAlign: TextAlign.justify,
                                trimCollapsedText: TKeys.read_more
                                    .translate(context)
                                    .capitalizeFirst
                                    .toString(),
                                trimExpandedText: TKeys.read_less
                                    .translate(context)
                                    .capitalizeFirst
                                    .toString(),
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                colorClickableText: Constants.vertIconColor,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Constants.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Constants.fontFamilyName,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<UserProvider>(
                          builder: (context, userPro, child) {
                        int totalL = userPro.isMainComment.length;
                        int reqL = (widget.mainLikeLength ?? 0) + 1;
                        int reqI = (widget.mainLikeLength ?? 0);
                        if (reqL > totalL) {
                          reqI = 0;
                        }
                        if (mainLikeCount > 0) {
                          mainLikeCount = mainLikeCount;
                        } else {
                          if (userPro.isMainComment[reqI ?? 0]
                              [widget.mainPos]) {
                            mainLikeCount = 0;
                            mainLikeCount = mainLikeCount + 1;
                          }else{
                            mainLikeCount = 0;
                          }
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: SvgPicture.asset(
                                userPro.isMainComment[reqI ?? 0][widget.mainPos]
                                    ? 'assets/images/Liked.svg'
                                    : 'assets/images/Unliked.svg',
                                height: 14,
                                color: userPro.isMainComment[reqI ?? 0]
                                        [widget.mainPos]
                                    ? Colors.red
                                    : Constants.commentDateColor,
                              ),
                              onTap: () {
                                //widget.likeCommentCallBack.call();

                                if(!userPro.isMainComment[reqI ?? 0]
                                [widget.mainPos]){
                                  userPro.changeMainLikeStatus(
                                      reqI ?? 0, widget.mainPos);
                                  if (userPro.isMainComment[reqI ?? 0]
                                  [widget.mainPos]) {
                                    setState(() {
                                      mainLikeCount = mainLikeCount + 1;
                                    });
                                    userPro.addLike(
                                        widget.comment.comment.id, widget.myID);
                                  }

                                }


                              /*  else {
                                  setState(() {
                                    mainLikeCount = mainLikeCount - 1;
                                  });
                                  userPro.removeLike(
                                      widget.comment.comment.id, widget.myID);
                                }*/
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              mainLikeCount.toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 11),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
