import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/faq_couple.dart';

const Map<String, String> constantDropDownCountryList = {
  'IT': 'Italia',
  'ES': 'Spain',
  'EN': 'England'
};
const Map<String, String> constantDropDownIspettoriaList = {
  'Triveneto': 'Triveneto',
  'Centrale': 'Centrale',
  'Lombardo-Emiliana': 'Lomba-Emiliana',
  'Sud': 'Sud'
};
const Map<String, String> constantDropDownGroupList = {
  'Sesto': 'Sesto',
  'Don Bosco Milano': 'Don Bosco Milano',
  'Salesiani Nave': 'Salesiani Nave'
};

const Map<EventTargetGender, String> constantEventTargetGenderList = {
  EventTargetGender.male: 'Maschile',
  EventTargetGender.female: 'Femminile',
  EventTargetGender.both: 'Entrambi',

};

const List<FAQCouple> faqsList = [
  FAQCouple(
      question: 'Come posso creare un evento?',
      answer:
          'Questo è un testo completamente a caso con lo scopo di vedere come sta graficamente la rispos all\'interno delle pagine.\nDiciamo che la divisione in paragrafi aiuta la lettura perchè aiuta a non affaticare la vista.'),
  FAQCouple(
      question: 'Posso creare un evento per un altro gruppo?',
      answer:
          'Questo è un testo completamente a caso con lo scopo di vedere come sta graficamente la rispos all\'interno delle pagine.\nDiciamo che la divisione in paragrafi aiuta la lettura perchè aiuta a non affaticare la vista.'),
  FAQCouple(
      question:
          'È possibile creare un sottogruppo all\'interno del mio gruppo?',
      answer:
          'Questo è un testo completamente a caso con lo scopo di vedere come sta graficamente la rispos all\'interno delle pagine.\nDiciamo che la divisione in paragrafi aiuta la lettura perchè aiuta a non affaticare la vista.'),
  FAQCouple(
      question: 'Come creo un codice sconto per i miei ragazzi?',
      answer:
          'Questo è un testo completamente a caso con lo scopo di vedere come sta graficamente la rispos all\'interno delle pagine.\nDiciamo che la divisione in paragrafi aiuta la lettura perchè aiuta a non affaticare la vista.'),
];

const List<String> menuList = [
  'Menù',
  'Info personali',
  'Crea evento',
  'Riporta un bug',
  'Lista FAQ',
  'Cambia tema',
  'Log out',
];
