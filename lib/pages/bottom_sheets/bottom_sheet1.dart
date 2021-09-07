import 'package:flutter/material.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet2.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_3.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_3_1.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_4.dart';
import 'package:avia_app/widgets/custom_button_1.dart';

import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';
import 'bottom_sheet_5.dart';

class BottomSheet1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: kBlueLight,
          borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton1(
            text: s19,
            color: kGreen,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: kTrans,
                    context: context,
                    builder: (context) {
                      return BottomSheet2();
                    });
              }
          ),
          SizedBox(height: 8,),
          CustomButton1(
            text: s20,
            color: kYellow,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: kTrans,
                    context: context,
                    builder: (context) {
                      return BottomSheet3();
                    });
              }
          ),
          SizedBox(height: 8,),
          CustomButton1(
            text: s21,
            color: kRed,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: kTrans,
                    context: context,
                    builder: (context) {
                      return BottomSheet3copy();
                    });
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s12,style: st1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s13,style: st1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s14,style: st1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s15,style: st1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s3,style: st1,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s17,style: st1,),
          ),
          SizedBox(height: 6,),
          CustomButton1(
            text: s18,
            color: kYellow,
          )
        ],
      ),
    );
  }
}
