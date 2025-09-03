import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/function_errors.dart';

void main() {
  group('FunctionErrors', () {
    late FunctionErrors functionErrors;

    setUp(() {
      functionErrors = FunctionErrors();
    });

    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        expect(functionErrors, isNotNull);
        expect(functionErrors, isA<FunctionErrors>());
      });

      test('multiple instances have same error codes', () {
        final errors1 = FunctionErrors();
        final errors2 = FunctionErrors();
        
        expect(errors1.genericError, equals(errors2.genericError));
        expect(errors1.badRequestParamsError, equals(errors2.badRequestParamsError));
        expect(errors1.userNotFoundError, equals(errors2.userNotFoundError));
      });
    });

    group('generic error codes', () {
      test('has correct generic error codes', () {
        expect(functionErrors.genericError, equals(0));
        expect(functionErrors.badRequestParamsError, equals(1));
        expect(functionErrors.missingParamsError, equals(2));
        expect(functionErrors.companyNotFoundError, equals(3));
        expect(functionErrors.userNotFoundError, equals(4));
        expect(functionErrors.userAlreadyLinkedError, equals(5));
      });
    });

    group('product error codes', () {
      test('has correct product error codes in 100 range', () {
        expect(functionErrors.productNameNotValidError, equals(100));
        expect(functionErrors.productSectionIdNotValidError, equals(101));
        expect(functionErrors.productTypeNotValid, equals(102));
        expect(functionErrors.productPriceNotValid, equals(103));
        expect(functionErrors.productAmountNotValid, equals(104));
      });
    });

    group('cart and order error codes', () {
      test('has correct cart error codes in 200 range', () {
        expect(functionErrors.cartNoSelectedSizeError, equals(200));
        expect(functionErrors.productsOutOfStockError, equals(201));
        expect(functionErrors.scheduleNotValidError, equals(202));
        expect(functionErrors.typeNotSupportedError, equals(203));
        expect(functionErrors.totalNotEnoughError, equals(204));
        expect(functionErrors.productHasNegativePriceError, equals(205));
      });
    });

    group('stripe error codes', () {
      test('has correct stripe error codes', () {
        expect(functionErrors.stripeAccountIdNotFoundError, equals(100));
        expect(functionErrors.stripeCompanyIdNotFoundError, equals(101));
        expect(functionErrors.stripePaymentMethodNotValidError, equals(102));
        expect(functionErrors.stripeDetachPaymentMethodFailedError, equals(103));
        expect(functionErrors.stripeAlreadySubscribedError, equals(104));
      });

      test('stripe error codes overlap with product codes', () {
        // Note: This test documents the current behavior where stripe codes overlap with product codes
        expect(functionErrors.stripeAccountIdNotFoundError, equals(functionErrors.productNameNotValidError));
        expect(functionErrors.stripeCompanyIdNotFoundError, equals(functionErrors.productSectionIdNotValidError));
      });
    });

    group('error code properties', () {
      test('all error codes are integers', () {
        expect(functionErrors.genericError, isA<int>());
        expect(functionErrors.badRequestParamsError, isA<int>());
        expect(functionErrors.productNameNotValidError, isA<int>());
        expect(functionErrors.cartNoSelectedSizeError, isA<int>());
        expect(functionErrors.stripeAccountIdNotFoundError, isA<int>());
      });

      test('error codes are non-negative', () {
        expect(functionErrors.genericError, greaterThanOrEqualTo(0));
        expect(functionErrors.badRequestParamsError, greaterThanOrEqualTo(0));
        expect(functionErrors.productNameNotValidError, greaterThanOrEqualTo(0));
        expect(functionErrors.cartNoSelectedSizeError, greaterThanOrEqualTo(0));
      });

      test('most error codes are unique within same category', () {
        final genericErrors = [
          functionErrors.genericError,
          functionErrors.badRequestParamsError,
          functionErrors.missingParamsError,
          functionErrors.companyNotFoundError,
          functionErrors.userNotFoundError,
          functionErrors.userAlreadyLinkedError,
        ];

        final uniqueGenericErrors = genericErrors.toSet();
        expect(uniqueGenericErrors.length, equals(genericErrors.length));

        final productErrors = [
          functionErrors.productNameNotValidError,
          functionErrors.productSectionIdNotValidError,
          functionErrors.productTypeNotValid,
          functionErrors.productPriceNotValid,
          functionErrors.productAmountNotValid,
        ];

        final uniqueProductErrors = productErrors.toSet();
        expect(uniqueProductErrors.length, equals(productErrors.length));
      });
    });

    group('error code ranges', () {
      test('generic errors are in low range (0-99)', () {
        expect(functionErrors.genericError, lessThan(100));
        expect(functionErrors.badRequestParamsError, lessThan(100));
        expect(functionErrors.userNotFoundError, lessThan(100));
      });

      test('product errors are in 100+ range', () {
        expect(functionErrors.productNameNotValidError, greaterThanOrEqualTo(100));
        expect(functionErrors.productSectionIdNotValidError, greaterThanOrEqualTo(100));
      });

      test('cart errors are in 200+ range', () {
        expect(functionErrors.cartNoSelectedSizeError, greaterThanOrEqualTo(200));
        expect(functionErrors.productsOutOfStockError, greaterThanOrEqualTo(200));
      });
    });
  });
}