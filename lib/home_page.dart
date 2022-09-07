import 'package:firebaseauthentication/firebase_auth_service.dart';
import 'package:firebaseauthentication/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Homepage
class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 Future<bool?>_exitApp(BuildContext context) {
    return showDialog(
      builder: (context) => AlertDialog(
        title: Text('Onaylama'),
        content: Text('Çıkmak istediğinizden emin misiniz?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Hayır'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Evet'),
          ),
        ],
      ), context: context,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {

                final logout=await _exitApp(context);
                print("logout degeri : ${logout}");
                if(logout==true){
                  try{
                    await Provider.of<AuthService>(context, listen: false).signOut;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WelcomePage()));
                  }catch(error){
                    print(error);
                  }
                }
              },
              icon: Icon(Icons.logout))
        ],
        title: Text("AnaSayfa"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Anasafya Ekranı")),
        ],
      ),
    );
  }
}
