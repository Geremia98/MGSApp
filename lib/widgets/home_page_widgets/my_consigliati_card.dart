import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';

class MyConsigliatiCard extends StatelessWidget {
  const MyConsigliatiCard({
    super.key,
    required this.height,
    required this.width,
    required this.event,
    required this.appConfig,
  });

  final double height;
  final double width;
  final EventModel event;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    print(event.image);
    final AppConfig appConfig = AppConfig(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(event: event),
          ),
        );
      },
      child: Container(
        constraints:
            BoxConstraints(maxHeight: height * 0.4, maxWidth: width * 0.7),
        padding: EdgeInsets.only(right: width * 0.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
            side: getCustomBorderSide(
                appConfig: appConfig,
                width: width * bigRecommendedEventsCardBorderThickness),
          ),
          child: Stack(children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                child: event.image == null || event.image!.downloadUrl == null
                    ? Image.asset(
                        'assets/images/party.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        event.image!.downloadUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
                left: width * 0.025,
                bottom: width * 0.025,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: width * 0.01),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.01)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04),
                        ),
                        Text(
                          formatDateToDayMonth(event.start),
                          style: TextStyle(
                            fontSize: width * 0.037,
                          ),
                        ),
                      ]),
                )),
          ]),
        ),
      ),
    );
  }
}
