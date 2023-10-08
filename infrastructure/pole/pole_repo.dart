import 'package:clean_api/clean_api.dart';
import 'package:Taillz/domain/auth/models/countries.dart';
import '../../domain/pole/i_pole_repo.dart';

class PoleRepo extends IPoleRepo {
  final cleanApi = CleanApi.instance;



  @override
  Future<Either<CleanFailure, List<Countries>>> getPoles() async {
    return await cleanApi.get(
        fromData: (json) => List<Countries>.from(
            json['payload'].map((e) => Countries.fromMap(e))),
        endPoint: 'QuestionPoll/GetQuestionPollID');
  }
}
