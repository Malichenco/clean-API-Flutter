import 'dart:developer';

import 'package:Taillz/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/domain/story/comments/comment_model.dart';
import 'package:Taillz/screens/blocked_users/block_user.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';

import '../Localization/localization_service.dart';
import '../domain/auth/models/user_info.dart';
import '../screens/comment_screen/comment_screen.dart';
import '../screens/comment_screen/replay_comment_screen.dart';

class UserRepliedCommentCard extends StatefulWidget {
  UserRepliedCommentCard({
    Key? key,
    required this.comment,
    required this.route,
    required this.storyUserId,
    required this.myID,
    required this.mainPos,
    required this.deleteCommentCallBack,
    required this.likeCommentCallBack,
    required this.mainStoryIndex,
    this.newComment = true,
    this.likeCountIds,
    this.likeCount,
    this.mainLikeLength,
    required this.myStoryUserId,
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
  final int myStoryUserId;
  final int mainStoryIndex;
  int? likeCount;
  int? mainLikeLength;
  String? likeCountIds;

  @override
  State<UserRepliedCommentCard> createState() => _UserRepliedCommentCardState();
}

class _UserRepliedCommentCardState extends State<UserRepliedCommentCard> {
  List<int> mainLikeCount = [];
  String language ='';
  var box = GetStorage();

  List<bool> isTrue = [];

  final localizationController = Get.find<LocalizationController>();

  List<String> listData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    language=box.read('lang');

    var userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isRepliedOneCall == false) {
      userProvider.setRepliedCommentFalse(context);
      userProvider.setReliedOneCall(true);
    }

    if (widget.comment.comment.repliedComment.isNotEmpty) {
      for (int i = 0; i < widget.comment.comment.repliedComment.length; i++) {
        mainLikeCount.add(widget.comment.comment.repliedComment.length);
        if (widget.comment.comment.repliedComment[i].likedUserIds != null &&
            widget.comment.comment.repliedComment[i].likedUserIds.isNotEmpty) {
          listData =
              widget.comment.comment.repliedComment[i].likedUserIds.split(',');
          listData.contains(widget.myID.toString()) == true
              ? userProvider.setIndexMainPos(widget.mainPos, i,widget.likeCount ?? 0,widget.mainStoryIndex)
              : false;
        }
        userProvider.setApiRepliedCommentTrue(context);
      }
    }

    if (widget.likeCountIds != null) {
      listData = widget.likeCountIds!.split(',');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.comment.comment.repliedComment.length,
        itemBuilder: (context, index) {

          if (widget.comment.comment.repliedComment[index].body != null) {
            return PopupMenuButton<int>(
              onSelected: (value) {},
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              itemBuilder: (ctx) {
                int userId = box.read('userID');
                log(userId.toString());
                log(widget.storyUserId.toString());
                return <PopupMenuEntry<int>>[
                  if(widget.myID == widget.comment.comment.repliedComment[index].userId)
                       PopupMenuItem(
                    onTap: widget.deleteCommentCallBack,
                    value: 0,
                    child: Text(
                      TKeys.delete_comment.translate(ctx),
                    ),
                  ),
                      if(widget.myID != widget.comment.comment.repliedComment[index].userId)
                        PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BlockedUser(
                                userId: widget.comment.user.id
                                    .toString()),
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
                                  userId: widget.comment.user.id
                                      .toString()),
                            ));
                      },
                      child: SizedBox(
                        width:
                        MediaQuery.of(context).size.width,
                        child: Text(TKeys.report_User
                            .translate(context)),
                      ),
                    ),
                  ),
                ];
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        /*Align(
                        alignment: Alignment.topLeft,
                        child: CustomUserAvatar(
                          size: 20,
                          imageUrl: widget.comment.user.gender == 1
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          userColor: widget.comment.itemColor.colorHex,
                        ),
                      ),*/
                        CustomUserAvatar(
                          size: 35,
                          imageUrl: widget.comment.user.gender == 1
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          userColor: widget.comment.comment.repliedComment[index]
                              .itemColor.colorHex.isEmpty
                              ? widget.comment.itemColor.colorHex
                              : widget.comment.comment.repliedComment[index]
                              .itemColor.colorHex,
                        ),
                        Expanded(
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
                                        color: Constants.textTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.fontFamilyName,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.comment.comment.repliedComment[index]
                                          .publishDate ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Constants.commentDateColor,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: Constants.fontFamilyName,
                                      ),
                                    ),
                                    /*  TextButton(
                                    onPressed: () {
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
                                        fontSize: 11,
                                        color: const Color(
                                            0xff132952),
                                        fontWeight:
                                        FontWeight.bold,
                                        fontFamily: Constants
                                            .fontFamilyName,
                                      ),
                                    ))*/
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                ReadMoreText(
                                  widget.comment.comment.repliedComment[index]
                                      .body ??
                                      '',
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
                        const SizedBox(width: 5,),
                        Consumer<UserProvider>(builder: (context, userPro, _) {
                          if (mainLikeCount[index] > 0) {
                            mainLikeCount[index] = mainLikeCount[index];
                          } else {
                            if (userPro.isTrueMainComment[widget.mainLikeLength ?? 0][widget.mainPos][index]) {
                              mainLikeCount[index] = 0;
                              mainLikeCount[index] = mainLikeCount[index] + 1;
                            }else{
                              mainLikeCount[index] = 0;
                            }
                          }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: SvgPicture.asset(
                            userPro.isTrueMainComment[widget.mainLikeLength ?? 0][widget.mainPos][index] !=
                                    true
                                ? 'assets/images/Unliked.svg'
                                : 'assets/images/Liked.svg',
                            height: 14,
                            color:userPro.isTrueMainComment[widget.mainLikeLength ?? 0][widget.mainPos][index] !=
                                false?Colors.red: Constants.commentDateColor,
                          ),
                          onTap: () {
                            // widget.likeCommentCallBack.call();
                            if(!userPro.isTrueMainComment[widget.mainLikeLength ?? 0][widget.mainPos][index]){
                              userPro.chnageReplayLikestatus(widget.mainLikeLength ?? 0,
                                  widget.mainPos, index);
                              if(userPro.isTrueMainComment[widget.mainLikeLength ?? 0][widget.mainPos][index]){
                                userPro.setRepliedCountAdd(widget.mainLikeLength ?? 0,widget.mainPos,index);
                                userPro.addLikeOnReplay(
                                    widget.comment.comment.repliedComment[index].id,widget.myID
                                );
                                setState(() {
                                  mainLikeCount[index]++;
                                });
                              }
                            }

                           /* else{
                              userPro.setRepliedCountRemove(widget.mainLikeLength ?? 0,widget.mainPos,index);
                              userPro.removeLike(
                                widget.comment.comment.repliedComment[index].id,widget.myID
                              );
                              setState(() {
                                mainLikeCount[index]--;
                              });
                            }*/

                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          mainLikeCount[index].toString(),
                          style: const TextStyle(color: Colors.black,fontSize: 11),
                        ),
                      ],
                    );
                  }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
