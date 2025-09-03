import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/widgets/buttons.dart';

import '../../services/translator/translator.dart';
import '../../utilities/app_config.dart';
import '../../widgets/button.dart';

class AddEventNavigator extends StatefulWidget {
  final AddEventController controller;
  final Translator? translator;

  const AddEventNavigator(
      this.controller,
      {
        super.key,
        this.translator,
      });

  @override
  _AddEventNavigatorState createState() => _AddEventNavigatorState();
}

class _AddEventNavigatorState extends State<AddEventNavigator> {
  late AddEventController controller;
  late Translator translator;

  late AppConfig appConfig;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.updateStagesButton = updateStatus;
    translator = widget.translator ?? Translator();
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      controller.isFirstStage()
          ? const SizedBox()
          : GoBackButton(
              icon: Icons.arrow_back_rounded,
              onTap: () {
                controller.prevStage();
              },
              appConfig: appConfig),
      ButtonText(
        text: controller.isLatestStage()
            ? controller.initialEvent != null
                ? 'Modifica'
                : 'Posta'
            : translator.translate('continue'),
        onTap: () => controller.nextStage(context),
        isEnabled: controller.isCurrentStageValid,
        isLoading: controller.isLoading,
        fixedWidth: appConfig.getWidth() * 30,
        //isEnabled: controller.isCurrentStageFilled(),
      ),
    ]);
  }

  void updateStatus() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {}),
    );
  }
}
