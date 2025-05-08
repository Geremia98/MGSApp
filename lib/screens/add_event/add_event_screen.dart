import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/add_event_navigator.dart';
import 'package:mgs_app2/screens/add_event/progress_bar.dart';
import 'package:mgs_app2/screens/add_event/stages/event_desc_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_end_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_image_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_info_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_start_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_target_group_stage.dart';
import 'package:mgs_app2/screens/add_event/stages/event_target_person.dart';
import 'package:mgs_app2/screens/add_event/stages/event_title_stage.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';

import '../../utilities/app_config.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({
    super.key,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late AddEventController controller;

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    controller = AddEventController(
      pageController: pageController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: appConfig.getWidth() * paddingForCreationEventHorizontal,
                      right: appConfig.getWidth() * paddingForCreationEventHorizontal,
                      bottom: appConfig.getHeight() * 2,
                      top: appConfig.getHeight() * 1.3),
                  child: BackButtonAppBar(
                    iconData: Icons.close_rounded,
                    appConfig: appConfig,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                AddEventProgressBar(
                  controller: controller,
                ),
                SizedBox(
                  height: appConfig.getHeight() * 6,
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      EventTitleStage(
                        controller: controller,
                      ),
                      EventDescStage(
                        controller: controller,
                      ),
                      EventStartStage(
                        controller: controller,
                      ),
                      EventEndStage(
                        controller: controller,
                      ),
                      EventImageStage(
                        controller: controller,
                      ),
                      EventInfoStage(
                        controller: controller,
                      ),
                      EventTargetGroupStage(controller: controller),
                      EventTargetPersonStage(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: appConfig.getWidth() * 100,
                padding:
                    EdgeInsets.symmetric(horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal),
                child: AddEventNavigator(
                  controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
