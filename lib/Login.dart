import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:internship/Screens/Picker.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLogin createState() => _UserLogin();
}

List<Color> col = [Color(0xFF00d2ff), Color(0xFF3a47d5)];

final _phoneController = TextEditingController();
final _codeController = TextEditingController();
FirebaseAuth _auth = FirebaseAuth.instance;
bool submit;

class _UserLogin extends State<UserLogin> {
  Future<bool> userLogin(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Picker()));
          } else {
            print("Error");
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [code]) =>
            smsSent(verificationId, [code], context),
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("LOGIN")),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 60, right: 60),
                  child: Image(image: AssetImage('assets/login.png'))),
              SizedBox(
                height: 100,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200])),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300])),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Mobile Number"),
                    controller: _phoneController,
                  )),
              SizedBox(
                height: 16,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 80, right: 80),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.shade400,
                              blurRadius: 20.0, // soften the shadow
                              spreadRadius: 2.0,
                              offset: Offset(5, 5))
                        ],
                        gradient: LinearGradient(colors: col),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.pink),
                    width: double.infinity,
                    child: FlatButton(
                        child: submit == true
                            ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.white,
                                ))
                            : Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        onPressed: () {
                          final phone = _phoneController.text.trim();

                          if (_phoneController.text != "") {
                            setState(() {
                              submit = true;
                            });
                            userLogin(phone, context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please Enter Your Number",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                        }),
                  ))
            ],
          ),
        ));
  }
}

smsSent(String verificationId, List<int> code, BuildContext context) {
  _phoneController.clear();
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => otpPage(context, verificationId)),
      (route) => false);
}

Widget otpPage(BuildContext context, String verificationId) {
  return Scaffold(
    body: Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage('assets/otp.png')),
        SizedBox(height: 20),
        Text(
          "Enter the OTP Code..",
          style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
              fontFamily: "Berkshire Swash"),
        ),
        SizedBox(height: 40),
        Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: TextStyle(color: Color.fromRGBO(38, 50, 56, .50)),
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                hintStyle: TextStyle(
                    color: Color.fromRGBO(38, 50, 56, 0.30),
                    fontSize: 15.0,
                    fontFamily: "Berkshire Swash"),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
              ),
            )),
        SizedBox(height: 30),
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade400,
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 2.0,
                      offset: Offset(5, 5))
                ],
                gradient: LinearGradient(colors: col),
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink),
            child: FlatButton(
              child: Text(
                "Confirm",
              ),
              textColor: Colors.white,
              onPressed: () async {
                final code = _codeController.text.trim();
                if (_codeController.text != "") {
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                      verificationId: verificationId, smsCode: code);

                  AuthResult result =
                      await _auth.signInWithCredential(credential);

                  FirebaseUser user = result.user;

                  if (user != null) {
                    Fluttertoast.showToast(
                        msg: "Logged In", toastLength: Toast.LENGTH_SHORT);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Picker()));
                  } else {
                    print("Error");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Enter the OTP",
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
            ))
      ],
    )),
  );
}
