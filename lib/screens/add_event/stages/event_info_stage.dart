import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';

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
    controller.setCurrentStageValid(controller.getLocation().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    controller.setCurrentStageValid(controller.getLocation().isNotEmpty);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(
            context,
            title: 'Luogo e prezzo',
            subtitle: 'Inserisci la città in cui si svolgerà l\'evento e il prezzo',
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
              hintText: 'Luogo',
              minLines: 1,
              maxLines: 15,
              maxLength: 1500,
              onChanged: onLocationChange,
              initialValue: controller.getLocation(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
            ),
            child: Row(
              children: [
                
                Container(
                  width: appConfig.getWidth()*30,
                  child: buildTextField(
                    appConfig,
                    textCapitalization: TextCapitalization.sentences,
                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                    hintText: 'Prezzo',
                    maxLength: 30,
                    onChanged: onPriceChange,
                    initialValue: controller.getPrice().toString(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                ),
                SizedBox(width: appConfig.getWidth()*2,),
                const Text('€'),
              ],
            ),
          ),
        ],
      ),
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
