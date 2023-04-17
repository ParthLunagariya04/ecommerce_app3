import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  // AsyncValue<void>.data(null) -- means no loading
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));
  final FakeAuthRepository authRepository;

  Future<void> signOut() async {
    //set state to loading
    //sign out (using auth repository)
    //if success, set state to data
    //if error, set state to error

    // try {
    //   state = const AsyncValue<void>.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e, st) {
    //   state = AsyncValue<void>.error(e, st);
    //   return false;
    // }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositortProvider);
  return AccountScreenController(authRepository: authRepository);
});
