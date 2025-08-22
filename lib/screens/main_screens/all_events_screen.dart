import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';

import '../../models/event_model.dart';
import 'event_screen.dart';

class AllEventsScreen extends StatefulWidget {
  final String titolo;
  final Future<List<EventModel>> futureEvents;

  const AllEventsScreen(
      {super.key, required this.futureEvents, required this.titolo});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  late Future<List<EventModel>> futureEvents;

  @override
  void initState() {
    super.initState();

    futureEvents = widget.futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          // Colore di sfondo
                          borderRadius: BorderRadius.circular(
                              width * 0.02), // Bordi arrotondati
                          border: Border.all(
                            width: width * 0.002, // Larghezza del bordo
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          // Icona simile a quella mostrata
                          size: 24.0, // Dimensione dell'icona
                        ),
                      ),
                    ),
                    /*Container(
                      width: width * 0.12,
                      height: width * 0.12,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/male.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.5)),
                        border: Border.all(
                          color: Colors.white,
                          width: width * 0.001,
                        ),
                      ),
                    ),*/
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: futureEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventModel>> snap) {
                      return buildPage(snap.data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildPage(List<EventModel>? events) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Set<int> animatedIndexes = {};

    return Column(
      children: [
        MyPersonalRow(
          width: width,
          titolo: widget.titolo,
          height: height,
          count: events == null ? -1 : events.length,
        ),
        events == null
            ? SizedBox()
            : ButtonRow(
                height: height,
                width: width,
                coloreBottonePremuto: ThemeData().highlightColor,
              ),
        events == null
            ? SizedBox()
            : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events!.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final firstTime = !animatedIndexes.contains(index);
                    if (firstTime) animatedIndexes.add(index);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventScreen(
                              event: events.elementAt(index),
                            ),
                          ),
                        );
                      },
                      child: MyEventCard(
                        triggerAnimation: firstTime,
                        height: height,
                        width: width,
                        image: events!.elementAt(index).image,
                        titolo: events!.elementAt(index).title,
                        luogo: events!.elementAt(index).location,
                        dataInizio: DateFormat('dd-MM-yyyy hh:mm')
                            .format(events!.elementAt(index).start!),
                        index: index,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class MyEventCard extends StatefulWidget {
  const MyEventCard({
    super.key,
    required this.height,
    required this.width,
    required this.image,
    required this.titolo,
    required this.luogo,
    required this.dataInizio,
    required this.index,
    required this.triggerAnimation,
  });

  final bool triggerAnimation;
  final double height;
  final double width;
  final ImageModel? image;
  final String titolo;
  final String luogo;
  final String dataInizio;
  final int index;

  @override
  State<MyEventCard> createState() => _MyEventCardState();
}

class _MyEventCardState extends State<MyEventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.triggerAnimation) {
      Future.delayed(Duration(milliseconds: widget.index * 50), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      // se già eseguita, vai direttamente allo stato finale
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: widget.height * 0.005),
        padding: EdgeInsets.symmetric(
          horizontal: widget.width * 0.025,
          vertical: widget.width * 0.025,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.width * 0.02)),
          border: getCustomBorder(
            appConfig: appConfig,
            width: widget.width * 0.0015,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: widget.width * 0.3,
              width: widget.width * 0.3,
              margin: EdgeInsets.only(right: widget.width * 0.04),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.width * 0.01)),
                child: widget.image == null || widget.image!.downloadUrl == null
                    ? Image.asset(
                        'assets/images/ballo.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.image!.downloadUrl!,
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
                    margin: EdgeInsets.only(bottom: widget.height * 0.007),
                    child: Text(
                      widget.titolo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.width * 0.04,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(right: widget.width * 0.02),
                          child: Icon(
                            size: widget.width * 0.035,
                            Icons.place_outlined,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.luogo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.width * 0.035,
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
                          padding: EdgeInsets.only(right: widget.width * 0.02),
                          child: Icon(
                            size: widget.width * 0.035,
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.dataInizio,
                          style: TextStyle(
                            fontSize: widget.width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: widget.height * 0.007),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            PersonForStack(
                              height: widget.height,
                              width: widget.width,
                              image: 'assets/images/female.jpg',
                              borderColor: Colors.white,
                              boxcolor: Colors.amber,
                            ),
                            Positioned(
                              left: widget.width * 0.06,
                              child: PersonForStack(
                                height: widget.height,
                                width: widget.width,
                                image: 'assets/images/male.jpg',
                                borderColor: Colors.white,
                                boxcolor: Colors.amber,
                              ),
                            ),
                            Positioned(
                              left: widget.width * 0.06 * 2,
                              child: Container(
                                width: widget.width * 0.08,
                                height: widget.width * 0.08,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: widget.width * 0.005,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '15+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.width * 0.03,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: widget.width * 0.001),
                          child: LikeButton(width: widget.width),
                        )
                      ],
                    ),
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

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLike;

  @override
  void initState() {
    _isLike = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            _isLike = !_isLike;
          });
        },
        icon: Icon(
          _isLike ? Icons.favorite_rounded : Icons.favorite_outline,
          size: widget.width * 0.06,
        ));
  }
}

