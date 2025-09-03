import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/button.dart';

import '../../models/event_model.dart';

class MyPersonalHomeRow extends StatelessWidget {
  const MyPersonalHomeRow({
    super.key,
    required this.width,
    required this.titolo,
    required this.height,
    required this.appConfig,
    required this.futureEvents,
  });

  final Future<List<EventModel>> futureEvents;
  final double width;
  final double height;
  final String titolo;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(
          top: height * 0.035,
          bottom: height * 0.015,
          left: width * 0.008,
          right: width * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titolo,
            style: textStyleTitle(context),
          ),
          Row(
            children: [
              Text(
                'Vedi tutti',
                style: textStyleTextField(context),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllEventsScreen(
                              titolo: titolo,
                          futureEvents: futureEvents,
                            )),
                  ),
                },
                child: Container(
                  padding: EdgeInsets.all(width * 0.006),
                  decoration: BoxDecoration(
                    // Colore di sfondo
                    borderRadius: BorderRadius.circular(
                        width * 0.02), // Bordi arrotondati
                    border: getCustomBorder(
                      appConfig: appConfig,
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}