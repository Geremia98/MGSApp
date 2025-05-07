import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/utilities/app_config.dart';

String formatDateToDayMonth(DateTime? date) {
  Intl.defaultLocale = 'it_IT';

  return DateFormat('d MMMM').format(date ?? DateTime.now());
}

String formatDateFromDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return 'xx/xx/xx';
  }

  return '${dateTime.day} / ${dateTime.month} / ${dateTime.year}';
}

String formatTimeFromTimeOfDay(TimeOfDay? time) {
  if (time == null) {
    return 'xx:xx';
  }

  // Convert TimeOfDay to DateTime
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);

  // Format using DateFormat
  return DateFormat('HH:mm').format(dateTime);
}

String formatTimeFromDateTime(DateTime dateTime) {
  return dateTime.hour < 10
      ? dateTime.minute < 10
          ? '0${dateTime.hour} : 0${dateTime.minute}'
          : '0${dateTime.hour} : ${dateTime.minute}'
      : dateTime.minute < 10
          ? '${dateTime.hour} : 0${dateTime.minute}'
          : '${dateTime.hour} : ${dateTime.minute}';
}

Widget buildAddNewImageButton(
    BuildContext context, double width, double raggio, double height) {
  final AppConfig appConfig = AppConfig(context);

  return Center(
    child: GestureDetector(
      onTap: () {
        debugPrint(
            'Si dovrebbe aggiungere la funzionalità per caricare immagine');
      },
      child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(raggio),
          dashPattern: [10, 10],
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 2.5,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: height * 0.2,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: appConfig.getTheme().primaryColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.2)),
                  ),
                  child: Icon(
                    Icons.add,
                    color: appConfig.getTheme().scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          )),
    ),
  );
}
