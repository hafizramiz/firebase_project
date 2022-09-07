import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // FirebaseAuth metotlarini kullanmam icin ondan bir obje olusturmam gerekiyor.
  final FirebaseAuth auth = FirebaseAuth.instance;
  late GoogleSignIn googleSignIn;

  ///Creating Sign in method
  Future<User> signInWithEmailAndPassword(
      {required email, required password}) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user!;
  }

  /// Creating Sing In Anonymously Method
  Future<User?> signInAnonymously() async {
    final userCredential = await auth.signInAnonymously();
    return userCredential.user;
  }

  /// Creating signOut Method
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // await googleSignIn.signOut();
    print("Cikis yapildi");
  }

  /// Creating stream method
  Stream<User?> authStateChange() {
    return auth.authStateChanges();
  }

  ///Creating getters
  get signOut => _signOut();

  /// Creating Sign Up method
  Future<User> createUserWithEmailAndPassword(
      {required emailAddress, required password}) async {
    final newUser = await auth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    print("yeni kullanici:${newUser.user!.email}");
    print("verify edildi:${newUser.user!.emailVerified}");
    return newUser.user!;
  }

  /// Creating reset password method
  Future<void> sendResetPassword({email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  /// Creating google sign in method
  Future<UserCredential> signInWithGoogle() async {
    googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await auth.signInWithCredential(credential);
  }
}
