import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';

import '../../../services/translator/translator.dart';
import '../../../utilities/app_config.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/font.dart';
import '../../../widgets/title.dart';

enum Months {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

String translateMonthFromDateTime(DateTime date) {
  final Translator translator = Translator();

  final String format = DateFormat('MMMM').format(date).toLowerCase();

  return translator.translate(format);
}

class EventEndStage extends StatefulWidget {
  final AddEventController controller;

  const EventEndStage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<EventEndStage> createState() => _TitleStageState();
}

class _TitleStageState extends State<EventEndStage> {
  late AddEventController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    controller.setCurrentStageValid(controller.getEndDate() != null && controller.getEndTime() != null);
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Fine evento',
          subtitle: '... e giorno e ora in cui si torna a casa',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * 10,
          ),
          child: Row(
            children: [
              Text(
                'Giorno:  ',
                style: TextStyle(
                  fontSize: fontSizeHuge,
                  color: appConfig.getTheme().secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Text(
                formatDateFromDateTime(controller.getEndDate()),
                style: TextStyle(
                  fontSize: fontSizeBig,
                  color: appConfig.getTheme().secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 18),
              GestureDetector(
                onTap: () async {
                  final DateTime? startDate = await showDatePicker(
                      context: context,
                      firstDate: controller.getStartDate()!,
                      lastDate: controller.getStartDate()!.add(Duration(days: 365)));
                    setState(() {
                      onDateChange(startDate);
                    });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      // Bordi arrotondati
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      )),
                  child: Icon(
                    Icons.mode_edit_rounded,
                    // Icona simile a quella mostrata
                    size: 16,
                    color: appConfig
                        .getTheme()
                        .secondaryHeaderColor, // Dimensione dell'icona
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * 10,
          ),
          child: Row(
            children: [
              Text(
                'Orario:  ',
                style: TextStyle(
                  fontSize: fontSizeHuge,
                  color: appConfig.getTheme().secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Text(
                formatTimeFromTimeOfDay(controller.getEndTime()),
                style: TextStyle(
                  fontSize: fontSizeBig,
                  color: appConfig.getTheme().secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 18),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? startTime = await showTimePicker(
                      context: context, initialTime: controller.getStartTime()!);
                    setState(() {
                      onTimeChange(startTime);
                    });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      // Bordi arrotondati
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      )),
                  child: Icon(
                    Icons.mode_edit_rounded,
                    // Icona simile a quella mostrata
                    size: 16,
                    color: appConfig
                        .getTheme()
                        .secondaryHeaderColor, // Dimensione dell'icona
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onDateChange(DateTime? date) {

    if (date == null ||  date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {

      controller.setEndDate(null);
      controller.setCurrentStageValid(false);
      return;
  }
  controller.setEndDate(date);
  controller.setCurrentStageValid(controller.getEndTime() != null);

  }

  void onTimeChange(TimeOfDay? time) {

    if (time == null) {

      controller.setEndTIme(null);
      controller.setCurrentStageValid(false);
      return;
    }
    controller.setEndTIme(time);
    controller.setCurrentStageValid(controller.getEndDate() != null);

  }

}
