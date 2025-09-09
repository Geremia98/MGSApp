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
          'È permesso solo ai coordinatori.\nPer farlo, aprire il menù sulla sinistra e lì si trova la voce relativa. A questo punto compilare tutti i campi indicati.'),
  FAQCouple(
      question: 'Posso creare un evento per un altro gruppo?',
      answer:
          'Sì, se sei un coordinatore di un gruppo puoi creare eventi direzionati a qualsiasi gruppo dell\'ispettoria.'),
  FAQCouple(
      question:
          'È possibile creare un sottogruppo all\'interno del mio gruppo?',
      answer:
          'No. I gruppi sono creati dai responsabili dell\'ispettoria e sono prefissati. Se vuoi un nuovo gruppo parla con il responsabile ispettoriale.'),
  FAQCouple(
      question: 'Come modifico i dati inseriti in fase di registrazione?',
      answer:
          'Nella pagina del tuo profilo, a cui puoi accedere cliccando la tua immagine profilo o dal menù sulla sinistra, ci sono tutti i tuoi dati raggruppati per categoria. Lì dentro puoi vederli e anche modificarli.'),
    FAQCouple(
      question: 'Ho ricevuto il codice per diventare coordinatore del gruppo.\nDove lo inserisco?',
      answer:
          'Nella pagina del tuo profilo c\'è una sezione chiamata \'Diventa Boss\'. Lì puoi inserire il nuovo codice.'),
    FAQCouple(
      question: 'Dove modifico le mie credenziali?',
      answer:
          'Nella pagina del profilo c\'è una sezione dedicata per email e password.'),
    FAQCouple(
      question: 'Perchè non vedo tutti gli eventi che sono stati creati?',
      answer:
          'Non vengono visualizzati gli eventi a cui non puoi iscriverti. Tutti quelli che sono adatti a te li trovi nella sezione \'Consigliati\'.'),
    FAQCouple(
      question: 'Come modifico un evento?',
      answer:
          'Nel menù sulla sinistra, c\'è una sezione dedicata alla gestione degli eventi che un responsabile ha creato. Lì trovi tutti i tuoi eventi e puoi modificarli.'),
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
