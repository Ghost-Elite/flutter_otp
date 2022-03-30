import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'home.dart';
import 'loginScreen.dart';

class OptScreen extends StatefulWidget {
  final String phone;
  OptScreen( this.phone);

  @override
  _OptScreenState createState() => _OptScreenState();
}

class _OptScreenState extends State<OptScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController? _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text('Verify +221 ${ widget.phone } ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      !.showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }
  verifyPhone()async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+221${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential)
              .then((value) async{
                if (value.user !=null) {
                  print("user logged in");
                }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String? verificationID,int? resendToken ){
          setState(() {
            _verificationCode =verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String? verificationID){
          setState(() {
            _verificationCode=verificationID;
          });

        },
      timeout: Duration(seconds: 60),
    );
  }
}
