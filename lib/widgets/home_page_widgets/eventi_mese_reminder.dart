import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';

import '../../models/event_model.dart';

class EventiDelMeseReminder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventiDelMeseReminder();
}

class _EventiDelMeseReminder extends State<EventiDelMeseReminder> {
  late Future<List<EventModel>> retrieveJoinedEvents;

  @override
  void initState() {
    super.initState();
    final EventFirestore eventFirestore = EventFirestore();

    retrieveJoinedEvents =
        eventFirestore.retrievePersonalEvents(onlyFuture: true);
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: retrieveJoinedEvents,
      builder: (BuildContext context, AsyncSnapshot<List<EventModel>> snap) {

        if (snap.connectionState != ConnectionState.done ||
            !snap.hasData ||
            snap.data == null ||
            snap.data!.isEmpty) {
          print("no data");
          return SizedBox();
        }
        print(snap.data!.length);


        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: width * 0.04),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
              color: appConfig.getTheme().highlightColor,
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
                    color: appConfig.getTheme().highlightColor,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/megaphone.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.02)),
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
                      text: snap.data!.length == 1 ? 'C\'è ' : 'Ci sono ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: width * eventiDelMeseReminderFontSize,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${snap.data!.length} event${snap.data!.length == 1 ? 'o' : 'i'}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' in\ncalendario questo mese'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
