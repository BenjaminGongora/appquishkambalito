import 'package:flutter/foundation.dart';

class WebUtils {
  static void initializeFirebaseWeb() {
    if (kIsWeb) {
      // Configuración específica para web
      print('Running on web platform');
    }
  }

  static String? getWebError(dynamic error) {
    if (kIsWeb) {
      // Manejar errores específicos de web
      if (error.toString().contains('JavaScriptObject')) {
        return 'Error de configuración de Firebase en web. Verifica la consola del navegador.';
      }
      if (error.toString().contains('auth/domain-config-required')) {
        return 'Configuración de dominio requerida. Verifica Firebase Console.';
      }
    }
    return error.toString();
  }
}
