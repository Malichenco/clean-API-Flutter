import 'package:Taillz/screens/change/c/change_controller.dart';
import 'package:flutter/material.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/models/change_model.dart';
import 'package:Taillz/screens/change/components/custom_video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';


import '../../providers/user_provider.dart';
import '../karma/c/karma_controller.dart';

class ChangeScreen extends StatefulWidget {
  const ChangeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _PageState();
}

class _PageState extends StateMVC<ChangeScreen> {
  late ChangeController _con;
  _PageState() : super(ChangeController()) {
    _con = controller as ChangeController;
  }
  @override
  void initState() {
    super.initState();
    var userProvider=Provider.of<UserProvider>(context,listen: false);
    userProvider.setFirstTimeCallTrue();
    _con.getVideos();
  }
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _body(userProvider),
    );
  }
  Widget _body(UserProvider userProvider){
    if(_con.response==null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(_con.response!.payload!.isEmpty){
      return Text('No data found');
    }
    return Stack(
      children: [
        ListView.builder(itemBuilder: (context, index) {
          return CustomVideoPlayer(
            play: false,
            model: _con.response!.payload![index], onTap: (int videoId,int userId) async {
            setState(() {
              showLoader = true;
            });
            await userProvider
                .likeAndDislike(
              videoId: videoId,
              userId: userId,
              context: context,
            )
                .then(
                  (value) {
                    setState(() {
                      showLoader = false;
                    });
              },
            );
          },
          );
        },itemCount: _con.response!.payload!.length,shrinkWrap: true,),
        showLoader
            ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black87.withOpacity(0.4),
          child: const Center(
            child: SpinKitFadingFour(
              size: 60,
              color: Color(0xff52527a),
            ),
          ),
        )
            : Container()
      ],
    );
  }
}
