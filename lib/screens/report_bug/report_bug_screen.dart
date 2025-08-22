import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/bug_report_service.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/buttons.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

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

    try {
      final bugReportService = BugReportService();
      await bugReportService.submitBugReport(_descriptionController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bug report submitted successfully.')),
      );
      // Add a short delay to let the user see the message
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit report: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);
    return Scaffold(
      body: SafeArea(
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
                  appConfig: appConfig),
              Container(
                padding: EdgeInsets.only(
                  top: appConfig.getHeight() * 3.5,
                  bottom: appConfig.getHeight() * 1,
                ),
                child: Text(
                  'Report a Bug',
                  style: TextStyle(
                    fontSize: appConfig.getWidth() * 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please describe the issue you are experiencing. '
                'Our team will review it as soon as possible.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              PrimaryTextField(
                controller: _descriptionController,
                labelText: 'Bug Description',
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Center(
                child: PrimaryButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  label: _isSubmitting ? 'Submitting...' : 'Submit Report',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}