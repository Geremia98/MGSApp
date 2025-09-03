import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_consigliati_card.dart';
import '../../test_helpers.dart';

void main() {
  group('MyConsigliatiCard', () {
    setUpAll(() async {
      setupFirebaseAuthMocks();
      await initializeDateFormatting('it_IT', null);
    });

    Widget createTestWidget({
      required EventModel event,
      void Function(bool)? onPop,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final appConfig = AppConfig(context);
              return MyConsigliatiCard(
                height: 600,
                width: 400,
                event: event,
                appConfig: appConfig,
                onPop: onPop ?? (_) {},
              );
            },
          ),
        ),
      );
    }

    EventModel createMockEvent({
      String? title,
      DateTime? start,
      ImageModel? image,
    }) {
      return EventModel(
        id: 'test-event-1',
        title: title ?? 'Test Event',
        desc: 'Test Description',
        start: start ?? DateTime.now().add(Duration(days: 5)),
        end: DateTime.now().add(Duration(days: 5, hours: 2)),
        image: image,
      );
    }

    testWidgets('renders correctly with basic structure', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      expect(find.byType(MyConsigliatiCard), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('displays event title correctly', (WidgetTester tester) async {
      const testTitle = 'Amazing Concert Event';
      final event = createMockEvent(title: testTitle);

      await tester.pumpWidget(createTestWidget(event: event));

      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('displays event date correctly', (WidgetTester tester) async {
      final testDate = DateTime(2024, 12, 25);
      final event = createMockEvent(start: testDate);

      await tester.pumpWidget(createTestWidget(event: event));

      // The date should be formatted by formatDateToDayMonth function
      expect(find.byType(Text), findsWidgets);
      
      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      expect(textWidgets.length, equals(2)); // Title and date
    });

    testWidgets('shows asset image when no image provided', (WidgetTester tester) async {
      final event = createMockEvent(image: null);

      await tester.pumpWidget(createTestWidget(event: event));

      // Should show asset image
      expect(find.byType(Image), findsOneWidget);
      
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<AssetImage>());
      
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, equals('assets/images/party.png'));
    });

    testWidgets('shows CachedNetworkImage when image url provided', (WidgetTester tester) async {
      final imageModel = ImageModel(downloadUrl: 'https://example.com/image.jpg');
      final event = createMockEvent(image: imageModel);

      await tester.pumpWidget(createTestWidget(event: event));

      // Should show CachedNetworkImage
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      
      final cachedImage = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.imageUrl, equals('https://example.com/image.jpg'));
      expect(cachedImage.fit, equals(BoxFit.cover));
      expect(cachedImage.memCacheWidth, equals(600));
      expect(cachedImage.memCacheHeight, equals(400));
    });

    testWidgets('shows asset image when image downloadUrl is null', (WidgetTester tester) async {
      final imageModel = ImageModel(downloadUrl: null);
      final event = createMockEvent(image: imageModel);

      await tester.pumpWidget(createTestWidget(event: event));

      // Should show asset image when downloadUrl is null
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('has correct styling and layout', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      // Check Card styling
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.shape, isA<RoundedRectangleBorder>());
      
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, isA<BorderRadius>());

      // Check Container constraints
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThan(1));

      // Check Stack and Positioned widgets
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('text has correct styling', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      
      // Title text should have bold weight
      final titleText = textWidgets.first;
      expect(titleText.style?.fontWeight, equals(FontWeight.bold));
      expect(titleText.maxLines, equals(1));
      expect(titleText.overflow, equals(TextOverflow.ellipsis));
      
      // Date text should have specific font size
      final dateText = textWidgets.last;
      expect(dateText.style?.fontSize, isNotNull);
    });

    testWidgets('has correct Column layout', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      expect(find.byType(Column), findsOneWidget);
      
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      expect(column.children.length, equals(2));
    });

    testWidgets('handles long title with ellipsis', (WidgetTester tester) async {
      const longTitle = 'This is a very long event title that should be truncated with ellipsis';
      final event = createMockEvent(title: longTitle);

      await tester.pumpWidget(createTestWidget(event: event));

      final titleWidget = tester.widgetList<Text>(find.byType(Text)).first;
      expect(titleWidget.maxLines, equals(1));
      expect(titleWidget.overflow, equals(TextOverflow.ellipsis));
      expect(find.text(longTitle), findsOneWidget);
    });

    testWidgets('ClipRRect has correct border radius', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      expect(find.byType(ClipRRect), findsOneWidget);
      
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, isA<BorderRadius>());
    });

    testWidgets('positioned container has correct decoration', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Find the positioned container with decoration
      final decoratedContainer = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      
      final decoration = decoratedContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.color, isNotNull);
    });

    testWidgets('navigates to EventScreen on tap', (WidgetTester tester) async {
      final event = createMockEvent();
      bool onPopCalled = false;
      bool onPopResult = false;

      await tester.pumpWidget(createTestWidget(
        event: event,
        onPop: (result) {
          onPopCalled = true;
          onPopResult = result;
        },
      ));

      // Tap on the card
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Should navigate to EventScreen
      expect(find.byType(EventScreen), findsOneWidget);
      
      // Navigate back
      Navigator.of(tester.element(find.byType(EventScreen))).pop(false);
      await tester.pumpAndSettle();

      // onPop should be called with false
      expect(onPopCalled, isTrue);
      expect(onPopResult, isFalse);
    });

    testWidgets('calls onPop with true when EventScreen returns true', (WidgetTester tester) async {
      final event = createMockEvent();
      bool onPopCalled = false;
      bool onPopResult = false;

      await tester.pumpWidget(createTestWidget(
        event: event,
        onPop: (result) {
          onPopCalled = true;
          onPopResult = result;
        },
      ));

      // Tap on the card
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Navigate back with true result
      Navigator.of(tester.element(find.byType(EventScreen))).pop(true);
      await tester.pumpAndSettle();

      // onPop should be called with true
      expect(onPopCalled, isTrue);
      expect(onPopResult, isTrue);
    });

    testWidgets('handles different screen dimensions', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final appConfig = AppConfig(context);
              return MyConsigliatiCard(
                height: 1200,
                width: 800,
                event: event,
                appConfig: appConfig,
                onPop: (_) {},
              );
            },
          ),
        ),
      ));

      expect(find.byType(MyConsigliatiCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('respects maxHeight and maxWidth constraints', (WidgetTester tester) async {
      final event = createMockEvent();
      const testHeight = 600.0;
      const testWidth = 400.0;

      await tester.pumpWidget(createTestWidget(event: event));

      final container = tester.widgetList<Container>(find.byType(Container)).first;
      expect(container.constraints, isNotNull);
      
      final constraints = container.constraints!;
      expect(constraints.maxHeight, equals(testHeight * 0.4));
      expect(constraints.maxWidth, equals(testWidth * 0.7));
    });

    testWidgets('positioned widgets are correctly positioned', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));

      final positioned = tester.widgetList<Positioned>(find.byType(Positioned));
      
      // Should have Positioned widgets from Stack
      expect(positioned.length, greaterThan(0));
      
      // Check for Positioned.fill by checking fill constructor
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('widget builds without errors', (WidgetTester tester) async {
      final event = createMockEvent();

      await tester.pumpWidget(createTestWidget(event: event));
      
      // Should build without throwing exceptions
      expect(tester.takeException(), isNull);
      expect(find.byType(MyConsigliatiCard), findsOneWidget);
    });
  });
}