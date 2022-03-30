
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'optScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                child: Center(
                  child: Text(' Phone authentication ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40,right: 10,left: 10),
                child: TextField(
                decoration: InputDecoration(hintText: 'Phone Number',
                  prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('+221')
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: numberController,
              ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.cyan,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>OptScreen(numberController.text.trim())));
              },
            child: Text('Next',style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

}
