import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthentication/home_page.dart';
import 'package:firebaseauthentication/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_service.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();


  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _emailPasswordResetController = TextEditingController();
  bool isLoading=false;

  myshowMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uyari'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    "E mailiniz verify edilmedi. Luften e mailinizi verify edin"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  passwordResetDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Şifre Yenileme'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Form(
                  key: _formKey1,
                  child: TextFormField(
                    controller: _emailPasswordResetController,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Gonder'),
              onPressed: () async {

                if (_formKey1.currentState!.validate()) {

                  try{
                    await Provider.of<AuthService>(context,listen: false).sendResetPassword(
                        email: _emailPasswordResetController.text);
                    print("sifre sifirlama linki gonderildi");
                  }catch(e){
                    print(e);
                  }
                   ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text("E mailinize şifre sıfırlama linki gonderildi.")));
                   Navigator.pop(context);
                }
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
        title: Text("Giriş Sayfası"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E mail bos birakilamaz';
                } else {
                  return null;
                }
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
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sifre bos birakilamaz';
                } else {
                  return null;
                }
              },
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Şifre girin",
                prefixIcon: Icon(Icons.lock),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading?null:() async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading=true;
                  });
                  try {
                    await Provider.of<AuthService>(context, listen: false)
                        .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text);
                    await FirebaseAuth.instance.currentUser!.reload();
                    if (FirebaseAuth.instance.currentUser!.emailVerified==false) {
                      Provider.of<AuthService>(context,listen: false).signOut();
                      print(
                          "Dogrulanma durumu:${FirebaseAuth.instance.currentUser!.emailVerified}");
                      await myshowMyDialog();
                    } else {
                      print("Kullanici iceri girdi");
                      //Burada safya sign in mi sign up mu gostermek icin enum kullanabiliriz.
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Giris Yapiliyor")));
                    }
                  } catch (e) {
                    print("HATA VAR:${e}");
                  }
                  setState(() {
                    isLoading=false;
                  });
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("hata olustu")));
                }
              },
              child: Text("Giriş"),
            ),
            TextButton(
                onPressed: () async {
                  await passwordResetDialog();
                  print("Sifre sifirlama calisti");
                },
                child: Text("Şifremi Unuttum")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text("Hesabiniz yok mu?"),
            )
          ],
        ),
      ),
    );
  }
}
