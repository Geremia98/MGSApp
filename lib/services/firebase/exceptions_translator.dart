import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseExceptionsTranslator {


  String getAuthMessage(FirebaseAuthException error) {

    switch (error.code.toLowerCase()) {
      case "invalid-credential":
        return "Email o password non corretti!";
      case "invalid-email":
        return "Formato email non valido!";
      case "wrong-password":
      case "account-exists-with-different-credential":
        return "Impossibile connettersi, password o email non corrette!";
      case "email-already-in-use":
      case "credential-already-in-use":
        return "Indirizzo email già in uso!";
      case "network-request-failed":
        return "Verifica la tua connessione";
      case "user-disabled":
        return "Questo account è stato disabilitato!";
      case "too-many-requests":
        return "Troppi tentativi di accesso. Riprovare più tardi!";
      case "user-not-found":
        return "Indirizzo email non registrato!";
      case "requires-recent-login":
        return "Operazione sensibile. Esci ed entra nuovamente nel tuo account!";
      default:
        return "${error.message ?? "Errore sconosciuto"} durante l'operazione! Contattare l'assistenza";
    }
  }

  String getDatabaseMessage(PlatformException error) {
    switch (error.code) {
      case "DEADLINE_EXCEEDED":
        return "Ci è voluto troppo tempo per completare l'operazione, riprova!";
      case "INVALID_ARGUMENT":
        return "Uno o più campi non validi!";
      case "NOT_FOUND":
        return "Documento non trovato, contatta l'assistenza!";
      case "UNAUTHENTICATED":
        return "Non sei autenticato. Prova ad effettuare nuovamente il login!";
      default:
        return "Errore nella comunicazione con il database! Contatta l'assistenza!";
    }
  }
}
