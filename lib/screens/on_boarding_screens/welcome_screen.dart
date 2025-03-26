import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/on_boarding_screens/on_boarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height*0.03, bottom: height*0.01),
              child: Image.asset('assets/images/sammy-aeroplano.png'),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyWelcomeTextWidget(width: width, text: 'Ciao!'),
                  MyWelcomeTextWidget(
                      width: width, text: 'Sei nella nuova app del MGS.'),
                  MyWelcomeTextWidget(
                      width: width, text: 'Come dici?\nNon sai cosa può fare?'),
                  MyWelcomeTextWidget(
                      width: width,
                      text: 'Un sacco di cose!\nVieni, te le mostro!'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, OnBoardingScreen.id);
                  },
                  child: Text(
                    'Let\'s go',
                    style: TextStyle(
                      fontSize: width * 0.05,
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

class MyWelcomeTextWidget extends StatelessWidget {
  const MyWelcomeTextWidget({
    super.key,
    required this.width,
    required this.text,
  });

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: width*0.1, right: width*0.1),
      child: text == 'Ciao!'
          ? Text(
              text,
              style: TextStyle(
                fontSize: (width <= 550) ? 30 : 22,
              ),
              textAlign: TextAlign.left,
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: (width <= 550) ? 20 : 15,
              ),
              textAlign: TextAlign.left,
            ),
    );
  }
}
