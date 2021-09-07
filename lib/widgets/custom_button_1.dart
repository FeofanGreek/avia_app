import 'package:flutter/material.dart';
import '../constants.dart';
import '../strings.dart';

class CustomButton1 extends StatelessWidget {
final String text;
final Color color;
final Function onPressed;
CustomButton1({this.color,this.text,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration:
        BoxDecoration(border: Border.all(color: kWhite1)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(text,style: TextStyle(
                fontSize: 16,
                color: color
            ),),
          ),
        ),
      ),
    );
  }
}
