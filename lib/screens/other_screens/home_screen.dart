import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as i;
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/screens/other_screens/all_events_screen.dart';
import 'package:mgs_app2/screens/other_screens/event_screen.dart';
import 'package:mgs_app2/screens/other_screens/personal_screen.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../main.dart';
import '../../models/event_model.dart';
import '../../services/firebase/auth.dart';
import '../../utilities/theme_colors.dart';
import '../../wrapper.dart';
import '../add_event/add_event_screen.dart';
import 'FAQ_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late Future<List<EventModel>> retrieveEvents;
  late Future<List<EventModel>> retrievePersonalEvents;

  @override
  void initState() {
    super.initState();
    EventFirestore eventFirestore = EventFirestore();

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
      drawer: MyAppDrawer(
        height: height,
        width: width,
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
                    globalKey: _globalKey,
                    width: width,
                    profileImage: 'assets/images/male.jpg'),
                EventiDelMeseReminder(
                    width: width,
                    coloreReminder: appConfig.getTheme().highlightColor),
                MyPersonalRow(
                    width: width, height: height, titolo: 'Consigliati'),
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
                            return MyConsigliatiCard(
                              height: height,
                              width: width,
                              image: 'assets/images/party.png',
                              date: formatDate(event.start),
                              title: event.title,
                            );
                          },
                        );
                      }),
                ),
                MyPersonalRow(
                    width: width, height: height, titolo: 'I miei eventi'),
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
                            return MyEventCard(
                              height: height,
                              width: width,
                              image: 'assets/images/party.png',
                              dataInizio: formatDate(event.start),
                              titolo: event.title,
                              luogo: event.location,
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

  String formatDate(DateTime? date) {

    i.Intl.defaultLocale = 'it_IT';

    return i.DateFormat('d MMMM').format(date ?? DateTime.now());

  }

  List<Widget> buildEventsWidget(List<EventModel> events) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Widget> widgets = [];

    for (EventModel event in events) {
      widgets.add(
        MyConsigliatiCard(
          height: height,
          width: width,
          image: 'assets/images/party.png',
          date: DateFormat('dd/MM/YYYY').format(event.start ?? DateTime.now()),
          title: event.title,
        ),
      );
    }

    return widgets;
  }
}

class EventiDelMeseReminder extends StatelessWidget {
  const EventiDelMeseReminder({
    super.key,
    required this.width,
    required this.coloreReminder,
  });

  final double width;
  final Color coloreReminder;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);

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
          width: width * 0.0015,
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
                  fontSize: width * 0.04,
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

class SortOfAppBar extends StatelessWidget {
  const SortOfAppBar({
    super.key,
    required this.globalKey,
    required this.width,
    required this.profileImage,
  });

  final GlobalKey<ScaffoldState> globalKey;
  final double width;
  final String profileImage;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => {
            debugPrint('bottone menu premuto'),
            globalKey.currentState!.openDrawer()
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(width * 0.02), // Bordi arrotondati
              border: getCustomBorder(
                width: width * 0.002,
                appConfig: appConfig,
              ),
            ),
            child: Icon(
              Icons.grid_view_rounded, // Icona simile a quella mostrata
              size: width * 0.08, // Dimensione dell'icona
            ),
          ),
        ),
        const Expanded(
            child: SizedBox(
          width: 10,
        )),
        Container(
          width: width * 0.12,
          height: width * 0.12,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(profileImage),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(width * 0.5)),
            border: Border.all(
              color: Colors.white,
              width: width * 0.001,
            ),
          ),
        ),
      ],
    );
  }
}

class MyPersonalRow extends StatelessWidget {
  const MyPersonalRow({
    super.key,
    required this.width,
    required this.titolo,
    required this.height,
  });

  final double width;
  final double height;
  final String titolo;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);
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
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                'Vedi tutti',
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllEventsScreen(
                              titolo: 'titolo',
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
                      width: width * 0.0015,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    // Icona simile a quella mostrata
                    size: width * 0.05, // Dimensione dell'icona
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

class MyConsigliatiCard extends StatelessWidget {
  const MyConsigliatiCard({
    super.key,
    required this.height,
    required this.width,
    required this.date,
    required this.image,
    required this.title,
  });

  final double height;
  final double width;
  final String title;
  final String date;
  final String image;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(),
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
                appConfig: appConfig, width: width * 0.0015),
          ),
          child: Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                )),
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
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04),
                        ),
                        Text(
                          date,
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

class MyEventCard extends StatelessWidget {
  const MyEventCard({
    super.key,
    required this.height,
    required this.width,
    required this.image,
    required this.titolo,
    required this.luogo,
    required this.dataInizio,
  });

  final double height;
  final double width;
  final String image;
  final String titolo;
  final String luogo;
  final String dataInizio;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventScreen()),
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
            width: width * 0.0015,
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
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
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
                      titolo,
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
                          luogo,
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
                          dataInizio,
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

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ThemeProvider>(context);

    final AppConfig appConfig = AppConfig(context);

    return Drawer(
      width: width * 0.7,
      child: Container(
        padding: EdgeInsets.only(
            top: height * 0.1, left: width * 0.08, right: width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.arrow_back_rounded,
              title: 'Menù',
              isTitle: true,
              onTap: () => Navigator.pop(
                context,
              ),
            ),
            Divider(
              height: height * 0.06,
              thickness: width * 0.001,
            ),
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.person_3_rounded,
              title: 'Info personali',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
              ),
            ),
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.add,
              title: 'Crea evento',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEventScreen(),
                ),
              ),
            ),
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.bug_report_rounded,
              title: 'Report a bug',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              ),
            ),
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.add,
              title: 'FAQ',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: width * 0.05,
                      left: width * 0.01,
                      top: height * 0.01,
                      bottom: height * 0.01),
                  child: GestureDetector(
                    onTap: () => {
                    BrightnessManager().toggleBrightness()
                      //provider.toggleTheme()
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.012),
                      decoration: BoxDecoration(
                        // Colore di sfondo
                        borderRadius: BorderRadius.circular(
                            width * 0.02), // Bordi arrotondati
                        border: getCustomBorder(
                          appConfig: appConfig,
                          width: width * 0.0015,
                        ),
                      ),
                      child: Icon(
                          size: width * 0.06,
                          Icons
                              .dark_mode //provider.isLight ? Icons.dark_mode : Icons.sunny, // Dimensione dell'icona
                          ),
                    ),
                  ),
                ),
                Text(
                  'asd', //provider.isLight ? 'Night Mode' : 'Day Mode',
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                ),
              ],
            ),
            Divider(
              height: height * 0.06,
              thickness: width * 0.001,
            ),
            ItemForMenu(
              height: height,
              width: width,
              icon: Icons.logout_rounded,
              title: 'Log out',
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }

  void logout(context) async {
    final FirebaseAuthService authService = FirebaseAuthService();
    await authService.signOut(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Wrapper(),
      ),
    );
  }
}

class ItemForMenu extends StatelessWidget {
  const ItemForMenu({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isTitle = false,
  });

  final double height;
  final double width;
  final IconData icon;
  final String title;
  final void Function() onTap;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * 0.05, left: width * 0.01),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(width * 0.012),
                decoration: BoxDecoration(
                  // Colore di sfondo
                  borderRadius:
                      BorderRadius.circular(width * 0.02), // Bordi arrotondati
                  border: getCustomBorder(
                    appConfig: appConfig,
                    width: width * 0.0015,
                  ),
                ),
                child: Icon(
                  size: width * 0.06,
                  icon, // Dimensione dell'icona
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isTitle ? width * 0.05 : width * 0.04,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
