import 'dart:convert';

import 'package:Taillz/utills/api_network.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_api/clean_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart' as provider;
import 'package:Taillz/Localization/localization_service.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/auth/auth_provider.dart';
import 'package:Taillz/application/auth/auth_state.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/presentation/screens/main_screen.dart';
import 'package:Taillz/providers/user_provider.dart';
import 'package:Taillz/screens/login_registration/forgot_password.dart';
import 'package:Taillz/screens/login_registration/resgistrationscreen/sceondscreen/secondscreen.dart';
import 'package:Taillz/widgets/custom_text_field.dart';
import '../../providers/widget_provider.dart';
import '../enddrawer/privacy_policy/privacy_policy_screen.dart';
import '../enddrawer/terms_of_use/terms_of_use_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends HookConsumerWidget {
  String? demo;
  int count = 0;
  final bool newScreen;

  LoginScreen({
    Key? key,
    this.demo,
    this.newScreen = true,
  }) : super(key: key);

  final localizationController = Get.find<LocalizationController>();
  final box = GetStorage();
  ConnectivityResult? connection;

  @override
  Widget build(BuildContext context, ref) {

    UserProvider userProvider = provider.Provider.of<UserProvider>(context);


    TextEditingController emailController = useTextEditingController();
    TextEditingController passwordController = useTextEditingController();

    void getConnection() async {
      connection = await Connectivity().checkConnectivity();
    }

    ref.listen<AuthState>(authProvider, (previous, next) async {
      getConnection();

      if (demo != null && count == 0) {
        count = 0;
        showflushbar(
          context,
          TKeys.account_created.translate(context),
        );
      }

      count++;

      if (next.userInfo != UserInfo.empty() ||
          previous!.userInfo != UserInfo.empty()) {}
      if (previous?.failure != next.failure &&
          next.failure != CleanFailure.none() &&
          next.userInfo == UserInfo.empty()) {
        Logger.w('clicked $connection hello');
        if (connection == ConnectivityResult.none) {
          showflushbar(context, TKeys.connectionStatus.translate(context));
        } else {
          showflushbar(
            context,
            TKeys.user_not_found.translate(context),
          );
        }
      }
    });

    if (newScreen) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/reply_back.svg'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //LOGO PEOPLE
              SvgPicture.asset(
                'assets/images/Logo_LoginScreenPeople.svg',
                height: 280,
                fit: BoxFit.cover,
              ),
              //   const SizedBox(height: 12),
              Container(
                width: Get.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  ////BORDER EMAIL ADDRESS
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: const Color(0xffdec3c3), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          hintText: TKeys.Email_Address.translate(context),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: Get.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  //////BORDER PASSWORD
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: const Color(0xffdec3c3), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          hintText: TKeys.Password_text.translate(context),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                width: 200,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: const Color(0xffdec3c3),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: TextButton(
                  onPressed: () {


                    final bool isValid =
                        EmailValidator.validate(emailController.text.trim());
                    if (isValid && passwordController.text.isNotEmpty) {
                      userProvider.setLoginLoading(true);

                      ref.read(authProvider.notifier).login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                      userProvider
                          .userLogin(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      )
                          .then(
                        (value) {
                          box.write('userTokenForAuth', userProvider.authToken);
                        },
                      );
                    } else if (emailController.text.isEmpty) {
                      userProvider.setLoginLoading(true);
                      showflushbar(
                        context,
                        TKeys.email_require.translate(context),
                      );
                      userProvider.setLoginLoading(false);
                    } else if (passwordController.text.isEmpty) {
                      userProvider.setLoginLoading(true);
                      showflushbar(
                        context,
                        TKeys.password_is_require.translate(context),
                      );
                      userProvider.setLoginLoading(false);
                    } else {
                      userProvider.setLoginLoading(true);
                      showflushbar(
                        context,
                        TKeys.invalid_email.translate(context),
                      );
                      userProvider.setLoginLoading(false);
                    }
                  },
                  child: userProvider.isLoginLoading
                      ? Center(
                          child: LoadingAnimationWidget.waveDots(
                              color: Colors.white, size: 40))
                      : Text(
                          TKeys.Login_text.translate(context).capitalizeFirst ??
                              TKeys.Login_text.translate(context),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),
                        ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 150,
                child: SvgPicture.asset(
                  'assets/images/LogoLoginScreen.svg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 300,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: TKeys.by_clicking_on.translate(context),
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xffdec3c3)),
                    children: [
                      TextSpan(
                        text: 'Terms of Use',
                        style: const TextStyle(color: Color(0xff5a3e84)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsOfUseScreen(),
                                ),
                              ),
                      ),
                      const TextSpan(text: ' / '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(color: Color(0xff5a3e84)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyScreen(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        TextButton(
                          onPressed: () {
                            box.write('IsUserHaveChangedTheLanguage', true);
                            localizationController.directionRtl();
                            localizationController.hebLanguage();
                          },
                          child: Text(
                            'עברית',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: const Color(0xff606060),
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Text(
                            'English',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: const Color(0xffdec3c3),
                            ),
                          ),
                          onPressed: () {
                            box.write('IsUserHaveChangedTheLanguage', true);
                            localizationController.engLanguage();
                            localizationController.dirctionLtr();
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: SvgPicture.asset(
                        'assets/images/Logo.svg',
                        height: MediaQuery.of(context).size.height * 0.12,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: Get.width * 0.9,
                      child: CustomTextFiled(
                        //EMAIL  PLACEMENT
                        hintText: TKeys.Email_Address.translate(context),

                        obsecureText: false,

                        textController: emailController,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.9,
                      child: CustomTextFiled(
                        ///PASSWORD PLACEMENT
                        hintText: TKeys.Password_text.translate(context),
                        obsecureText: true,
                        textController: passwordController,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 40,
                      //LOGIN BACKGROUND
                      width: Get.width * 0.7,
                      decoration: BoxDecoration(
                        color: const Color(0xff00c2cb),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextButton(
                        onPressed: () {
                          //Email validateor function

                          final bool isValid = EmailValidator.validate(
                              emailController.text.trim());
                          if (isValid && passwordController.text.isNotEmpty) {
                            ref.read(authProvider.notifier).login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );

                            userProvider
                                .userLogin(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            )
                                .then(
                              (value) {
                                Logger.e(
                                    '${userProvider.authToken} =======================================|');
                                box.write(
                                    'userTokenForAuth', userProvider.authToken);
                              },
                            );
                          } else if (emailController.text.isEmpty) {
                            showflushbar(
                              context,
                              TKeys.email_require.translate(context),
                            );
                          } else if (passwordController.text.isEmpty) {
                            showflushbar(
                              context,
                              TKeys.password_is_require.translate(context),
                            );
                          } else {
                            showflushbar(
                              context,
                              TKeys.invalid_email.translate(context),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //LOGIN TEXT
                              TKeys.Login_text.translate(context),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        TKeys.Forgot_Password.translate(context),
                        style: const TextStyle(
                          //FORGOT PASSWORD not on this page
                          color: Color(0xffdec3c3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      child: Container(
                        //margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 40,
                        width: Get.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              spreadRadius: 0,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondScreen(),
                              ),
                            );
                          },
                          child: Text(
                            TKeys.Create_New_Account.translate(context),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              //CREATE NEW ACCOUNT
                              color: const Color(0xffdec3c3),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getUserInfo(BuildContext context, UserInfo? userInfo) async {
    var box = GetStorage();

    Uri uri = Uri.tryParse(ApiNetwork.getUserInfo)!;
    WidgetProvider widgetProvider = provider.Provider.of<WidgetProvider>(
      context,
      listen: false,
    );
    await widgetProvider
        .returnConnection()
        .get(
          uri,
          headers: Constants.authenticatedHeaders(
              context: context, userToken: box.read('userTokenForAuth')),
        )
        .catchError((e) {
      debugPrint(e);
    }).then((value) {
      var response = json.decode(value.body);
      if (response['errors'] != null && response['errors'].isNotEmpty) {
        BotToast.showText(
          text: '${response['errors'][0]['message']}',
          contentColor: Color(0xffdec3c3),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
      } else {
        userInfo = UserInfo.fromMap(response['payload']);
        // changeUserInfo(userInfo: UserInfo.fromMap(response['payload']));
      }
    });
  }

//ERROR ALERTS
//Flushbar widget
  void showflushbar(BuildContext context, String title) {
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
      backgroundColor: const Color(0xffdec3c3),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1300),
    ).show(context);
  }

  void wrongShowflushbar(BuildContext context) {
    Flushbar(
      isDismissible: true,
      messageSize: 16,
      messageText: const Text(
        'Wrong email or password',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: const Color(0xffdec3c3),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1300),
    ).show(context);
  }
}
