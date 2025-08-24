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
  bool isCountryBroadcast = false;
  bool isIspettoriaBroadcast = false;

  @override
  void initState() {
    controller = widget.controller;
    isCountryBroadcast = controller.isCountryBroadcast;
    isIspettoriaBroadcast = controller.isIspettoriaBroadcast;
    controller.setCurrentStageValid(_isStateValid());
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
              CheckboxListTile(
                title: const Text('Invia a tutto il paese'),
                value: isCountryBroadcast,
                onChanged: (value) {
                  setState(() {
                    isCountryBroadcast = value!;
                    if (isCountryBroadcast) {
                      isIspettoriaBroadcast = false;
                      controller.setIspettoria(null);
                      controller.setGroup(null);
                    }
                    controller.setCountryBroadcast(isCountryBroadcast);
                    controller.setIspettoriaBroadcast(isIspettoriaBroadcast);
                    controller.setCurrentStageValid(_isStateValid());
                  });
                },
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownIspettoriaList,
                controller.getIspettoria(),
                onValueChange: onIspettoriaChange,
                title: 'Ispettoria:',
                isEnable: !isCountryBroadcast,
              ),
              CheckboxListTile(
                title: const Text('Invia a tutta l\'ispettoria'),
                value: isIspettoriaBroadcast,
                onChanged: (value) {
                  setState(() {
                    isIspettoriaBroadcast = value!;
                    if (isIspettoriaBroadcast) {
                      isCountryBroadcast = false;
                      controller.setGroup(null);
                    }
                    controller.setIspettoriaBroadcast(isIspettoriaBroadcast);
                    controller.setCountryBroadcast(isCountryBroadcast);
                    controller.setCurrentStageValid(_isStateValid());
                  });
                },
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownGroupList,
                controller.getGroup(),
                onValueChange: onGroupChange,
                title: 'Gruppo:',
                isEnable: !isCountryBroadcast && !isIspettoriaBroadcast,
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
    } else {
      controller.setCountry(country);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  void onIspettoriaChange(String? ispettoria) {
    if (ispettoria == null || ispettoria.isEmpty) {
      controller.setIspettoria(null);
    } else {
      controller.setIspettoria(ispettoria);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  void onGroupChange(String? group) {
    if (group == null || group.isEmpty) {
      controller.setGroup(null);
    } else {
      controller.setGroup(group);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  bool _isStateValid() {
    if (isCountryBroadcast) {
      return controller.getCountry() != null;
    } else if (isIspettoriaBroadcast) {
      return controller.getCountry() != null && controller.getIspettoria() != null;
    } else {
      return controller.getCountry() != null &&
          controller.getIspettoria() != null &&
          controller.getGroup() != null;
    }
  }
}
