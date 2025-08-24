
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import '../../../utilities/app_config.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/title.dart';

class EventDescStage extends StatefulWidget {
  final AddEventController controller;

  const EventDescStage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<EventDescStage> createState() => _TitleStageState();
}

class _TitleStageState extends State<EventDescStage> {
  late AddEventController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

  }

  @override
  Widget build(BuildContext context) {

    controller.setCurrentStageValid(controller.getDesc().isNotEmpty);


    final AppConfig appConfig = AppConfig(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(
            context,
            title: 'Descrizione evento',
            subtitle: 'Ora inserisci una breve descrizione riguardo a cosa si farà',
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
              hintText: 'Descrizione',
              minLines: 3,
              maxLines: 15,
              maxLength: 1500,
              onChanged: onTitleChange,
              initialValue: controller.getDesc(),
            ),
          ),
        ],
      ),
    );
  }

  void onTitleChange(String? title) {

    if (title == null || title.isEmpty) {
      controller.setDesc('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setDesc(title);
    controller.setCurrentStageValid(true);
  }
}
