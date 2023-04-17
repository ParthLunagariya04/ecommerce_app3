import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@gmail.com';
  const testPassword = '1234';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('surrent user is not null after sign in', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEamailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('current user is not null after registration', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after sign out', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEamailAndPassword(testEmail, testPassword);
      // expect(
      //     authRepository.authStateChanges(),
      //     emitsInOrder([
      //       testUser, //after signin
      //       null, //after sign out
      //     ]));
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('signIn after dispose throws exception', () async {
      final authRepository = makeAuthRepository();
      authRepository.dispose();
      expect(
        () =>
            authRepository.signInWithEamailAndPassword(testEmail, testPassword),
        throwsStateError,
      );
    });
  });
}
