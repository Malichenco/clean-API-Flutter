import 'package:flutter/material.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/utills/functions/from_rgb_color.dart';

class CustomProfileAvatar extends StatelessWidget {
  const CustomProfileAvatar({
    Key? key,
    required this.story,
  }) : super(key: key);

  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          color: fromRGBColor(story.userColor),
        ),
        padding: const EdgeInsets.only(
          right: 1.5,
        ),
        child: Image.asset(
          story.userGender == 'Male'
              ? 'assets/images/male.png'
              : 'assets/images/female.png',
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
