import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_login/otp_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerifyScreen extends StatefulWidget {
  String mobileNumber;

  OtpVerifyScreen({String number}) {
    this.mobileNumber = number;
  }

  @override
  State<StatefulWidget> createState() {
    return _OtpVerifyScreen(mobileNumber);
  }
}

class _OtpVerifyScreen extends State<OtpVerifyScreen> {
  String mobileNumber;

  _OtpVerifyScreen(this.mobileNumber);

  bool isCodeSent = false;
  String _verificationId;

  TextEditingController _pinEditingController = TextEditingController();

  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, top: 4),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Verify Details",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "OTP sent to ${widget.mobileNumber}",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: PinInputTextField(
                pinLength: 6,
                decoration: _pinDecoration,
                autoFocus: true,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    showToast("Invalid OTP", Colors.red);
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Text(
                      "Enter OTP",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      if (_pinEditingController.text.length == 6) {
                        _onFormSubmitted();
                      } else {
                        showToast("Invalid OTP", Colors.red);
                      }
                    },
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          debugPrint("phone number ${value.user.phoneNumber}");
          showToast("Login Success", Colors.green);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("error ${error.toString()}", Colors.red);
      });
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    _firebaseAuth.signInWithCredential(_authCredential).then((value) {
      if (value.user != null) {
        debugPrint("${value.user.phoneNumber}");
        debugPrint("final result ${value.toString()}");
        showToast("Otp verify success", Colors.green);
      } else {
        showToast("Otp verification error ", Colors.red);
      }
    }).catchError((error) {
      showToast("Someting went wrong", Colors.red);
    });
  }
}
