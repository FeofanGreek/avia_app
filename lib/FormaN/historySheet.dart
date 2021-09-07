import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/text_styles.dart';
import '../../constants.dart';
import '../../strings.dart';
import 'history.dart';

int selectedTabHistory = 1;

String dropdownValue = s157;
bool switch1 = true;
String filterName = '';

class historySheet extends StatefulWidget {
  @override
  _BottomSheet7State createState() => _BottomSheet7State();
}

int check = 0;

class _BottomSheet7State extends State<historySheet> {

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
                padding: MediaQuery.of(context).viewInsets,
                decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                margin: EdgeInsets.only(top: 80),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(8.0),
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
                      height: 5,
                    ),
                    Stack(
                        children:[
                        GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
              child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Отмена',style: st12),),),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                            '${historyList[selectedTabHistory]['routNumber']} - ${historyList[selectedTabHistory]['routeDateIn']}',
                            style: TextStyle(fontSize: 16,fontFamily: 'AlS Hauss',),
                          ),),

                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child:ListView.builder(
                            //padding: EdgeInsets.only(left: 8),
                            //scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: historyList[selectedTabHistory]['historyBody'].length,
                            itemBuilder: (context, index2) {
                              return Container( margin: EdgeInsets.fromLTRB(10,0,10,0),child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    SizedBox(height: 10,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Image.asset(
                                            historyList[selectedTabHistory]['historyBody'][index2]['type'] == 'Ошибка' ?  'icons/triangle_red.png' : historyList[selectedTabHistory]['historyBody'][index2]['type'] == 'Примечание' ? 'icons/triangle_blue.png' : 'icons/aboutIcon.png', width: 16,
                                            height: 16,
                                            fit: BoxFit.fitHeight),
                                        SizedBox(width: 5,),
                                    Text(
                                      '${historyList[selectedTabHistory]['historyBody'][index2]['header']}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: historyList[selectedTabHistory]['historyBody'][index2]['type'] == 'Ошибка' ? Color(0xFFEB5757) : historyList[selectedTabHistory]['historyBody'][index2]['type'] == 'Примечание' ? Color(0xFF337AD9) : kWhite), textAlign: TextAlign.left,
                                    ),
                                    ]),
                                    Text(
                                      '${historyList[selectedTabHistory]['historyBody'][index2]['partOfForm']}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite2), textAlign: TextAlign.left,
                                    ),

                                    SizedBox(height: 10,),
                                    //Divider(height: 1,thickness: 1,color: kWhite1,),
                                  ]));}
                        )),
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
