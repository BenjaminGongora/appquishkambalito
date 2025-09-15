import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  static Future<User?> signInWithGoogle({bool forceRedirect = false}) async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      if (forceRedirect) {
        // Forzar flujo de redirección
        return await _signInWithRedirect(googleProvider);
      } else {
        // Intentar popup primero, luego redirect
        try {
          return await _signInWithPopup(googleProvider);
        } catch (popupError) {
          return await _signInWithRedirect(googleProvider);
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<User?> _signInWithPopup(AuthProvider provider) async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithPopup(provider);
    return userCredential.user;
  }

  static Future<User?> _signInWithRedirect(AuthProvider provider) async {
    await FirebaseAuth.instance.signInWithRedirect(provider);

    // Esperar a que se complete la redirección
    return await FirebaseAuth.instance.authStateChanges().firstWhere(
      (user) => user != null,
      orElse: () => null,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
