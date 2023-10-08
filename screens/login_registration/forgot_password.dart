import 'package:another_flushbar/flushbar.dart';
import 'package:clean_api/clean_api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/auth/auth_provider.dart';
import 'package:Taillz/application/auth/auth_state.dart';
import 'package:Taillz/domain/auth/models/recovery.dart';
import 'package:Taillz/widgets/custom_flushbar.dart';

import '../../providers/user_provider.dart';

class ForgotPassword extends HookConsumerWidget {
  ForgotPassword({Key? key}) : super(key: key);

  bool showLoader = false;

  @override
  Widget build(BuildContext context, ref) {
    bool showTimer = false;
    final emailcontroller = useTextEditingController();
    final optTimerButtonController = OtpTimerButtonController();
    // ref.listen<AuthState>(authProvider, (previous, next) {
    //   if (previous != next) {
    //     Logger.i(next.failure.toString());
    //     if (next.loading == false && next.failure == CleanFailure.none()) {
    //       Logger.i(next.toString());
    //
    //       showFlushBar(
    //         context,
    //         TKeys.resetpassword.translate(context),
    //       );
    //     } else if (next.failure != CleanFailure.none()) {
    //       Logger.i(next.toString());
    //       // showFlushBar(context, next.failure.error);
    //       showTimer = false;
    //     }
    //     // Navigator.push(
    //     //     context, MaterialPageRoute(builder: (context) => FirstScreen()));
    //   }
    // });
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: StatefulBuilder(builder: (context, setState) {
        return Stack(
          children: [
            Column(
              children: [
                SvgPicture.asset('assets/images/PasswordRecoveryLock.svg'),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  TKeys.password_recovery.translate(context),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff2d2d6c),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: emailcontroller,
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
                SizedBox(
                  height: 30,
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
                      if (emailcontroller.text.isNotEmpty &&
                          emailcontroller.text.isEmail) {
                        setState(() {
                          showLoader = true;
                        });
                        await userProvider
                            .sendForgetPasswordOtp(
                          email: emailcontroller.text,
                          context: context,
                        )
                            .then((value) {
                          setState(() {
                            showLoader = false;
                          });
                        });
                      } else {
                        showFlushBar(
                            context, 'Please insert your Email Address');
                      }
                    },
                    child: Text(
                      TKeys.PasswordRecoverySend.translate(context),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                /* StatefulBuilder(builder: (context, setState) {
                  return Container(
                    child: GestureDetector(
                        onTap: () {
                          final bool isValid = EmailValidator.validate(
                              emailcontroller.text.trim());
                          if (isValid && emailcontroller.text.isNotEmpty) {
                            final Recovery email = Recovery(email: emailcontroller.text);

                            ref
                                .read(authProvider.notifier)
                                .passWordRecovery(email);
                            setState1(() {
                              showLoader = true;
                            });
                            Future.delayed(
                              Duration(seconds: 0),
                              () {
                                setState(() {
                                  showTimer = true;
                                });
                              },
                            );
                            Future.delayed(
                              Duration(milliseconds: 2000),
                              () {
                                emailcontroller.clear();
                              },
                            );

                            Future.delayed(
                              Duration(milliseconds: 2200),
                              () {
                                setState1(() {
                                  showLoader = false;
                                });
                              },
                            );

                            Future.delayed(
                              Duration(seconds: 125),
                              () {
                                setState(() {
                                  showTimer = false;
                                });
                              },
                            );
                          } else if (emailcontroller.text.isEmpty) {
                            if (showTimer == false) {
                              showFlushBar(
                                context,
                                TKeys.email_require.translate(context),
                              );
                            }
                          } else {
                            if (showTimer == false) {
                              showFlushBar(
                                context,
                                TKeys.invalid_email.translate(context),
                              );
                            }
                          }
                        },
                        child: showTimer
                            ? OtpTimerButton(
                                height: 60,
                                text: Text(
                                  TKeys.forget_password_timer
                                      .translate(context),
                                ),
                                duration: 120,
                                radius: 30,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                buttonType: ButtonType
                                    .text_button, // or ButtonType.outlined_button
                                loadingIndicator: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                                loadingIndicatorColor: Colors.red,
                                onPressed: () {},
                              )
                            : Image.asset(
                                'assets/images/pswrd.PNG',
                                height: 90,
                              )),
                    alignment: AlignmentDirectional.center,
                  );
                }),*/
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
    );
  }
}

class ResendButton extends StatefulWidget {
  const ResendButton({Key? key}) : super(key: key);

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
