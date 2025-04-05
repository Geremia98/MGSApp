import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/title.dart';

class EventTargetPersonStage extends StatefulWidget {
  final AddEventController controller;
  const EventTargetPersonStage({required this.controller, super.key});

  @override
  State<EventTargetPersonStage> createState() => _EventTargetPersonStageState();
}

class _EventTargetPersonStageState extends State<EventTargetPersonStage> {
  late AddEventController controller;

  @override
  void initState() {
    controller = widget.controller;
    controller.setCurrentStageValid(controller.getAge().isNotEmpty);
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
          subtitle: 'Specifica le caratteristiche del target per cui è pensato l\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
      ],
    );
  }

  void onTargetDateChanged(String? age){
    if (age == null || age.isEmpty) {
      controller.setAge('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setAge(age);
    controller.setCurrentStageValid(true);
  }

  void onSexTargetChanged(bool? isJustForMales){
    if (isJustForMales == null) {
      controller.setSex(false);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setSex(isJustForMales);
    controller.setCurrentStageValid(true);
  }









}
