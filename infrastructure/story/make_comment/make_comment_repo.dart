import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:clean_api/clean_api.dart';
import 'package:Taillz/domain/story/comments/i_make_comment_repo.dart';
import 'package:Taillz/domain/story/comments/make_comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakeCommentRepo extends IMakeCommentRepo {
  @override
  Future<Either<CleanFailure, Unit>> makeComment(
    MakeCommentModel comment,
  ) async {
    final cleanApi = CleanApi.instance;
    final prefs = await SharedPreferences.getInstance();
    cleanApi.setHeader({'Authorization': 'Bearer ${prefs.getString("token")}'});
    return await cleanApi.post(
      fromData: (json) => unit,
      body: comment.toMap(),
      endPoint: 'comments',
    );
  }

  @override
  Future<Either<CleanFailure, Unit>> replayOnComment(MakeCommentModel comment) async {
    UserInfo user = await getSession();
    final cleanApi = CleanApi.instance;
    final prefs = await SharedPreferences.getInstance();
    cleanApi.setHeader({'Authorization': 'Bearer ${prefs.getString("token")}'});
    return await cleanApi.post(
      fromData: (json) => unit,
      /*body: {
        "publishDate": DateTime.now().toUtc().toString(),
        "body": comment.body,
        "commentId": comment.storyId,
        "storyId": comment.storyId,
        "userId": user.id
      }*/
      body: comment.toMap(),
      endPoint: 'RepliedComments',
    );
  }
}
