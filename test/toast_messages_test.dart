import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toast_messages/toast_messages.dart';

class SetupWidget extends StatelessWidget {
  const SetupWidget({super.key, required this.toastShower});

  final void Function(BuildContext context) toastShower;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => toastShower(context),
              child: Text('show toast'),
            );
          },
        ),
      ),
    );
  }
}

///I might add more tests in the future, but for now testing that the toast function shows a toast with correct animation is enough for me.
void main() {
  testWidgets('Toast appears and dissapears after duration + fade animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      SetupWidget(
        toastShower: (context) => ToastManager.show(
          context,
          content: Text('Message in my toast'),
          duration: Duration(seconds: 3),
          fadeDuration: Duration(milliseconds: 350),
        ),
      ),
    );

    final buttonFinder = find.text('show toast');
    final toastFinder = find.text('Message in my toast');

    await tester.tap(buttonFinder);

    //fade in animation
    await tester.pumpAndSettle();

    expect(toastFinder, findsOne);

    await tester.pump(Duration(seconds: 3));
    //fade out animation
    await tester.pumpAndSettle();

    expect(toastFinder, findsNothing);
  });
}
