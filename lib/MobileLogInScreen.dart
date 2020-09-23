import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_login/OtpVerifyScreen.dart';

class MobileLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileLoginScreen();
  }
}

class _MobileLoginScreen extends State<MobileLoginScreen> {
  final _phoneController = TextEditingController();

  String countryCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mobile Screen'),
        ),
        body: Column(
          children: [
            CountryCodePicker(
              onChanged: (value) {
                debugPrint("country code " + value.toString());
                setState(() {
                  countryCode = value.toString();
                });
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'US',
              //favorite: ['+880','BD'],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
            Container(
              child: TextFormField(
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
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("LOGIN"),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                onPressed: () async {
                  final phone = _phoneController.text.trim();
                  String number = countryCode + phone;
                  debugPrint("number is $number");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerifyScreen(
                              number: number,
                            )),
                  );
                },
                color: Colors.blue,
              ),
            )
          ],
        ));
  }
}
