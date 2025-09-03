import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/add_event_navigator.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  group('AddEventNavigator', () {
    late AddEventController controller;
    late PageController pageController;
    late MockTranslator mockTranslator;

    Future<void> pumpNavigator(WidgetTester tester, AddEventController controller) async {
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
                AddEventNavigator(controller, translator: mockTranslator),
              ],
            ),
          ),
        ),
      );
    }

    setUp(() {
      pageController = PageController();
      controller = AddEventController(pageController: pageController);
      mockTranslator = MockTranslator();
      when(mockTranslator.translate('continue')).thenReturn('Continue');
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpNavigator(tester, controller);

      expect(find.byType(AddEventNavigator), findsOneWidget);
    });

    testWidgets('initial state', (WidgetTester tester) async {
      await pumpNavigator(tester, controller);

      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.widgetWithText(ButtonText, 'Continue'), findsOneWidget);
      expect(tester.widget<ButtonText>(find.widgetWithText(ButtonText, 'Continue')).isEnabled, isFalse);
    });

    testWidgets('next button', (WidgetTester tester) async {
      controller.setCurrentStageValid(true);

      await pumpNavigator(tester, controller);

      final button = find.widgetWithText(ButtonText, 'Continue');
      expect(button, findsOneWidget);
      expect(tester.widget<ButtonText>(button).isEnabled, isTrue);

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(controller.getCurrentStage(), AddEventStage.desc);
    });

    testWidgets('back button', (WidgetTester tester) async {
      await pumpNavigator(tester, controller);

      controller.nextStage(MockBuildContext());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(controller.getCurrentStage(), AddEventStage.title);
    });

    testWidgets('last stage', (WidgetTester tester) async {
      await pumpNavigator(tester, controller);

      for (int i = 0; i < controller.stagesLength() - 1; i++) {
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
      }

      expect(find.widgetWithText(ButtonText, 'Posta'), findsOneWidget);
    });
  });
}
