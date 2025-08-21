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

//Test branch creation
class EventScreen extends StatefulWidget {
  final EventModel event;

  EventScreen({required this.event, super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  bool isLoading = false;
  bool isEventJoined = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    isEventJoined = widget.event.participants.any((userUid) => userUid == UserModel.uid);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height * 1.2,
          ),
          Container(
            height: height * 0.5,
            child: widget.event.image == null ||
                    widget.event.image!.downloadUrl == null
                ? SizedBox()
                : Image.network(
                    widget.event.image!.downloadUrl!,
                    fit: BoxFit.cover,
                  ),
          ),
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
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded, // Icona simile a quella mostrata
                  size: 24.0, // Dimensione dell'icona
                ),
              ),
            ),
          ),
          Positioned(
              top: height * 0.4,
              width: width,
              height: height * 0.6,
              child: Container(
                height: height * 0.6,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
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
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.event.desc,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: appConfig.getTheme().dividerColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.05),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: ButtonText(
                                text: widget.event.participants.any((userUid) => userUid == UserModel.uid) ? 'Abbandona' : 'Partecipa',
                                onTap: widget.event.participants.any((userUid) => userUid == UserModel.uid) ? leaveEvent : joinEvent,
                                isEnabled:  widget.event.participants.any((userUid) => userUid == UserModel.uid) ? true : isEventAvailable(),
                                isLoading: isLoading,
                                color: widget.event.participants.any((userUid) => userUid == UserModel.uid) ? Colors.red.shade700 : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  bool isEventAvailable() {
    if (widget.event.targetGender == EventTargetGender.male && UserModel.gender == UserGender.female) {
      return false;
    }

    if (widget.event.targetGender == EventTargetGender.female && UserModel.gender == UserGender.male) {
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

      setState(() {
        isLoading = false;
      });

      if (response.getType() == ResponseType.error) {
        snackBarStyle.showSnackBar('Impossibile abbandonare l\'evento. Riprova più tardi.');
        return;
      }

      print("Evento abbandonato");
      snackBarStyle.showSnackBar('Evento lasciato correttamente');


  }

  Future<void> joinEvent() async{


    final FirebaseFunctionCaller caller = FirebaseFunctionCaller();
    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);
    

    if (widget.event.price == 0) {

      setState(() {
        isLoading = true;
      });

      FunctionResponse response = await caller.joinEvent(widget.event.id);

      if (response.getType() == ResponseType.error) {
        snackBarStyle.showSnackBar('Impossibile partecipare. Riprova più tardi.');

        setState(() {
          isLoading = false;
        });

        return;
      }

      snackBarStyle.showSnackBar('Evento aggiunto correttamente');

      setState(() {
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

    FunctionResponse response = await caller.joinEvent(widget.event.id, paymentMethodId: paymentMethodId ?? '');


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

    return Container(
      height: height * 0.09,
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
              Text(
                subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.035,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
