import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';

class MobileLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileLoginScreen();
  }
}

class _MobileLoginScreen extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Screen'),
      ),
      body: Container(
        child: CountryCodePicker(
          onChanged: (value){
            debugPrint("country code "+ value.toString());
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
      ),
    );
  }
}
