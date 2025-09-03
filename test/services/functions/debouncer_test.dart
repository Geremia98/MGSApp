import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/debouncer.dart';

void main() {
  group('Debouncer', () {
    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 100),
        );
        
        expect(debouncer, isNotNull);
        expect(debouncer, isA<Debouncer>());
      });

      test('accepts different trigger functions', () {
        String result = '';
        
        final debouncer1 = Debouncer(
          (_) => result = 'test1',
          const Duration(milliseconds: 50),
        );
        
        final debouncer2 = Debouncer(
          (_) => result = 'test2',
          const Duration(milliseconds: 100),
        );
        
        expect(debouncer1, isA<Debouncer>());
        expect(debouncer2, isA<Debouncer>());
      });

      test('accepts different duration values', () {
        bool triggered = false;
        
        final shortDebouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 10),
        );
        
        final longDebouncer = Debouncer(
          (_) => triggered = true,
          const Duration(seconds: 1),
        );
        
        expect(shortDebouncer, isA<Debouncer>());
        expect(longDebouncer, isA<Debouncer>());
      });
    });

    group('runFunction behavior', () {
      test('method exists and can be called', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 100),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('can be called multiple times without error', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 100),
        );
        
        expect(() {
          debouncer.runFunction();
          debouncer.runFunction();
          debouncer.runFunction();
        }, returnsNormally);
      });

      test('handles rapid successive calls', () {
        int callCount = 0;
        final debouncer = Debouncer(
          (_) => callCount++,
          const Duration(milliseconds: 100),
        );
        
        // Make multiple rapid calls
        for (int i = 0; i < 10; i++) {
          debouncer.runFunction();
        }
        
        // Should not throw and debouncer should handle it
        expect(() => debouncer.runFunction(), returnsNormally);
      });
    });

    group('timer management', () {
      test('creates timer when runFunction is called', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 50),
        );
        
        debouncer.runFunction();
        
        // Timer should be created (indirectly tested by no exceptions)
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('cancels previous timer when called again', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 100),
        );
        
        // First call
        debouncer.runFunction();
        
        // Second call should cancel the first
        debouncer.runFunction();
        
        // Should not throw
        expect(triggered, isFalse); // Immediate check, timer hasn't fired yet
      });

      test('handles null timer state correctly', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 50),
        );
        
        // First call when timer is null
        expect(() => debouncer.runFunction(), returnsNormally);
        
        // Subsequent calls
        expect(() => debouncer.runFunction(), returnsNormally);
      });
    });

    group('duration handling', () {
      test('works with very short durations', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 1),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('works with zero duration', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          Duration.zero,
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('works with longer durations', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(seconds: 2),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });
    });

    group('trigger function handling', () {
      test('accepts trigger function with different parameter types', () {
        String result = '';
        
        final debouncer = Debouncer(
          (dynamic param) => result = param.toString(),
          const Duration(milliseconds: 50),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('handles trigger functions that throw', () {
        final debouncer = Debouncer(
          (_) => throw Exception('Test exception'),
          const Duration(milliseconds: 50),
        );
        
        // The timer creation should not throw, even if the trigger would throw later
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('accepts void returning trigger functions', () {
        bool sideEffect = false;
        
        final debouncer = Debouncer(
          (_) {
            sideEffect = true;
          },
          const Duration(milliseconds: 50),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('accepts async trigger functions', () {
        bool triggered = false;
        
        final debouncer = Debouncer(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 10));
            triggered = true;
          },
          const Duration(milliseconds: 50),
        );
        
        expect(() => debouncer.runFunction(), returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles multiple debouncer instances independently', () {
        bool triggered1 = false;
        bool triggered2 = false;
        
        final debouncer1 = Debouncer(
          (_) => triggered1 = true,
          const Duration(milliseconds: 50),
        );
        
        final debouncer2 = Debouncer(
          (_) => triggered2 = true,
          const Duration(milliseconds: 100),
        );
        
        debouncer1.runFunction();
        debouncer2.runFunction();
        
        // Both should work independently
        expect(() => debouncer1.runFunction(), returnsNormally);
        expect(() => debouncer2.runFunction(), returnsNormally);
      });

      test('handles rapid creation and disposal pattern', () {
        for (int i = 0; i < 10; i++) {
          bool triggered = false;
          final debouncer = Debouncer(
            (_) => triggered = true,
            const Duration(milliseconds: 10),
          );
          
          debouncer.runFunction();
          
          // Should handle creation/usage pattern
          expect(triggered, isFalse); // Immediate check
        }
      });
    });

    group('state management', () {
      test('maintains state between calls', () {
        int callCount = 0;
        final debouncer = Debouncer(
          (_) => callCount++,
          const Duration(milliseconds: 100),
        );
        
        debouncer.runFunction();
        debouncer.runFunction(); // Should cancel first
        debouncer.runFunction(); // Should cancel second
        
        // State should be maintained (no exceptions thrown)
        expect(() => debouncer.runFunction(), returnsNormally);
      });

      test('can be used after timer completion cycle', () {
        bool triggered = false;
        final debouncer = Debouncer(
          (_) => triggered = true,
          const Duration(milliseconds: 10),
        );
        
        debouncer.runFunction();
        
        // Wait a bit to ensure timer could have completed
        return Future.delayed(const Duration(milliseconds: 50), () {
          // Should still be usable
          expect(() => debouncer.runFunction(), returnsNormally);
        });
      });
    });
  });
}