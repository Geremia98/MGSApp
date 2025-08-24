import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/buttons.dart';

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
  List<EventModel> filteredEvents = [];
  List<EventModel> events = [];
  String filter = '';
  bool alreadyLoaded = false;

  @override
  void initState() {
    super.initState();

    futureEvents = widget.futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GoBackButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                      appConfig: appConfig,
                    ),
                Expanded(
                  child: FutureBuilder(
                    future: futureEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventModel>> snap) {
                      if (snap.data != null) {
                        events = snap.data!;
                      }

                      return buildPage(snap.data == null
                          ? null
                          : filter.isEmpty
                              ? events
                              : filteredEvents);
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

  void onFilter(String value) {
    if (value.isEmpty) {
      setState(() {
        filter = '';
      });
      return;
    }

    switch (value) {
      case 'day':
        setState(() {
          filter = 'day';
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          filteredEvents = events.where((e) {
            final start = e.start!;
            final eventDay = DateTime(start.year, start.month, start.day);
            return eventDay == today;
          }).toList();
        });
        return;

      case 'week':
        setState(() {
          filter = 'week';
          final now = DateTime.now();
          // Trova il lunedì della settimana corrente
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 7));

          filteredEvents = events.where((e) {
            final start = e.start!;
            return start.isAfter(startOfWeek) && start.isBefore(endOfWeek);
          }).toList();
        });
        return;

      case 'month':
        setState(() {
          filter = 'month';
          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);
          final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

          filteredEvents = events.where((e) {
            final start = e.start!;
            return start.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
                start.isBefore(startOfNextMonth);
          }).toList();
        });
        return;

      default:
        return;
    }

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
                sortFilter: onFilter,
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

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    super.key,
    required this.height,
    required this.width,
    required this.coloreBottonePremuto,
    required this.sortFilter,
  });

  final double height;
  final double width;
  final Color coloreBottonePremuto;
  final void Function(String) sortFilter;

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {

  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = '';
  }
  @override
  Widget build(BuildContext context) {

    print(selectedFilter);

    return Container(
      padding: EdgeInsets.only(
          bottom: widget.height * 0.01, left: widget.width * 0.008, right: widget.width * 0.008),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterButton(
              coloreBottonePremuto: widget.coloreBottonePremuto,
              label: 'Preferiti',
              width: widget.width,
              onTap: () {
                widget.sortFilter('fav');
                setState(() {
                  selectedFilter = 'fav';
                });
              },
              onRemove: () {
                widget.sortFilter('');
                setState(() {
                  selectedFilter = '';
                });
              },
              isSelected: selectedFilter == 'fav',
            ),
            SizedBox(width: 8),
            FilterButton(
              coloreBottonePremuto: widget.coloreBottonePremuto,
              label: 'Oggi',
              width: widget.width,
              onTap: () {
                widget.sortFilter('day');
                setState(() {
                  print("setted");
                  selectedFilter = 'day';

                });
              },
              onRemove: () {
                widget.sortFilter('');
                setState(() {
                  selectedFilter = '';
                });
              },
              isSelected: selectedFilter == 'day',
            ),
            SizedBox(width: 8), // Spacing between buttons
            FilterButton(
              coloreBottonePremuto: widget.coloreBottonePremuto,
              label: 'Questa settimana',
              width: widget.width,
              onTap: () {
                widget.sortFilter('week');
                setState(() {
                  selectedFilter = 'week';
                });
              },
              onRemove: () {
                widget.sortFilter('');
                setState(() {
                  selectedFilter = '';
                });
              },
              isSelected: selectedFilter == 'week',
            ),
            SizedBox(width: 8), // Spacing between button
            FilterButton(
              coloreBottonePremuto: widget.coloreBottonePremuto,
              label: 'Questo mese',
              width: widget.width,
              onTap: () {
                widget.sortFilter('month');
                setState(() {
                  selectedFilter = 'month';
                });
              },
              onRemove: () {
                widget.sortFilter('');
                setState(() {
                  selectedFilter = '';
                });
              },
              isSelected: selectedFilter == 'month',
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
      required this.onTap,
      required this.coloreBottonePremuto,
      required this.label,
      required this.onRemove,
        required this.isSelected,
      required this.width});

  final Color coloreBottonePremuto;
  final String label;
  final double width;
  final void Function() onTap;
  final void Function() onRemove;
  final bool isSelected;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);
    return GestureDetector(
      onTap: () => {_onButtonPressed()},
      child: Container(
          padding: EdgeInsets.all(widget.width * 0.01),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.coloreBottonePremuto
                : Theme.of(context).scaffoldBackgroundColor,
            // Colore di sfondo
            borderRadius:
                BorderRadius.circular(widget.width * 0.02), // Bordi arrotondati
            border: getCustomBorder(
                  appConfig: appConfig,
                  width: widget.width * 0.0015,
            ),
          ),
          child: widget.isSelected
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.width * 0.015),
                      child: Text(
                        widget.label,
                        style: TextStyle(fontSize: widget.width * 0.037),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: widget.width * 0.015),
                      child: GestureDetector(
                        onTap: () => {_onButtonPressed()},
                        child: Icon(
                          Icons.close,
                          size: 13,
                        )
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

    if (!widget.isSelected) {
      widget.onTap();
    } else {
      widget.onRemove();
    }
  }
}
