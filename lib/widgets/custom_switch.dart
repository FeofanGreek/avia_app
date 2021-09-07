import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../constants.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function onChanged;
  CustomSwitch({this.value,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 36.0,
      height: 22.0,
      valueFontSize: 25.0,
      toggleSize: 14.0,
      value: value,
      borderRadius: 30.0,
      padding: 4.0,
      showOnOff: false,
      onToggle: onChanged,
      activeColor: kYellow,
      inactiveColor: kBlueLight,
      activeToggleColor: kWhite,
      inactiveToggleColor: kYellow,
    );
  }
}
