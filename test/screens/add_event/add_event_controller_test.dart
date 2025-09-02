import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  group('AddEventController', () {
    late AddEventController controller;
    late PageController pageController;

    Future<void> pumpController(WidgetTester tester, AddEventController controller, {Widget? child}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => child ?? PageView(
                  controller: controller.pageController,
                  children: List.generate(controller.stagesLength(), (index) => Container()),
                ),
              );
            },
          ),
        ),
      );
    }

    setUp(() {
      pageController = PageController();
      controller = AddEventController(pageController: pageController);
    });

    test('initialization', () {
      expect(controller.getCurrentStage(), AddEventStage.title);
      expect(controller.isCurrentStageValid, isFalse);
    });

    testWidgets('stage management', (tester) async {
      await pumpController(tester, controller);

      controller.nextStage(MockBuildContext());
      await tester.pumpAndSettle();
      expect(controller.getCurrentStage(), AddEventStage.desc);

      controller.prevStage();
      await tester.pumpAndSettle();
      expect(controller.getCurrentStage(), AddEventStage.title);
    });

    group('isCurrentStateFilled', () {
      testWidgets('title stage', (tester) async {
        await pumpController(tester, controller);

        controller.setTitle('Test Title');
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setTitle('');
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('desc stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setDesc('Test Description');
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setDesc('');
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('start stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setStartDate(DateTime.now());
        controller.setStartTime(TimeOfDay.now());
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setStartDate(null);
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('end stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setEndDate(DateTime.now());
        controller.setEndTIme(TimeOfDay.now());
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setEndDate(null);
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('banner stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        expect(controller.isCurrentStateFilled(), isTrue);
      });

      testWidgets('info stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setLocation('Test Location');
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setLocation('');
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('targetGroup stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setCountry('IT');
        controller.setIspettoria('Triveneto');
        controller.setGroup('Sesto');
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setCountry(null);
        expect(controller.isCurrentStateFilled(), isFalse);
      });

      testWidgets('targetPerson stage', (tester) async {
        await pumpController(tester, controller);

        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();
        controller.nextStage(MockBuildContext());
        await tester.pumpAndSettle();

        controller.setMinAge(18);
        controller.setMaxAge(30);
        expect(controller.isCurrentStateFilled(), isTrue);

        controller.setMinAge(null);
        expect(controller.isCurrentStateFilled(), isFalse);
      });
    });

    group('data setting', () {
      test('setTitle', () {
        controller.setTitle('Test Title');
        expect(controller.getTitle(), 'Test Title');
      });

      test('setDesc', () {
        controller.setDesc('Test Description');
        expect(controller.getDesc(), 'Test Description');
      });

      test('setStartDate', () {
        final date = DateTime.now();
        controller.setStartDate(date);
        expect(controller.getStartDate(), date);
      });

      test('setStartTime', () {
        final time = TimeOfDay.now();
        controller.setStartTime(time);
        expect(controller.getStartTime(), time);
      });

      test('setEndDate', () {
        final date = DateTime.now();
        controller.setEndDate(date);
        expect(controller.getEndDate(), date);
      });

      test('setEndTIme', () {
        final time = TimeOfDay.now();
        controller.setEndTIme(time);
        expect(controller.getEndTime(), time);
      });

      test('setBanner', () {
        final banner = ImageModel(downloadUrl: 'test_url');
        controller.setBanner(banner);
        expect(controller.getBanner(), banner);
      });

      test('setLocation', () {
        controller.setLocation('Test Location');
        expect(controller.getLocation(), 'Test Location');
      });

      test('setPrice', () {
        controller.setPrice('10.0');
        expect(controller.getPrice(), 10.0);
      });

      test('setCountry', () {
        controller.setCountry('IT');
        expect(controller.getCountry(), 'IT');
      });

      test('setIspettoria', () {
        controller.setIspettoria('Triveneto');
        expect(controller.getIspettoria(), 'Triveneto');
      });

      test('setGroup', () {
        controller.setGroup('Sesto');
        expect(controller.getGroup(), 'Sesto');
      });

      test('setMinAge', () {
        controller.setMinAge(18);
        expect(controller.getMinAge(), 18);
      });

      test('setMaxAge', () {
        controller.setMaxAge(30);
        expect(controller.getMaxAge(), 30);
      });

      test('setGender', () {
        controller.setGender(EventTargetGender.male);
        expect(controller.getGender(), EventTargetGender.male);
      });
    });

    group('publish', () {
      testWidgets('publish success', (tester) async {
        final mockEventFirestore = MockEventFirestore();
        final mockStorageService = MockFirebaseStorageService();

        when(mockEventFirestore.addEvent(any)).thenAnswer((_) async => 'test_event_id');
        when(mockStorageService.getEventBannerImage(any)).thenAnswer((_) async => ImageModel(downloadUrl: 'test_url'));

        await pumpController(
          tester,
          controller,
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => controller.publish(context, eventFirestore: mockEventFirestore, storageService: mockStorageService),
                child: const Text('Publish'),
              );
            },
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
      });
    });
  });
}
