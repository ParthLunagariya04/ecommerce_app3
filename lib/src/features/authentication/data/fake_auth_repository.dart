// ignore_for_file: override_on_non_overriding_member

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/domain/fake_app_user.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
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
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);
  final List<FakeAppUser> _users = [];

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEamailAndPassword(String email, String password) async {
    await delay(addDelay);
    for (final u in _users) {
      // matching email and password
      if (u.email == email && u.password == password) {
        _authState.value = u;
        return;
      }
      // same email, wrong password
      if (u.email == email && u.password != password) {
        throw Exception('Wrong password'.hardcoded);
      }
    }
    throw Exception('User not found'.hardcoded);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw Exception('Email already in use'.hardcoded);
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw Exception('Password is too weak'.hardcoded);
    }
    // create new user
    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    // await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection Failed');
    _authState.value = null;
  }

  // we must call this method in our provider
  void dispose() => _authState.close();

  //common method that use in different places
  void _createNewUser(String email, String password) {
    // create new user
    final user = FakeAppUser(
      uid: email.split('').reversed.join(),
      email: email,
      password: password,
    );
    // register it
    _users.add(user);
    // update the auth state
    _authState.value = user;
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authrRpository = ref.watch(authRepositoryProvider);
  return authrRpository.authStateChanges();
});
