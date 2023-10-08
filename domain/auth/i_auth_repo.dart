// import 'package:clean_api/clean_api.dart';
import 'package:http/http:dart' as http;
import 'package:fpdart/fpdart.dart';

import 'package:Taillz/domain/auth/models/recovery.dart';
import 'package:Taillz/domain/auth/models/colors.dart';
import 'package:Taillz/domain/auth/models/countries.dart';
import 'package:Taillz/domain/auth/models/language.dart';
import 'package:Taillz/domain/auth/models/registration.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';

abstract class IAuthRepo {
  Future<Either<FormatException, UserInfo>> login({
    required String email,
    required String password,
  });

  Future<Either<FormatException, UserInfo>> tryLogin();

  Future<Either<FormatException, UserInfo>> getUserInfo();
  Future<Either<FormatException, Unit>> registration(Registration registration);
  Future<void> logOut();
  Future<Either<FormatException, bool>> nickNameCheck(String nickname);
  Future<Either<FormatException, Unit>> passwordRecovary(Recovery recovery);
  Future<Either<FormatException, bool>> emailCheck(String email);
  Future<Either<FormatException, List<Countries>>> getCountries();
  Future<Either<FormatException, List<Language>>> getLanguages();
  Future<Either<FormatException, List<ColorsModel>>> getColors();
}
