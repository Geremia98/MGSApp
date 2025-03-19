//boss si/no

//Se è boss mettere un positioned, 
//come un pallino o una piccola label sulla foto profilo

import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/other_screens/home_screen.dart';
import 'package:mgs_app2/utilities/theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';

class PersonalScreen extends StatefulWidget {
  static const String id = 'PersonalScreen';

  const PersonalScreen({super.key});

  @override
  PersonalScreenState createState() => PersonalScreenState();
}

class PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
          onTap: () => {
            Navigator.pop(
                context,)
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              // Colore di sfondo
              borderRadius:
                  BorderRadius.circular(width * 0.02), // Bordi arrotondati
              border: MyTheme.getCustomBorder(
                context: context,
                width: width * 0.002,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded, // Icona simile a quella mostrata
              size: 24.0, // Dimensione dell'icona
            ),
          ),
        ),
            Center(
              child: Container(
                width: width * 0.35,
                height: width * 0.35,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/male.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.5)),
                  border: Border.all(
                    color: Colors.white,
                    width: width * 0.001,
                  ),
                ),
              ),
            ),
            Text('Geremia Moretti'),
            Divider(height: height*0.02,),
            Text('Milano - Sant\'Ambrogio'),
            Text('Nato il 09-12-1998'),

          ],
        ),
      ),
    );
  }
}
