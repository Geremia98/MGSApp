
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import '../../../utilities/app_config.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/title.dart';

class EventTitleStage extends StatefulWidget {
  final AddEventController controller;

  const EventTitleStage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<EventTitleStage> createState() => _TitleStageState();
}

class _TitleStageState extends State<EventTitleStage> {
  late AddEventController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    controller.setCurrentStageValid(controller.getTitle().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Titolo evento',
          subtitle: 'Inserisci il titolo dell\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: buildTextField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            hintText: 'Titolo',
            onChanged: onTitleChange,
            initialValue: controller.getTitle(),
          ),
        ),
      ],
    );
  }

  void onTitleChange(String? title) {

    if (title == null || title.isEmpty) {
      controller.setTitle('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setTitle(title);
    controller.setCurrentStageValid(true);
  }
}
