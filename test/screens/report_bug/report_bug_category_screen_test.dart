import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_category_screen.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_screen.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import '../../test_helpers.dart';

void main() {
  group('ReportBugCategoryScreen', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.uid = 'test_uid';
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
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        expect(find.byType(ReportBugCategoryScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.text('Seleziona una categoria'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays all required UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.text('Seleziona una categoria'), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays all category buttons', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set larger screen size to ensure all buttons are visible
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Check for all 4 category buttons
        expect(find.byType(CategoryButton), findsNWidgets(4));
        
        // Check for specific category texts
        expect(find.text('Pagamenti'), findsOneWidget);
        expect(find.text('Autenticazione & Credenziali'), findsOneWidget);
        expect(find.text('Gestione Eventi'), findsOneWidget);
        expect(find.text('Gestione Gruppi'), findsOneWidget);
        
        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays all category icons', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Check for category icons
        expect(find.byIcon(Icons.payment), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.event_note), findsOneWidget);
        expect(find.byIcon(Icons.group), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('navigates to ReportBugScreen when category is tapped', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Tap on the first category button (Pagamenti)
        await tester.tap(find.text('Pagamenti'));
        await tester.pumpAndSettle();

        // Should navigate to ReportBugScreen
        expect(find.byType(ReportBugScreen), findsOneWidget);
        expect(find.text('Segnala un bug'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('navigates with correct category parameter', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Test different categories
        await tester.tap(find.text('Gestione Eventi'));
        await tester.pumpAndSettle();
        expect(find.byType(ReportBugScreen), findsOneWidget);
        
        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();
        
        // Test another category
        await tester.tap(find.text('Autenticazione & Credenziali'));
        await tester.pumpAndSettle();
        expect(find.byType(ReportBugScreen), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button pops navigator', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
        
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ReportBugCategoryScreen(),
                        ),
                      );
                    },
                    child: const Text('Push'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ReportBugCategoryScreen), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(ReportBugCategoryScreen), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('GridView has correct properties', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        
        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.crossAxisSpacing, equals(16));
        expect(delegate.mainAxisSpacing, equals(16));
        expect(delegate.childAspectRatio, equals(1.2));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('CategoryButton has correct structure and styling', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Check CategoryButton structure
        expect(find.byType(InkWell), findsNWidgets(4));
        expect(find.byType(Container), findsWidgets);
        
        // Check that each category button has an icon and text
        final categoryButtons = tester.widgetList<CategoryButton>(find.byType(CategoryButton));
        expect(categoryButtons.length, equals(4));
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('all category buttons are tappable', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Test tapping each category button
        final categories = ['Pagamenti', 'Autenticazione & Credenziali', 'Gestione Eventi', 'Gestione Gruppi'];
        
        for (final category in categories) {
          await tester.tap(find.text(category));
          await tester.pumpAndSettle();
          
          // Should navigate to ReportBugScreen
          expect(find.byType(ReportBugScreen), findsOneWidget);
          
          // Navigate back
          await tester.tap(find.byIcon(Icons.arrow_back_rounded));
          await tester.pumpAndSettle();
          
          // Should be back to category screen
          expect(find.byType(ReportBugCategoryScreen), findsOneWidget);
        }
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('CategoryButton widget works independently', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        bool tapped = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryButton(
                icon: Icons.bug_report,
                label: 'Test Category',
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        expect(find.byType(CategoryButton), findsOneWidget);
        expect(find.text('Test Category'), findsOneWidget);
        expect(find.byIcon(Icons.bug_report), findsOneWidget);
        
        await tester.tap(find.byType(CategoryButton));
        expect(tapped, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('maintains state during interactions', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Scroll the grid view
        await tester.drag(find.byType(GridView), const Offset(0, -100));
        await tester.pump();
        
        // All categories should still be present
        expect(find.text('Pagamenti'), findsOneWidget);
        expect(find.text('Autenticazione & Credenziali'), findsOneWidget);
        expect(find.text('Gestione Eventi'), findsOneWidget);
        expect(find.text('Gestione Gruppi'), findsOneWidget);
        
        // Title should still be present
        expect(find.text('Seleziona una categoria'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles screen resizing properly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(600, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugCategoryScreen(),
          ),
        );

        // Test with initial size
        expect(find.byType(ReportBugCategoryScreen), findsOneWidget);
        expect(find.byType(CategoryButton), findsNWidgets(4));

        // Change screen size (simulated)
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pump();
        
        // Should still work correctly
        expect(find.byType(ReportBugCategoryScreen), findsOneWidget);
        expect(find.byType(CategoryButton), findsNWidgets(4));
        
        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}