import 'package:flutter/material.dart';
import 'package:avia_app/widgets/custom_button_1.dart';

import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet1copy extends StatelessWidget {
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
