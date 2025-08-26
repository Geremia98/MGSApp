import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../../utilities/constants_strings.dart';
import '../../../widgets/selector.dart';

class EventTargetGroupStage extends StatefulWidget {
  final AddEventController controller;

  const EventTargetGroupStage({required this.controller, super.key});

  @override
  State<EventTargetGroupStage> createState() => _EventTargetGroupStageState();
}

class _EventTargetGroupStageState extends State<EventTargetGroupStage> {
  late AddEventController controller;
  bool isCountryBroadcast = false;
  bool isIspettoriaBroadcast = false;
  String? _selectedCountry;
  String? _selectedIspettoria;
  String? _selectedGroup;

  @override
  void initState() {
    controller = widget.controller;
    isCountryBroadcast = controller.isCountryBroadcast;
    isIspettoriaBroadcast = controller.isIspettoriaBroadcast;
    _selectedCountry = controller.getCountry();
    _selectedIspettoria = controller.getIspettoria();
    _selectedGroup = controller.getGroup();
    controller.setCurrentStageValid(_isStateValid());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
          context,
          title: 'Per chi è?',
          subtitle:
              'Inserisci il paese, l\'ispettoria e il gruppo a cui vuoi inviare l\'evento',
        ),
        SizedBox(
          height: appConfig.getHeight() * 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal,
          ),
          child: Column(
            children: [
              SelectorStyle(
                constantDropDownCountryList,
                _selectedCountry,
                onValueChange: onCountryChange,
                title: 'Paese:',
              ),
              CheckboxListTile(
                title: Text(
                  'Invia a tutto il paese',
                  style: TextStyle(
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
                value: isCountryBroadcast,
                side: BorderSide(
                  color: appConfig.getTheme().secondaryHeaderColor,
                ),
                onChanged: (value) {
                  setState(() {
                    isCountryBroadcast = value!;
                    if (isCountryBroadcast) {
                      isIspettoriaBroadcast = false;
                      _selectedIspettoria = null;
                      _selectedGroup = null;
                      controller.setIspettoria(null);
                      controller.setGroup(null);
                    }
                    controller.setCountryBroadcast(isCountryBroadcast);
                    controller.setIspettoriaBroadcast(isIspettoriaBroadcast);
                    controller.setCurrentStageValid(_isStateValid());
                  });
                },
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownIspettoriaList,
                _selectedIspettoria,
                onValueChange: onIspettoriaChange,
                title: 'Ispettoria:',
                isEnable: !isCountryBroadcast,
              ),
              CheckboxListTile(
                title: Text(
                  'Invia a tutta l\'ispetttoria',
                  style: TextStyle(
                    color: appConfig.getTheme().secondaryHeaderColor,
                  ),
                ),
                value: isIspettoriaBroadcast,
                side: BorderSide(
                  color: appConfig.getTheme().secondaryHeaderColor,
                ),
                onChanged: (value) {
                  setState(() {
                    isIspettoriaBroadcast = value!;
                    if (isIspettoriaBroadcast) {
                      isCountryBroadcast = false;
                      _selectedGroup = null;
                      controller.setGroup(null);
                    }
                    controller.setIspettoriaBroadcast(isIspettoriaBroadcast);
                    controller.setCountryBroadcast(isCountryBroadcast);
                    controller.setCurrentStageValid(_isStateValid());
                  });
                },
              ),
              SizedBox(height: 20),
              SelectorStyle(
                constantDropDownGroupList,
                _selectedGroup,
                onValueChange: onGroupChange,
                title: 'Gruppo:',
                isEnable: !isCountryBroadcast && !isIspettoriaBroadcast,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onCountryChange(String? country) {
    setState(() {
      _selectedCountry = country;
    });
    if (country == null || country.isEmpty) {
      controller.setCountry(null);
    } else {
      controller.setCountry(country);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  void onIspettoriaChange(String? ispettoria) {
    setState(() {
      _selectedIspettoria = ispettoria;
    });
    if (ispettoria == null || ispettoria.isEmpty) {
      controller.setIspettoria(null);
    } else {
      controller.setIspettoria(ispettoria);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  void onGroupChange(String? group) {
    setState(() {
      _selectedGroup = group;
    });
    if (group == null || group.isEmpty) {
      controller.setGroup(null);
    } else {
      controller.setGroup(group);
    }
    controller.setCurrentStageValid(_isStateValid());
  }

  bool _isStateValid() {
    if (isCountryBroadcast) {
      return _selectedCountry != null;
    } else if (isIspettoriaBroadcast) {
      return _selectedCountry != null && _selectedIspettoria != null;
    } else {
      return _selectedCountry != null &&
          _selectedIspettoria != null &&
          _selectedGroup != null;
    }
  }
}