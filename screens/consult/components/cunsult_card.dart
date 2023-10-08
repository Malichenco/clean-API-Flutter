import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/auth/auth_provider.dart';
import 'package:Taillz/application/story/get/story_provider.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/screens/blocked_users/block_user.dart';
import 'package:Taillz/screens/comment_screen/comment_screen.dart';
import 'package:Taillz/screens/writerPage/writer_screen.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';
import 'package:Taillz/widgets/user_comment.dart';
import '../../../utills/counter_function.dart';

class CunsultCard extends HookConsumerWidget {
  final String item;
  final String image;
  final StoryModel story;
  final bool isFollowed;
  CunsultCard({
    Key? key,
    required this.item,
    required this.image,
    required this.story,
    required this.isFollowed,
  }) : super(key: key);

  List<String> bgImages = [
    'assets/images/PostBackground/1.png',
    'assets/images/PostBackground/2.png',
    'assets/images/PostBackground/3.png',
    'assets/images/PostBackground/4.png',
    'assets/images/PostBackground/5.png',
    'assets/images/PostBackground/6.png',
    'assets/images/PostBackground/7.png',
    'assets/images/PostBackground/8.png',
    'assets/images/PostBackground/9.png',
    'assets/images/PostBackground/10.png',
    'assets/images/PostBackground/11.png',
    'assets/images/PostBackground/12.png',
    'assets/images/PostBackground/13.png',
    'assets/images/PostBackground/14.png',
    'assets/images/PostBackground/15.png',
    'assets/images/PostBackground/16.png',
    'assets/images/PostBackground/17.png',
    'assets/images/PostBackground/18.png',
    'assets/images/PostBackground/19.png',
    'assets/images/PostBackground/20.png',
    'assets/images/PostBackground/21.png',
    'assets/images/PostBackground/22.png',
    'assets/images/PostBackground/23.png',
    'assets/images/PostBackground/24.png',
    'assets/images/PostBackground/25.png',
    'assets/images/PostBackground/49.png',
    'assets/images/PostBackground/26.png',
    'assets/images/PostBackground/27.png',
    'assets/images/PostBackground/28.png',
    'assets/images/PostBackground/29.png',
    'assets/images/PostBackground/30.png',
    'assets/images/PostBackground/31.png',
    'assets/images/PostBackground/32.png',
    'assets/images/PostBackground/33.png',
    'assets/images/PostBackground/34.png',
    'assets/images/PostBackground/35.png',
    'assets/images/PostBackground/36.png',
    'assets/images/PostBackground/37.png',
    'assets/images/PostBackground/38.png',
    'assets/images/PostBackground/39.png',
    'assets/images/PostBackground/40.png',
    'assets/images/PostBackground/41.png',
    'assets/images/PostBackground/42.png',
    'assets/images/PostBackground/43.png',
    'assets/images/PostBackground/44.png',
    'assets/images/PostBackground/45.png',
    'assets/images/PostBackground/46.png',
    'assets/images/PostBackground/47.png',
    'assets/images/PostBackground/48.png',
    'assets/images/PostBackground/49.png',
  ];

  final localizationscontroller = Get.find<LocalizationController>();
  var box = GetStorage();

