// import 'package:clean_api/clean_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conver;
import 'package:fpdart/fpdart.dart';

import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Taillz/domain/auth/i_auth_repo.dart';
import 'package:Taillz/domain/auth/models/colors.dart';
import 'package:Taillz/domain/auth/models/countries.dart';
import 'package:Taillz/domain/auth/models/language.dart';
import 'package:Taillz/domain/auth/models/recovery.dart';
import 'package:Taillz/domain/auth/models/registration.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';

import '../../main.dart';

class AuthRepo extends IAuthRepo {
  // final cleanApi = CleanApi.instance;
  @override
  Future<Either<FormatException, UserInfo>> login({
    required String email,
    required String password,
  }) async {
    // final response = await cleanApi.post(
    //   showLogs: true,
    //   fromData: (json) {
    //     try {
    //       return json['payload'] as String;
    //     } catch (e) {
    //       if ((json['errors'] as List).isNotEmpty) {
    //         final error = (json['errors'] as List).first;
    //         throw error['message'];
    //       } else {
    //         rethrow;
    //       }
    //     }
    //   },
    //   body: {'Email': email, 'Password': password},
    //   endPoint: 'clients/login',
    // );

    var request = http.Request('POST', Uri.parse(baseUrl + '/clients/login'));
    // Set the request body
    request.body = '{"Email": $email, "Password": $password}';

    var response = await BaseClient.send(request);
    
    if (response.status == 200) {
      var responseBody = await response.stream.bytesToString();
    } else {
      left('failure');
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', jsonResponse);
    request.headers.addAll({ 'Authorization': 'Bearer $responseBody' });

    return await getUserInfo();
    // return await response.fold((l) => left(l), (r) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', r);
    //   request.headers.addAll({'Authorization': 'Bearer $r'});
    //   return await getUserInfo();
    // });
  }

  @override
  Future<Either<FormatException, UserInfo>> getUserInfo() async {
    return await cleanApi.get(
      showLogs: true,
      fromData: ((json) => UserInfo.fromMap(json['payload'])),
      endPoint: 'clients/info',
    );
  }

  @override
  Future<Either<FormatException, Unit>> registration(
      Registration registration) async {
    return await cleanApi.post(
        fromData: (json) {
          // final error = json['errors'];
          // final payload = json['payload'];
          // Logger().i(json);

          return unit;
        },
        body: registration.toMap(),
        endPoint: 'clients');
  }

  @override
  Future<void> logOut() async {
    cleanApi.setHeader({'Authorization': ''});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
  }

  @override
  Future<Either<FormatException, bool>> nickNameCheck(String nickname) async {
    return await cleanApi.get(
        fromData: (json) => !(json['success'] ?? true),
        endPoint:
            'clients/hiddenSearchByNick/${Uri.encodeComponent(nickname)}');
  }

  @override
  Future<Either<FormatException, Unit>> passwordRecovary(Recovery recovery) async {
    return await cleanApi.post(
        showLogs: true,
        fromData: (json) {
          if ((json['errors'] as List).isNotEmpty) {
            final error = (json['errors'] as List).first;
            throw error['message'];
          } else {
            return unit;
          }
        },
        body: recovery.toMap(),
        endPoint: 'clients/Recovery');
  }

  @override
  Future<Either<FormatException, bool>> emailCheck(String email) async {
    final bool isValid = EmailValidator.validate(email.trim());
    if (isValid) {
      return await cleanApi.get(
          fromData: (json) {
            return !(json['success'] ?? true);
          },
          endPoint:
              'clients/hiddenSearchByEmail/${Uri.encodeComponent(email)}');
    } else {
      return right(isValid);
    }
  }

  @override
  Future<Either<FormatException, List<Countries>>> getCountries() async {
    return await cleanApi.get(
        fromData: (json) => List<Countries>.from(
            json['payload'].map((e) => Countries.fromMap(e))),
        endPoint: 'lists/countries');
  }

  @override
  Future<Either<FormatException, List<Language>>> getLanguages() async {
    return await cleanApi.get(
      fromData: (json) =>
          List<Language>.from(json['payload'].map((e) => Language.fromMap(e))),
      endPoint: 'lists/languages',
    );
  }

  @override
  Future<Either<FormatException, List<ColorsModel>>> getColors() async {
    return await cleanApi.get(
        showLogs: true,
        // withToken: false,
        fromData: (json) => List<ColorsModel>.from(
            json['payload'].map((e) => ColorsModel.fromMap(e))),
        endPoint: 'lists/colors');
  }

  @override
  Future<Either<FormatException, UserInfo>> tryLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final r = prefs.getString(
        'token',
      );

      cleanApi.setHeader({'Authorization': 'Bearer $r'});
      return await getUserInfo();
    } catch (e) {
      return left(
        FormatException(
          // tag: 'Initial login check',
          error: e.toString(),
        ),
      );
    }
  }
}
