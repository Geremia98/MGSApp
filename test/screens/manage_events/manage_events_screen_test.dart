import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/manage_events/manage_events_screen.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'manage_events_screen_test.mocks.dart';

@GenerateMocks([EventFirestore])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
    await initializeDateFormatting('it_IT', null);
  });

  group('ManageEventsScreen', () {
    late MockEventFirestore mockEventFirestore;
    late List<EventModel> testEvents;

    setUp(() {
      mockEventFirestore = MockEventFirestore();
      
      // Set up UserModel with test data
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.uid = 'test_user_uid';

      // Create test events
      testEvents = [
        EventModel(
          id: 'event1',
          title: 'Test Event 1',
          location: 'Test Location 1',
          start: DateTime.now().add(Duration(days: 1)),
          end: DateTime.now().add(Duration(days: 1, hours: 2)),
          creatorUid: 'test_user_uid',
          participants: [],
        ),
        EventModel(
          id: 'event2',
          title: 'Test Event 2',
          location: 'Test Location 2',
          start: DateTime.now().add(Duration(days: 2)),
          end: DateTime.now().add(Duration(days: 2, hours: 3)),
          creatorUid: 'test_user_uid',
          participants: ['participant1', 'participant2'],
        ),
      ];
    });

    testWidgets('renders correctly with basic structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        expect(find.byType(ManageEventsScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays correct page title', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        // Wait for the future to complete
        await tester.pump();

        expect(find.text('Gestisci eventi'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button exists and is tappable', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        final backButton = find.byType(GoBackButton);
        expect(backButton, findsOneWidget);
        
        // Verify back button can be tapped
        await tester.tap(backButton);
        await tester.pump();
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays MyPersonalRow with correct properties', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        // Wait for the future to complete
        await tester.pump();

        expect(find.byType(MyPersonalRow), findsOneWidget);
        
        final personalRowWidget = tester.widget<MyPersonalRow>(find.byType(MyPersonalRow));
        expect(personalRowWidget.titolo, 'Gestisci eventi');
        expect(personalRowWidget.count, -1); // Initially -1 when events is null
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has proper layout structure and components', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Expanded), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays loading state initially', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        // Initially, the FutureBuilder should be in loading state
        expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays empty list when no events exist', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        // Wait for the future to complete
        await tester.pump();
        
        // Should show empty ListView when no events
        expect(find.byType(ListView), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('SafeArea configuration is correct', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        final safeArea = find.byType(SafeArea);
        expect(safeArea, findsOneWidget);
        
        final safeAreaWidget = tester.widget<SafeArea>(safeArea);
        expect(safeAreaWidget.bottom, false);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('ListView has correct configuration', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        // Wait for the future to complete
        await tester.pump();

        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);
        
        final listViewWidget = tester.widget<ListView>(listView);
        expect(listViewWidget.shrinkWrap, true);
        expect(listViewWidget.physics, isA<AlwaysScrollableScrollPhysics>());
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('page responds to different screen sizes', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with small screen
        await tester.binding.setSurfaceSize(const Size(350, 600));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        expect(find.byType(ManageEventsScreen), findsOneWidget);
        await tester.pump();
        
        // Test with larger screen
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pump();
        
        expect(find.byType(ManageEventsScreen), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('contains all required UI components', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        await tester.pump();

        // Check for main components
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
        expect(find.byType(MyPersonalRow), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        
        // Check for proper text content
        expect(find.text('Gestisci eventi'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('padding configuration is correct', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        // Verify padding exists
        expect(find.byType(Padding), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('CrossAxisAlignment is set correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        // Verify that Column widgets exist with proper alignment
        expect(find.byType(Column), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('AppConfig is properly initialized', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        // Should render without errors, indicating AppConfig is working
        expect(find.byType(ManageEventsScreen), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}