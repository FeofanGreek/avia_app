import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/text_styles.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import '../../constants.dart';
import '../../strings.dart';

class BottomSheet8 extends StatefulWidget {
  @override
  _BottomSheet8State createState() => _BottomSheet8State();
}

class _BottomSheet8State extends State<BottomSheet8> {
  bool cb1 = false;

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
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                margin: EdgeInsets.only(top: 80),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    controller: controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 150),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Divider(
                            height: 4,
                            thickness: 4,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            s170,
                            style: st3,
                            textAlign: TextAlign.center,
                          ),
                          Spacer(
                            flex: 5,
                          ),
                          Text(
                            s165,
                            style: st8,
                            textAlign: TextAlign.center,
                          ),
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration:
                        BoxDecoration(border: Border.all(color: kWhite1)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s171,
                              suffixStyle: st2
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            if(cb1 == true){
                              cb1 = false;
                            }else{
                              cb1 = true;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s171,style: st1,),
                                SizedBox(height: 4,),
                                Text(s172,style: st2,),
                              ],
                            ),
                            AnimatedContainer(
                              curve: Curves.linear,
                              duration: Duration(milliseconds: 200),
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                border: cb1 ? Border.all(color: kTrans) : Border.all(color: kWhite1),
                                shape: BoxShape.circle,
                                color: cb1 ? kYellow : kTrans,
                              ),
                              child: Icon(Icons.done,color: cb1 ? kWhite : kTrans,size: 14,),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Divider(
                        color: kWhite1,
                        thickness: 1,
                      ),
                      SizedBox(height: 400,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton1(
                              text: s173,
                              color: kYellow,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration:
                            BoxDecoration(border: Border.all(color: kWhite1)),
                            child: Center(
                              child: Container(
                                height: 16,
                                width: 16,
                                child: Image.asset('icons/delete.png'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
