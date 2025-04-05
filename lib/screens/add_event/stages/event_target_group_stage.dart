import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/title.dart';

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
    controller.setCurrentStageValid(controller.getCountry().isNotEmpty &
        controller.getIspettoria().isNotEmpty &
        controller.getGroup().isNotEmpty);
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
          subtitle: 'Inserisci il paese, l\'ispettoria e il gruppo a cui vuoi inviare l\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
      ],
    );
  }

  void onCountryChange(String? country) {
    if (country == null || country.isEmpty) {
      controller.setCountry('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setCountry(country);
    controller.setCurrentStageValid(true);
  }

  void onIspettoriaChange(String? ispettoria) {
    if (ispettoria == null || ispettoria.isEmpty) {
      controller.setCountry('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setCountry(ispettoria);
    controller.setCurrentStageValid(true);
  }

  void onGroupChange(String? group) {
    if (group == null || group.isEmpty) {
      controller.setCountry('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setCountry(group);
    controller.setCurrentStageValid(true);
  }










}


