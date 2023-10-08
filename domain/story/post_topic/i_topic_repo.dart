import 'package:clean_api/clean_api.dart';
import 'package:Taillz/domain/story/post_topic/topic.dart';

abstract class ITopicRepo {
  Future<Either<CleanFailure, List<Topics>>> getTopics();
}
