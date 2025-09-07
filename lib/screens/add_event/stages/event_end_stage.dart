import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';

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
  String? _errorMessage;

    @override
  void initState() {
    super.initState();

    controller = widget.controller;
    if (controller.startDate != null && controller.endTime != null && controller.startTime != null && controller.endTime != null) {

      final DateTime startDateTime = DateTime(controller.startDate!.year, controller.startDate!.month, controller.startDate!.day, controller.startTime!.hour, controller.startTime!.minute);
      final DateTime endDateTime = DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, controller.endTime!.hour, controller.endTime!.minute);

      controller.setCurrentStageValid( startDateTime.isBefore(endDateTime));
      return;
    }

    controller.setCurrentStageValid(false);
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
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
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
                  onDateChange(startDate);
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
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
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
                  onTimeChange(startTime);
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
        if (_errorMessage != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: fontSizeMedium,
              ),
            ),
          ),
      ],
    );
  }

  void onDateChange(DateTime? date) {
    setState(() {
      controller.setEndDate(date);
      _validateEndDateTime();
    });
  }

  void onTimeChange(TimeOfDay? time) {
    setState(() {
      controller.setEndTIme(time);
      _validateEndDateTime();
    });
  }

  void _validateEndDateTime() {
    final DateTime? startDate = controller.getStartDate();
    final TimeOfDay? startTime = controller.getStartTime();
    final DateTime? endDate = controller.getEndDate();
    final TimeOfDay? endTime = controller.getEndTime();

    if (endDate == null || endTime == null) {
      _errorMessage = null;
      controller.setCurrentStageValid(false);
      return;
    }

    final DateTime startDateTime = DateTime(startDate!.year, startDate.month, startDate.day, startTime!.hour, startTime.minute);
    final DateTime endDateTime = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);

    if (endDateTime.isAfter(startDateTime)) {
      _errorMessage = null;
      controller.setCurrentStageValid(true);
    } else {
      _errorMessage = 'La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.';
      controller.setCurrentStageValid(false);
    }
  }
}