
import 'package:Taillz/widgets/user_repliedComment.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/story/make_comment/make_comment_provider.dart';
import 'package:Taillz/application/story/make_comment/make_comment_state.dart';
import 'package:Taillz/domain/story/comments/comment_model.dart';
import 'package:Taillz/domain/story/comments/make_comment.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';
import 'package:Taillz/widgets/user_comment.dart';

import '../../utills/constant.dart';

class CommentScreen extends HookConsumerWidget {
  final int postId;
  int? likeCount;
  int? mainLikeLength;
  final List<CommentModel>? comments;
  StoryModel? storyModel;
  final String route;
  String? male;
  String? color;
  int? mystoriesId;
  int mainStoryIndex;

  CommentScreen(
      {Key? key,
      this.storyModel,
        required this.mainStoryIndex,
      this.likeCount,
      this.mainLikeLength,
      required this.comments,
      required this.postId,
      required this.route,
      this.mystoriesId,
      this.male,
      this.color})
      : super(key: key);

  var box1 = GetStorage();

  List<bool> replies = [];

  @override
  Widget build(BuildContext context, ref) {
    StoryProvider storyProvider = provider.Provider.of<StoryProvider>(context);


    bool isShowButton = false;
    List<String> listData = [];
    String language = '';
    int? index1;

    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    Logger.w(box1.read('userID'));

    final controller = useTextEditingController();
    // TODO
    final replyController = useTextEditingController();

    ScrollController scrollController = useMemoized(() => ScrollController());

    var box = GetStorage();

    int myIdData = box.read('userID');
    language = box.read('lang');

    useEffect(() {

      Logger.e(box.read('userTokenForAuth'));
      storyProvider
          .getSingleStoryComments(
              context: context,
              pageNumber: 0,
              storyId: postId,
              authTOKEN: box.read('userTokenForAuth'))
          .then((value) {
        Logger.w(value!.length);
      });

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          isShowButton = true;
          Future.delayed(Duration(seconds: 3), () {
            isShowButton = false;
          });
        }
      });

      /* scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          pageNumber++;

          isShowButton=true;



          storyProvider.getSingleStoryComments(
              context: context,
              pageNumber: 2,
              storyId: postId,
              authTOKEN: box.read('userTokenForAuth'));

          isShowButton=false;
        }
      });*/

