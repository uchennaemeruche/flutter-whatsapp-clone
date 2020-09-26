import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print("Hello there, verification started: $verId");
      setState(() {
        this.verificationId = verId;
      });
      smsCodeDialog(context);
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      print("verified");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return Home();
      }));
    };

    final PhoneVerificationFailed verificationFailed = (AuthException err) {
      print('${err.message}');
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      setState(() {
        this.verificationId = verID;
      });
      print("SMS code sent");
      print(verID);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        timeout: Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Enter SMS Code"),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    this.smsCode = value;
                  });
                },
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) {
                      if (user != null) {
                        print("There is a user: $user");
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) {
                          return Home();
                        }));
                      } else {
                        print("There is no user $user");
                        Navigator.pop(context);
                        signIn();
                      }
                    });
                  },
                )
              ],
            ));
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return Home();
      }));
    }).catchError((e) => print("There is an error: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign into WhatsAPp"),
      ),
      body: ListView(
        children: <Widget>[
          FlutterLogo(
            size: 250,
            colors: Colors.teal,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter Phone Number"),
            onChanged: (value) {
              setState(() {
                this.phoneNo = value;
              });
            },
          ),
          RaisedButton(
            onPressed: verifyNumber,
            color: Colors.teal,
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
