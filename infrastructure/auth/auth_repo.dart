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
    BaseRequest.url = Uri.parse(baseUrl + '/clients/login');
    // Set the request body
    BaseRequest.body = '{
      "Email": $email, 
      "Password": $password
    }';

    final response = await BaseClient.post(BaseRequest);
    if (response.status == 200) {
      var responseBody = await response.stream.bytesToString();
    } else {
      left('failure');
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', jsonResponse);
    BaseRequest.headers.addAll({ 
      'Authorization': 'Bearer $responseBody' 
    });
    BaseClient.close();

    return await getUserInfo();
  }

  @override
  Future<Either<FormatException, UserInfo>> getUserInfo() async {
    BaseRequest.url = Uri.parse(baseUrl + '/clients/info');
    final response = await BaseClient.get(BaseRequest);
    UserInfo.fromMap(response['payload']);
    
    return response;
  }

  @override
  Future<Either<FormatException, Unit>> registration(
      Registration registration) async {
    // return await cleanApi.post(
    //     fromData: (json) {
    //       // final error = json['errors'];
    //       // final payload = json['payload'];
    //       // Logger().i(json);

    //       return unit;
    //     },
    //     body: registration.toMap(),
    //     endPoint: 'clients');
    return await BaseClient.post(
      Uri.https('${baseUrl}/clients'),
      body: registration.toMap()
    ); 
  }

  @override
  Future<void> logOut() async {
    BaseRequest.headers.addAll({'Authorization': ''});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
  }

  @override
  Future<Either<FormatException, bool>> nickNameCheck(String nickname) async {
    BaseRequest.url = Uri.parse('${baseUrl}/clients/hiddenSearchByNick/${Uri.encodeComponent(nickname)}');
    var response = await BaseClient.get(BaseRequest);
    var responseBody = await response.stream.bytesToString();
    BaseClient.close();

    return !(responseBody['success'] ?? true);
  }

  @override
  Future<Either<FormatException, Unit>> passwordRecovary(Recovery recovery) async {
    BaseRequest.url = Uri.parse('${baseUrl}/clients/Recovery');
    BaseRequest.body = recovery.toMap();
    var response = await BaseClient.post(BaseRequest);
    BaseClient.close();

    return response;
  }

  @override
  Future<Either<FormatException, bool>> emailCheck(String email) async {
    final bool isValid = EmailValidator.validate(email.trim());
    if (isValid) {
      var url = Uri.parse(
        '${baseUrl}/clients/hiddenSearchByEmail/${Uri.encodeComponent(email)}'
      );
      var headers = {'Content-type': 'application/json'};

      return await http.get(url, headers: headers);
    } else {
      return right(isValid);
    }
  }

  @override
  Future<Either<FormatException, List<Countries>>> getCountries() async {
    var url = Uri.https(baseUrl, 'lists/countries');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<Countries>.from(response['payload'].map((e) => Countries.fromMap(e)));
    }
    return response;
  }

  @override
  Future<Either<FormatException, List<Language>>> getLanguages() async {
    BaseRequest.url = Uri.parse('${baseUrl}/lists/languages');
    final response = await BaseClient.get(BaseRequest);
    List<Language>.from(response['payload'].map((e) => Language.fromMap(e)));
    BaseClient.close();
    
    return response;
  }

  @override
  Future<Either<FormatException, List<ColorsModel>>> getColors() async {
    final response = http.get(baseUrl, 'lists/colors');
    List<ColorsModel>.from(response['payload'].map((e) => ColorsModel.fromMap(e)));
    return response;
  }

  @override
  Future<Either<FormatException, UserInfo>> tryLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final r = prefs.getString(
        'token',
      );
      BaseRequest.headers.addAll({'Authorization': 'Bearer $r'});
      return await getUserInfo();
    } catch (e) {
      return left(
        FormatException(
          // tag: 'Initial login check',
          error: e.toString(),
        )
      );
    }
  }
}
