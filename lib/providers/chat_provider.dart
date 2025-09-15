import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;

  User? _currentUser;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  ChatProvider()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance {
    _initializeGoogleSignIn();
    _initAuth();
  }

  void _initializeGoogleSignIn() {
    try {
      _googleSignIn = GoogleSignIn(
        clientId: kIsWeb
            ? '659158041292-f9ht6q53u1f6i2jfghlt9l7ps570hh6h.apps.googleusercontent.com'
            : null,
        scopes: ['email', 'profile'],
      );
    } catch (error) {
      _error = 'Error configurando Google Sign-In: $error';
      notifyListeners();
    }
  }

  void _initAuth() {
    _auth.authStateChanges().listen(
      (User? user) {
        _currentUser = user;
        _isAuthenticated = user != null;
        _error = null;
        notifyListeners();

        if (_isAuthenticated) {
          _listenToMessages();
        }
      },
      onError: (error) {
        _handleError(error, 'Error en autenticación');
      },
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      // Usar Firebase auth directamente con redirect
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      if (kIsWeb) {
        // Forzar redirect en web
        await _auth.signInWithRedirect(googleProvider);
      } else {
        await _auth.signInWithPopup(googleProvider);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _signInWithGoogleWeb() async {
    try {
      // Intentar silent sign-in primero
      final GoogleSignInAccount? silentUser = await _googleSignIn
          .signInSilently();

      if (silentUser != null) {
        await _handleGoogleSignInResult(silentUser);
        return;
      }

      // Si silent sign-in falla, intentar con signIn normal
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        await _handleGoogleSignInResult(googleUser);
      }
    } catch (error) {
      // Fallback: usar Firebase auth directamente
      await _signInWithFirebaseRedirect();
    }
  }

  Future<void> _signInWithGoogleMobile() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      await _handleGoogleSignInResult(googleUser);
    }
  }

  Future<void> _signInWithFirebaseRedirect() async {
    try {
      // Usar Firebase auth directamente
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      await _auth.signInWithPopup(googleProvider);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _handleGoogleSignInResult(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    try {
      _error = null;
      await _auth.signOut();
      await _googleSignIn.signOut();
      _messages.clear();
    } catch (error) {
      _handleError(error, 'Error al cerrar sesión');
    }
  }

  void _listenToMessages() {
    _firestore
        .collection('chat_messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            _messages = snapshot.docs
                .map(
                  (doc) => ChatMessage.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();
            _error = null;
            notifyListeners();
          },
          onError: (error) {
            _handleError(error, 'Error al cargar mensajes');
          },
        );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _currentUser == null) return;

    try {
      _error = null;

      await _firestore.collection('chat_messages').add({
        'text': text.trim(),
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? 'Usuario',
        'userAvatar': _currentUser!.photoURL ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'isSystemMessage': false,
      });
    } catch (error) {
      _handleError(error, 'Error al enviar mensaje');
    }
  }

  void _handleError(dynamic error, String context) {
    if (kIsWeb) {
      _error = 'Error en la aplicación web. Verifica la consola del navegador.';
      print('$context: $error');
    } else {
      _error = error.toString();
    }
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Getters públicos
  User? get currentUser => _currentUser;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
}
