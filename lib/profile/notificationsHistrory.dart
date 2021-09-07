import 'dart:convert';

import 'package:avia_app/widgets/custom_filter_button.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:avia_app/widgets/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';

String notifFromServer = '[{"notificationId" : "1",'+
'"notificationBody": {'+
'"autor" : "Сидоров Иван Петрович",'+
'"date": "2021-03-21",'+
'"status": "1",'+
'"message" : "Предоставил вам доступ к воздушному судну «Жорик»"}},'+
'{"notificationId" : "2",'+
'"notificationBody": {'+
'"autor" : "Сидоров Иван Петрович",'+
'"date": "2021-03-22",'+
'"status": "2",'+
'"message" : "22.03.2020 14:00 - 22.03.2020 15:00 HELICOPTER: Robinson R66, MTOW: 1,134 кг. Прием/выпуск, слот, заправка 3000 л. Стоянка"}},'+
'{"notificationId" : "3",'+
'"notificationBody": {'+
'"autor" : "Сидоров Иван Петрович",'+
'"date": "2021-03-21",'+
'"status": "1",'+
'"message" : "Предоставил вам доступ к воздушному судну «Жорик»"}}]';

List notifList = json.decode(notifFromServer);

class notificationsHistroyPage extends StatefulWidget {
  @override
  _notificationsHistroyPageScreenState createState() => _notificationsHistroyPageScreenState();
}

class _notificationsHistroyPageScreenState extends State<notificationsHistroyPage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
        title: Container(
            width:MediaQuery.of(context).size.width ,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                  onTap: (){
                    headerValue = s191;
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/profile');},
                      child:Container(
                              width:MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              child:  Text(
                                s170,
                                style: st10,
                              ),
                            ),
                          ),
                  GestureDetector(
                      onTap: (){
                    dialogScreen(context, 'Раздел находится в разработке');
                    },
                      child:Container(
                        width:MediaQuery.of(context).size.width,
                        alignment: Alignment.centerRight,
                        child:  Text(
                      s201,
                      style: st10,
                    ),
                  ),
                )
          ])
        ),
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(15,0,0,25),
                    alignment: Alignment.topLeft,
                    child: Text(s203, style: TextStyle(fontSize: 28.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notifList.length,
                      itemBuilder: (BuildContext context, int index) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(notifList[index]['notificationBody']['autor'], style: st11),
                                        SizedBox(width: 10,),
                                        Text(notifList[index]['notificationBody']['date'], style: st14),
                                      ],
                                    ),
                                  ),
                              GestureDetector(
                                onTap: (){
                                  dialogScreen(context, 'Раздел находится в разработке');
                                },
                                child:Container(
                                    alignment: Alignment.centerRight,
                                    child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                  ),
                              )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,0,0,10),
                              child:  Text(notifList[index]['notificationBody']['message'], style: st11),
                            ),
                            notifList[index]['notificationBody']['status'] == '2' ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.fromLTRB(10,20,10,25),
                              child: TextButton(
                                onPressed:(){
                                    dialogScreen(context, 'Раздел находится в разработке');
                                } ,
                                child: Text(s202, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
                                style: ElevatedButton.styleFrom(
                                  primary: kBlue,
                                  minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: kWhite2,
                                        width: 1,
                                        style: BorderStyle.solid
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                            ) : Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,5,0,10),
                              height: 1,
                              color: kBlueLight,
                              child: Divider(
                                color: kWhite3,
                                height: 0.5,
                              ),
                            ),
                          ]);
                    }),


                ]
            )
        ),
      ),
    );
  }
}