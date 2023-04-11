// ignore_for_file: override_on_non_overriding_member

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// abstract class AuthRepository {
//   Stream<AppUser?> authStateChanges();
//   AppUser? get currentUser;
//   Future<void> signInWithEamailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
// }

// class FirebaseAuthRepository implements AuthRepository{
//   @override
//   Stream<AppUser?> authStateChanges() {
//     // TODO: implement authStateChanges
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> createUserWithEmailAndPassword(String email, String password) {
//     // TODO: implement createUserWithEmailAndPassword
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement currentUser
//   AppUser? get currentUser => throw UnimplementedError();

//   @override
//   Future<void> signInWithEamailAndPassword(String email, String password) {
//     // TODO: implement signInWithEamailAndPassword
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> signOut() {
//     // TODO: implement signOut
//     throw UnimplementedError();
//   }

// }

class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEamailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> signOut() async {
    // await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection Failed');
    _authState.value = null;
  }

  // we must call this method in our provider
  void dispose() => _authState.close();

  //common method that use in different places
  void _createNewUser(String email) {
    _authState.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }
}

final authRepositortProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authrRpository = ref.watch(authRepositortProvider);
  return authrRpository.authStateChanges();
});
