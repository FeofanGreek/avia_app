import 'dart:convert';

import 'package:avia_app/pages/homepage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/constants.dart';
import 'package:avia_app/text_styles.dart';
import 'package:intl/intl.dart';
import '../strings.dart';

String routesToProcess = '[{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"}]';
List routToProcess = json.decode(routesToProcess);
List <String> statuses = ['Отложить','Передать в УЛЭРА', 'Отклонить', 'Согласовать' ];
int senderStatus = 0;
List switchToRoute = [];


class proceedScreenR extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<proceedScreenR> {
  var _controllerSearchRegion = TextEditingController();


  @override
  void initState() {
    super.initState();
    for(int i = 0; i < routToProcess.length; i++){
      switchToRoute.add(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      //extendBody: true,

        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: kBlue,
          automaticallyImplyLeading: false,
          title:Container(
              padding: EdgeInsets.fromLTRB(0,8,0,0),
              child:Text('Отправить форму?', style: st5)
          ) ,
          actions: [
            Container(
              height: 40,
              //alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(10,0,10,0),
              child:TextButton(
                onPressed:(){
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) =>HomePage()));
                },
                child: Icon(CupertinoIcons.clear, size: 20, color: kWhite3,),
                style: ElevatedButton.styleFrom(
                  primary: kBlue,
                  //minimumSize: Size(MediaQuery.of(context).size.width, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 1,
                    groupValue: senderStatus,
                    onChanged: (value) {
                      setState(() {
                        senderStatus = value;
                      });
                    },
                  ),
                  Text('ФАВТ')
                ]),
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 2,
                    groupValue: senderStatus,
                    onChanged: (value) {
                      setState(() {
                        senderStatus = value;
                      });
                    },
                  ),
                  Text('МИД')
                ]),
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 3,
                    groupValue: senderStatus,
                    onChanged: (value) {
                      setState(() {
                        senderStatus = value;
                      });
                    },
                  ),
                  Text('МИнпромторг')
                ]),
            Container(
                padding: EdgeInsets.fromLTRB(10,10,0,0),
                child:Text('Выберите рейсы', style: st11)
            ) ,
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: routToProcess.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                              children: [
                                Row(
                                  children:[
                                    GestureDetector( onTap: (){setState(() {
                                      switchToRoute[index] = !switchToRoute[index];
                                    });},
                                      child:Container(
                                        color: !switchToRoute[index] ? kWhite1 : kWhite3,
                                        width: MediaQuery.of(context).size.width/3*2-12,
                                        margin: EdgeInsets.fromLTRB(5,5,5,5),
                                        padding: EdgeInsets.fromLTRB(5,5,5,5),
                                        child: Row(
                                          children:[
                                            Image.asset(
                                                routToProcess[index]['status'] == 'Отложить' ?  'icons/plane_grey.png' : routToProcess[index]['status'] == 'Отклонить' ? 'icons/plane_red.png' : routToProcess[index]['status'] == 'Передать в УЛЭРА' ? 'icons/plane_yellow.png' : 'icons/plane_blue.png', width: 16,
                                                height: 16,
                                                fit: BoxFit.fitHeight),
                                            SizedBox(width: 5,),
                                            Text(routToProcess[index]['rout'], style: st4,),
                                            SizedBox(width: 5,),
                                            Expanded( child:Text(routToProcess[index]['option'], style: st9,),),
                                            ])),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width/3,
                                        height: 40,
                                        //margin: EdgeInsets.fromLTRB(0,8,9,0),
                                        //padding: EdgeInsets.fromLTRB(8,3,0,3),
                                        //decoration: BoxDecoration(
                                        //    border: Border.all(color: kWhite.withOpacity(0.2), width: 2)
                                        //),
                                        child: DropdownButton<String>(
                                          //menuMaxHeight: 67,
                                          isExpanded: true,
                                          value: routToProcess[index]['status'],
                                          icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                                          iconSize: 30,
                                          elevation: 10,
                                          underline: Container(
                                            height: 0,
                                            color: kBlueLight,
                                          ),
                                          onChanged: (String newValue){
                                            setState(() {
                                              routToProcess[index]['status'] = newValue;
                                            });
                                          },
                                          items: statuses.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: st4,),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ])
                              ]);
                        }) ,

                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:BottomAppBar(
          color: Colors.transparent,
          child:Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(10,0,10,10),
            child:TextButton(
              onPressed:(){
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) =>HomePage()));
              } ,
              child: Text('Применить', style: st17,textAlign: TextAlign.center,),
              style: ElevatedButton.styleFrom(
                primary: kYellow,
                minimumSize: Size(MediaQuery.of(context).size.width , 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          elevation: 0,
        )
    );
  }

}




