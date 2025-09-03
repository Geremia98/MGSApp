import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../utilities/my_theme_data.dart';
import '../../widgets/buttons.dart';
import '../main_screens/all_events_screen.dart';
import '../main_screens/event_screen.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  late AppConfig appConfig;
  late Future<List<EventModel>> loadPersonalEvents;

  @override
  void initState() {
    super.initState();

    final EventFirestore eventFirestore = EventFirestore();

    loadPersonalEvents =
        eventFirestore.retrievePersonalEvents(justCreatedByMe: true);
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appConfig.getWidth() * 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GoBackButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  appConfig: appConfig),
              Expanded(
                child: FutureBuilder(
                    future: loadPersonalEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventModel>> snap) {
                      return buildPage(snap.data);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(List<EventModel>? events) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MyPersonalRow(
          width: width,
          titolo: 'Gestisci eventi',
          height: height,
          count: events == null ? -1 : events.length,
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: events == null ? 0 : events!.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return buildEventWidget(events!.elementAt(index));
              }),
        ),
      ],
    );
  }

  Widget buildEventWidget(EventModel event) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              event: event,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.005),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.025, vertical: width * 0.025
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
          border: getCustomBorder(
            appConfig: appConfig,
            width: width * 0.0015,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 90,
              width: 90,
              margin: EdgeInsets.only(right: width * 0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.01)),
                child: event.image == null || event.image!.downloadUrl == null
                    ? Image.asset(
                        'assets/images/ballo.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        event.image!.downloadUrl!,
                        fit: BoxFit.cover,
                        cacheWidth: 600,
                        cacheHeight: 400,
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                            fontSize: 14,
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
                          DateFormat('dd-MM-yyyy hh:mm').format(event.start!),
                          style: TextStyle(
                            fontSize: 14,
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
                            Icons.people_outline,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          event.participants.isEmpty ? 'Nessun partecipante' : '${event.participants.length} partecipant${event.participants.length == 1 ? 'e' : 'i'}',
                          style: TextStyle(
                            fontSize: 14,
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
