import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseExceptionsTranslator {

  String getAuthMessage(FirebaseAuthException error) {

    switch (error.code.toUpperCase()) {
      case "INVALID-CREDENTIAL":
        return "Le credenziali specificate sono scadute! (Error: 200)";
      case "INVALID-EMAIL":
        return "Formato email non valido!";
      case "WRONG-PASSWORD":
        return "Impossibile connettersi, password o email non corrette!";
      case "ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL":
        return "Impossibile connettersi, password o email non corrette!";
      case "EMAIL-ALREADY-IN-USE":
        return "Indirizzo email già in uso!";
      case "CREDENTIAL-ALREADY-IN-USE":
        return "Indirizzo email già in uso!";
      case "NETWORK-REQUEST-FAILED":
        return "Verifica la tua connessione";
      case "USER-DISABLED":
        return "Questo account è stato disabilitato!";
      case "TOO-MANY-REQUESTS":
        return "Troppi tentativi di accesso. Riprovare più tardi!";
      case "USER-NOT-FOUND":
        return "Indirizzo email non registrato!";
      case  'REQUIRES-RECENT-LOGIN':
        return "Operazione sensibile. Esci ed entra nuovamente nel tuo account!";
      default:
        return "${error.message} errore durante l'operazione! Contattare l'assistenza";
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
