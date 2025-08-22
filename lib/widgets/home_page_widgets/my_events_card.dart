import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';

class MyEventsCard extends StatelessWidget {
  const MyEventsCard({
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventScreen(
                    event: event,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.005),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.025, vertical: width * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
          border: getCustomBorder(
            appConfig: appConfig,
            width: width * smallMyEventsCardBorderThickness,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: width * 0.2,
              width: width * 0.2,
              margin: EdgeInsets.only(right: width * 0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.01)),
                child: event.image == null || event.image!.downloadUrl == null
                    ? Image.asset(
                        'assets/images/party.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        event.image!.downloadUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, widget, loadingProgress) {
                          if (loadingProgress == null) return widget;
                          return ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.asset(
                              'assets/images/party.png',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.007),
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.02),
                          child: Icon(
                            size: width * 0.035,
                            Icons.place_outlined,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.02),
                          child: Icon(
                            size: width * 0.035,
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formatDateToDayMonth(event.start),
                          style: TextStyle(
                            fontSize: width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
