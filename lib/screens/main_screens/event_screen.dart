import 'package:intl/intl.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/credit_card_screen.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

import '../../models/event_model.dart';

class EventScreen extends StatefulWidget {
  final EventModel event;

  EventScreen({required this.event, super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isLoading = false;
  bool isEventJoined = false;
  double _extraHeight = 0.0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(-200);
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    isEventJoined =
        widget.event.participants.any((userUid) => userUid == UserModel.uid);
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
            child: widget.event.image == null ||
                    widget.event.image!.downloadUrl == null
                ? SizedBox()
                : Image.network(
                    widget.event.image!.downloadUrl!,
                    fit: BoxFit.cover,
                  ),
          ),
          widget.event.creatorUid == UserModel.uid ||
                  widget.event.participants.contains(UserModel.uid)
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
                          vertical: width * 0.02 + 1,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          border: Border.all(
                            width: width * 0.002, // Larghezza del bordo
                            color: appConfig.getTheme().secondaryHeaderColor,
                          ),
                          color: appConfig.getTheme().scaffoldBackgroundColor,
                        ),
                        child: Text(
                          widget.event.creatorUid == UserModel.uid
                              ? 'Creato da te'
                              : 'Iscritto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                Navigator.pop(context),
              },
              child: Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  // Colore di sfondo
                  color: appConfig.getTheme().scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(width * 0.02), // Bordi arrotondati
                  border: Border.all(
                    width: width * 0.002, // Larghezza del bordo
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
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          child: Text(
                            widget.event.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.event.desc,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.05),
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: width * 0.4,
                                child: Column(
                                  children: [
                                    EventDetailBox(
                                      width: width,
                                      height: height,
                                      icon: Icons.calendar_month_rounded,
                                      title: 'Data inizio',
                                      subTitle: DateFormat('dd-MM-yyyy')
                                              .format(widget.event.start!) +
                                          '\n' +
                                          DateFormat('hh:mm')
                                              .format(widget.event.start!),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.location_on_rounded,
                                        title: 'Luogo',
                                        subTitle: widget.event.location),
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.4,
                                child: Column(
                                  children: [
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.calendar_month_rounded,
                                        title: 'Data fine',
                                        subTitle: DateFormat('dd-MM-yyyy')
                                                .format(widget.event.end!) +
                                            '\n' +
                                            DateFormat('hh:mm')
                                                .format(widget.event.end!)),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    EventDetailBox(
                                        width: width,
                                        height: height,
                                        icon: Icons.airplane_ticket_rounded,
                                        title: 'Biglietto',
                                        subTitle: '€ ' +
                                            widget.event.price.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.event.creatorUid == UserModel.uid ||
                                widget.event.start!.isBefore(DateTime.now())
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  bottom: 50,
                                ),
                                child: ButtonText(
                                  text: !isEventAvailable()
                                      ? 'Non disponibile'
                                      : widget.event.participants.any(
                                              (userUid) =>
                                                  userUid == UserModel.uid)
                                          ? 'Abbandona'
                                          : 'Partecipa',
                                  onTap: widget.event.participants.any(
                                          (userUid) => userUid == UserModel.uid)
                                      ? leaveEvent
                                      : joinEvent,
                                  isEnabled: !isEventAvailable()
                                      ? false
                                      : widget.event.participants.any(
                                              (userUid) =>
                                                  userUid == UserModel.uid)
                                          ? true
                                          : isEventAvailable(),
                                  isLoading: isLoading,
                                  color: !isEventAvailable()
                                      ? null
                                      : widget.event.participants.any(
                                              (userUid) =>
                                                  userUid == UserModel.uid)
                                          ? Colors.red.shade700
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

  bool isEventAvailable() {
    if (widget.event.targetGender == EventTargetGender.male &&
        UserModel.gender == UserGender.female) {
      return false;
    }

    if (widget.event.targetGender == EventTargetGender.female &&
        UserModel.gender == UserGender.male) {
      return false;
    }

    if (widget.event.start!.isBefore(DateTime.now())) {
      return false;
    }

    //TODO also include target age

    return true;
  }

  Future<void> leaveEvent() async {
    //TODO aggiungere una schermata "are you sure"

    final FirebaseFunctionCaller caller = FirebaseFunctionCaller();
    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    setState(() {
      isLoading = true;
    });

    FunctionResponse response = await caller.leaveEvent(widget.event.id);

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
      widget.event.participants.remove(UserModel.uid);
    });

    print("Evento abbandonato");
    snackBarStyle.showSnackBar('Evento lasciato correttamente');
  }

  Future<void> joinEvent() async {
    final FirebaseFunctionCaller caller = FirebaseFunctionCaller();
    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    if (widget.event.price == 0) {
      setState(() {
        isLoading = true;
      });

      FunctionResponse response = await caller.joinEvent(widget.event.id);

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
        widget.event.participants.add(UserModel.uid);
        isLoading = false;
        isEventJoined = false;
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

    FunctionResponse response = await caller.joinEvent(widget.event.id,
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
      isEventJoined = true;
    });

    snackBarStyle.showSnackBar('Evento aggiunto correttamente');
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
        width: width * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(right: width * 0.05),
              child: Icon(
                icon,
                size: width * 0.1,
                color: appConfig.getTheme().focusColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.035,
                  ),
                ),
                SizedBox(
                  width: width * 0.25,
                  child: Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