  @override
  Widget build(BuildContext context, ref) {
    final userInfo = ref.watch(authProvider);
    UserProvider localUserProvider =
        provider.Provider.of<UserProvider>(context);
    StoryProvider localStoryProvider =
        provider.Provider.of<StoryProvider>(context);
    UserProvider userProvider =
        provider.Provider.of<UserProvider>(context, listen: false);

    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 130,
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
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Color(0x4B000000)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 5, end: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: PopupMenuButton<int>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 28,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              itemBuilder: (context) {
                                bool? isFollowed = false;
                                if (localUserProvider.followingUsers != null &&
                                    localUserProvider
                                        .followingUsers!.isNotEmpty) {
                                  for (var element
                                      in localUserProvider.followingUsers!) {
                                    if (element.id == story.userId) {
                                      isFollowed = true;
                                    }
                                  }
                                }
                                return <PopupMenuEntry<int>>[
                                  if (userInfo.userInfo.id != story.userId)
                                    PopupMenuItem(
                                      onTap: () {
                                        if (!isFollowed!) {
                                          localUserProvider.followUser(
                                            context: context,
                                            userId: story.userId,
                                          );
                                          UserInfo user = UserInfo(
                                            totalPending: 0,
                                            totalDrafts: 0,
                                            totalApproval: 0,
                                            totalImTailing: 0,
                                            deniedPublished: 0,
                                            name: story.userNick,
                                            color: story.userColor,
                                            count: 0,
                                            id: story.userId,
                                            gender: story.userGender,
                                            inboxCount: 0,
                                            newImTailingCount: 0,
                                            unreadNotifsNo: 0,
                                            yearOfBirth: 1983,
                                          );
                                          localUserProvider.followingUsers ??=
                                              [];
                                          localUserProvider.followingUsers!
                                              .add(user);
                                        } else {
                                          localUserProvider.unfollowUser(
                                            context: context,
                                            userId: story.userId,
                                          );
                                          localUserProvider.followingUsers!
                                              .removeWhere(
                                            (element) =>
                                                element.id == story.userId,
                                          );
                                          localUserProvider
                                              .changeFollowingUsers(
                                            localUserProvider.followingUsers,
                                          );
                                        }
                                      },
                                      value: 0,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          isFollowed!
                                              ? 'UnFollow'
                                              : TKeys.follow.translate(context),
                                        ),
                                      ),
                                    ),
                                  if (userInfo.userInfo.id != story.userId)
                                    PopupMenuItem(
                                        value: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlockedUser(
                                                  userId:
                                                      story.userId.toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            TKeys.report_block.translate(
                                              context,
                                            ),
                                          ),
                                        )),
                                  if (userInfo.userInfo.id == story.userId)
                                    PopupMenuItem(
                                      onTap: () {},
                                      value: 3,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          TKeys.delete_post.translate(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ),
                                ];
                              },
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
                                CustomUserAvatar(
                                  imageUrl: story.userGender == 'Male'
                                      ? 'assets/images/male.png'
                                      : 'assets/images/female.png',
                                  userColor: story.userColor,
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
                                                    isFollowed: isFollowed,
                                                item: item,
                                                image: image,
                                                story: story,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          story.userNick,
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
                                        ),
                                      ),
                                      Text(
                                        story.story.publishDate,
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
                                    isFollowed: isFollowed,
                                    item: item,
                                    image: image,
                                    story: story,
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
                                    isFollowed: isFollowed,
                                    item: item,
                                    image: image,
                                    story: story,
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
          Container(
            margin:
                const EdgeInsets.only(bottom: 5, right: 15, left: 15, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: box.read('lang') == 'he' ? 10 : 20,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => WriterScreen(
                                isFollowed: isFollowed,
                                item: item,
                                image: image,
                                story: story,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          story.story.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff19334D),
                            fontFamily: Constants.fontFamilyName,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${CounterFunction.countforInt(int.parse(story.story.views.toString()))} ${TKeys.views.translate(context)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: Constants.fontFamilyName,
                        color: Constants.readMoreColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.only(
                    right: box.read('lang') == 'he' ? 10 : 35,
                    left: box.read('lang') == 'he' ? 35 : 0,
                  ),
                  child: Text(
                    story.story.body
                        .substring(0, 200)
                        .replaceAll('<p>', '')
                        .replaceAll('</p>', ''),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.fontFamilyName,
                      color: Colors.black,
                      overflow: TextOverflow.visible,
                    ),
                    maxLines: 5,
                    textAlign: localizationscontroller.directionRTL
                        ? TextAlign.justify
                        : TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: localizationscontroller.directionRTL ? 20 : 0,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      TKeys.read_more
                          .translate(context)
                          .capitalizeFirst
                          .toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constants.fontFamilyName,
                        color: const Color(0xff19334D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    mainStoryIndex: 1,
                    mystoriesId: story.userId,
                    comments: story.comments,
                    postId: story.story.id,
                    storyModel: story,
                    route: 'cunsult',
                    color: userInfo.userInfo.color.isEmpty
                        ? userProvider.userInfo?.color
                        : userInfo.userInfo.color,
                    male: userInfo.userInfo.gender.isEmpty
                        ? userProvider.userInfo?.gender
                        : userInfo.userInfo.gender,
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
                      child: Row(children: [
                        //Like
                        InkWell(
                          onTap: () {},
                          child: false
                              ? SvgPicture.asset(
                            'assets/images/Liked.svg',
                            height: 20,
                            color: Colors.black87,
                          )
                              : SvgPicture.asset(
                            'assets/images/Unliked.svg',
                            height: 20,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 15,),

                        //Comment
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                  mainStoryIndex: 1,
                                  mystoriesId: story.userId,
                                  comments: story.comments,
                                  postId: story.story.id,
                                  storyModel: story,
                                  route: 'cunsult',
                                  color: userInfo.userInfo.color.isEmpty
                                      ? userProvider.userInfo?.color
                                      : userInfo.userInfo.color,
                                  male: userInfo.userInfo.gender.isEmpty
                                      ? userProvider.userInfo?.gender
                                      : userInfo.userInfo.gender,
                                ),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/Comment.svg',
                            height: 20,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 6.0),
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
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.send_rounded,color: Colors.black,)

                      ],),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 4, 15, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 6, end: 6.0),
                          child: Text(
                            CounterFunction.countforInt(
                                int.parse(CounterFunction.countforInt(int.parse('10'))
                                    .toString()))
                                .toString(),
                            // likes.value.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: Constants.fontFamilyName,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        const Text('likes'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*Padding(
            padding:
                const EdgeInsets.only(left: 8, top: 12, bottom: 12, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(start: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: false
                              ? SvgPicture.asset(
                                  'assets/images/Liked.svg',
                                  height: 20,
                                  color: Colors.black87,
                                )
                              : SvgPicture.asset(
                                  'assets/images/Unliked.svg',
                                  height: 20,
                                  color: Colors.black87,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 6, end: 6.0),
                          child: Text(
                            CounterFunction.countforInt(int.parse('10'))
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: Constants.fontFamilyName,
                              color: const Color(0xff19334D),
                            ),
                          ),
                        ),
                        const Expanded(
                            child:
                                Divider(thickness: 1, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(start: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                  comments: story.comments,
                                  postId: story.story.id,
                                  storyModel: story,
                                  route: 'cunsult',
                                  color: userInfo.userInfo.color.isEmpty
                                      ? userProvider.userInfo?.color
                                      : userInfo.userInfo.color,
                                  male: userInfo.userInfo.gender.isEmpty
                                      ? userProvider.userInfo?.gender
                                      : userInfo.userInfo.gender,
                                ),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/Comment.svg',
                            height: 20,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 6.0, end: 6.0),
                          child: Text(
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
                        ),
                        const Expanded(
                            child:
                                Divider(thickness: 1, color: Colors.black87)),
                        const SizedBox(width: 6.0),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Text(
                    TKeys.comment_text.translate(context),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xff19334D),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          comments: story.comments,
                          postId: story.story.id,
                          storyModel: story,
                          route: 'cunsult',
                          color: userInfo.userInfo.color.isEmpty
                              ? userProvider.userInfo?.color
                              : userInfo.userInfo.color,
                          male: userInfo.userInfo.gender.isEmpty
                              ? userProvider.userInfo?.gender
                              : userInfo.userInfo.gender,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),*/
          const SizedBox(
            height: 22,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: story.comments.length > 2 ? 2 : story.comments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          mainStoryIndex: 1,
                          comments: story.comments,
                          postId: story.story.id,
                          storyModel: story,
                          route: 'cunsult',
                          color: userInfo.userInfo.color.isEmpty
                              ? userProvider.userInfo?.color
                              : userInfo.userInfo.color,
                          male: userInfo.userInfo.gender.isEmpty
                              ? userProvider.userInfo?.gender
                              : userInfo.userInfo.gender,
                        ),
                      ),
                    );
                  },
                  child: UserCommentCard(
                    mainStoryIndex: 1,
                    userProvider: userProvider,
                    commentData: story.comments,
                    storyId: story.story.id,
                    storyModel: story,
                    isNextScreen: true,
                    mainPos: index,
                    myStoryUserId: story.userId,
                    length: story.comments.length,
                    storyUserId: 'story123',
                    comment: story.comments[index],
                    myID: box.read('userID'),
                    deleteCommentCallBack: () {},
                    route: 'cunsult',
                    likeCommentCallBack: () {},
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    mainStoryIndex: 1,
                    mystoriesId: story.userId,
                    comments: story.comments,
                    postId: story.story.id,
                    storyModel: story,
                    route: 'cunsult',
                    color: userInfo.userInfo.color.isEmpty
                        ? userProvider.userInfo?.color
                        : userInfo.userInfo.color,
                    male: userInfo.userInfo.gender.isEmpty
                        ? userProvider.userInfo?.gender
                        : userInfo.userInfo.gender,
                  ),
                ),
              );
            },
            child:story.totalComments>2
                ? Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 15),
              child: Text('View all ${CounterFunction.countforInt(
                  int.parse(story.totalComments.toString()))
                  .toString()} comments'),
            )
                :Container(),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
