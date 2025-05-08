import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../../utilities/constants_strings.dart';
import '../../../widgets/selector.dart';

class EventTargetGroupStage extends StatefulWidget {
  final AddEventController controller;

  const EventTargetGroupStage({required this.controller, super.key});

  @override
  State<EventTargetGroupStage> createState() => _EventTargetGroupStageState();
}

class _EventTargetGroupStageState extends State<EventTargetGroupStage> {
  late AddEventController controller;

  @override
  void initState() {
    controller = widget.controller;
    controller.setCurrentStageValid(controller.getCountry() != null &&
        controller.getIspettoria() != null &&
        controller.getGroup() != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Per chi è?',
          subtitle:
              'Inserisci il paese, l\'ispettoria e il gruppo a cui vuoi inviare l\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: Column(
            children: [
              SelectorStyle(
                constantDropDownCountryList,
                controller.getCountry(),
                onValueChange: onCountryChange,
                title: 'Paese:',
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownIspettoriaList,
                controller.getIspettoria(),
                onValueChange: onIspettoriaChange,
                title: 'Ispettoria:',
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownGroupList,
                controller.getGroup(),
                onValueChange: onGroupChange,
                title: 'Gruppo:',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onCountryChange(String? country) {
    if (country == null || country.isEmpty) {
      controller.setCountry(null);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setCountry(country);
    controller.setCurrentStageValid(controller.getIspettoria() != null && controller.getGroup() != null);
  }

  void onIspettoriaChange(String? ispettoria) {
    if (ispettoria == null || ispettoria.isEmpty) {
      controller.setIspettoria(null);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setIspettoria(ispettoria);
    controller.setCurrentStageValid(controller.getCountry() != null && controller.getGroup() != null);
  }

  void onGroupChange(String? group) {
    if (group == null || group.isEmpty) {
      controller.setGroup(null);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setGroup(group);
    controller.setCurrentStageValid(controller.getIspettoria() != null && controller.getCountry() != null);
  }
}
