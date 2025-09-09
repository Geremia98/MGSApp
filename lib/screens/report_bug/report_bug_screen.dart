import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/buttons.dart';

class ReportBugScreen extends StatefulWidget {
  final String category;

  const ReportBugScreen({super.key, required this.category});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    if (_descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final FirebaseFunctionCaller caller = FirebaseFunctionCaller();

    final FunctionResponse response =
        await caller.sendReport(widget.category, _descriptionController.text);

    setState(() {
      _isSubmitting = false;
    });

    SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    if (response.getType() == ResponseType.success) {
      snackBarStyle.showSnackBar('Segnalazione inviata.');
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }

    snackBarStyle.showSnackBar('Errore durante l\'invio, riprova più tardi.');
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appConfig.getWidth() * 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GoBackButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  appConfig: appConfig,
                  title: 'Segnala un bug',
                ),
                SizedBox(
                  height: appConfig.isTablet() ? 60 : 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        appConfig.isTablet() ? appConfig.getWidth() * 10 : 0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Perfavore descrivi il problema che stai riscontrando. '
                            '\nIl nostro team controllerà appena possibile.',
                        style: textStyleSubtitle(context),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: appConfig.isTablet() ? 50 : 24),
                      PrimaryTextField(
                        controller: _descriptionController,
                        labelText: 'Descrizione Bug',
                        maxLines: 100,
                        maxLength: 1500,
                      ),
                      SizedBox(height: appConfig.isTablet() ? 50 : 24),
                      Center(
                        child: PrimaryButton(
                          onPressed: _isSubmitting ? null : _submitReport,
                          label: _isSubmitting
                              ? 'Inviando...'
                              : 'Invia segnalazione',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
