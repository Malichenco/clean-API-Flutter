import 'dart:convert';

import 'package:Taillz/Dios/api_dio.dart';
import 'package:Taillz/session/session_repo.dart';
import 'package:Taillz/utills/prefs.dart';
import 'package:clean_api/clean_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Taillz/application/story/make_comment/make_comment_state.dart';
import 'package:Taillz/domain/story/comments/i_make_comment_repo.dart';
import 'package:Taillz/domain/story/comments/make_comment.dart';
import 'package:Taillz/infrastructure/story/make_comment/make_comment_repo.dart';

import '../../../domain/auth/models/user_info.dart';

final makeCommentProvider =
    StateNotifierProvider<MakeCommentNotifier, MakeCommentState>((ref) {
  return MakeCommentNotifier(MakeCommentRepo());
});

class MakeCommentNotifier extends StateNotifier<MakeCommentState> {
  final IMakeCommentRepo makeCommentRepo;
  MakeCommentNotifier(this.makeCommentRepo)
      : super(MakeCommentState(loading: false, failure: CleanFailure.none()));

  makeComment(MakeCommentModel makeCommentModel) async {
    state = state.copyWith(loading: true);
    final data = await makeCommentRepo.makeComment(makeCommentModel);
    state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false));
  }

  makeReplayComment(MakeCommentModel commentModel) async {
    // state = state.copyWith(loading: true);
    //String token = await getAuthToken();
    //UserInfo user = await getSession();
    //map['userId'] = user.id;
    final data = await makeCommentRepo.replayOnComment(commentModel);
    state = data.fold((l) => state.copyWith(loading: false, failure: l), (r) => state.copyWith(loading: false));
    //var data = await httpClientWithHeader(token).post(ApiNetwork.getRepliedComments, data: jsonEncode(map));
    //return data.data;
  }
  addLike(Map map) async {
    // state = state.copyWith(loading: true);
    String token= await getAuthToken();
    UserInfo user= await getSession();
    map['userId']=user.id;
    final data=await httpClientWithHeader(token).put("Comments/AddLikes",data: jsonEncode(map));
    // final data = await makeCommentRepo.replayOnComment(makeCommentModel);
   /* state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false));
  */}
}
