import 'package:Taillz/application/pole/pole_state.dart';
import 'package:Taillz/infrastructure/pole/pole_repo.dart';
import 'package:clean_api/clean_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Taillz/domain/auth/models/user_info.dart';

final poleProvider = StateNotifierProvider<PoleNotifier, PoleState>((ref) {
  return PoleNotifier(PoleRepo());
});

class PoleNotifier extends StateNotifier<PoleState> {
  final PoleRepo poleRepo;
  PoleNotifier(this.poleRepo)
      : super(PoleState(
            userInfo: UserInfo.empty(),
            loading: false,
            failure: CleanFailure.none(),
            valueChecking: false,
            languageList: const [],
            countryList: const [],
            colorsList: const [],
            validEmail: false,
            validName: false));

  getPoles() async {
    state = state.copyWith(loading: true);
    final data = await poleRepo.getPoles();
    state = data.fold((l) => state.copyWith(loading: false, failure: l),
        (r) => state.copyWith(loading: false, countryList: r));
  }


}
