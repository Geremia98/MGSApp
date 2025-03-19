import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';

import '../../../services/translator/translator.dart';
import '../../../utilities/app_config.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/title.dart';

class EventInfoStage extends StatefulWidget {
  final AddEventController controller;

  const EventInfoStage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<EventInfoStage> createState() => _TitleStageState();
}

class _TitleStageState extends State<EventInfoStage> {
  late AddEventController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);
    final Translator translator = Translator();

    controller.setCurrentStageValid(controller.getLocation().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Informazioni evento',
          subtitle: 'Inserisci il titolo dell\'evento.',
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
            hintText: 'Luogo',
            maxLength: 30,
            onChanged: onLocationChange,
            initialValue: controller.getLocation(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * 10,
          ),
          child: buildTextField(
            appConfig,
            textCapitalization: TextCapitalization.sentences,
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            hintText: 'Prezzo',
            maxLength: 30,
            onChanged: onPriceChange,
            initialValue: controller.getPrice().toString(),
          ),
        ),
      ],
    );
  }

  void onLocationChange(String? loc) {
    if (loc == null || loc.isEmpty) {
      controller.setLocation('');
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setLocation(loc);
    controller.setCurrentStageValid(true);
  }

  void onPriceChange(String? price) {
    if (price == null || price.isEmpty) {
      controller.setPrice('');
      controller.setCurrentStageValid(true);
      return;
    }

    controller.setPrice(price);
    controller.setCurrentStageValid(true);
  }


}
