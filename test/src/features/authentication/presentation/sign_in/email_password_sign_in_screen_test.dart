import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('sign in', () {
    testWidgets(
        '''
    Given formType is signIn
    When tap on the sign-in button
    Then signWithEmailAndPassword is not called
    ''',
        (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.signInWithEamailAndPassword(
          any(),
          any(),
        ),
      );
    });

    testWidgets(
        '''
    Given formType is signIn
    When enter valid Email and Password
    And tap on the sign-in button
    Then signInWithEmailAndPassword is called
    And onSignIn callback is called
    And error alert is not shown
    ''',
        (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.signInWithEamailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSigndIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(() => authRepository.signInWithEamailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });
}
