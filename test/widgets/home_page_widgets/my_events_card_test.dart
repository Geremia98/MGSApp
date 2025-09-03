import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_events_card.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  final event = EventModel(
    title: 'Test Event',
    location: 'Test Location',
    start: DateTime(2025, 1, 1),
    end: DateTime(2025, 1, 2),
  );

  setUpAll(() {
    initializeDateFormatting('it_IT', null);
  });

  testWidgets('MyEventsCard displays event data', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return SizedBox(
                width: 500,
                child: MyEventsCard(
                  appConfig: AppConfig(context),
                  event: event,
                  height: 200,
                  width: 300,
                  onPop: (value) {}, isLoading: false,
                ),
              );
            }
          ),
        ),
      ),
    );

    expect(find.text('Test Event'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
    expect(find.text('1 gennaio'), findsOneWidget);
  });
}




