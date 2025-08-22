
import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:flutter/material.dart';
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

    final String recipientEmail = 'support@example.com'; // <-- IMPORTANT: Change this to your support email
    final String subject = 'Bug Report - ${widget.category}';
    final String body = _descriptionController.text.trim();

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch email client';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening email client...')),
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open email client: $e')),
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
