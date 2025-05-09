import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';

class EventiDelMeseReminder extends StatelessWidget {
  const EventiDelMeseReminder({
    super.key,
    required this.width,
    required this.coloreReminder,
    required this.appConfig,
  });

  final double width;
  final Color coloreReminder;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: width * 0.04),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
        color: coloreReminder,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: width * 0.03, // Shadow position
          ),
        ],
        border: getCustomBorder(
          appConfig: appConfig,
          width: width * monthEventsReminderBorderThickness,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.15,
            height: width * 0.15,
            decoration: BoxDecoration(
              color: coloreReminder,
              image: const DecorationImage(
                image: AssetImage('assets/images/megaphone.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
              border: Border.all(
                color: Colors.white,
                width: width * 0.01,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: RichText(
              text: TextSpan(
                text: 'Ci sono ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: width * eventiDelMeseReminderFontSize,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
                children: const <TextSpan>[
                  TextSpan(
                      text: '3 eventi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' in\ncalendario questo mese'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}