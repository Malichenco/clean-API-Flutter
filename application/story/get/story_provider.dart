import 'package:Taillz/screens/consult/consultProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Taillz/application/story/get/story_state.dart';
import 'package:Taillz/domain/story/i_story_repo.dart';
import 'package:Taillz/infrastructure/story/story_repo.dart';
import 'package:provider/provider.dart';

final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier(StoryRepo());
});

class StoryNotifier extends StateNotifier<StoryState> {
  final IStoryRepo storyRepo;
  StoryNotifier(this.storyRepo) : super(StoryState.init());

  getStories() async {
    state = state.copyWith(loading: true);
    final data = await storyRepo.getStory();
    state = data.fold(
      (l) => state.copyWith(loading: false, failure: l),
      (r) => state.copyWith(
        loading: false,
        storyList: r,
      ),
    );
  }

  like(int id,BuildContext context,ConsultProvider consultProvider,String consultName) async {
    state = state.copyWith(loading: true);
    final data = await storyRepo.like(id);
    data.fold(
        (l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(
              loading: false,
            ));

    getStories();

    if(consultName.isNotEmpty){
      consultProvider.getStories(consultName, context);
    }
  }

  deleteComment(int id) async {
    state = state.copyWith(loading: true);
    final data = await storyRepo.deleteComment(id);
    data.fold(
      (l) => state.copyWith(loading: false, failure: l),
      (r) => state.copyWith(
        loading: false,
      ),
    );
  }

  viewStory(int id) async {
    state = state.copyWith(loading: true);
    final data = await storyRepo.viewStory(id);
    data.fold(
      (l) => state.copyWith(loading: false, failure: l),
      (r) => state.copyWith(loading: false),
    );
    getStories();
  }

  deleteStory(int storyId) async {
    state = state.copyWith(loading: true);
    final data = await storyRepo.deleteComment(storyId);
    data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false));
    getStories();
  }
}
