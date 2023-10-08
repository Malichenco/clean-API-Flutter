import 'package:clean_api/clean_api.dart';
import 'package:Taillz/domain/auth/models/recovery.dart';
import 'package:Taillz/domain/auth/models/colors.dart';
import 'package:Taillz/domain/auth/models/countries.dart';
import 'package:Taillz/domain/auth/models/language.dart';
import 'package:Taillz/domain/auth/models/registration.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';

abstract class IPoleRepo {
  Future<Either<CleanFailure, List<Countries>>> getPoles();
}