      /*return () {
        scrollController.dispose();
      };*/
    }, []);

    ref.listen<MakeCommentState>(makeCommentProvider, ((previous, next) {
      if (!next.loading && next.failure == CleanFailure.none()) {
        showFlushBar(context, TKeys.comment_pending.translate(context));
        // ref.read(storyProvider.notifier).getStories();
      }
    }));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/reply_back.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StatefulBuilder(builder: (context,setState1){
        return Column(
          children: [
            Consumer(builder: (context, ref, _) {
              return storyProvider.singleStoryComments != null
                  ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: storyProvider.singleStoryComments!.length,
                  itemBuilder: (context, index) {
                    userProvider.setMainCommentLength(storyProvider.singleStoryComments?.length ?? 0, context);
                    if (index <
                        storyProvider.singleStoryComments!.length) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 15,
                            top: index == 0 ? 30 : 0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            UserCommentCard(
                              mainStoryIndex: mainStoryIndex,
                              mainLikeLength: mainLikeLength,
                              comment: storyProvider
                                  .singleStoryComments![index],
                              storyUserId:
                              storyModel!.story.id.toString(),
                              myStoryUserId: mystoriesId ?? 0,
                              myID: box.read('userID'),
                              deleteCommentCallBack: () {
                                userProvider.deleteComment(
                                  context: context,
                                  commentId: storyProvider
                                      .singleStoryComments![
                                  index]
                                      .comment
                                      .id ??
                                      0,
                                );

                                storyProvider.singleStoryComments!
                                    .removeAt(index);
                                storyProvider
                                    .changeSingleStoryComments(
                                  singleStoryComments: storyProvider
                                      .singleStoryComments!,
                                );
                              },
                              route: '/comment',
                              mainPos: index,
                              likeCountIds: storyProvider
                                  .singleStoryComments![index]
                                  .comment
                                  .likedUserIds,
                              likeCount: storyProvider
                                  .singleStoryComments![index]
                                  .comment
                                  .likesCount,
                              length: storyProvider
                                  .singleStoryComments
                                  ?.length ??
                                  0,
                              likeCommentCallBack: () {
                                storyProvider
                                    .getSingleStoryComments(
                                    context: context,
                                    pageNumber: 0,
                                    storyId: postId,
                                    authTOKEN: box.read(
                                        'userTokenForAuth'))
                                    .then((value) {
                                  Logger.w(value!.length);
                                });

                                // userProvider.changeMainLikeStatus(index);
                              },
                            ),
                            Align(
                              alignment: language == 'en'
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  for (int i = 0;
                                  i <
                                      storyProvider
                                          .singleStoryComments!
                                          .length;
                                  i++) {
                                    storyProvider
                                        .singleStoryComments![i]
                                        .showInput = false;
                                  }
                                  storyProvider
                                      .singleStoryComments![index]
                                      .showInput = true;
                                  setState1(() {});
                                },
                                child:
                                storyProvider
                                    .singleStoryComments![
                                index]
                                    .showInput!
                                    ? Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            0),
                                        height: 50,
                                        width: 60,
                                        decoration:
                                        BoxDecoration(
                                          color: Colors
                                              .grey
                                              .withOpacity(
                                              0.1),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomUserAvatar(
                                              imageUrl: male ==
                                                  'Male'
                                                  ? 'assets/images/male.png'
                                                  : 'assets/images/female.png',
                                              userColor:
                                              color!,
                                            ),
                                            const SizedBox(
                                              width: 0,
                                            ),
                                            box.read('lang') ==
                                                'he'
                                                ? Expanded(
                                              child:
                                              TextFormField(
                                                onTap:
                                                    () {
                                                  index1 = index;
                                                  setState1(() {});
                                                },
                                                autofocus:
                                                true,
                                                onFieldSubmitted:
                                                    (value) {
                                                  controller.clear();
                                                },
                                                controller:
                                                replyController,
                                                decoration: const InputDecoration(
                                                    isDense: true,
                                                    hintText: 'השב לתגובה',
                                                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                                                style:
                                                const TextStyle(color: Color(0xff121556), fontSize: 14),
                                              ),
                                            )
                                                : Expanded(
                                              child:
                                              TextFormField(
                                                onTap:
                                                    () {
                                                  index1 = index;
                                                  setState1(() {});
                                                },
                                                autofocus:
                                                true,
                                                onFieldSubmitted:
                                                    (value) {
                                                  controller.clear();
                                                },
                                                controller:
                                                replyController,
                                                decoration: const InputDecoration(
                                                    isDense: true,
                                                    hintText: 'Reply the Comment',
                                                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                                                style:
                                                const TextStyle(color: Color(0xff121556), fontSize: 14),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  if (replyController
                                                      .text
                                                      .isNotEmpty) {
                                                    final MakeCommentModel makeCommentModel = MakeCommentModel(
                                                        commentId:
                                                        storyProvider.singleStoryComments![index].comment.id,
                                                        storyId: postId,
                                                        body: replyController.text);
                                                    ref.read(makeCommentProvider.notifier).makeReplayComment(
                                                        makeCommentModel);
                                                    replyController
                                                        .clear();
                                                    setState1(
                                                            () {
                                                          storyProvider
                                                              .singleStoryComments![index]
                                                              .showInput = false;
                                                        });
                                                  }
                                                },
                                              child:
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                    10),
                                                child:
                                                Icon(
                                                  Icons
                                                      .send,
                                                  color: Color(
                                                      0xff121556),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Padding(
                                  padding:
                                  EdgeInsets.only(
                                      left:
                                      language ==
                                          'en'
                                          ? 50
                                          : 0,
                                      right:
                                      language ==
                                          'he'
                                          ? 50
                                          : 0),
                                  child: Text(
                                    TKeys.replyText
                                        .translate(
                                        context),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color(
                                          0xffBBBBBB),
                                      fontWeight:
                                      FontWeight.bold,
                                      fontFamily: Constants
                                          .fontFamilyName,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: language == 'en' ? 20 : 0,
                                  right: language == 'he' ? 20 : 0),
                              child: UserRepliedCommentCard(
                                mainStoryIndex: mainStoryIndex,
                                mainLikeLength: mainLikeLength,
                                myStoryUserId: mystoriesId ?? 0,
                                comment: storyProvider
                                    .singleStoryComments![index],
                                storyUserId:
                                storyModel!.story.id.toString(),
                                myID: box.read('userID'),
                                mainPos: index,
                                deleteCommentCallBack: () {
                                  userProvider.deleteComment(
                                    context: context,
                                    commentId: storyProvider
                                        .singleStoryComments![
                                    index]
                                        .comment
                                        .id ??
                                        0,
                                  );

                                  storyProvider.singleStoryComments!
                                      .removeAt(index);
                                  storyProvider
                                      .changeSingleStoryComments(
                                    singleStoryComments:
                                    storyProvider
                                        .singleStoryComments!,
                                  );
                                },
                                route: '/comment',
                                likeCommentCallBack: () async {
                                  //userProvider.setIsTrue(true);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Logger.w(
                          'is all comment loaded ${storyProvider.isAllCommentsLoaded}');
                      return storyProvider.isAllCommentsLoaded
                          ? Container()
                          : storyProvider
                          .singleStoryComments!.isEmpty
                          ? const Center(
                        child: SpinKitFadingFour(
                          size: 40,
                          color: Color(0xff52527a),
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          storyProvider
                              .changePageNumber();
                          isShowButton = true;

                          storyProvider
                              .getSingleStoryComments(
                              context: context,
                              pageNumber: storyProvider
                                  .pageNumberForData,
                              storyId: postId,
                              authTOKEN: box.read(
                                  'userTokenForAuth'));

                          isShowButton = false;
                        },
                        child: Center(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8,
                                top: 8,
                                right: 8,
                                bottom: 20),
                            child: Text(
                              'view previous replies',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                Constants.blueColor,
                                fontWeight:
                                FontWeight.bold,
                                fontFamily: Constants
                                    .fontFamilyName,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
                  : const Expanded(
                child: Center(
                  child: Text(
                    'Be the first to comment',
                  ),
                ),
              );
            }),

            // FutureBuilder(
            //   future: storyProvider.getSingleStoryComments(
            //     context: context,
            //   ),
            //   builder: (c, AsyncSnapshot<List<CommentModel>?> snapshot) {
            //     if (snapshot.hasData) {
            //       if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            //         return Expanded(
            //           child: StatefulBuilder(builder: (context, setState) {
            //             return Column(
            //               children: [
            //                 Expanded(
            //                   child: ListView.builder(
            //                     controller: scrollController,
            //                     itemCount:
            //                         storyProvider.singleStoryComments!.length + 1,
            //                     itemBuilder: (context, index) {
            //                       if (index <
            //                           storyProvider.singleStoryComments!.length) {
            //                         return Padding(
            //                           padding: EdgeInsets.only(
            //                               left: 10,
            //                               right: 10,
            //                               bottom: 15,
            //                               top: index == 0 ? 30 : 0),
            //                           child: Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.end,
            //                             children: [
            //                               UserCommentCard(
            //                                 comment: storyProvider.singleStoryComments![index],
            //                                 storyUserId:
            //                                     storyModel!.story.id.toString(),
            //                                 myID: box.read('userID'),
            //                                 deleteCommentCallBack: () {
            //                                   userProvider.deleteComment(
            //                                     context: context,
            //                                     commentId: storyProvider
            //                                         .singleStoryComments![index]
            //                                         .comment
            //                                         .id,
            //                                   );
            //
            //                                   storyProvider.singleStoryComments!
            //                                       .removeAt(index);
            //                                   storyProvider
            //                                       .changeSingleStoryComments(
            //                                     singleStoryComments: storyProvider
            //                                         .singleStoryComments!,
            //                                   );
            //                                 },
            //                                 route: '/comment',
            //                                 likeCommentCallBack: () {
            //                                   userProvider.addLike(storyProvider
            //                                       .singleStoryComments![index]
            //                                       .comment
            //                                       .id,);
            //                               },
            //                               ),
            //                               /*  Padding(
            //                                   padding: const EdgeInsets.symmetric(horizontal: 10),
            //                                   child: GestureDetector(
            //                                     onTap: () {
            //                                      for(int i = 0; i < _storyProvider.singleStoryComments!.length; i++){
            //                                        _storyProvider.singleStoryComments![i].showInput = false;
            //                                      }
            //                                       _storyProvider.singleStoryComments![index].showInput = true;
            //                                       setState((){
            //
            //                                       });
            //
            //                                     },
            //                                     child: _storyProvider.singleStoryComments![index].showInput! ? Row(
            //                                       crossAxisAlignment: CrossAxisAlignment.end,
            //                                       children: [
            //                                         Expanded(
            //                                           child: Container(
            //                                             padding: const EdgeInsets.symmetric(horizontal: 0),
            //                                             height: 50,
            //                                             width: 60,
            //                                             decoration: BoxDecoration(
            //                                               color: Colors.grey.withOpacity(0.1),
            //                                               borderRadius: BorderRadius.circular(10),
            //                                             ),
            //                                             child: Row(
            //                                               children: [
            //                                                 // CircleAvatar(
            //                                                 //   backgroundImage:
            //                                                 //       _userProvider.userInfo!.gender == 'Male'
            //                                                 //           ? const AssetImage('assets/images/man.png')
            //                                                 //           : const AssetImage(
            //                                                 //               'assets/images/female.png',
            //                                                 //             ),
            //                                                 //   radius: 15,
            //                                                 // ),
            //                                                 CustomUserAvatar(
            //                                                   imageUrl: male == 'Male'
            //                                                       ? "assets/images/female.png"
            //                                                       : 'assets/images/female.png',
            //                                                   userColor: color!,
            //                                                 ),
            //                                                 const SizedBox(
            //                                                   width: 0,
            //                                                 ),
            //                                                 box.read('lang') == 'he' ? Expanded(
            //                                                   child: TextFormField(
            //                                                     autofocus: true,
            //                                                     // onFieldSubmitted: (value) {
            //                                                     //   controller.clear();
            //                                                     // },
            //                                                     controller: replyController,
            //                                                     decoration: const InputDecoration(
            //                                                         isDense: true,
            //                                                         hintText: 'השב לתגובה',
            //                                                         border: OutlineInputBorder(
            //                                                             borderSide: BorderSide.none)),
            //                                                     style: const TextStyle(
            //                                                         color: Color(0xff121556), fontSize: 14),
            //                                                   ),
            //                                                 ) :  Expanded(
            //                                                   child: TextFormField(
            //                                                     autofocus: true,
            //                                                     // onFieldSubmitted: (value) {
            //                                                     //   controller.clear();
            //                                                     // },
            //                                                     controller: replyController,
            //                                                     decoration: const InputDecoration(
            //                                                         isDense: true,
            //                                                         hintText: 'Reply the Comment',
            //                                                         border: OutlineInputBorder(
            //                                                             borderSide: BorderSide.none)),
            //                                                     style: const TextStyle(
            //                                                         color: Color(0xff121556), fontSize: 14),
            //                                                   ),
            //                                                 ),
            //                                                 const SizedBox(
            //                                                   width: 10,
            //                                                 ),
            //                                                 InkWell(
            //                                                   onTap: () {
            //                                                     if (replyController.text.isNotEmpty) {
            //                                                       final MakeCommentModel makeCommentModel =
            //                                                       MakeCommentModel(
            //                                                           storyId: postId, body: replyController.text);
            //                                                       ref
            //                                                           .read(makeCommentProvider.notifier)
            //                                                           .makeComment(makeCommentModel);
            //                                                       replyController.clear();
            //                                                       setState((){
            //                                                         _storyProvider.singleStoryComments![index].showInput = false;
            //                                                       });
            //                                                     }
            //
            //                                                   },
            //                                                   child: Padding(
            //                                                     padding: const EdgeInsets.symmetric(horizontal: 10),
            //                                                     child: const Icon(
            //                                                       Icons.send,
            //                                                       color: Color(0xff121556),
            //                                                     ),
            //                                                   ),
            //                                                 ),
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ) :
            //                                     Text(
            //                                       TKeys.replyText.translate(context),
            //                                       style: TextStyle(
            //                                         fontSize: 13,
            //                                         color: const Color(0xff132952),
            //                                         fontWeight: FontWeight.bold,
            //                                         fontFamily: Constants.fontFamilyName,
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),*/
            //                             ],
            //                           ),
            //                         );
            //                       } else {
            //                         Logger.w(
            //                             'is all comment loaded ${storyProvider.isAllCommentsLoaded}');
            //                         return storyProvider.isAllCommentsLoaded
            //                             ? Container()
            //                             : const Center(
            //                                 child: SpinKitFadingFour(
            //                                   size: 40,
            //                                   color: Color(0xff52527a),
            //                                 ),
            //                               );
            //                       }
            //                     },
            //                   ),
            //                 ),
            //               ],
            //             );
            //           }),
            //         );
            //       } else {
            //         return const Expanded(
            //           child: Center(
            //             child: Text(
            //               'Be the first to comment',
            //             ),
            //           ),
            //         );
            //       }
            //     } else {
            //       return Expanded(
            //         child: Transform.scale(
            //           scale: 1.5,
            //           child: const Center(
            //             child: SpinKitFadingFour(
            //               size: 40,
            //               color: Color(0xff52527a),
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // CircleAvatar(
                          //   backgroundImage:
                          //       _userProvider.userInfo!.gender == 'Male'
                          //           ? const AssetImage('assets/images/man.png')
                          //           : const AssetImage(
                          //               'assets/images/female.png',
                          //             ),
                          //   radius: 15,
                          // ),
                          CustomUserAvatar(
                            imageUrl: male == 'Male'
                                ? 'assets/images/male.png'
                                : 'assets/images/female.png',
                            userColor: color ?? '',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              onTap: () {
                                for (int i = 0;
                                i < storyProvider.singleStoryComments!.length;
                                i++) {
                                  storyProvider
                                      .singleStoryComments![i].showInput = false;
                                }

                                setState1(() {});
                              },
                              autofocus: true,
                              // onFieldSubmitted: (value) {
                              //   controller.clear();
                              // },
                              controller: controller,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              style: const TextStyle(
                                  color: Color(0xff121556), fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.text.isNotEmpty) {
                                final MakeCommentModel makeCommentModel =
                                MakeCommentModel(
                                    storyId: postId, body: controller.text);
                                ref
                                    .read(makeCommentProvider.notifier)
                                    .makeComment(makeCommentModel);
                                controller.clear();
                              }
                            },
                            child: const Icon(
                              Icons.send,
                              color: Color(0xff121556),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },),
    );
  }

//FlushBar widget
  void showFlushBar(BuildContext context, String title) {
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
      backgroundColor: const Color(0xff121556),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1500),
    ).show(context);
  }
}
