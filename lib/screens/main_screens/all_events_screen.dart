import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/buttons.dart';

class AllEventsScreen extends StatefulWidget {
  final String titolo;
  const AllEventsScreen({super.key, required this.titolo});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      GoBackButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                        appConfig: appConfig,
                      ),
                      const Expanded(
                          child: SizedBox(
                        width: 10,
                      )),
                      Container(
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
                      ),
                    ],
                  ),
                  MyPersonalRow(
                      width: width, titolo: widget.titolo, height: height),
                  ButtonRow(
                    height: height,
                    width: width,
                    coloreBottonePremuto: ThemeData().highlightColor,
                  ),
                  Container(
                    height: height * 0.9,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/meditazione.png',
                          titolo: 'Weekend meditativo',
                          luogo: 'Oratorio Sesto',
                          dataInizio: '30 nov 2023',
                        ),
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/giardinaggio.png',
                          titolo: 'Giardino didattico',
                          luogo: 'Campo della parrocchia',
                          dataInizio: '9 mag 2023',
                        ),
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/party.png',
                          titolo: 'Festa di fine anno',
                          luogo: 'Istituto don Bosco',
                          dataInizio: '4 giu 2023',
                        ),
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/ballo.png',
                          titolo: 'Serata anni 90\'',
                          luogo: 'Teatro Santa Giulia',
                          dataInizio: '2 feb 2024',
                        ),
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/giardinaggio.png',
                          titolo: 'Giardino didattico',
                          luogo: 'Campo della parrocchia',
                          dataInizio: '9 mag 2023',
                        ),
                        MyEventCard(
                          height: height,
                          width: width,
                          image: 'assets/images/meditazione.png',
                          titolo: 'Weekend meditativo',
                          luogo: 'Oratorio Sesto',
                          dataInizio: '30 nov 2023',
                        ),
                        SizedBox(
                          height: height * 0.07,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
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
      onTap: () {},
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
              height: width * 0.3,
              width: width * 0.3,
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
                  Container(
                    margin: EdgeInsets.only(top: height * 0.007),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            PersonForStack(
                              height: height,
                              width: width,
                              image: 'assets/images/female.jpg',
                              borderColor: Colors.white,
                              boxcolor: Colors.amber,
                            ),
                            Positioned(
                              left: width * 0.06,
                              child: PersonForStack(
                                height: height,
                                width: width,
                                image: 'assets/images/male.jpg',
                                borderColor: Colors.white,
                                boxcolor: Colors.amber,
                              ),
                            ),
                            Positioned(
                              left: width * 0.06 * 2,
                              child: Container(
                                width: width * 0.08,
                                height: width * 0.08,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: width * 0.005,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '15+',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.03),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: width * 0.001),
                          child: LikeButton(width: width),
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
  });

  final double width;
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
          Row(
            children: [
              Text(
                '15 eventi',
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
