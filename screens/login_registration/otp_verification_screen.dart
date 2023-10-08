import 'package:Taillz/screens/login_registration/reset_password_screen.dart';
import 'package:Taillz/widgets/custom_flushbar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Localization/t_keys.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart' as provider;

import 'c/verification_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<OtpVerificationScreen> {
  late VerificationController _con;

  var otpCode = 0;

  _PageState() : super(VerificationController()) {
    _con = controller as VerificationController;
  }

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController newPasswordcontroller = TextEditingController();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/PasswordRecoveryLock.svg',
                    width: 70,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    TKeys.PasswordRecoveryEnterCode.translate(context),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2d2d6c),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '( Code is valid for 24hrs )',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OtpTextField(
                    numberOfFields: 5,
                    borderColor: Color(0xFF512DA8),
                    fieldWidth: 50,
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      otpCode = int.parse(verificationCode);
                    }, // end onSubmit
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  OtpTimerButton(
                    onPressed: () {},
                    text: Text(
                      TKeys.PasswordRecoveryDidntGetCode.translate(context),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2d2d6c),
                      ),
                    ),
                    duration: 120,
                    buttonType: ButtonType.text_button,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      label: Text(
                        TKeys.PasswordRecoveryYourEmail.translate(context),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2d2d6c),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      label: Text(
                        TKeys.PasswordRecoveryNewPassword.translate(context),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2d2d6c),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: newPasswordcontroller,
                    decoration: InputDecoration(
                      label: Text(
                        TKeys.PasswordRecoveryConfirmNewPassword.translate(
                            context),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2d2d6c),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 45,
                    width: 200,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (otpCode == 0) {
                          showFlushBar(
                              context,
                              TKeys.PasswordRecoveryPleaseFillDetails.translate(
                                  context));
                          return;
                        }
                        if (!(emailcontroller.text.isNotEmpty &&
                            emailcontroller.text.isEmail)) {
                          showFlushBar(
                              context,
                              TKeys.PasswordRecoveryPleaseEnterEmail.translate(
                                  context));
                          return;
                        }

                        if (passwordcontroller.text.isEmpty &&
                            !validateStructure(passwordcontroller.text)) {
                          showFlushBar(context,
                              TKeys.password_validation.translate(context));
                          return;
                        }

                        if (newPasswordcontroller.text.isEmpty &&
                            !validateStructure(newPasswordcontroller.text)) {
                          showFlushBar(context,
                              TKeys.password_validation.translate(context));
                          return;
                        }

                        if (!(passwordcontroller.text ==
                            newPasswordcontroller.text)) {
                          showFlushBar(
                              context,
                              TKeys.PasswordRecoveryPasswordsNotMatch.translate(
                                  context));
                          return;
                        }

                        setState(() {
                          showLoader = true;
                        });
                        await userProvider
                            .sendForgetPassword(
                          email: emailcontroller.text,
                          password: newPasswordcontroller.text,
                          code: otpCode,
                          context: context,
                        )
                            .then(
                          (value) {
                            setState(() {
                              showLoader = false;
                            });
                          },
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ResetPasswordScreen(),
                        //     ));
                      },
                      child: Text(
                        TKeys.PasswordRecoverySubmit.translate(context),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        ),
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
