import 'dart:convert';
import 'dart:math';

import 'package:Taillz/screens/consult/consultProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/domain/story/story_model.dart';
import 'package:Taillz/providers/widget_provider.dart';
import 'package:Taillz/screens/consult/consult_screen.dart';
import 'package:Taillz/screens/consult/create_consult_post.dart';
import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/story_card_new.dart';

import '../../utills/utils.dart';
import '../../widgets/story_card.dart';

class ConsultDetailScreen extends StatefulWidget {
  const ConsultDetailScreen({
    Key? key,
    this.imagePath,
    this.consultName,
    this.builder,
    required this.consultGroupName,
  }) : super(key: key);

  final MyBuilder? builder;
  final String? imagePath;
  final String? consultName;
  final String? consultGroupName;

  @override
  State<ConsultDetailScreen> createState() => _ConsultDetailScreenState();
}

class _ConsultDetailScreenState extends State<ConsultDetailScreen> {
  final localizationController = Get.find<LocalizationController>();
  var list = ['assets/images/bg1.png'];
  var box = GetStorage();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    var consultProvider = Provider.of<ConsultProvider>(context,listen: false);
    consultProvider.getStories(widget.consultGroupName!,context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        consultProvider.pageNumberAdd();
        consultProvider.getStories(widget.consultGroupName!,context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
         Consumer<ConsultProvider>(builder: (context,consultProvider,_){
           return  Container(
             color: Colors.white,
             child: Column(
               children: [
                 SizedBox(
                   height: 108,
                   child: Card(
                     elevation: 0,
                     clipBehavior: Clip.antiAlias,
                     child: Stack(
                       children: [
                         SizedBox(
                             height: 108,
                             width: MediaQuery.of(context).size.width,
                             child: Image.asset(
                               widget.imagePath!,
                               fit: BoxFit.fitWidth,
                             )),
                         Container(
                           decoration:
                           const BoxDecoration(color: Color(0x4B000000)),
                         ),
                         InkWell(
                           onTap: () => widget.builder!.call(context, () {}),
                           child: const Padding(
                             padding: EdgeInsets.symmetric(
                                 horizontal: 10, vertical: 15),
                             child: Icon(
                               Icons.arrow_back_ios,
                               size: 25,
                               color: Colors.white,
                             ),
                           ),
                         ),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: SizedBox(
                                 width: MediaQuery.of(context).size.width,
                                 child: Text(
                                   widget.consultName!,
                                   // textAlign: TextAlign.center,
                                   style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 15,
                                     fontWeight: FontWeight.w600,
                                     fontFamily: Constants.fontFamilyName,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
                 consultProvider.storiesByGroups.isEmpty
                     ?  consultProvider.isLoadedForConsult
                     ? Container()
                     : const Expanded(
                   child: Center(
                     child: SpinKitFadingFour(
                       size: 60,
                       color: Color(0xff52527a),
                     ),
                   ),
                 )
                     : Expanded(
                   flex: 1,
                   child: ListView.builder(
                     controller: _scrollController,
                     itemCount:  consultProvider.storiesByGroups.length + 1,
                     itemBuilder: (context, i) {
                       if (i <  consultProvider.storiesByGroups.length) {
                         return StoryCardNew(
                           Index: i,
                           img:
                           bgImages[Random().nextInt(bgImages.length)],
                           story:  consultProvider.storiesByGroups[i],
                           route: widget.consultGroupName!,
                         );
                       } else {
                         return  consultProvider.isLoadedForConsult
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
             ),
           );
         }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: box.read('lang') == 'he'
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: const Color(0xff19334D),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => CreateConsultScreen(
                        image: widget.imagePath!,
                        consultGroupName: widget.consultGroupName!,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
