import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:provider/provider.dart';

import '../../services/translator/translator.dart';
import '../../utilities/app_config.dart';
import '../../widgets/button.dart';

class AddEventNavigator extends StatefulWidget {
  final AddEventController controller;

  const AddEventNavigator(
      this.controller,
      {
        super.key,
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
    translator = Translator();
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      controller.isFirstStage()
          ? const SizedBox()
          : ButtonIcon(
        icon: LineIcons.arrowLeft,
        onTap: () => controller.prevStage(),
        isLoading: controller.isLoading,
        //isEnabled: controller.isCurrentStageFilled(),
      ),
      ButtonText(
        text: controller.isLatestStage()
            ? 'Pubblica'
            : translator.translate('continue'),
        onTap: () => controller.nextStage(),
        isEnabled: controller.isCurrentStageValid,
        isLoading: controller.isLoading,
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
