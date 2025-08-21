
import 'package:mgsapp/services/firebase/bug_report_service.dart';
import 'package:flutter/material.dart';
import 'package:mgsapp/widgets/back_button_app_bar.dart';
import 'package:mgsapp/widgets/button.dart';
import 'package:mgsapp/widgets/text_field.dart';
import 'package:mgsapp/utilities/my_colors.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({Key? key}) : super(key: key);

  @override
  _ReportBugScreenState createState() => _ReportBugScreenState();
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bug report submitted successfully.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
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
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Report a Bug',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Please describe the issue you are experiencing. '
              'Our team will review it as soon as possible.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            PrimaryTextField(
              controller: _descriptionController,
              labelText: 'Bug Description',
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: _isSubmitting ? null : _submitReport,
              label: _isSubmitting ? 'Submitting...' : 'Submit Report',
            ),
          ],
        ),
      ),
    );
  }
}
