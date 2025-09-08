import 'package:flutter/material.dart';
import 'package:mgs_app2/models/faq_couple.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/font.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appConfig.getWidth() * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GoBackButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  appConfig: appConfig,
                  title: 'FAQ',
                ),
                SizedBox(
                  height: appConfig.isTablet() ? 60 : 30,
                ),
                const Expanded(
                    child: FAQList(
                  faqs: faqsList,
                )),
                Container(
                  padding: EdgeInsets.only(
                    top: appConfig.getHeight() * 3,
                    bottom: appConfig.getHeight() * 3,
                  ),
                  child: Column(children: [
                    Center(
                      child: Text('Quello che cerchi non c\'è?',
                          style: textStyleSubtitle(context)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Mandaci una mail',
                          style: textStyleSubtitle(context).copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: appConfig.getTheme().primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ]),
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
    final AppConfig appConfig = AppConfig(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: appConfig.isTablet() ? 10 : 8),
      decoration: BoxDecoration(
        color: appConfig.getTheme().highlightColor,
        border: Border.all(
            color: appConfig.getTheme().primaryColor,
            width: appConfig.getWidth() * 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Riga titolo/icone
          InkWell(
            onTap: _handleTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: textStyleTitle(context),
                    ),
                  ),
                  // Icona di espansione animata
                  RotationTransition(
                    turns: _arrowAnimation,
                    child: const Icon(Icons.expand_more),
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
                  style: textStyleSubtitle(context)
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
