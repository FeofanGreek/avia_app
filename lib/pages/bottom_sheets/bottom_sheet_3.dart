import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.001),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
                ),
                margin: EdgeInsets.only(top: 80),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 150),
                        child: Divider(height: 4,
                          thickness: 4,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.settings,size: 18,color: kWhite2,),
                        Spacer(flex: 4,),
                        Text(s50,style: st8,textAlign: TextAlign.center,),
                        Spacer(flex: 5,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(s23,style: st2,),
                        SizedBox(width: 6,),
                        Expanded(
                          child: Divider(
                            color: kWhite1,
                            thickness: 2,
                            height: 2,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s24,style: st2,),
                        Text(s25,style: st4,textAlign: TextAlign.right,),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s26,style: st2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s27,style: st2,),
                            SizedBox(width: 6,),
                            Text(s28,style: st4,),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s29,style: st2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s30,style: st2,),
                            SizedBox(width: 6,),
                            Text(s31,style: st4,),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s32,style: st2,),
                        Text(s33,style: st4,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s34,style: st2,),
                        Text(s35,style: st4,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s36,style: st2,),
                        Text(s37,style: st4,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s38,style: st2,),
                        Text(s39,style: st4,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s40,style: st2,),
                        Text(s41,style: st4,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s42,style: st2,),
                        Text(s43,style: st4,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text(s44,style: st2,),
                        SizedBox(width: 6,),
                        Expanded(
                          child: Divider(
                            color: kWhite1,
                            thickness: 2,
                            height: 2,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: kYellow
                          ),
                          child: Text('PDF',style: st1,),
                        ),
                        SizedBox(width: 10,),
                        Text('FPL',style: st3,)
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: s52
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 45,
                      child: FlatButton(
                        color: kYellow,
                        child: Text(
                          s20,
                          style: st1,
                        ),
                        onPressed: () {
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


