import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../widgets/button.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key});

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  bool _loading = false;
  String? _paymentMethodId;
  CardFormEditController _cardFormController = CardFormEditController();

  Future<void> _createPaymentMethod() async {
    setState(() => _loading = true);

    try {

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
            ),
          ),
        ),
      );

      //setState(() {
        _paymentMethodId = paymentMethod.id;
      //});

      Navigator.pop(context, paymentMethod.id);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Errore: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _cardFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);


    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.08,
            left: width * 0.05,
            child: GestureDetector(
              onTap: () => {
                Navigator.pop(context),
              },
              child: Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  // Colore di sfondo
                  color: appConfig.getTheme().scaffoldBackgroundColor,
                  borderRadius:
                  BorderRadius.circular(width * 0.02), // Bordi arrotondati
                  border: Border.all(
                    width: width * 0.002, // Larghezza del bordo
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded, // Icona simile a quella mostrata
                  size: 24.0, // Dimensione dell'icona
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: appConfig.getHeight() * 20),
                Center(
                  child: CardFormField(
                    controller: _cardFormController,
                    style: CardFormStyle(
                      borderColor: Colors.grey,
                      borderRadius: 10,
                      borderWidth: 1,
                      //padding: 12,
                      textColor: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ButtonText(
                  text: 'Conferma',
                  onTap: _createPaymentMethod,
                  isLoading: _loading,
                ),
                const SizedBox(height: 20),
                if (_paymentMethodId != null)
                  Text('ID PaymentMethod: $_paymentMethodId'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
