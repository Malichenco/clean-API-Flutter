import 'package:another_flushbar/flushbar.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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

// ignore: must_be_immutable
class ReplayCommentScreen extends HookConsumerWidget {
  final CommentModel comments;
  final int storyID;
  final int mainStoryIndex;
  ReplayCommentScreen(
      {Key? key,
        required this.mainStoryIndex,
      required this.comments,
      required this.storyID})
      : super(key: key);

  var box1 = GetStorage();

  List<bool> replies = [];

  @override
  Widget build(BuildContext context, ref) {
    StoryProvider storyProvider = provider.Provider.of<StoryProvider>(context);
    final controller = useTextEditingController();
    // TODO
    // final replyController = useTextEditingController();
    int pageNumber = 0;
    ScrollController scrollController = useMemoized(() => ScrollController());
    useEffect(() {
      var box = GetStorage();
      Logger.e(box.read('userTokenForAuth'));
      storyProvider.getReplayComments(
              context: context,
              pageNumber: pageNumber,
              commentID: comments.comment.id,
              authTOKEN: box.read('userTokenForAuth'))
          .then((value) {
        Logger.w(value!.length);
      });

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          pageNumber++;

          storyProvider.getReplayComments(
              context: context,
              pageNumber: pageNumber,
              commentID: comments.comment.id,
              authTOKEN: box.read('userTokenForAuth'));
        }
      });
      return () {
        scrollController.dispose();
      };
    }, []);
    ref.listen<MakeCommentState>(makeCommentProvider, ((previous, next) {
      if (!next.loading && next.failure == CleanFailure.none()) {
        showFlushBar(context, TKeys.comment_pending.translate(context));
        // ref.read(storyProvider.notifier).getStories();
      }
    }));

    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    var box = GetStorage();
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
      body: Column(
        children: [
          FutureBuilder(
            future: storyProvider.getReplayComments(
              context: context,
            ),
            builder: (c, AsyncSnapshot<List<CommentModel>?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount:
                                  storyProvider.singleStoryComments!.length + 1,
                              itemBuilder: (context, index) {
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
                                          mainPos: index,
                                          length: storyProvider.singleStoryComments?.length ?? 0,
                                          comment: storyProvider
                                              .singleStoryComments![index],
                                          storyUserId:
                                              comments.comment.id.toString(),
                                          myID: box.read('userID'),
                                          deleteCommentCallBack: () {
                                            userProvider.deleteComment(
                                              context: context,
                                              commentId: storyProvider
                                                  .singleStoryComments![index]
                                                  .comment
                                                  .id ?? 0,
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
                                          newComment: false,
                                          recursiveComment: true,
                                          likeCommentCallBack: () {
                                        },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Logger.w(
                                      'is all comment loaded ${storyProvider.isAllCommentsLoaded}');
                                  return storyProvider.isAllCommentsLoaded
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
                      );
                    }),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'Be the first to comment',
                      ),
                    ),
                  );
                }
              } else {
                return Expanded(
                  child: Transform.scale(
                    scale: 1.5,
                    child: const Center(
                      child: SpinKitFadingFour(
                        size: 40,
                        color: Color(0xff52527a),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
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
                        CustomUserAvatar(
                          imageUrl: comments.user.gender == 'Male'
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          userColor: '#000fff',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
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
                             Map<String,dynamic>map=Map();
                             map['publishDate']=DateTime.now().toUtc().toString().replaceAll(" ", 'T');
                             map['body']=controller.value.text;
                             map['commentId']=comments.comment.id;
                             map['storyId']=comments.comment.storyId;
                             /*ref.read(makeCommentProvider.notifier).makeReplayComment(map).then((value){

                              });*/
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
                ),
              ],
            ),
          ),
        ],
      ),
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
