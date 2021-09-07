import 'package:flutter/material.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_7.dart';
import '../constants.dart';

class CustomFilterButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: kTrans,
            context: context,
            builder: (context) {
              return BottomSheet7();
            });
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(border: Border.all(color: kWhite1)),
        child: Icon(
          Icons.filter_alt,
          color: kWhite,
        ),
      ),
    );
  }
}