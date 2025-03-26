//boss si/no

//Se è boss mettere un positioned,
//come un pallino o una piccola label sulla foto profilo

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/theme_data.dart';

class PersonalScreen extends StatefulWidget {
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
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.pop(
                        context,
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        // Colore di sfondo
                        borderRadius: BorderRadius.circular(
                            width * 0.02), // Bordi arrotondati
                        border: MyTheme.getCustomBorder(
                          context: context,
                          width: width * 0.002,
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .arrow_back_rounded, // Icona simile a quella mostrata
                        size: 24.0, // Dimensione dell'icona
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Center(
                child: Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/male.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(width * 0.5),
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: width * 0.001,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Geremia Moretti',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Divider(
              indent: width * 0.06,
              endIndent: width * 0.06,
              height: height * 0.02,
            ),
            Text(
              'Nato il 09-12-1998',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Ispettoria: Triveneto',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Gruppo: Sesto',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            Text(
              'Numero di telefono:\n+393881113429',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.03),
            ),
            GestureDetector(
                    onTap: () => {
                      Navigator.pop(
                        context,
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(180, 71, 242, 159),
                        // Colore di sfondo
                        borderRadius: BorderRadius.circular(
                            width * 0.04), // Bordi arrotondati
                        border: MyTheme.getCustomBorder(
                          context: context,
                          width: width * 0.001,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height*0.003, horizontal: width*0.1),
                        child: Text(
                          'Modifica',
                          style: TextStyle(
                            fontSize: height*0.02,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                  ),
          ],
        ),
        
      ),
    );
  }
}
