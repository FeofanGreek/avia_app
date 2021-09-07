import 'package:flutter/material.dart';
import '../constants.dart';
import '../text_styles.dart';

class CustomBorderTitleContainer extends StatelessWidget {
  final Widget child;
  final String title;
  CustomBorderTitleContainer({this.child,this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration:
              BoxDecoration(border: Border.all(color: kWhite1)),
              child: child,
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            child: Container(
              color: kBlue,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(title,style: st2,),
            ),
          )
        ],
      ),
    );
  }
}