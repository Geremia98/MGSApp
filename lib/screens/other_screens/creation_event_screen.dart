import 'package:mgs_app2/utilities/models.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';

class CreationEventScreen extends StatelessWidget {
  static const String id = 'CreationEventScreen';

  const CreationEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                  CustomAppBar(
                    width: width,
                    titolo: 'Nuovo Evento',
                  ),
                  AddNewProductForm(
                    height: height,
                    width: width,
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
        ],
      ),
    );
  }
}

class AddNewProductForm extends StatefulWidget {
  const AddNewProductForm({
    super.key,
    required this.width,
    required this.height,
  });

  final double height;
  final double width;

  @override
  _AddNewProductFormState createState() => _AddNewProductFormState();
}

class _AddNewProductFormState extends State<AddNewProductForm> {
  late String _titolo = '';
  late String _descrizione = '';
  late String _immagineCaricata = 'assets/images/giardinaggio.png';
  late DateTime _dataInizio = DateTime.now().copyWith(hour: 22, minute: 22);
  late DateTime _dataFine = DateTime.now().copyWith(hour: 22, minute: 22);
  late String _luogo = '';
  late int _prezzo = 0;

  late bool _isDisabled;

  @override
  void initState() {
    _isDisabled = true;
    super.initState();
  }

  void calculateWetherEnablingTheButton() {
    if (_titolo.isNotEmpty &&
        _descrizione.isNotEmpty &&
        _immagineCaricata.isNotEmpty &&
        _luogo.isNotEmpty &&
        _prezzo != 0 &&
        isDateTimeOk()) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
  }