class PersonForStack extends StatelessWidget {
  const PersonForStack({
    required this.borderColor,
    required this.boxcolor,
    required this.height,
    required this.image,
    required this.width,
    super.key,
  });

  final double height;
  final double width;
  final String image;
  final Color boxcolor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.08,
      height: width * 0.08,
      decoration: BoxDecoration(
        color: boxcolor,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: borderColor,
          width: width * 0.005,
        ),
      ),
    );
  }
}

class MyPersonalRow extends StatelessWidget {
  const MyPersonalRow({
    super.key,
    required this.width,
    required this.titolo,
    required this.height,
    required this.count,
  });

  final double width;
  final int count;
  final double height;
  final String titolo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: height * 0.02,
          bottom: height * 0.01,
          left: width * 0.008,
          right: width * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titolo,
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          count == -1
              ? SizedBox()
              : Row(
                  children: [
                    Text(
                      '${count} event${count == 1 ? 'o' : 'i'}',
                      style: TextStyle(
                        fontSize: width * 0.045,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    required this.height,
    required this.width,
    required this.coloreBottonePremuto,
  });

  final double height;
  final double width;
  final Color coloreBottonePremuto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: height * 0.01, left: width * 0.008, right: width * 0.008),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterButton(
              coloreBottonePremuto: coloreBottonePremuto,
              label: 'Preferiti',
              width: width,
            ),
            SizedBox(width: 8),
            FilterButton(
              coloreBottonePremuto: coloreBottonePremuto,
              label: 'Oggi',
              width: width,
            ),
            SizedBox(width: 8), // Spacing between buttons
            FilterButton(
              coloreBottonePremuto: coloreBottonePremuto,
              label: 'Questa settimana',
              width: width,
            ),
            SizedBox(width: 8), // Spacing between button
            FilterButton(
              coloreBottonePremuto: coloreBottonePremuto,
              label: 'Questo mese',
              width: width,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatefulWidget {
  const FilterButton(
      {super.key,
      required this.coloreBottonePremuto,
      required this.label,
      required this.width});

  final Color coloreBottonePremuto;
  final String label;
  final double width;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_onButtonPressed()},
      child: Container(
          padding: EdgeInsets.all(widget.width * 0.01),
          decoration: BoxDecoration(
            color: _isSelected
                ? widget.coloreBottonePremuto
                : Theme.of(context).scaffoldBackgroundColor,
            // Colore di sfondo
            borderRadius:
                BorderRadius.circular(widget.width * 0.02), // Bordi arrotondati
            border: Border.all(
              // Colore del bordo
              width: widget.width * 0.0015, // Larghezza del bordo
            ),
          ),
          child: _isSelected
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.width * 0.015),
                      child: Text(
                        widget.label,
                        style: TextStyle(fontSize: widget.width * 0.04),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: widget.width * 0.015),
                      child: GestureDetector(
                        onTap: () => {_onButtonPressed()},
                        child: Text(
                          'X',
                          style: TextStyle(
                            fontSize: widget.width * 0.04,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: widget.width * 0.015),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.width * 0.037,
                    ),
                  ),
                )),
    );
  }

  _onButtonPressed() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }
}
