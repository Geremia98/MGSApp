import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../../widgets/selector.dart';
import '../../../widgets/text_field.dart';

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
    controller.setCurrentStageValid(controller.getGender() != null);
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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: Column(
            children: [
              SelectorStyle(
                constantEventTargetGenderList,
                controller.getGender(),
                onValueChange: onGenderTargetChanged,
                title: 'Genere:',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: buildTextField(
                      appConfig,
                      textCapitalization: TextCapitalization.characters,
                      textInputType: const TextInputType.numberWithOptions(decimal: false),
                      hintText: 'Età minima',
                      onChanged: onTargetDateChanged,
                      initialValue: controller.getAge() != null ? controller.getAge().toString() : '',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: appConfig.getWidth()*3),
                    child: const Text('--')),
                  Flexible(
                    flex: 2,
                    child: buildTextField(
                      appConfig,
                      textCapitalization: TextCapitalization.characters,
                      textInputType: const TextInputType.numberWithOptions(decimal: false),
                      hintText: 'Età massima',
                      onChanged: onTargetDateChanged,
                      initialValue: controller.getAge() != null ? controller.getAge().toString() : '',
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  void onGenderTargetChanged(EventTargetGender? gender){
    if (gender == null) {
      controller.setGender(null);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setGender(gender);
    controller.setCurrentStageValid(true);
  }

}
