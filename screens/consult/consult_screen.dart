import 'dart:developer';

import 'package:Taillz/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/models/consult_model.dart';
import 'package:Taillz/providers/story_provider.dart';
import 'package:Taillz/screens/consult/components/consult_group_card.dart';
import 'package:Taillz/screens/consult/consult_detail_screen.dart';
import 'package:Taillz/utills/constant.dart';

typedef MyBuilder = void Function(
  BuildContext context,
  void Function() methodA,
);

class ConsultScreen extends StatefulWidget {
  const ConsultScreen({Key? key}) : super(key: key);

  @override
  State<ConsultScreen> createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
  late ScrollController controller;
  int _currentIndex = 0;
  final List<int> _backstack = [0];
  String imagePath = '';
  String consultName = '';
  String consultGroupName = '';

  void _scrollListener() {
    debugPrint(controller.position.extentAfter.toString());
    if (controller.position.extentAfter < 500) {}
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    _loading = true;

    if (notification is ScrollEndNotification) {
      if (controller.position.extentAfter == 0) {
        setState(() {
          listCount += 10;
          _loading = false;
        });
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    var userProvider=Provider.of<UserProvider>(context,listen: false);
    userProvider.setFirstTimeCallTrue();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fragments = [
      fragmentOne(navigateTo),
      ConsultDetailScreen(
        consultName: consultName,
        consultGroupName: '',
        imagePath: imagePath,
      )
    ];

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Container(
        child: _currentIndex == 0
            ? fragments[_currentIndex]
            : ConsultDetailScreen(
                imagePath: imagePath,
                consultName: consultName,
                consultGroupName: consultGroupName,
                builder: (BuildContext context, void Function() methodA) {
                  // myMethod = methodA;
                  customPop(context);
                },
              ),
      ),
    );
  }

  void navigateTo(int index) {
    _backstack.add(index);
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateBack(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  customPop(BuildContext context) {
    if (_backstack.length - 1 > 0) {
      navigateBack(0);
    } else {
      _backstack.removeAt(_backstack.length - 1);
      Navigator.pop(context);
    }
  }

  late List<ConsultModel> list;
  int listCount = 10;
  bool _loading = false;

  Widget fragmentOne(void Function(int index) navigateTo) {
    final box = GetStorage();
    String gender = box.read('userGender');
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    log(gender);

    debugPrint(_loading.toString());

    list = [
      ConsultModel(
        Constants.consult1,
        TKeys.Relationship_text.translate(context),
      ),
      if (gender.isEmpty
          ? userProvider.userInfo?.gender == 'Female'
          : gender == 'Female')
        ConsultModel(
          Constants.consult2,
          TKeys.Women_talk_text.translate(context),
        ),
      if (gender.isEmpty
          ? userProvider.userInfo?.gender == 'Female'
          : gender == 'Female')
        ConsultModel(
          Constants.consult3,
          TKeys.Motherhood_text.translate(context),
        ),
      ConsultModel(
        Constants.consult4,
        TKeys.Divorced_text.translate(context),
      ),
      ConsultModel(
        Constants.consult5,
        TKeys.LGBT_text.translate(context),
      ),
      ConsultModel(
        Constants.consult6,
        TKeys.Humanity_text.translate(context),
      ),
      ConsultModel(
        Constants.consult7,
        TKeys.Discrimination_text.translate(context),
      ),
      ConsultModel(
        Constants.consult8,
        TKeys.Vegan_text.translate(context),
      ),
    ];

    StoryProvider storyProvider = Provider.of<StoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        color: Colors.white,
        child: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: GridView.builder(
            controller: controller,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: list.length >= listCount ? listCount : list.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  setState(() {
                    imagePath = list[i].imagePath;
                    consultName = list[i].consultName;
                    consultGroupName = Constants().consultGroupNames[i];
                  });
                  if (storyProvider.storiesByGroups == null ||
                      storyProvider.storiesByGroups!.isEmpty ||
                      storyProvider.storiesByGroups![
                              Constants().consultGroupNames[i]] ==
                          null ||
                      storyProvider
                          .storiesByGroups![Constants().consultGroupNames[i]]!
                          .isEmpty) {
                    storyProvider.getStoriesbyGroup(
                      groupName: Constants().consultGroupNames[i],
                      context: context,
                    );
                  }
                  navigateTo(1);
                },
                child: ConsultGroupCard(
                  consultModel: list[i],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
