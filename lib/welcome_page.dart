import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthentication/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_service.dart';
import 'home_page.dart';

///Welcome Buttons Page
class WelcomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Giriş Ekranı"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
                "Giriş Seçenekleri",
                style: TextStyle(fontSize: 30),
              )),
          //Anonim Giris Butonu
          ElevatedButton(onPressed:  () async{
            // SignIn Anonymously methodunu tamamlamam gerekiyor
            // Butonlari bir kere basinca dezaktif olacak sekilde ayarliycam
            try {
              final user= await Provider.of<AuthService>(context,listen: false).signInAnonymously();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                print("Anonim Giris yapildi.Kullanici uid si:${user!.uid}");

            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case "operation-not-allowed":
                  print("Anonim girise izin verilmedi");
                  break;
                default:
                  print("Beklenmeyen hata olustu");
              }
            }
          }, child: Text("Anonim Giriş")),
          ElevatedButton(
              onPressed: () {
                //Tiklaninca Sign In Page'e gonder
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
              }, child: Text("Email/Şifre ile Giriş ")),
          ElevatedButton(
              onPressed: () async {
                try {
                  final userCredential =
                  await Provider.of<AuthService>(context, listen: false)
                      .signInWithGoogle();
                  if (userCredential.user != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  print("Google sign in calisti, Kullanici giris yapti");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'account-exists-with-different-credential') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Hesap zaten farklı bir kimlik bilgisi ile mevcut.',),
                      ),
                    );
                  } else if (e.code == 'invalid-credential') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Kimlik bilgilerine erişilirken hata oluştu. Tekrar deneyin.'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Google Sign-In ile giris yapilirken hata oluştu. Tekrar deneyin.'),
                    ),
                  );
                  print("Google signin hatasi: ${e}");
                }
              },
              child: Text("Google ile Giriş")),
        ],
      ),
    );
  }
}