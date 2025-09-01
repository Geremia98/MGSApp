import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/credit_card_screen.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';
import 'package:mgs_app2/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/event_model.dart';
import '../../models/participant_model.dart';
import '../../utilities/my_theme_data.dart';
import '../add_event/add_event_screen.dart';

class EventScreen extends StatefulWidget {
  final EventModel event;

  EventScreen({required this.event, super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isLoading = false;
  double _extraHeight = 0.0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  bool reloadAncestor = false;
  late EventModel event;

  @override
  void initState() {
    super.initState();

    event = widget.event;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(-200);
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: height * 1.2,
          ),
          Container(
            height: height * 0.5 + _extraHeight,
            child: event.image == null || event.image!.downloadUrl == null
                ? Image.asset(
                    'assets/images/ballo.png',
                    fit: BoxFit.cover,
                  )
                : Hero(
                    tag: 'event-image-${event.id}',
                    child: CachedNetworkImage(
                      imageUrl: event.image!.downloadUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 1920,
                      memCacheHeight: 1080,
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
          event.participants.contains(UserModel.uid)
              ? Positioned(
                  left: 0,
                  right: 0,
                  top: height * 0.08,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1.0),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: width * 0.02 + 2,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          border: Border.all(
                            width: 0.5,
                            color: appConfig.getTheme().secondaryHeaderColor,
                          ),
                          color: Color(0xFF388E3C),
                        ),
                        child: Text(
                          'Iscritto',
                          style: textStyleEventCardTitle(context),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Positioned(
            top: height * 0.08,
            left: width * 0.05,
            child: GestureDetector(
              onTap: () => {
                Navigator.pop(context, reloadAncestor),
              },
              child: Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  // Colore di sfondo
                  color: appConfig.getTheme().scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(width * 0.02), // Bordi arrotondati
                  border: Border.all(
                    width: 0.5, // Larghezza del bordo
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_rounded, // Icona simile a quella mostrata
                  size: 24.0, // Dimensione dell'icona
                  color: appConfig.getTheme().secondaryHeaderColor,
                ),
              ),
            ),
          ),
          if (UserModel.uid == event.creatorUid)
            Positioned(
              top: height * 0.08,
              right: width * 0.05,
              child: GestureDetector(
                onTap: () async {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;

                  showMenu<String>(
                    context: context,
                    color: appConfig.getTheme().scaffoldBackgroundColor,
                    position: RelativeRect.fromLTRB(
                      overlay.size.width - width * 0.15, // distanza da destra
                      height * 0.13, // distanza dall’alto
                      width * 0.05, // margine destro
                      0,
                    ),
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
                child: Container(
                  padding: EdgeInsets.all(width * 0.02),
                  decoration: BoxDecoration(
                    // Colore di sfondo
                    color: appConfig.getTheme().scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(width * 0.02),
                    border: Border.all(
                      width: 0.5,
                      color: appConfig.getTheme().secondaryHeaderColor,
                    ),
                  ),
                  child: Icon(
                    Icons.more_vert, // Icona simile a quella mostrata
                    size: 24, // Dimensione dell'icona
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
              ),
            ),
          Positioned(
            top: height * 0.4,
            width: width,
            height: height * 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification.metrics.outOfRange &&
                      scrollNotification.metrics.pixels < 0) {
                    setState(() {
                      _extraHeight = (scrollNotification.metrics.pixels.abs())
                          .clamp(0.0, 200.0);
                    });
                  } else if (scrollNotification is ScrollEndNotification) {
                    // reset gradualmente (puoi animare se vuoi)
                    setState(() {
                      _extraHeight = 0.0;
                    });
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: appConfig.getWidth() * 5,
                          ),
                          child: Text(
                            event.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: textStyleTitle(context),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: appConfig.getWidth() * 5,
                          ),
                          child: Text(
                            event.desc,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
                            style: textStyleSubtitle(context),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.05),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: width * 0.5,
                                child: Column(
                                  children: [
                                    EventDetailBox(
                                      width: width,
                                      height: height,
                                      icon: Icons.calendar_month_rounded,
                                      title: 'Data inizio',
                                      subTitle: DateFormat('dd-MM-yyyy')
                                              .format(event.start!) +
                                          '\n' +
                                          DateFormat('hh:mm')
                                              .format(event.start!),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.location_on_rounded,
                                        title: 'Luogo',
                                        subTitle: event.location),
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Column(
                                  children: [
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.calendar_month_rounded,
                                        title: 'Data fine',
                                        subTitle: DateFormat('dd-MM-yyyy')
                                                .format(event.end!) +
                                            '\n' +
                                            DateFormat('hh:mm')
                                                .format(event.end!)),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.airplane_ticket_rounded,
                                        title: 'Biglietto',
                                        subTitle: event.price == 0
                                            ? 'Gratuito'
                                            : '€ ' +
                                                event.price.toStringAsFixed(2)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        event.creatorUid == UserModel.uid
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: appConfig.getWidth() * 5,
                                    top: 30,
                                    bottom: 30),
                                child: GestureDetector(
                                  onTap: showParticipants,
                                  child: Row(
                                    children: [
                                      ParticipantBubbles(
                                        participants: event.participants,
                                        showText: false,
                                      ),
                                      SizedBox(
                                        width: event.participants.isNotEmpty
                                            ? 10
                                            : 0,
                                      ),
                                      Text('Mostra partecipanti',
                                          style:
                                              textStyleEventCardTitle(context)),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 17,
                                        color: appConfig
                                            .getTheme()
                                            .secondaryHeaderColor,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : event.start!.isBefore(DateTime.now())
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Center(
                                        child: Text(
                                          'Evento terminato',
                                          style:
                                              textStyleEventCardTitle(context)
                                                  .copyWith(color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      )
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: 50,
                                      bottom: 50,
                                    ),
                                    child: ButtonText(
                                      text: !isEventAvailable()
                                          ? 'Non disponibile'
                                          : event.participants.any((userUid) =>
                                                  userUid == UserModel.uid)
                                              ? 'Abbandona'
                                              : 'Partecipa',
                                      onTap: event.participants.any((userUid) =>
                                              userUid == UserModel.uid)
                                          ? leaveEvent
                                          : joinEvent,
                                      isEnabled: !isEventAvailable()
                                          ? false
                                          : event.participants.any((userUid) =>
                                                  userUid == UserModel.uid)
                                              ? true
                                              : isEventAvailable(),
                                      isLoading: isLoading,
                                      color: !isEventAvailable()
                                          ? null
                                          : event.participants.any((userUid) =>
                                                  userUid == UserModel.uid)
                                              ? Colors.red
                                              : null,
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showParticipants() async {
    showDialog(
      context: context,
      fullscreenDialog: true,
      builder: (context) => ParticipantsEventDialog(
        onDeleteParticipant: onDeleteParticipant,
        participants: event.participants,
      ),
    );
  }

  void onDeleteParticipant(String uid) {}

  void deleteEvent() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmEventDialog(
        event: event,
        // il tuo EventModel
        title: 'Eliminare evento?',
        subtitle:
            'Sei sicuro di voler eliminare l\'evento "${event.title}"? Questa azione non può essere annullata.',
        cancel: 'Annulla',
        confirm: 'Elimina',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () async {
          final SnackBarStyle snackBarStyle =
              SnackBarStyle(context, scaffoldKey);
          Navigator.of(context).pop();
          final EventFirestore eventFirestore = EventFirestore();
          eventFirestore.deleteEvent(event);
          snackBarStyle.showSnackBar('Evento eliminato');
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void editEvent() async {
    Object? value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          event: event,
        ),
      ),
    );

    if (value is EventModel) {
      setState(() {
        reloadAncestor = true;
        event = value;
      });
    }
  }

  bool isEventAvailable() {
    if (event.targetGender == EventTargetGender.male &&
        UserModel.gender == UserGender.female) {
      return false;
    }

    if (event.targetGender == EventTargetGender.female &&
        UserModel.gender == UserGender.male) {
      return false;
    }

    if (event.start!.isBefore(DateTime.now())) {
      return false;
    }

    //TODO also include target age

    return true;
  }

  Future<void> leaveEvent() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmEventDialog(
        event: event,
        // il tuo EventModel
        title: 'Abbandonare evento?',
        subtitle:
            'Sei sicuro di voler abbandonare l\'evento "${event.title}"? Verrai risarcito del costo del biglietto e potrai comunque iscriverti nuovamente in seguito.',
        cancel: 'Annulla',
        confirm: 'Conferma',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () async {
          final FirebaseFunctionCaller caller = FirebaseFunctionCaller();
          final SnackBarStyle snackBarStyle =
              SnackBarStyle(context, scaffoldKey);

          setState(() {
            isLoading = true;
          });

          FunctionResponse response = await caller.leaveEvent(event.id);

          if (response.getType() == ResponseType.error) {
            setState(() {
              isLoading = false;
            });
            snackBarStyle.showSnackBar(
                'Impossibile abbandonare l\'evento. Riprova più tardi.');
            return;
          }

          setState(() {
            isLoading = false;
            event.participants.remove(UserModel.uid);
            reloadAncestor = true;
          });

          print("Evento abbandonato");
          snackBarStyle.showSnackBar('Evento abbandonato');
        },
      ),
    );
  }

  Future<void> joinEvent() async {
    final FirebaseFunctionCaller caller = FirebaseFunctionCaller();
    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    if (event.price == 0) {
      setState(() {
        isLoading = true;
      });

      FunctionResponse response = await caller.joinEvent(event.id);

      if (response.getType() == ResponseType.error) {
        snackBarStyle
            .showSnackBar('Impossibile partecipare. Riprova più tardi.');

        setState(() {
          isLoading = false;
        });

        return;
      }

      snackBarStyle.showSnackBar('Evento aggiunto correttamente');

      setState(() {
        event.participants.add(UserModel.uid);
        isLoading = false;
        reloadAncestor = true;
      });

      return;
    }

    String? paymentMethodId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardScreen(),
      ),
    );

    if (paymentMethodId == null || paymentMethodId.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    FunctionResponse response = await caller.joinEvent(event.id,
        paymentMethodId: paymentMethodId ?? '');

    if (response.getType() == ResponseType.error) {
      snackBarStyle.showSnackBar('Impossibile partecipare. Riprova più tardi.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
    });

    snackBarStyle.showSnackBar('Evento aggiunto correttamente');
  }
}

class ConfirmEventDialog extends StatelessWidget {
  final EventModel event;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  final String title;
  final String subtitle;
  final String cancel;
  final String confirm;

  const ConfirmEventDialog({
    Key? key,
    required this.event,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    required this.subtitle,
    required this.cancel,
    required this.confirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: textStyleTitle(context),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: textStyleSubtitle(context),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonText(
                  fixedWidth: 130,
                  text: cancel,
                  onTap: onCancel,
                  color: appConfig.getTheme().highlightColor,
                  textColor: appConfig.getTheme().secondaryHeaderColor,
                ),
                ButtonText(
                  fixedWidth: 130,
                  text: confirm,
                  color: Colors.red,
                  onTap: onCancel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EventDetailBox extends StatelessWidget {
  const EventDetailBox({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final double width;
  final double height;
  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: width * 0.5 - 30,
        decoration: BoxDecoration(
          color: appConfig.getTheme().highlightColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Icon(
                    icon,
                    size: 22,
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: textStyleEventCardTitle(context),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Icon(
                    icon,
                    size: 22,
                    color: Colors.transparent,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: width * 0.5 - 85,
                  child: Text(subTitle,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleEventCardSubtitle(context)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ParticipantsEventDialog extends StatefulWidget {
  final void Function(String) onDeleteParticipant;
  final List<String> participants;

  const ParticipantsEventDialog({
    super.key,
    required this.onDeleteParticipant,
    required this.participants,
  });

  @override
  State<ParticipantsEventDialog> createState() =>
      _ParticipantsEventDialogState();
}

class _ParticipantsEventDialogState extends State<ParticipantsEventDialog> {
  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      child: Container(
        height: appConfig.getHeight() * 60,
        width: appConfig.getWidth() * 90,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Partecipanti ',
                      style: textStyleTitle(context),
                    ),
                    /*TextSpan(
                      text: '(${widget.participants.length})',
                      style: textStyleTitle(context),
                    ),*/
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.participants.length,
                itemBuilder: (BuildContext context, int index) {
                  final participant = widget.participants[index];
                  return buildParticipant(
                      participant, index == widget.participants.length - 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildParticipant(String uid, bool isLast) {
    final UserFirestore userFirestore = UserFirestore();
    final AppConfig appConfig = AppConfig(context);

    return FutureBuilder(
      future: userFirestore.getParticipant(uid),
      builder:
          (BuildContext context, AsyncSnapshot<ParticipantModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == null) {
          return SizedBox();
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Shimmer.fromColors(
            baseColor: shimmerColorBase,
            highlightColor: shimmerColorHighlight,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: appConfig.getWidth() * 40,
                          height: 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: appConfig.getTheme().scaffoldBackgroundColor,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: appConfig.getWidth() * 30,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: appConfig.getTheme().scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.network(
                      snapshot.data!.image!.downloadUrl!,
                      fit: BoxFit.cover,
                      cacheHeight: 50,
                      cacheWidth: 50,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: appConfig.getWidth() * 40,
                      child: Text(
                        '${snapshot.data!.name} ${snapshot.data!.surname}',
                        style: textStyleEventCardTitle(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      (snapshot.data!.gender == UserGender.male
                              ? 'Uomo'
                              : 'Donna') +
                          ', ' +
                          calculateAge(snapshot.data!.birth!).toString() +
                          ' anni',
                      style: textStyleEventCardSubtitle(context),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            isLast
                ? SizedBox()
                : Divider(
                    height: 1,
                    color: appConfig.getTheme().highlightColor,
                  )
          ],
        );
      },
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Controlla se non ha ancora compiuto gli anni quest'anno
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
