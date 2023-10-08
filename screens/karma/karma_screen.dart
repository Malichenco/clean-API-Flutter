import 'package:Taillz/screens/karma/c/karma_controller.dart';
import 'package:Taillz/screens/karma/m/karma_response.dart';
import 'package:flutter/material.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../presentation/screens/main_screen.dart';
import '../medal/medal_screen.dart';

class KarmaScreen extends StatefulWidget {
  const KarmaScreen({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<KarmaScreen> {
  late KarmaController _con;
  _PageState() : super(KarmaController()) {
    _con = controller as KarmaController;
  }
  @override
  void initState() {
    super.initState();
    _con.getKarma();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: 0,
        title: CustomAppBarTitle(scaffoldKey: _con.scaffoldKey, index: 2),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 75,
              ),
              width: double.infinity,
            ),
            Text(
              TKeys.our_way.translate(context),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                TKeys.write_nice_comment.translate(context),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Your Credit: ${_con.getTotal()}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,

              // child: Text(
              // TKeys.you_can_redeem.translate(context),
              //style: const TextStyle(fontSize: 16),
              //textAlign: TextAlign.center,
              //),
            ),
            const SizedBox(
              height: 50,
            ),
            if (_con.response != null &&
                _con.response!.payload!.isNotEmpty) ...{
              ListView.builder(
                itemBuilder: (context, index) {
                  Payload data = _con.response!.payload![index];
                },
                itemCount: _con.response!.payload!.length,
                shrinkWrap: true,
                primary: false,
              )
            }
          ],
        ),
      ),
    );
  }
}
