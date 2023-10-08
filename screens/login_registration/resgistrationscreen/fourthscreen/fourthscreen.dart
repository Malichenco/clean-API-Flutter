import 'package:another_flushbar/flushbar.dart';
import 'package:clean_api/clean_api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../Localization/t_keys.dart';
import '../../../../application/auth/auth_provider.dart';
import '../../../../application/auth/auth_state.dart';
import '../../../../domain/auth/models/registration.dart';
import '../../../../providers/user_provider.dart';
import '../../../enddrawer/privacy_policy/privacy_policy_screen.dart';
import '../../../enddrawer/terms_of_use/terms_of_use_screen.dart';
import '../../components/custom_next_button.dart';
import '../../login_screen.dart';
import '../thirdscreen/components/customtextformfiled.dart';
import '../thirdscreen/initiate_debounce.dart';
import 'package:provider/provider.dart' as provider;

class FourthScreen extends HookConsumerWidget {
  final int color;
  final String nickName;
  final String gender;
  final int yearOfBirth;
  final dynamic countryId;
  final dynamic languageId;

  FourthScreen(
      {Key? key,
      required this.color,
      required this.nickName,
      required this.gender,
      required this.yearOfBirth,
      required this.countryId,
      required this.languageId})
      : super(key: key);

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Client Validation',
        style: TextStyle(color: Colors.purple),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('You must accept Privacy and Terms'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  bool showLoader = false;

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(authProvider);
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    final TextEditingController emailcontroller = useTextEditingController();

    final TextEditingController passwordcontroller = useTextEditingController();

    final enteredEmail = useState(false);
    final checkValue = useState(false);
    final lastCheckedValue = useState('');

    ref.listen<AuthState>(authProvider, ((previous, next) {
      if (previous != next) {
        if (next.failure != CleanFailure.none() &&
            next.failure != previous?.failure) {
          showflushbar(context, next.failure.error);
          // Navigator.pop(context);
        }
        if (!next.loading &&
            next.failure == previous?.failure &&
            next.loading != previous?.loading) {
          //showflushbar(context, "Please wait for Confirmation");
          // if(checkValue.value){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen(
                        demo: 'created',
                      )),
              (_) => false);
          // }else{
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) => _buildPopupDialog(context),
          //   );
          // }
        }
      }
    }));

    initiateDebouce(
        controller: emailcontroller,
        task: (value) {
          if (value.isNotEmpty && value != lastCheckedValue.value) {
            if (EmailValidator.validate(value)) {
              enteredEmail.value = true;
              lastCheckedValue.value = value;
              ref.read(authProvider.notifier).checkEmail(value);
            }
          }
        });

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 15),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 15),
                          child: CustomNextButton(
                            text: TKeys.finish_button.translate(context),
                            onPressed: () {
                              //Email validateor function
                              if (state.validEmail) {
                                final bool isValid = EmailValidator.validate(
                                    emailcontroller.text.trim());
                                if (passwordcontroller.text.length > 7) {
                                  if (isValid &&
                                      passwordcontroller.text.isNotEmpty) {
                                    if (validateStructure(
                                        passwordcontroller.text)) {
                                      setState(() {
                                        showLoader = true;
                                      });
                                      final Registration registration =
                                          Registration(
                                        email: emailcontroller.text.trim(),
                                        password: passwordcontroller.text,
                                        termsAndConditions: true,
                                        application: 0,
                                        ItemColorID: color,
                                        isTrySignup: true,
                                        nickName: nickName,
                                        yearOfBirth: yearOfBirth,
                                        CountryId: countryId,
                                        LanguageId: languageId,
                                        gender: int.parse(gender),
                                      );
                                      userProvider
                                          .userSignup(
                                        registration: registration,
                                        context: context,
                                      )
                                          .then(
                                        (value) {
                                          setState(() {
                                            showLoader = false;
                                          });
                                        },
                                      );
                                    } else {
                                      showflushbar(
                                          context,
                                          TKeys.password_validation
                                              .translate(context));
                                    }
                                  } else if (emailcontroller.text.isEmpty) {
                                    showflushbar(context,
                                        TKeys.email_require.translate(context));
                                  } else if (emailcontroller.text.isEmpty) {
                                    showflushbar(context,
                                        TKeys.email_require.translate(context));
                                  } else if (passwordcontroller.text.isEmpty) {
                                    showflushbar(
                                        context,
                                        TKeys.password_is_require
                                            .translate(context));
                                  } else if (passwordcontroller.text.length <
                                      8) {
                                    showflushbar(
                                        context,
                                        TKeys.password_validation
                                            .translate(context));
                                  } else {
                                    showflushbar(context,
                                        TKeys.invalid_email.translate(context));
                                  }
                                } else if (passwordcontroller.text.isEmpty) {
                                  showflushbar(
                                      context,
                                      TKeys.password_is_require
                                          .translate(context));
                                } else {
                                  showflushbar(
                                      context,
                                      TKeys.password_validation
                                          .translate(context));
                                }
                              } else if (emailcontroller.text.isEmpty) {
                                showflushbar(context,
                                    TKeys.email_require.translate(context));
                              } else if (passwordcontroller.text.isEmpty) {
                                showflushbar(
                                    context,
                                    TKeys.password_is_require
                                        .translate(context));
                              } else if (!state.validEmail &&
                                  passwordcontroller.text.length < 8) {
                                showflushbar(
                                    context,
                                    TKeys.password_validation
                                        .translate(context));
                              } else if (!state.validEmail &&
                                  passwordcontroller.text.length > 7) {
                                showflushbar(
                                    context,
                                    TKeys.email_taken_error_message
                                        .translate(context));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      TKeys.Login_information.translate(context),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color(0xff121556),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormFiled(
                      hintText: TKeys.Email_text.translate(context),
                      prefixicon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      suffixicon: enteredEmail.value
                          ? state.valueChecking
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    color: Colors.teal,
                                    strokeWidth: 2,
                                  ),
                                )
                              : state.validEmail
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    )
                          : const SizedBox(),
                      obsecure: false,
                      controller: emailcontroller,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormFiled(
                      controller: passwordcontroller,
                      hintText: TKeys.choose_pass.translate(context),
                      prefixicon: Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      obsecure: true,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, top: 10, right: 35),
                      child: Text(
                        TKeys.uniquepassword.translate(context),
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, top: 10, right: 35),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text.rich(TextSpan(
                            text: TKeys.SignUpLine1.translate(context),
                            style: TextStyle(fontSize: 14),
                            children: <InlineSpan>[
                              TextSpan(
                                text: TKeys.SignUpLine2.translate(context),
                                style: TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: ' & ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: TKeys.SignUpLine3.translate(context),
                                style: TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsOfUseScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ])),
                      ),
                      // CheckboxListTile(
                      //   title:
                      //
                      //   value: checkValue.value,
                      //   onChanged: (newValue) {
                      //     checkValue.value=newValue!;
                      //     // setState(() {
                      //     //   checkedValue = newValue;
                      //     // });
                      //   },
                      //   controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      // )
                    ),
                  ],
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
            );
          }),
        ),
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

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
      backgroundColor: const Color(0xff121556),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1000),
    ).show(context);
  }
}
