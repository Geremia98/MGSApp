import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_scren4.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../widgets/back_button_app_bar.dart';
import '../../widgets/font.dart';
import '../../widgets/personal_page_widgets/my_squared_icon_button.dart';
import '../../widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import '../../widgets/selector.dart';
import '../../widgets/text_field.dart';

class BankDataRegistrationScreen extends StatefulWidget {
  final RegistrationController controller;

  const BankDataRegistrationScreen({
    required this.controller,
    super.key,
  });

  @override
  State<BankDataRegistrationScreen> createState() =>
      _BankDataRegistrationScreenState();
}

class _BankDataRegistrationScreenState
    extends State<BankDataRegistrationScreen> {
  late RegistrationController controller;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isEnable = false;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    isEnable = controller.isIbanValid(controller.IBAN) == null && controller.bankHolder.isNotEmpty;

  }

  void setEnable() {

    setState(() {
      isEnable = controller.isIbanValid(controller.IBAN) == null && controller.bankHolder.isNotEmpty;

    });
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: appConfig.getHeight() * 100,
          padding: EdgeInsets.only(
              right: appConfig.getWidth() * 8,
              left: appConfig.getWidth() * 8,
              top: appConfig.getHeight() * 0.7),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BackButtonAppBar(
                      iconData: Icons.arrow_back_rounded,
                      appConfig: appConfig,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Center(
                      child: CircleAvatar(
                          radius: appConfig.getWidth() * 24,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 221, 109),
                          child: Image.asset(
                            'assets/images/sammy-registration1.png',
                            height: 190,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        'Qualche informazione in più',
                        textAlign: TextAlign.start,
                        style: textStyleTitle(context),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'Qui è dove manderemo i soldi dei biglietti venduti per il tuo evento.',
                        textAlign: TextAlign.center,
                        style: textStyleSubtitle(context),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          buildMyTextFormField(
                            appConfig,
                            initialValue: controller.bankHolder,
                            hintText: 'Nome intestatario',
                            onChanged: (value) {
                              controller.setBankHolder(value);
                              setEnable();
                            }
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          buildMyTextFormField(
                            appConfig,
                            initialValue: controller.IBAN,
                            hintText: 'IBAN',
                            //validator: (value) => controller.setIBAN(value),
                            onChanged: (value) {
                              controller.setIBAN(value);
                              setEnable();
                            }
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SelectorStyle<String>(
                            const {
                              'CHF': 'CHF - Swiss Franc',
                              'DKK': 'DKK - Danish Krone',
                              'EUR': 'EUR - Euro',
                              'GBP': 'GBP - British Pound',
                              'NOK': 'NOK - Norwegian Krone',
                              'SEK': 'SEK - Swedish Krona',
                              'USD': 'USD - US Dollar',
                            },
                            controller.currency,
                            hintText: 'Seleziona la valuta',
                            onValueChange: controller.setCurrency,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: MySquaredIconButton(
                  activeColor: appConfig.getTheme().primaryColor,
                  disabledColor: appConfig.getTheme().disabledColor,
                  icon: Icons.arrow_forward_rounded,
                  onTap: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen4(
                                controller: controller,
                              )),
                    );
                  },
                  isEnable: isEnable, //Settato a true perchè puo essere skippable
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
