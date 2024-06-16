import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game2d/PositionComponentWidget.dart';
import 'package:game2d/score_display.dart'; // Adjust path as per your project structure

void main() {
  testWidgets('ScoreDisplayWidget renders correct score', (WidgetTester tester) async {
    // Your test logic here
    final scoreDisplay = ScoreDisplay(score: 100);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScoreDisplayWidget(scoreDisplay: scoreDisplay),
        ),
      ),
    );

    expect(find.text('Score: 100'), findsOneWidget);
  });
}
