
import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Descrizione evento',
          subtitle: 'Inserisci la descrizione dell\'evento.',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * 10,
          ),
          child: buildTextField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            hintText: 'Descrizione',
            maxLines: 10,
            onChanged: onTitleChange,
            initialValue: controller.getDesc(),
          ),
        ),
      ],
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
