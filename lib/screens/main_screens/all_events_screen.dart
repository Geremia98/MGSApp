import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/local/favorite_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

import '../../models/event_firestore.dart';
import '../../models/event_model.dart';
import '../add_event/add_event_screen.dart';
import 'event_screen.dart';

class AllEventsScreen extends StatefulWidget {
  final String titolo;
  final bool isManage;
  final Future<List<EventModel>> futureEvents;

  const AllEventsScreen(
      {super.key, required this.futureEvents, this.isManage = false, required this.titolo});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  late Future<List<EventModel>> futureEvents;
  final ScrollController _scrollController = ScrollController();
  String filter = '';
  bool titleShowedInAppbar = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, EventModel?> editedEvents = {};

  @override
  void initState() {
    super.initState();
    futureEvents = widget.futureEvents;
    _scrollController.addListener(onScroll);
  }

  void onScroll() {

    if (!mounted) return;

    double currentScroll = _scrollController.position.pixels;

    if (currentScroll > 40 && !titleShowedInAppbar ) {
      setState(() {
        titleShowedInAppbar = true;
      });
      return;
    }

    if (currentScroll <= 40 && titleShowedInAppbar) {
      setState(() {
        titleShowedInAppbar = false;
      });
      return;
    }
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
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GoBackButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context, editedEvents.keys.isEmpty ? false : true),
                appConfig: appConfig,
                title: titleShowedInAppbar ? widget.titolo : '',
              ),
              Expanded(
                child: FutureBuilder<List<EventModel>>(
                  future: futureEvents,
                  builder: (context, snap) {


                    if (snap.hasError) {
                      return Center(child: Text('Errore durante il caricamente degli eventi'));
                    }

                    if (snap.connectionState == ConnectionState.done && (!snap.hasData || snap.data!.isEmpty)) {
                      return Center(child: Text('Nessun evento trovato'));
                    }

                    final allEvents = snap.data ?? [];

                    print("setted");

                    for (final entry in editedEvents.entries) {
                      final id = entry.key;
                      final edited = entry.value;

                      final index = allEvents.indexWhere((e) => e.id == id);
                      if (index != -1) {
                        if (edited == null) {
                          allEvents.removeAt(index);
                        } else {
                          print("set edited");
                          print(edited!.title);
                          allEvents[index] = edited;
                        }
                      }
                    }

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
          return start
                  .isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
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

  void onEventChange(String id, EventModel? event) {
    setState(() {
      editedEvents[id] = event;
    });
  }

  Widget buildPage(List<EventModel> events) {
    //TODO sarebbe da aggiungere shimmer anche qua
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Set<int> animatedIndexes = {};

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: MyPersonalRow(
            width: width,
            titolo: widget.titolo,
            height: height,
            count: events.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: height * 0.02,
          ),
        ),
        if (!widget.isManage)SliverPersistentHeader(
          pinned: true,
          delegate: _SliverTabBarDelegate(
            ButtonRow(
              height: height,
              width: width,
              coloreBottonePremuto: ThemeData().highlightColor,
              sortFilter: onFilter,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                      dataInizio:
                      DateFormat('dd-MM-yyyy hh:mm').format(event.start!),
                      onFavouriteChange: onFavouriteChange,
                      index: index,
                      isManage: widget.isManage,
                      event: event,
                      scaffoldKey: scaffoldKey,
                      onEventChange: onEventChange,
                    ),
                  );
                },
            childCount: events.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
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
    required this.isManage,
    required this.event,
    required this.scaffoldKey,
    required this.onEventChange,
  });

  final bool isManage;
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
  final EventModel event;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(String id, EventModel?) onEventChange;

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
        //margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.only(
          //horizontal: 0,
          top: 20,
        ),
        decoration: BoxDecoration(
            /*borderRadius: BorderRadius.all(Radius.circular(widget.width * 0.02)),
          border: getCustomBorder(
            appConfig: appConfig,
            width: 0.5,
          ),*/
            ),
        child: Stack(
          children: [
            if (widget.isManage)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

                    final RelativeRect position = RelativeRect.fromLTRB(
                      overlay.size.width - (buttonPosition.dx + button.size.width), // distanza dal lato destro
                      buttonPosition.dy, // distanza dall’alto
                      0, // attaccato al bordo destro
                      overlay.size.height - buttonPosition.dy - button.size.height, // distanza dal basso
                    );


                    showMenu<String>(
                      context: context,
                      color: appConfig.getTheme().scaffoldBackgroundColor,
                      position: position,

                      items: [
                        PopupMenuItem(
                          height: kMinInteractiveDimension - 5,
                          onTap: editEvent,
                          value: 'edit',
                          child: Text('Modifica',
                              style: textStyleTextField(context)),
                        ),
                        PopupMenuItem(
                          height: kMinInteractiveDimension - 5,
                          onTap: deleteEvent,
                          value: 'delete',
                          child: Text('Elimina',
                              style: textStyleTextField(context)
                                  .copyWith(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                  child: Icon(
                    Icons.more_vert, // Icona simile a quella mostrata
                    size: 22, // Dimensione dell'icona
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
              ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: widget.width * 0.3,
                      width: widget.width * 0.3,
                      margin: EdgeInsets.only(right: 15),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.width * 0.01)),
                        child: widget.image == null ||
                                widget.image!.downloadUrl == null
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: widget.height * 0.007),
                            child: Text(
                              widget.titolo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleEventCardTitle(context),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: widget.width * 0.02),
                                  child: Icon(
                                    size: 14,
                                    Icons.place_outlined,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.luogo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleEventCardSubtitle(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: widget.width * 0.02),
                                  child: Icon(
                                    size: 14,
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.dataInizio,
                                  style: textStyleEventCardSubtitle(context),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                ParticipantBubbles(
                                    participants: widget.participants),
                                if (widget.isManage)
                                  SizedBox(height: 40,),
                                if (!widget.isManage)Container(
                                  margin:
                                      EdgeInsets.only(left: widget.width * 0.001),
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
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: appConfig.getTheme().highlightColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }



  void deleteEvent() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmEventDialog(
        event: widget.event,
        // il tuo EventModel
        title: 'Eliminare evento?',
        subtitle:
        'Sei sicuro di voler eliminare l\'evento "${widget.event.title}"? Questa azione non può essere annullata.',
        cancel: 'Annulla',
        confirm: 'Elimina',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () async {
          final SnackBarStyle snackBarStyle = SnackBarStyle(context, widget.scaffoldKey);

          Navigator.of(context).pop();

          final EventFirestore eventFirestore = EventFirestore();
          eventFirestore.deleteEvent(widget.event);

          snackBarStyle.showSnackBar('Evento eliminato');

          widget.onEventChange(widget.event.id, null);
        },
      ),
    );
  }

  void editEvent() async {
    Object? value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          event: widget.event,
        ),
      ),
    );

    if (value is EventModel) {
      widget.onEventChange(widget.event.id, value);
    }
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
    final AppConfig appConfig = AppConfig(context);

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
          color: appConfig.getTheme().secondaryHeaderColor,
          size: 22,
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
          top: height * 0.02, left: width * 0.008, right: width * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titolo, style: textStyleTitle(context)),
          count == -1
              ? SizedBox()
              : Row(
                  children: [
                    Text('${count} event${count == 1 ? 'o' : 'i'}',
                        style: textStyleSubtitle(context)),
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
      height: 50,
      padding: EdgeInsets.only(
          left: widget.width * 0.008, right: widget.width * 0.008, top: 10, bottom: 10),
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
                ? appConfig.getTheme().highlightColor
                : Theme.of(context).scaffoldBackgroundColor,
            // Colore di sfondo
            borderRadius:
                BorderRadius.circular(widget.width * 0.02), // Bordi arrotondati
            border: getCustomBorder(
              appConfig: appConfig,
              width: 1,
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
                        style: textStyleTextField(context),
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
                    style: textStyleTextField(context),
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

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _filters;

  _SliverTabBarDelegate(this._filters);

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _filters,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
