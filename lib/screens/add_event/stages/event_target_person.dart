import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../../widgets/selector.dart';
import '../../../widgets/text_field.dart';

class EventTargetPersonStage extends StatefulWidget {
  final AddEventController controller;
  const EventTargetPersonStage({required this.controller, super.key});

  @override
  State<EventTargetPersonStage> createState() => _EventTargetPersonStageState();
}

class _EventTargetPersonStageState extends State<EventTargetPersonStage> {
  late AddEventController controller;
  final _formKey = GlobalKey<FormState>();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  String? _minAgeError;
  String? _maxAgeError;

  @override
  void initState() {
    controller = widget.controller;
    controller.setCurrentStageValid(controller.getGender() != null);
    _minAgeController.text = controller.getMinAge()?.toString() ?? '';
    _maxAgeController.text = controller.getMaxAge()?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(
            context,
            title: 'Per chi è?',
            subtitle: 'Specifica le caratteristiche del target per cui è pensato l\'evento',
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
                  constantEventTargetGenderList,
                  controller.getGender(),
                  onValueChange: onGenderTargetChanged,
                  title: 'Genere:',
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          buildTextField(
                            appConfig,
                            controller: _minAgeController,
                            textCapitalization: TextCapitalization.characters,
                            textInputType: const TextInputType.numberWithOptions(decimal: false),
                            hintText: 'Età minima',
                            onChanged: (_) => _validateAges(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          if (_minAgeError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _minAgeError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      margin: EdgeInsets.symmetric(horizontal: appConfig.getWidth()*3),
                      child: const Text('--')
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          buildTextField(
                            appConfig,
                            controller: _maxAgeController,
                            textCapitalization: TextCapitalization.characters,
                            textInputType: const TextInputType.numberWithOptions(decimal: false),
                            hintText: 'Età massima',
                            onChanged: (_) => _validateAges(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          if (_maxAgeError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _maxAgeError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _parseAndValidateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inserisci un\'età';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Solo numeri';
    }
    if (age < 14) {
      return 'Minimo 14 anni';
    }
    if (age > 199) {
      return 'Non può essere maggiore di 199';
    }
    return null;
  }

  void _validateAges() {
    setState(() {
      _minAgeError = _parseAndValidateAge(_minAgeController.text);
      _maxAgeError = _parseAndValidateAge(_maxAgeController.text);

      if (_maxAgeError == null) {
        final maxAge = int.tryParse(_maxAgeController.text);
        final minAge = int.tryParse(_minAgeController.text);
        if (minAge != null && maxAge! < minAge) {
          _maxAgeError = 'Non può essere minore dell\'età minima';
        }
      }

      if (_minAgeError == null && _maxAgeError == null) {
        final minAge = int.tryParse(_minAgeController.text);
        final maxAge = int.tryParse(_maxAgeController.text);
        controller.setMinAge(minAge);
        controller.setMaxAge(maxAge);
        controller.setCurrentStageValid(true);
      } else {
        controller.setCurrentStageValid(false);
      }
    });
  }

  void onGenderTargetChanged(EventTargetGender? gender){
    if (gender == null) {
      controller.setGender(null);
      controller.setCurrentStageValid(false);
      return;
    }

    controller.setGender(gender);
    controller.setCurrentStageValid(true);
  }
}

