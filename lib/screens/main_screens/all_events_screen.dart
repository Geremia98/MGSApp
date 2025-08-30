import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/local/favorite_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';

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
  String filter = '';

  @override
  void initState() {
    super.initState();
    futureEvents = widget.futureEvents;
  }

  void onFavouriteChange(String eventId, bool isFavourite) {
    setState(() {
      futureEvents = futureEvents.then((events) {
        final event = events.firstWhere((e) => e.id == eventId);
        event.isFavourite = isFavourite;
        return events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
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
                child: FutureBuilder<List<EventModel>>(
                  future: futureEvents,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('Error loading events'));
                    }
                    if (!snap.hasData || snap.data!.isEmpty) {
                      return Center(child: Text('No events found'));
                    }

                    final allEvents = snap.data!;
                    final filteredEvents = _getFilteredEvents(allEvents);

                    return buildPage(filteredEvents);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<EventModel> _getFilteredEvents(List<EventModel> events) {
    if (filter.isEmpty) {
      return events;
    }
    switch (filter) {
      case 'fav':
        return events.where((e) => e.isFavourite == true).toList();
      case 'day':
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        return events.where((e) {
          final start = e.start!;
          final eventDay = DateTime(start.year, start.month, start.day);
          return eventDay == today;
        }).toList();
      case 'week':
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return events.where((e) {
          final start = e.start!;
          return start.isAfter(startOfWeek) && start.isBefore(endOfWeek);
        }).toList();
      case 'month':
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
        return events.where((e) {
          final start = e.start!;
          return start.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
              start.isBefore(startOfNextMonth);
        }).toList();
      default:
        return events;
    }
  }

  void onFilter(String value) {
    setState(() {
      filter = value;
    });
  }

  Widget buildPage(List<EventModel> events) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Set<int> animatedIndexes = {};

    return Column(
      children: [
        MyPersonalRow(
          width: width,
          titolo: widget.titolo,
          height: height,
          count: events.length,
        ),
        ButtonRow(
          height: height,
          width: width,
          coloreBottonePremuto: ThemeData().highlightColor,
          sortFilter: onFilter,
        ),
        Expanded(
          child: ListView.builder(
            cacheExtent: 3000.0,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              final firstTime = !animatedIndexes.contains(index);
              if (firstTime) animatedIndexes.add(index);
              final event = events[index];

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
                child: MyEventCard(
                  triggerAnimation: firstTime,
                  height: height,
                  width: width,
                  eventId: event.id,
                  image: event.image,
                  titolo: event.title,
                  luogo: event.location,
                  isLike: event.isFavourite,
                  participants: event.participants,
                  dataInizio: DateFormat('dd-MM-yyyy hh:mm').format(event.start!),
                  onFavouriteChange: onFavouriteChange,
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
    required this.eventId,
    required this.dataInizio,
    required this.index,
    required this.triggerAnimation,
    required this.isLike,
    required this.onFavouriteChange,
    required this.participants,
  });

  final bool triggerAnimation;
  final double height;
  final double width;
  final ImageModel? image;
  final String titolo;
  final String luogo;
  final String dataInizio;
  final String eventId;
  final int index;
  final bool isLike;
  final void Function(String, bool) onFavouriteChange;
  final List<String> participants;

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
                    : CachedNetworkImage(
                        imageUrl: widget.image!.downloadUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 600,
                        memCacheHeight: 400,
                        placeholder: (context, url) => ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                          child: Image.asset(
                            'assets/images/ballo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/ballo.png',
                          fit: BoxFit.cover,
                        ),
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
                        ParticipantBubbles(participants: widget.participants),
                        Container(
                          margin: EdgeInsets.only(left: widget.width * 0.001),
                          child: LikeButton(
                            width: widget.width,
                            eventId: widget.eventId,
                            isLike: widget.isLike,
                            onFavouriteChange: widget.onFavouriteChange,
                          ),
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

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.width,
    required this.eventId,
    required this.isLike,
    required this.onFavouriteChange,
  });

  final double width;
  final String eventId;
  final bool isLike;
  final void Function(String, bool) onFavouriteChange;

  @override
  Widget build(BuildContext context) {
    final FavoritesService favoritesService = FavoritesService();

    return IconButton(
        onPressed: () {
          final newIsLike = !isLike;
          onFavouriteChange(eventId, newIsLike);
          if (newIsLike) {
            favoritesService.addFavorite(eventId);
          } else {
            favoritesService.removeFavorite(eventId);
          }
        },
        icon: Icon(
          isLike ? Icons.favorite_rounded : Icons.favorite_outline,
          size: width * 0.06,
        ));
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
    return Container(
      padding: EdgeInsets.only(
          bottom: widget.height * 0.01,
          left: widget.width * 0.008,
          right: widget.width * 0.008),
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
                          )),
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
