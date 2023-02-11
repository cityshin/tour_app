import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modu_tour/signPage.dart';
import 'login.dart';
import 'mainPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database.db'),
      onCreate: (db,version)
    {
      return db.execute(
        "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, tel TEXT , zipcode TEXT , address TEXT , mapx Number , mapy Number , imagePath TEXT)",

      );
    },version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: '모두의 여행',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          return FutureBuilder(
            future: Firebase.initializeApp(),
              builder: (context, snapshot) {
              if(snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              }
              if(snapshot.connectionState==ConnectionState.done) {
                _initFirebaseMessaging(context);
                return LoginPage();
              }

              return Center(
                child: CircularProgressIndicator(),
              );
              });
        },
        '/sign': (context) => SignPage(),
        '/main': (context) => MainPage(database),
      },
    );
  }

  _initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      bool? pushCheck = await _loadData();
      if(pushCheck!) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Text(event.notification!.title!),
            content: Text(event.notification!.body!),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('OK'))
            ],
          );
        });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){});
  }

  Future<bool?> _loadData() async {
    var key = "push";
    SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.getBool(key);
    return value;
  }
}

