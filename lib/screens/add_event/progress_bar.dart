import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:provider/provider.dart';

import '../../utilities/app_config.dart';

class AddEventProgressBar extends StatefulWidget {
  final AddEventController controller;

  const AddEventProgressBar({required this.controller, Key? key})
      : super(key: key);

  @override
  State<AddEventProgressBar> createState() => _AddEventProgressBarState();
}

class _AddEventProgressBarState extends State<AddEventProgressBar> {
  late AddEventController controller;
  late AddEventStage currentStage;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

    currentStage = controller.getCurrentStage();
  }

  void animateProgressBar() {
    setState(() {
      currentStage = controller.getCurrentStage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    controller.setAnimateProgressBar(animateProgressBar);


    final double fullWidth = appConfig.getWidth() * 90;
    final double singleStepWidth =
        (fullWidth / (AddEventStage.values.length - 1));
    double progress = (singleStepWidth * controller.getCurrentStageIndex());

    if (progress <= 0) {
      progress = 6;
    }

    return Column(
      children: [
        /*SizedBox(
          height: 20,
          child: Text(
            '${controller.getCurrentStageIndex() + 1}/${controller.stagesLength()}',
            style: textStyleClickable(context),
          ),
        ),
        SizedBox(
          height: 5,
        ),*/
        Container(
          width: appConfig.getWidth() * 90,
          height: 6,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
              left: 0,
              right: (fullWidth - progress),
            ),
            // Adjust the height of your progress bar
            decoration: BoxDecoration(
              color: appConfig.getTheme().primaryColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
