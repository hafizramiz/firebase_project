import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthentication/firebase_auth_service.dart';
import 'package:firebaseauthentication/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  _myshowMyDialog({required String dialogMessage, required Function onPress}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uyari'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("${dialogMessage}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: (){
                onPress();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Oluşturma Sayfası"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///E mail TextFormField
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lutfen e mail girin';
                } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Lutfen gecerli bir email giriniz';
                }
                return null;
              },
              autofocus: false,
              decoration: InputDecoration(
                labelText: "E-mail girin",
                prefixIcon: Icon(Icons.email),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            ///Password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sifre bos gecilemez';
                } else if (_passwordController.text.length < 6) {
                  return "Sifre en az 6 karakter olmalidir";
                } else {
                  return null;
                }
              },
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Sifrenizi girin",
                prefixIcon: Icon(Icons.lock),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            ///Password Confirmation
            TextFormField(
              obscureText: true,
              controller: _passwordConfirmController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Sifre bos gecilemez';
                } else if (_passwordController.text.trim() !=
                    _passwordConfirmController.text.trim()) {
                  return "Sifreler uyusmuyor";
                } else {
                  return null;
                }
              },
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Sifrenizi onaylayin",
                prefixIcon: Icon(Icons.lock),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veri Kaydediliyor')),
                  );
                  try {
                    final user = await Provider.of<AuthService>(context,
                            listen: false)
                        .createUserWithEmailAndPassword(
                            emailAddress: _emailController.text.trim(),
                            password: _passwordConfirmController.text.trim());
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _myshowMyDialog(onPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));},
                        dialogMessage:
                            "E mailinize dogrulama linki gonderildi. Linki onaylayıp tekrar giriş yapın");
                  } on FirebaseAuthException catch(e){
                    if (e.code == 'email-already-in-use') {
                      print('Bu e-posta için hesap zaten var.');
                      _myshowMyDialog(
                          dialogMessage: "Bu e-posta için hesap zaten var. Başka bir e-posta adresi deneyin",
                          onPress: () {
                            Navigator.of(context).pop();
                          });
                    }
                  }
                  catch (e) {
                    print(e);
                  }
                } else {
                  return  _myshowMyDialog(
                      dialogMessage: "Lutfen kirmizi ile gosterilen alanlari doldurun",
                      onPress: () {
                        Navigator.of(context).pop();
                      });
                }
              },
              child: Text("Hesap Oluştur"),
            ),

            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Zaten bir hesabim var"))
          ],
        ),
      ),
    );
  }
}
