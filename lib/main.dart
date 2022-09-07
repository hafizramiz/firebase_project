import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthentication/home_page.dart';
import 'package:firebaseauthentication/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_auth_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Provider<AuthService>(
      create: (context) => AuthService(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.indigo[100],
          primarySwatch: Colors.indigo,
          appBarTheme: AppBarTheme(backgroundColor: Colors.indigo)),
      home: OnBoardWidget(),
    );
  }
}

///Burasi On Board Widget
// On Board neden Stateful oldu?
class OnBoardWidget extends StatefulWidget {
  @override
  State<OnBoardWidget> createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  @override
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Provider.of<AuthService>(context,listen: false ).authStateChange(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.data != null ? HomePage() : WelcomePage();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
