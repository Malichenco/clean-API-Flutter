// ignore_for_file: empty_catches

import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Taillz/application/auth/auth_state.dart';
import 'package:Taillz/domain/auth/i_auth_repo.dart';
import 'package:Taillz/domain/auth/models/recovery.dart';
import 'package:Taillz/domain/auth/models/registration.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/infrastructure/auth/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../session/session_repo.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthRepo());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepo authRepo;
  AuthNotifier(this.authRepo)
      : super(AuthState(
            userInfo: UserInfo.empty(),
            loading: false,
            // failure: CleanFailure.none(),
            failure: null,
            valueChecking: false,
            languageList: const [],
            countryList: const [],
            colorsList: const [],
            validEmail: false,
            validName: false));

  login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loading: true, failure: null);
    final data = await authRepo.login(
      email: email,
      password: password,
    );

    state = data.fold(
      (l) => state.copyWith(failure: l, loading: false),
      (r) => state.copyWith(
        loading: false,
        userInfo: r,
        // failure: CleanFailure.none(),
        failure: null,
      ),
    );

  }

  tryLogin() async {
    state = state.copyWith(
      loading: true,
    );
    const data = null;

    try{
      state = data.fold(
              (l) => state.copyWith(loading: false),
              (r) {
            CreateSession(r.toMap());
            return state.copyWith(
              loading: false,
              userInfo: r,
              failure: null,
            );
          }
      );
    }catch(error){

    }
  }

  createRegistration(Registration registration) async {
    state = state.copyWith(loading: true, failure: null);
    final data = await authRepo.registration(registration);

    state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false));
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_info', state.userInfo.name);
    state = state.copyWith(userInfo: UserInfo.empty());
    await prefs.setString('current_user_info', state.userInfo.name);

    await authRepo.logOut();
  }

  passWordRecovery(Recovery recovery) async {
    state = state.copyWith(loading: true, failure: null);
    final data = await authRepo.passwordRecovary(recovery);
    state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false));
  }

  checkNickName(String nickName) async {
    state = state.copyWith(valueChecking: true);
    final data = await authRepo.nickNameCheck(nickName);
    state = data.fold((l) => state.copyWith(failure: l),
        (r) => state.copyWith(validName: r).copyWith(valueChecking: false));
  }

  checkEmail(String email) async {
    state = state.copyWith(valueChecking: true, failure: null);
    final data = await authRepo.emailCheck(email);
    state = data.fold((l) => state.copyWith(failure: l),
        (r) => state.copyWith(validEmail: r).copyWith(valueChecking: false));
  }

  getCountries() async {
    // state = state.copyWith(loading: true);
    final data = await authRepo.getCountries();
    state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false, countryList: r));
  }

  getLanguage() async {
    // state = state.copyWith(loading: true);
    final data = await authRepo.getLanguages();
    state = data.fold((l) => state.copyWith(failure: l, loading: false),
        (r) => state.copyWith(loading: false, languageList: r));
  }

  getColors() async {
    // state = state.copyWith(loading: true);
    final data = await authRepo.getColors();
    state = data.fold((l) => state.copyWith(loading: false, failure: l), (r) {
      r.shuffle();
      return state.copyWith(loading: false, colorsList: r);
    });
  }
}
