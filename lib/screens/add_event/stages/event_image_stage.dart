import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import '../../../utilities/app_config.dart';
import '../../../widgets/image_upload.dart';
import '../../../widgets/title.dart';

class EventImageStage extends StatefulWidget {
  final AddEventController controller;

  const EventImageStage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<EventImageStage> createState() => _TitleStageState();
}

class _TitleStageState extends State<EventImageStage> {
  late AddEventController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.setCurrentStageValid(true);

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
          title: 'Copertina',
          subtitle: 'Inserisci l\'immagine che verrà usata come copertina dell\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * 10,
          ),
          child: Center(
            child: ImageUploadCard(
              width: appConfig.getWidth() * 80,
              height: appConfig.getWidth() * 80 * 9 / 16,
              imageType: ImageType.eventBanner,
              initialImage: controller.getBanner(),
              onImagePicked: (value) => controller.setBanner(value),
            ),
          ),
        ),
      ],
    );
  }

}
