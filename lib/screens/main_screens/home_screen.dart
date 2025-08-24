import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/home_page_widgets/eventi_mese_reminder.dart';
import 'package:mgs_app2/widgets/home_page_widgets/home_screen_drawer.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_consigliati_card.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_events_card.dart';
import 'package:mgs_app2/widgets/home_page_widgets/sort_of_app_bar.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_personal_home_raw.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final EventFirestore eventFirestore = EventFirestore();
  late Future<List<EventModel>> retrieveEvents;
  late Future<List<EventModel>> retrievePersonalEvents;

  @override
  void initState() {
    super.initState();

    retrieveEvents = eventFirestore.retrieveEvents();
    retrievePersonalEvents = eventFirestore.retrievePersonalEvents();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: _globalKey,
      drawer: HomePageDrawer(
        appConfig: appConfig,
        height: height,
        width: width,
        onEventCreation: onEventCreation,
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SortOfAppBar(
                    iconData: Icons.grid_view_rounded,
                    appConfig: appConfig,
                    globalKey: _globalKey,),
                EventiDelMeseReminder(),
                MyPersonalHomeRow(
                  appConfig: appConfig,
                  width: width,
                  height: height,
                  titolo: 'Consigliati',
                  futureEvents: eventFirestore.retrieveEvents(),
                ),
                SizedBox(
                  height: height * 0.23,
                  child: FutureBuilder(
                      future: retrieveEvents,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<EventModel>> snap) {
                        if (snap.connectionState != ConnectionState.done) {
                          return Center(
                            child: CupertinoActivityIndicator(
                              color: appConfig.getTheme().secondaryHeaderColor,
                            ),
                          );
                        }

                        if (snap.data == null || snap.data!.isEmpty) {
                          //TODO mettere una scritta 'nessun evento'
                          return SizedBox(
                            child: Text('Nessun evento'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: math.min(snap.data!.length, 3),
                          itemBuilder: (BuildContext context, int index) {
                            EventModel event = snap.data![index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.7, end: 1.0),
                              duration:
                                  Duration(milliseconds: 300 + index * 100),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: MyConsigliatiCard(
                                appConfig: appConfig,
                                height: height,
                                width: width,
                                event: event,
                              ),
                            );
                          },
                        );
                      }),
                ),
                MyPersonalHomeRow(
                  appConfig: appConfig,
                  width: width,
                  height: height,
                  futureEvents: eventFirestore.retrievePersonalEvents(),
                  titolo: 'I miei eventi',
                ),
                FutureBuilder(
                    future: retrievePersonalEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventModel>> snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: appConfig.getTheme().secondaryHeaderColor,
                          ),
                        );
                      }

                      if (snap.data == null || snap.data!.isEmpty) {
                        //TODO mettere una scritta 'nessun evento'
                        return SizedBox(
                          child: Text('Nessun evento'),
                        );
                      }

                      return SizedBox(
                        height: height * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: math.min(snap.data!.length, 3),
                          itemBuilder: (BuildContext context, int index) {
                            EventModel event = snap.data![index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.7, end: 1.0),
                              duration:
                                  Duration(milliseconds: 300 + index * 100),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: MyEventsCard(
                                appConfig: appConfig,
                                height: height,
                                width: width,
                                event: event,
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEventCreation(EventModel? event) {
    if (event == null) {
      return;
    }

    Navigator.of(context).pop();

    SnackBarStyle snackBarStyle = SnackBarStyle(context, _globalKey);

    snackBarStyle.showSnackBar('Evento creato correttamente');

    setState(() {
      retrievePersonalEvents = eventFirestore.retrievePersonalEvents();
    });
  }

  List<Widget> buildEventsWidget(List<EventModel> events, AppConfig appConfig) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Widget> widgets = [];

    for (EventModel event in events) {
      widgets.add(
        MyConsigliatiCard(
          appConfig: appConfig,
          height: height,
          width: width,
          event: event,
        ),
      );
    }

    return widgets;
  }
}