  bool isDateTimeOk() {
    return _dataFine.isAfter(_dataInizio) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: widget.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: widget.height * 0.03),
            Text(
              'Titolo e descrizione:',
              style: TextStyle(
                  fontSize: widget.height * 0.025, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: widget.height * 0.012),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Titolo evento',
              ),
              onChanged: (value) => {
                setState(() {
                  _titolo = value;
                  calculateWetherEnablingTheButton();
                }),
              },
            ),
            SizedBox(height: widget.height * 0.02),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Descrizione evento',
              ),
              onChanged: (value) => {
                setState(() {
                  _descrizione = value;
                  calculateWetherEnablingTheButton();
                }),
              },
              maxLines: 3,
            ),
            SizedBox(height: widget.height * 0.028),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data inizio:',
                      style: TextStyle(
                          fontSize: widget.height * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: widget.height * 0.005),
                    Row(
                      children: [
                        Text(
                          formatDateFromDateTime(_dataInizio),
                          style: TextStyle(
                            fontSize: widget.height * 0.02,
                          ),
                        ),
                        SizedBox(width: widget.height * 0.015),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? dateInizio = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2050));
                            if (dateInizio != null) {
                              setState(() {
                                _dataInizio = dateInizio;
                                calculateWetherEnablingTheButton();
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(widget.width * 0.015),
                            decoration: BoxDecoration(
                              color: MyTheme.getCiSonoButtonColor(
                                  context: context),
                              borderRadius: BorderRadius.circular(
                                  widget.width * 0.05), // Bordi arrotondati
                              border: MyTheme.getCustomBorder(
                                context: context,
                                width: widget.width * 0.002,
                              ),
                            ),
                            child: Icon(
                              Icons.mode_edit_rounded,
                              // Icona simile a quella mostrata
                              size: widget.width * 0.05,
                              color: MyTheme.getCiSonoButtonTextColor(
                                  context: context), // Dimensione dell'icona
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.height * 0.015),
                    Text(
                      'Data fine:',
                      style: TextStyle(
                          fontSize: widget.height * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: widget.height * 0.005),
                    Row(
                      children: [
                        Text(
                          formatDateFromDateTime(_dataFine),
                          style: TextStyle(
                            fontSize: widget.height * 0.02,
                          ),
                        ),
                        SizedBox(width: widget.height * 0.015),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? dateFine = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2050));
                            if (dateFine != null) {
                              setState(() {
                                _dataFine = dateFine;
                                calculateWetherEnablingTheButton();
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(widget.width * 0.015),
                            decoration: BoxDecoration(
                              color: MyTheme.getCiSonoButtonColor(
                                  context: context),
                              borderRadius: BorderRadius.circular(
                                  widget.width * 0.05), // Bordi arrotondati
                              border: MyTheme.getCustomBorder(
                                context: context,
                                width: widget.width * 0.002,
                              ),
                            ),
                            child: Icon(
                              color: MyTheme.getCiSonoButtonTextColor(
                                  context: context),
                              Icons.mode_edit_rounded,
                              // Icona simile a quella mostrata
                              size:
                                  widget.width * 0.05, // Dimensione dell'icona
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.height * 0.03),
                    Text(
                      'Orario inizio:',
                      style: TextStyle(
                          fontSize: widget.height * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: widget.height * 0.005),
                    Row(
                      children: [
                        Text(
                          formatTimeFromDateTime(_dataInizio),
                          style: TextStyle(
                            fontSize: widget.height * 0.02,
                          ),
                        ),
                        SizedBox(width: widget.height * 0.015),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? timeInizio = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (timeInizio != null) {
                              setState(() {
                                _dataInizio = _dataInizio.copyWith(
                                    hour: timeInizio.hour,
                                    minute: timeInizio.minute);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(widget.width * 0.015),
                            decoration: BoxDecoration(
                              color: MyTheme.getCiSonoButtonColor(
                                  context: context),
                              borderRadius: BorderRadius.circular(
                                  widget.width * 0.05), // Bordi arrotondati
                              border: MyTheme.getCustomBorder(
                                context: context,
                                width: widget.width * 0.002,
                              ),
                            ),
                            child: Icon(
                              Icons.mode_edit_rounded,
                              // Icona simile a quella mostrata
                              size: widget.width * 0.05,
                              color: MyTheme.getCiSonoButtonTextColor(
                                  context: context), // Dimensione dell'icona
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.height * 0.02),
                    Text(
                      'Orario fine:',
                      style: TextStyle(
                          fontSize: widget.height * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: widget.height * 0.005),
                    Row(
                      children: [
                        Text(
                          formatTimeFromDateTime(_dataFine),
                          style: TextStyle(
                            fontSize: widget.height * 0.02,
                          ),
                        ),
                        SizedBox(width: widget.height * 0.015),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? timeFine = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (timeFine != null) {
                              setState(() {
                                _dataFine = _dataFine.copyWith(
                                    hour: timeFine.hour,
                                    minute: timeFine.minute);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(widget.width * 0.015),
                            decoration: BoxDecoration(
                              color: MyTheme.getCiSonoButtonColor(
                                  context: context),
                              borderRadius: BorderRadius.circular(
                                  widget.width * 0.05), // Bordi arrotondati
                              border: MyTheme.getCustomBorder(
                                context: context,
                                width: widget.width * 0.002,
                              ),
                            ),
                            child: Icon(
                              Icons.mode_edit_rounded,
                              // Icona simile a quella mostrata
                              size: widget.width * 0.05,
                              color: MyTheme.getCiSonoButtonTextColor(
                                  context: context), // Dimensione dell'icona
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: widget.height * 0.4,
                      maxWidth: widget.width * 0.5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.width * 0.02)),
                      side: MyTheme.getCustomBorderSide(
                          context: context, width: widget.width * 0.0008),
                    ),
                    child: Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.width * 0.02)),
                          child: Image.asset(
                            'assets/images/plants.png',
                            fit: BoxFit.cover,
                          )),
                    ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.height * 0.03),
            Text(
              'Carica immagine:',
              style: TextStyle(
                  fontSize: widget.height * 0.025, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: widget.height * 0.015),
            buildAddNewImageButton(
                context, widget.width, widget.width * 0.1, widget.width * 0.5),
            SizedBox(height: widget.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: widget.width * 0.05),
                  constraints: BoxConstraints(
                      maxHeight: widget.height * 0.35,
                      maxWidth: widget.width * 0.4),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.width * 0.02)),
                      side: MyTheme.getCustomBorderSide(
                          context: context, width: widget.width * 0.0008),
                    ),
                    child: Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.width * 0.02)),
                          child: Image.asset(
                            'assets/images/cats.png',
                            fit: BoxFit.cover,
                          )),
                    ]),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dove:',
                        style: TextStyle(
                            fontSize: widget.height * 0.025,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: widget.height * 0.01),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Luogo',
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _luogo = value;
                            calculateWetherEnablingTheButton();
                          }),
                        },
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: widget.height * 0.02),
                      Text(
                        'Costo evento:',
                        style: TextStyle(
                            fontSize: widget.height * 0.025,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: widget.height * 0.01),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Prezzo',
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _prezzo = int.parse(value);
                            calculateWetherEnablingTheButton();
                          }),
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.height * 0.03),
            isDateTimeOk()
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: widget.height * 0.02),
                    child: Text(
                      'Attenzione, la data e l\'ora di inizio evento devono essere prima di quelle della fine!',
                      style: TextStyle(
                        color: MyTheme.getErrorColor(context: context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: widget.height * 0.005),
              child: Center(
                child: ElevatedButton(
                  onPressed: _isDisabled
                      ? null
                      : () {
                          EventModel e = EventModel(
                              _titolo,
                              _descrizione,
                              _immagineCaricata,
                              _dataInizio,
                              _dataFine,
                              _luogo,
                              _prezzo,
                              false,
                              new List.empty());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        MyTheme.getCiSonoButtonColor(context: context),
                    disabledBackgroundColor:
                        MyTheme.getColorDisabledButton(context: context),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Crea evento',
                    style: TextStyle(
                      color: MyTheme.getCiSonoButtonTextColor(context: context),
                      fontSize: widget.width * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
