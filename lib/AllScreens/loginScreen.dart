import 'package:flutter/material.dart';

class login extends StatelessWidget {
  const login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(2),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  'TRACK \nN\' RIDE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoBold',
                    color: Colors.orange[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 60,),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: RaisedButton(
                  textColor: Colors.orange[400],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey),),
                  child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          fontFamily: 'RobotoRegular',
                          fontSize: 20),
                  ),
                  onPressed: () {
                    print('');
                    print('');
                  },
                )),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: RaisedButton(
                  textColor: Colors.orange[400],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey),),
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                        fontFamily: 'RobotoRegular',
                        fontSize: 20),
                  ),
                  onPressed: () {
                    print('');
                    print('');
                  },
                )),
          ],
        )
      ),
    );
  }
}
