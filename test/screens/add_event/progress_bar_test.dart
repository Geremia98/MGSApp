import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/progress_bar.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';
import '../../test_helpers.dart';

void main() {
  group('AddEventProgressBar', () {
    late AddEventController controller;
    late PageController pageController;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    Future<void> pumpProgressBar(WidgetTester tester, AddEventController controller) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    children: List.generate(controller.stagesLength(), (index) => Container()),
                  ),
                ),
                AddEventProgressBar(controller: controller),
              ],
            ),
          ),
        ),
      );
    }

    setUp(() {
      pageController = PageController();
      controller = AddEventController(pageController: pageController);
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      expect(find.byType(AddEventProgressBar), findsOneWidget);
    });

    testWidgets('displays progress bar container', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('initial state shows minimal progress', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      final animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final margin = animatedContainer.margin as EdgeInsets;
      
      // At initial state, progress should be minimal (6 pixels as per the code)
      expect(margin.left, equals(0));
      expect(margin.right, greaterThan(0));
    });

    testWidgets('progress updates when moving to next stage', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      // Get initial margin
      var animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      var initialMargin = animatedContainer.margin as EdgeInsets;
      final initialRightMargin = initialMargin.right;

      // Move to next stage
      controller.nextStage(MockBuildContext());
      await tester.pumpAndSettle();

      // Get updated margin
      animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final updatedMargin = animatedContainer.margin as EdgeInsets;
      final updatedRightMargin = updatedMargin.right;

      // Progress should have advanced (right margin should be smaller)
      expect(updatedRightMargin, lessThan(initialRightMargin));
    });

    testWidgets('progress bar has correct styling', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      final animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = animatedContainer.decoration as BoxDecoration;
      
      expect(decoration.borderRadius, equals(BorderRadius.circular(5.0)));
      expect(animatedContainer.duration, equals(Duration(milliseconds: 500)));
      expect(animatedContainer.curve, equals(Curves.easeInOut));
    });

    testWidgets('progress bar has correct structure', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      // Check that we have the expected structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      
      // Test that the progress bar renders without errors
      final progressBar = find.byType(AddEventProgressBar);
      expect(progressBar, findsOneWidget);
    });

    testWidgets('handles multiple stage transitions', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      // Record initial state
      var animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      var margin = animatedContainer.margin as EdgeInsets;
      final initialRightMargin = margin.right;

      // Move through multiple stages
      controller.nextStage(MockBuildContext());
      await tester.pumpAndSettle();

      controller.nextStage(MockBuildContext());
      await tester.pumpAndSettle();

      // Check final state
      animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      margin = animatedContainer.margin as EdgeInsets;
      final finalRightMargin = margin.right;

      // Should have progressed further
      expect(finalRightMargin, lessThan(initialRightMargin));
    });

    testWidgets('progress bar animation completes', (WidgetTester tester) async {
      await pumpProgressBar(tester, controller);

      controller.nextStage(MockBuildContext());
      
      // Pump with specific duration to test animation
      await tester.pump();
      await tester.pump(Duration(milliseconds: 250)); // Half way through animation
      await tester.pump(Duration(milliseconds: 250)); // Complete animation
      
      final animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(animatedContainer.duration, equals(Duration(milliseconds: 500)));
    });
  });
}
