import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_book/registration/RegistrationScreen.dart';

void main() {
  // init RegistrationScreen Widget
  var regScreen = new MediaQuery(data: new MediaQueryData(),
      child: new MaterialApp(home: RegistrationScreen()));
  //initialize finders
  Finder form = find.byType(Form);
  Finder firstName = find.byKey(Key('firstName'));
  Finder lastName = find.byKey(Key('lastName'));
  Finder email = find.byKey(Key('email'));
  Finder phoneNumber = find.byKey(Key('phoneNumber'));
  Finder password = find.byKey(Key('password'));
  Finder submit = find.byKey(Key('submit'));
  //carry out tests
  testWidgets('valid registration form data', (WidgetTester tester) async{
    await tester.pumpWidget(regScreen);

    await tester.enterText(firstName, "John");
    await tester.enterText(lastName, "Doe");
    await tester.enterText(email, "jdoe@gmail.com");
    await tester.enterText(phoneNumber, "08012345678");
    await tester.enterText(password, "1234");
    await tester.tap(submit);
    await tester.pump();

    Form formWidget = tester.widget(form) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
    //Assert
    expect(formKey.currentState.validate(), isTrue);
  });

  testWidgets('invalid registration form data', (WidgetTester tester) async{
    await tester.pumpWidget(regScreen);

    await tester.enterText(firstName, "J");
    await tester.enterText(lastName, "Doe");
    await tester.enterText(email, "xxx");
    await tester.enterText(phoneNumber, "111");
    await tester.enterText(password, "");
    await tester.tap(submit);
    await tester.pump();

    Form formWidget = tester.widget(form) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
    //Assert
    expect(formKey.currentState.validate(), isFalse);
  });
}