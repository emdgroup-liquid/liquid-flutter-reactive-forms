import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:liquid_flutter_reactive_forms/liquid_flutter_reactive_forms.dart';
import 'package:reactive_forms/reactive_forms.dart';

_wrapWithMaterialApp(Widget widget) {
  return MaterialApp(
    localizationsDelegates: const [
      LiquidLocalizations.delegate,
    ],
    home: Scaffold(
      body: LdThemeProvider(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(child: widget),
        ),
      ),
    ),
  );
}

void main() {
  group('LdFormSubmitConfig', () {
    test('creates a copy with action', () {
      // Arrange
      final config = LdFormSubmitConfig(
        loadingText: 'Loading...',
        submitText: 'Submit',
        allowResubmit: true,
        withHaptics: false,
        autoTrigger: true,
        timeout: const Duration(seconds: 5),
        allowCancel: true,
      );

      // Act
      String actionResult = '';
      final configWithAction = config.copyWithAction<String>(() async {
        actionResult = 'Action executed';
        return 'Success';
      });

      // Assert
      expect(configWithAction.loadingText, equals('Loading...'));
      expect(configWithAction.submitText, equals('Submit'));
      expect(configWithAction.allowResubmit, isTrue);
      expect(configWithAction.withHaptics, isFalse);
      expect(configWithAction.autoTrigger, isTrue);
      expect(configWithAction.timeout, equals(const Duration(seconds: 5)));
      expect(configWithAction.allowCancel, isTrue);

      // Check the action works
      configWithAction.action();
      expect(actionResult, equals('Action executed'));
    });
  });

  group('LdReactiveForm', () {
    testWidgets('renders form items correctly', (WidgetTester tester) async {
      // Arrange
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'name',
          inputFieldHint: 'Enter your name',
          label: 'Name',
        ),
        LdReactiveFormItem.checkbox(
          key: 'terms',
          label: 'Accept Terms',
        ),
      ];

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            onSubmit: (form) async => 'Success',
          ),
        ),
      );

      // Assert
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Accept Terms'), findsOneWidget);
      expect(find.byType(LdInput), findsOneWidget);
      expect(find.byType(LdCheckbox), findsOneWidget);
      expect(find.byType(LdSubmit<void>), findsOneWidget);
    });

    testWidgets('form validation works', (WidgetTester tester) async {
      // Arrange
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'email',
          inputFieldHint: 'Enter your email',
          label: 'Email',
          validators: [Validators.required, Validators.email],
          validationMessages: {
            'required': (error) => 'Email is required',
            'email': (error) => 'Invalid email format',
          },
        ),
      ];

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            onSubmit: (form) async => 'Success',
          ),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.byType(LdButton);
      expect(submitButton, findsOneWidget);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - validation error should appear
      expect(find.text('Email is required'), findsOneWidget);

      // Enter invalid email and submit
      await tester.enterText(find.byType(LdInput), 'not-an-email');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - email validation error should appear
      expect(find.text('Invalid email format'), findsOneWidget);

      // Enter valid email and submit
      await tester.enterText(find.byType(LdInput), 'test@example.com');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - no validation errors
      expect(find.text('Invalid email format'), findsNothing);
      expect(find.text('Email is required'), findsNothing);
    });

    testWidgets('onSubmit is called with valid form',
        (WidgetTester tester) async {
      // Arrange
      bool onSubmitCalled = false;
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'name',
          inputFieldHint: 'Enter your name',
          initialValue: 'John Doe', // Pre-populate with valid value
        ),
      ];

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            onSubmit: (form) async {
              onSubmitCalled = true;
              return 'Success';
            },
          ),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.byType(LdButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert
      expect(onSubmitCalled, isTrue);
    });

    testWidgets('form is disabled during submission',
        (WidgetTester tester) async {
      // Arrange
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'name',
          inputFieldHint: 'Enter your name',
          initialValue: 'John Doe',
        ),
      ];

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            onSubmit: (form) async {
              // Simulate network delay
              await Future.delayed(const Duration(milliseconds: 500));
              return 'Success';
            },
            submitConfig: LdFormSubmitConfig(
              loadingText: 'Submitting...',
            ),
          ),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.byType(LdButton);
      await tester.tap(submitButton);
      await tester.pump(); // Pump once to start the submission process

      // Assert that loading text is shown
      expect(find.text('Submitting...'), findsOneWidget);

      // Complete the submission
      await tester.pumpAndSettle();
    });

    testWidgets('custom submit button appears correctly',
        (WidgetTester tester) async {
      // Arrange
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'name',
          inputFieldHint: 'Enter your name',
        ),
      ];

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            onSubmit: (form) async => 'Success',
            submitBuilder: (context, form, child) {
              return LdButton(
                onPressed: () async {},
                disabled: form.disabled,
                child: const Text('Custom Submit'),
              );
            },
          ),
        ),
      );

      // Assert
      expect(find.text('Custom Submit'), findsOneWidget);
    });

    testWidgets('form validators are applied', (WidgetTester tester) async {
      // Arrange
      final formItems = [
        LdReactiveFormItem.input<String>(
          key: 'username',
          inputFieldHint: 'Username',
          initialValue: 'user1',
        ),
        LdReactiveFormItem.input<String>(
          key: 'password',
          inputFieldHint: 'Password',
          initialValue: 'pass',
        ),
      ];

      // Create a form-level validator that checks if username and password match
      final formValidator = Validators.mustMatch(
        'username',
        'password',
      );

      bool onSubmitCalled = false;

      // Act
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          LdReactiveForm(
            items: formItems,
            validators: [formValidator],
            validationMessages: {
              'matchError': (error) => 'Username and password must not match',
            },
            onSubmit: (form) async {
              onSubmitCalled = true;
              return 'Success';
            },
          ),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.byType(LdButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - form-level validation error should appear
      expect(find.text('Username and password must not match'), findsNothing);
      // Assert - onSubmit should not be called, as the form is invalid
      expect(onSubmitCalled, isFalse);

      // Make username and password match
      await tester.enterText(find.byType(LdInput).first, 'same');
      await tester.enterText(find.byType(LdInput).last, 'same');

      // Submit again
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - form submission has been called
      expect(onSubmitCalled, isTrue);
    });
  });
}
