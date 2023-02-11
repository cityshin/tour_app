import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modu_tour/data/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {

  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://modutour-85f4e-default-rtdb.firebaseio.com/';

  double opacity = 0;
  AnimationController? _animationController;
  Animation? _animation;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;


  void initState() {
    super.initState();

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _animationController = AnimationController(vsync: this,duration: Duration(seconds: 3));

    _animation = Tween<double>(begin: 0,end: pi*2).animate(_animationController!);

    _animationController!.repeat();

    Timer(Duration(seconds: 2),(){
      setState(() {
        opacity = 1;
      });
    });

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('user');

  }

  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController!,
                builder: (context, widget){
                  return Transform.rotate(
                      angle: _animation!.value,
                  child: widget,);
                },
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.green,
                  size: 80,
                )),
              SizedBox(
                height: 100,
                  child: Center(
                    child: Text('Modu_Tour',style: TextStyle(fontSize: 30),),
                  ),
              ),
              AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(seconds: 1),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                      child: TextField(
                        controller: _idTextController,
                        maxLines: 1,
                        decoration: InputDecoration(labelText: 'ID',
                        border: OutlineInputBorder()),
                      ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _pwTextController,
                      obscureText: true,
                      maxLines: 1,
                      decoration: InputDecoration(labelText: 'PW',
                      border: OutlineInputBorder()),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamed('/sign');
                      },
                          child: Text('회원가입')),
                      TextButton(onPressed: () {
                        if(_idTextController!.value.text.length==0||
                        _pwTextController!.value.text.length==0){
                          makeDialog('빈칸 있습니다.');
                        } else {
                          reference!.child(_idTextController!.value.text).onValue.listen((event) {
                            if(event.snapshot.value==null) {
                              makeDialog('아이디가 없습니다.');
                            } else {
                              reference!.child(_idTextController!.value.text).onChildAdded.listen((event) {
                                User user = User.fromSnapshot(event.snapshot);

                                var bytes = utf8.encode(_pwTextController!.value.text);
                                var digest = sha1.convert(bytes);
                                if(user.pw==digest.toString()) {
                                  Navigator.of(context).pushReplacementNamed('/main',arguments: _idTextController!.value.text);
                                } else {
                                  makeDialog('비밀번호가 틀립니다.');
                                }

                              });
                            }
                          });
                        }
                      },
                          child: Text('로그인')
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )

                ],
              ),),

            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),

    );
  }

  void makeDialog(String text) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Text(text),
      );
    });
  }

}