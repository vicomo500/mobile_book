import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpArgumentWidget(
    WidgetTester tester, {
      @required Object args,
      @required Widget child,
    }) async {
  final key = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MediaQuery(
      data: new MediaQueryData(),
      child: MaterialApp(
        navigatorKey: key,
        home: FlatButton(
          onPressed: () => key.currentState.push(
            MaterialPageRoute<void>(
              settings: RouteSettings(arguments: args),
              builder: (_) => child,
            ),
          ),
          child: const SizedBox(),
        ),
      ),
    ),
  );
  await tester.tap(find.byType(FlatButton));
  await tester.pumpAndSettle(); // Might need to be removed when testing infinite animations
}

/*class _MockNavigatorObserver extends Mock implements NavigatorObserver {}
final _mockObserver = _MockNavigatorObserver();
var homeScreen = new MediaQuery(data: new MediaQueryData(),
    child: new MaterialApp(
      home: HomeScreen(),
      navigatorObservers: [_mockObserver],
    ));
//when(_mockObserver.)
*/