import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/screens/blocked_users/block_user.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_user_avatar.dart';

class FollowingTab extends StatefulWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: userProvider.followingUsers != null &&
                      userProvider.followingUsers!.isNotEmpty
                  ? ListView.builder(
                      itemCount: userProvider.followingUsers!.length,
                      itemBuilder: (context, index) {
                        return Following(
                          name: userProvider.followingUsers![index].name,
                          userColor: userProvider.followingUsers![index].color,
                          imageAddress:
                              userProvider.followingUsers![index].gender ==
                                      'Male'
                                  ? 'assets/images/male.png'
                                  : 'assets/images/female.png',
                          userId: userProvider.followingUsers![index].id,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No Following Users',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Following extends StatelessWidget {
  final String? userColor, name, imageAddress;
  final int? userId;
  const Following({
    Key? key,
    this.userColor,
    this.name,
    this.imageAddress,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CustomUserAvatar(
            imageUrl: imageAddress!,
            userColor: userColor!,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: Text(
              name!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: Constants.fontFamilyName,
              ),
            ),
          ),
          const Spacer(),
          PopupMenuButton<int>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(
                  onTap: () {
                    userProvider.unfollowUser(
                      userId: userId!,
                      context: context,
                    );
                    userProvider.followingUsers!.removeWhere(
                      (element) => element.id == userId,
                    );
                    userProvider.changeFollowingUsers(
                      userProvider.followingUsers,
                    );
                  },
                  value: 0,
                  child: Text(TKeys.remove_follower.translate(context)),
                ),
                PopupMenuItem(
                  value: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlockedUser(
                            userId: userId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      TKeys.report_block.translate(context),
                    ),
                  ),
                ),
              ];
            },
            child: Container(
              padding: const EdgeInsets.only(right: 25, left: 25),
              height: 36,
              width: 48,
              child: Icon(
                Icons.more_vert,
                color: Constants.vertIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
