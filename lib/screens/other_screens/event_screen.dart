import 'package:mgs_app2/utilities/models.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/theme_data.dart';

class EventScreen extends StatefulWidget {
  
  final EventModel event = EventModel(
        'Giardinaggio',
        'Eccoci con l\'attesissima festa di fine anno. Saluteremo gli studenti diplomati e ci sarà musica, buon cibo e anche un ospite speciale! Sarà l\'occasione per augurarci buone vacanze!',
        'assets/images/giardinaggio.png',
        DateTime.now(),
        DateTime.now(),
        'Brescia',
        12,
        false,
        List.empty());

  EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height*1.2,
          ),
          Container(
            height: height * 0.5,
            child: Image.asset(
              widget.event.immagineCaricata,
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(
                                width * 0.02), // Bordi arrotondati
                            border: Border.all(
                              width: width * 0.002, // Larghezza del bordo
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .arrow_back_rounded, // Icona simile a quella mostrata
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
                                widget.event.titolo,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                        child: Text(
                          widget.event.descrizione,
                          style: TextStyle(
                              fontSize: 16,
                              color: MyTheme.getCustomDescriptionColor(context: context),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.05),
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
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
                                      subTitle: widget.event.dataInizio.day.toString()+ ' - ' + widget.event.dataInizio.month.toString() + ' - ' + widget.event.dataInizio.year.toString() +
                                          '\n' +
                                          widget.event.dataInizio.hour.toString()),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  EventDetailBox(
                                      width: width,
                                      height: height,
                                      icon: Icons.location_on_rounded,
                                      title: 'Luogo',
                                      subTitle: widget.event.luogo),
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
                                      subTitle: widget.event.dataFine.day.toString()+ ' - ' + widget.event.dataFine.month.toString() + ' - ' + widget.event.dataFine.year.toString() +
                                          '\n' +
                                          widget.event.dataFine.hour.toString()),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  EventDetailBox(
                                      width: width,
                                      height: height,
                                      icon: Icons.airplane_ticket_rounded,
                                      title: 'Biglietto',
                                      subTitle: '€ ' +
                                          widget.event.prezzo.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.005),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.getCiSonoButtonColor(context: context),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Ci sono!',
                              style: TextStyle(
                                color: MyTheme.getCiSonoButtonTextColor(context: context),
                                fontSize: width*0.05,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
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
              color: MyTheme.getLighter(context: context),
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
