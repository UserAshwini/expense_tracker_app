import 'package:expense_tracker_app/models/auth_model.dart';
import 'package:expense_tracker_app/screens/authentications/data/providers/authentication_firebase_provider.dart';
import 'package:expense_tracker_app/screens/authentications/data/providers/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final AuthenticationFirebaseProvider _authenticationFirebaseProvider;
  final GoogleSignInProvider _googleSignInProvider;
  AuthenticationRepository(
      {required AuthenticationFirebaseProvider authenticationFirebaseProvider,
      required GoogleSignInProvider googleSignInProvider})
      : _googleSignInProvider = googleSignInProvider,
        _authenticationFirebaseProvider = authenticationFirebaseProvider;

  Stream<AuthModel> getAuthDetailStream() {
    return _authenticationFirebaseProvider.getAuthStates().map((user) {
      return _getAuthCredentialFromFirebaseUser(user: user);
    });
  }

  Future<AuthModel> authenticateWithGoogle() async {
    User? user = await _authenticationFirebaseProvider.login(
        credential: await _googleSignInProvider.login());
    return _getAuthCredentialFromFirebaseUser(user: user);
  }

  Future<void> unAuthenticate() async {
    await _googleSignInProvider.logout();
    await _authenticationFirebaseProvider.logout();
  }

  AuthModel _getAuthCredentialFromFirebaseUser({required User? user}) {
    AuthModel authDetail;
    if (user != null) {
      authDetail = AuthModel(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        name: user.displayName,
      );
    } else {
      authDetail = AuthModel(isValid: false);
    }
    return authDetail;
  }
}
