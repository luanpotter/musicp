import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  static final FirebaseAuth _firebase = FirebaseAuth.instance;
  static final GoogleSignIn _google = GoogleSignIn();

  Auth._();

  static Future<GoogleSignInAccount> _getAccount() async {
    GoogleSignInAccount account = _google.currentUser;
    if (account != null) {
      return account;
    }

    account = await _google.signInSilently();
    if (account != null) {
      return account;
    }
    
    return await _google.signIn();
  }

  static Future<FirebaseUser> signIn() async {
    GoogleSignInAccount account = await _getAccount();
    GoogleSignInAuthentication googleAuth = await account.authentication;

    AuthCredential cred = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return _firebase.signInWithCredential(cred);
  }

  static Future signOut() {
    return _google.signOut();
  }
}