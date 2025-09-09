
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/buttons.dart';

class ReportBugCategoryScreen extends StatelessWidget {
  const ReportBugCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    final List<Map<String, dynamic>> categories = [
      {'name': 'Pagamenti', 'icon': Icons.payment},
      {'name': 'Autenticazione & Credenziali', 'icon': Icons.lock_outline},
      {'name': 'Gestione Eventi', 'icon': Icons.event_note},
      {'name': 'Gestione Gruppi', 'icon': Icons.group},
    ];

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
                  'Di che si tratta?',
                  style: TextStyle(
                    fontSize: appConfig.getWidth() * 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2, // Adjust for better button shape
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryButton(
                      icon: category['icon'],
                      label: category['name'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportBugScreen(category: category['name']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: getCustomBorder(
            width: 0.3,
            appConfig: AppConfig(context),
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
