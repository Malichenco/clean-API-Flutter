import 'dart:io';
import 'package:clean_api/clean_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../Localization/localization_service.dart';
import '../../Localization/t_keys.dart';
import '../../application/auth/auth_provider.dart';
import '../enddrawer/privacy_policy/privacy_policy_screen.dart';
import '../enddrawer/terms_of_use/terms_of_use_screen.dart';
import 'forgot_password.dart';
import 'login_screen.dart';
import 'resgistrationscreen/sceondscreen/secondscreen.dart';

//ignore: must_be_immutable
class LoginPromptScreen extends HookConsumerWidget {
  LoginPromptScreen({this.demo, Key? key}) : super(key: key);

  String? demo;

  final localizationController = Get.find<LocalizationController>();
  final box = GetStorage();
  ConnectivityResult? connection;

  @override
  Widget build(BuildContext context, ref) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 1), () async {
        ref.read(authProvider.notifier).getColors();
        ref.read(authProvider.notifier).getCountries();
        ref.read(authProvider.notifier).getLanguage();

        Logger.e(connection);
        box.write('lang', 'en');
        localizationController.engLanguage();
        localizationController.dirctionLtr();

        //String locale = await Devicelocale.currentLocale ?? 'en';

        // String locale = Localizations.localeOf(context).languageCode;
        String locale = Platform.localeName.split('_')[0];


        //Languages Interface Selection
        debugPrint(locale);
        if (box.read('IsUserHaveChangedTheLanguage') == true ||
            box.read('IsUserHaveChangedTheLanguage') == null) {
          if (locale.startsWith('en')) {
            box.write('lang', 'en');
            localizationController.engLanguage();
            localizationController.dirctionLtr();
          } else if (locale.startsWith('he')) {
            Logger.w(locale.startsWith('he'));
            box.write('lang', 'he');
            localizationController.directionRtl();
            localizationController.hebLanguage();
          } else if (locale.startsWith('ar')) {
            box.write('lang', 'ar');
            localizationController.directionRtl();
            localizationController.arLanguage();
          } else if (locale.startsWith('ru')) {
            box.write('lang', 'ru');
            localizationController.ruLanguage();
            localizationController.dirctionLtr();
          } else if (locale.startsWith('es')) {
            box.write('lang', 'es');
            localizationController.spLanguage();
            localizationController.dirctionLtr();
          } else {
            box.write('lang', 'en');
            localizationController.engLanguage();
            localizationController.dirctionLtr();
          }
        } else {
          box.write('lang', 'en');
          localizationController.engLanguage();
          localizationController.dirctionLtr();
        }
      });
      return null;
    }, []);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        child: Container(
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          decoration: localizationController.currentLanguage == 'he'
                              ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black, width: 1))
                              : null,
                          child: TextButton(
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
                                fontWeight:
                                localizationController.currentLanguage == 'he'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Container(
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          decoration: localizationController.currentLanguage == 'en'
                              ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black, width: 1))
                              : null,
                          child: TextButton(
                            child: Text(
                              'English',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: const Color(0xff606060),
                                fontWeight:
                                localizationController.currentLanguage == 'en'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onPressed: () {
                              box.write('IsUserHaveChangedTheLanguage', true);
                              localizationController.engLanguage();
                              localizationController.dirctionLtr();
                            },
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Container(
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          decoration: localizationController.currentLanguage == 'es'
                              ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black, width: 1))
                              : null,
                          child: TextButton(
                            child: Text(
                              'español',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: const Color(0xff606060),
                                fontWeight:
                                localizationController.currentLanguage == 'es'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onPressed: () {
                              box.write('IsUserHaveChangedTheLanguage', true);
                              localizationController.spLanguage();
                              localizationController.dirctionLtr();
                            },
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Container(
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          decoration: localizationController.currentLanguage == 'ru'
                              ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black, width: 1))
                              : null,
                          child: TextButton(
                            child: Text(
                              'Русский',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: const Color(0xff606060),
                                fontWeight:
                                localizationController.currentLanguage == 'ru'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onPressed: () {
                              box.write('IsUserHaveChangedTheLanguage', true);
                              localizationController.ruLanguage();
                              localizationController.dirctionLtr();
                            },
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Container(
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          decoration: localizationController.currentLanguage == 'ar'
                              ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black, width: 1))
                              : null,
                          child: TextButton(
                            child: Text(
                              'عربي',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: const Color(0xff606060),
                                fontWeight:
                                localizationController.currentLanguage == 'ar'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onPressed: () {
                              box.write('IsUserHaveChangedTheLanguage', true);
                              localizationController.arLanguage();
                              localizationController.directionRtl();
                            },
                          ),
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 320,
              child: Stack(
                fit: StackFit.loose,

                //LOGO_LANDING_PAGE

                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/images/LogoLandingPageHomeIcon.svg',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => LoginScreen(demo: demo),
                  ),
                );
              },
              //LOGIN BUTTON
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                decoration: const ShapeDecoration(
                    shape: StadiumBorder(), color: Color(0xffdec3c3)),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    //Icon(Icons.person,color: Colors.white,),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(

                      //Login Button
                        child: Text(
                          TKeys.login_with_username.translate(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000)),
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Stack(
                children: [
                  const Divider(
                    color: Color(0xffdec3c3),
                    height: 20,
                    thickness: 1,
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      color: Colors.white,
                      alignment: AlignmentDirectional.center,
                      child: const Text(
                        ///OR//
                        'or',
                        style: TextStyle(
                            color: Color(0xffdec3c3),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(),
                  ),
                );
              },
              child: Container(
                height: 48,
                margin: EdgeInsets.symmetric(horizontal: 50),
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Color(0xffdec3c3), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Color(0xff000000),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      //CREATE NEW ACOCUNT
                      child: Text(
                        TKeys.create_account_with_email.translate(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              //FORGOT PASSWORD STRING POSITION width value
              width: 250,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
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
                      color: Color(0xff000000),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            //PRIVACY AND TERMS SECTION
            const SizedBox(height: 34),
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
                      //Terms Of Use Link
                      text: 'Terms of Use',
                      style: const TextStyle(color: Color(0xff000000)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfUseScreen(),
                          ),
                        ),
                    ),
                    const TextSpan(text: ' / '),
                    //Privacy Policy Link
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(color: Color(0xff000000)),
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
}
