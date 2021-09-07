import 'package:flutter/material.dart';
import 'package:avia_app/constants.dart';

import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet2 extends StatefulWidget {
  @override
  _BottomSheet2State createState() => _BottomSheet2State();
}

class _BottomSheet2State extends State<BottomSheet2> {
  bool first = false,second = false;


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
                        Text(s22,style: st8,textAlign: TextAlign.center,),
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
                          child: Text('DOC',style: st1,),
                        ),
                        SizedBox(width: 10,),
                        Text(s45,style: st3,)
                      ],
                    ),
                    SizedBox(height: 10,),
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
                    Row(
                      children: [
                        Text(s46,style: st2,),
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
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: 3,),
                                  Container(
                                    width: 10,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(color: kWhite1),
                                            top: BorderSide(color: kWhite1)
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(Icons.lock,color: kWhite3,),
                                          labelText: s47,
                                          labelStyle: st2
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text('1',style: st2,),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 3,),
                                  Container(
                                    width: 10,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(color: kWhite1),
                                            bottom: BorderSide(color: kWhite1)
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(Icons.lock,color: kWhite3,),
                                          labelText: s48,labelStyle: st2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                if(first == true){
                                  first = false;
                                }else{
                                  first = true;
                                }
                              });
                            },
                            child: first ? CircleAvatar(
                              radius: 12,
                              backgroundColor: kYellow,
                              child: Icon(Icons.done,color: kWhite,size: 16,),
                            ) : Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kWhite1)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: 3,),
                                  Container(
                                    width: 10,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(color: kWhite1),
                                            top: BorderSide(color: kWhite1)
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(Icons.lock,color: kWhite3,),
                                          labelText: s47,
                                          labelStyle: st2
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text('2',style: st2,),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 3,),
                                  Container(
                                    width: 10,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(color: kWhite1),
                                            bottom: BorderSide(color: kWhite1)
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(Icons.lock,color: kWhite3,),
                                          labelText: s48,labelStyle: st2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                if(second == true){
                                  second = false;
                                }else{
                                  second = true;
                                }
                              });
                            },
                            child: second ? CircleAvatar(
                              radius: 12,
                              backgroundColor: kYellow,
                              child: Icon(Icons.done,color: kWhite,size: 16,),
                            ) : Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kWhite1)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 45,
                      child: FlatButton(
                        color: kYellow,
                        child: Text(
                          first == true && second == true ? s19 : s49,
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

