@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  group('submit', () {
    test('''Given formType is signIn
      When signInWithEmailAndPassword succeeds
      Then return true
      And state is AsyncData''', () async {
      //setup
      final authRepository = MockAuthRepository();
      when(
        () =>
            authRepository.signInWithEamailAndPassword(testEmail, testPassword),
      ).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);
      //expact later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        ]),
      );
      //run
      final result = await controller.submit(testEmail, testPassword);
      //verify
      expect(result, true);
    });

    test('''Given formType is signIn
      When signInWithEmailAndPassword fails
      Then return false
      And state is AsyncData''', () async {
      //setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed');
      when(
        () =>
            authRepository.signInWithEamailAndPassword(testEmail, testPassword),
      ).thenThrow(exception);
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);
      //expact later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.signIn);
            expect(state.value.hasError, true);
            return true;
          })
        ]),
      );
      //run
      final result = await controller.submit(testEmail, testPassword);
      //verify
      expect(result, false);
    });
  });

  group('updateFormType', () {
    test('''Given formType is register
      When createUserWithEmailAndPassword succeeds
      Then return true
      And state is AsyncData''', () async {
      //setup
      final authRepository = MockAuthRepository();
      when(
        () => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword),
      ).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);
      //expact later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading<void>(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        ]),
      );
      //run
      final result = await controller.submit(testEmail, testPassword);
      //verify
      expect(result, true);
    });

    test('''Given formType is register
      When createUserWithEmailAndPassword fails
      Then return false
      And state is AsyncData''', () async {
      //setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed');
      when(
        () => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword),
      ).thenThrow(exception);
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);
      //expact later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading<void>(),
          ),
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.register);
            expect(state.value.hasError, true);
            return true;
          })
        ]),
      );
      //run
      final result = await controller.submit(testEmail, testPassword);
      //verify
      expect(result, false);
    });
  });
}
