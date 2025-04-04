import 'package:flutter/material.dart';
import 'package:mgs_app2/models/faq_couple.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          // Colore di sfondo
                          borderRadius: BorderRadius.circular(width * 0.02),
                          // Bordi arrotondati
                          border: Border.all(
                            width: width * 0.002,
                            color: appConfig.getTheme().cardColor
                            // Larghezza del bordo
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          // Icona simile a quella mostrata
                          size: 24.0,
                          // Dimensione dell'icona
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: height * 0.035,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    'FAQ',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: FAQList(
                      faqs: faqsList,
                    )),
                Container(
                  padding: EdgeInsets.only(
                    top: height * 0.03,
                    bottom: height * 0.04,
                  ),
                  child: Center(
                    child: Text(
                      'Quello che cerco non è presente ...',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: width * 0.04,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class FAQItemWidget extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItemWidget({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  _FAQItemWidgetState createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _arrowAnimation;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _arrowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
    _expandAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(196, 237, 237, 237),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Riga titolo/icone
          InkWell(
            onTap: _handleTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Icona di espansione animata
                  RotationTransition(
                    turns: _arrowAnimation,
                    child: const Icon(Icons.expand_more, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // Contenuto espanso animato
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller.view,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topLeft,
                  heightFactor: _expandAnimation.value,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14),
                child: Text(
                  widget.answer,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  final List<FAQCouple> faqs;

  const FAQList({Key? key, required this.faqs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return FAQItemWidget(
              question: faqs[index].question, answer: faqs[index].answer);
        });
  }
}


