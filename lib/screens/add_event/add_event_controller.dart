import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';


enum AddEventStage {
  title,
  desc,
  start,
  end,
  banner,
  info,
}

class AddEventController {

  final PageController pageController;

  late AddEventStage _stage;
  late bool isCurrentStageValid;

  void Function()? _animateProgressBar;
  void Function()? updateStagesButton;

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String description = '';
  String title = '';

  ImageModel? bannerImage;

  String location = '';
  double price = 0;

  bool isLoading = false;


  AddEventController({
    required this.pageController,
  }) {
    _stage = AddEventStage.values.first;
    isCurrentStageValid = false;
  }


  void setAnimateProgressBar(void Function() animateFunction) {
    _animateProgressBar ??= animateFunction;
  }

  void nextStage() {
    if (isLatestStage()) {
      return;
    }

    _stage = AddEventStage.values.elementAt(getCurrentStageIndex() + 1);

    isCurrentStageValid = isCurrentStateFilled();

    if (_animateProgressBar != null) {
      _animateProgressBar!();
    }

    if (isLatestStage() || _stage.index == 1) {
      changeNextButton();
    }

    pageController.animateToPage(
      getCurrentStageIndex(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void prevStage() {
    _stage = AddEventStage.values.elementAt(getCurrentStageIndex() - 1);

    isCurrentStageValid = isCurrentStateFilled();

    if (isLatestStage() || isFirstStage()) {
      changeNextButton();
    }

    if (_animateProgressBar != null) {
      _animateProgressBar!();
    }

    pageController.animateToPage(
      getCurrentStageIndex(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void publish() async{
    isLoading = true;

    EventModel eventModel = EventModel(
      location: location,
      start: startDate,
      end: endDate,
      title: title,
      desc: description,
      price: price ?? 0.0,
    );

    EventFirestore eventFirestore = EventFirestore();

    String result = await eventFirestore.addEvent(eventModel);

    //TODO if result is empty non è andato a buon fine se no contiene la ref dell'evento
    changeNextButton();
  }

  bool isCurrentStateFilled() {
    switch (getCurrentStage()) {
      case AddEventStage.title:
        {
          return title.isNotEmpty;
        }

      case AddEventStage.desc:
        {
          return description.isNotEmpty;
        }

      case AddEventStage.start:
        {
          return startDate != null && startTime != null;
        }

      case AddEventStage.end:
        {
          return endDate != null && endTime != null;
        }
      case AddEventStage.banner:
        {
          return true;
        }
      case AddEventStage.info:
        {
          return location.isNotEmpty;
        }
    }
  }

  int getCurrentStageIndex() =>
      AddEventStage.values.indexOf(
        AddEventStage.values.firstWhere(
              (element) => element.name == _stage.name,
        ),
      );

  int stagesLength() => AddEventStage.values.length;

  bool isFirstStage() => getCurrentStageIndex() == 0;

  bool isLatestStage() =>
      getCurrentStageIndex() == AddEventStage.values.length - 1;

  AddEventStage getCurrentStage() => _stage;

  void setCurrentStageValid(bool value) {
    isCurrentStageValid = value;
    changeNextButton();
  }

  void changeNextButton() {
    if (updateStagesButton != null) {
      updateStagesButton!();
    }
  }


  void setTitle(String title) {
    this.title = title;
  }

  void setDesc(String desc) {
    description = desc;
  }

  void setStartDate(DateTime? date) {
    startDate = date;
  }

  void setStartTime(TimeOfDay? time) {
    startTime = time;
  }

  void setEndDate(DateTime? date) {
    endDate = date;
  }

  void setEndTIme(TimeOfDay? time) {
    endTime = time;
  }

  void setBanner(ImageModel? banner) {
    bannerImage = banner;
  }

  void setLocation(String loc) {
    location = loc;
  }

  void setPrice(String price) {
    this.price = double.tryParse(price) ?? 0;
  }

  ImageModel? getBanner() => bannerImage;

  DateTime? getStartDate() => startDate;

  DateTime? getEndDate() => endDate;

  TimeOfDay? getStartTime() => startTime;

  TimeOfDay? getEndTime() => endTime;

  String getTitle() => title;

  String getDesc() => description;

  double? getPrice() => price;

  String getLocation() => location;

}