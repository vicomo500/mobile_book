
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/authentication/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  // init Login Screen Widget
  var loginScreen = new MediaQuery(data: new MediaQueryData(),
      child: new MaterialApp(home: LoginScreen()));
  //initialize finders
  Finder email = find.byKey(Key('email'));
  Finder password = find.byKey(Key('password'));
  Finder submit = find.byKey(Key('submit'));
  Finder form = find.byType(Form);

  testWidgets('valid login form data', (WidgetTester tester) async {

    await tester.pumpWidget(loginScreen);

    await tester.enterText(email, "jdoe@gmail.com");
    await tester.enterText(password, "1234");
    await tester.tap(submit);
    await tester.pump();

    Form formWidget = tester.widget(form) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
    //Assert
    expect(formKey.currentState.validate(), isTrue);
  });
  testWidgets('invalid login form data', (WidgetTester tester) async {
    await tester.pumpWidget(loginScreen);

    await tester.enterText(email, "invalid email");
    await tester.enterText(password, ""); //empty password
    await tester.tap(submit);
    await tester.pump();

    Form formWidget = tester.widget(form) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
    //Assert
    expect(formKey.currentState.validate(), isFalse);
  });
}