import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../models/attempt_model_test.dart';
import '../../../models/group_challenge_model_test.dart';
import '../../../services/faker_service.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // arrange
    GroupChallengeModel groupChallenge = mockGroupChallengeModel();
    DateTime startDate = FakerService.dateTime();
    AttemptModel attempt = mockAttemptModel(startDate: startDate);

    // Wrap the widget under test with Directionality and MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: StartAndEndDateComponent.attempt(
              editAttempt: attempt,
              groupChallenge: groupChallenge,
            ),
          ),
        ),
      ),
    );

    // Verify that the title is correct
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('End'), findsOneWidget);
  });
}
