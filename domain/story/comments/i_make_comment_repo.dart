import 'package:clean_api/clean_api.dart';
import 'package:Taillz/domain/story/comments/make_comment.dart';

abstract class IMakeCommentRepo {
  Future<Either<CleanFailure, Unit>> makeComment(MakeCommentModel comment);
  Future<Either<CleanFailure, Unit>> replayOnComment(MakeCommentModel comment);
}
