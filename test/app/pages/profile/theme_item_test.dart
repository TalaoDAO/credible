import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talao/app/pages/profile/widgets/theme_item.dart';

class MockCallback extends Mock {
  int call() => 5;
}

void main() {
  group('ThemeItem', () {
    var isTrue = true;
    var title = 'Light Theme';

    var mockFunction;

    setUp(() {
      mockFunction = MockCallback();
    });

    testWidgets(
      'renders correct Title',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
            body: ThemeItem(
              isTrue: isTrue,
              title: title,
              onTap: () => mockFunction(),
            ),
          )),
        );
        expect(find.text(title), findsOneWidget);
      },
    );

    testWidgets(
      'renders correct Icon when true case ',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
            body: ThemeItem(
              isTrue: isTrue,
              title: title,
              onTap: () => mockFunction(),
            ),
          )),
        );
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      },
    );

    testWidgets(
      'renders correct Icon when true case ',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
            body: ThemeItem(
              isTrue: false,
              title: title,
              onTap: () => mockFunction(),
            ),
          )),
        );
        expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      },
    );

    ///TODO: Test failed
    testWidgets(
      'triggers correct function',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
            body: ThemeItem(
              isTrue: false,
              title: title,
              onTap: () => mockFunction(),
            ),
          )),
        );
        await tester.tap(find.byType(InkWell));
        //await tester.pumpAndSettle();
        verify(() => mockFunction()).called(1);
      },
    );
  });
}
