import 'dart:convert';
import 'dart:io';

import 'package:avia_app/profile/tuneProfile.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';


int  passNotCompare = 0;


class roleProfilePage extends StatefulWidget {
  @override
  _roleProfilePageScreenState createState() => _roleProfilePageScreenState();
}

class _roleProfilePageScreenState extends State<roleProfilePage> {

  TextEditingController _email, _password, _passwordR, _passwordOld, _familia, _name, _fatherName, _phone, _dopInfo;

  @override
  void initState() {
    _fatherName = TextEditingController(text: fatherName);
    _name = TextEditingController(text: name);
    _familia = TextEditingController(text: familia);
    _passwordR = TextEditingController(text: passwordR);
    _password = TextEditingController(text: password);
    _passwordOld = TextEditingController(text: passwordOld);
    _email = TextEditingController(text: regEmail);
    _phone = TextEditingController(text: regPhone);
    _dopInfo = TextEditingController(text: dopInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
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
                      saveTunes();
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
                ])
        ),
      ),
      body:SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              margin: EdgeInsets.fromLTRB(10,0,10,0),
              color: kBlue,
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(0,0,0,25),
                      alignment: Alignment.topLeft,
                      child: Text(s204, style: TextStyle(fontSize: 28.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              saveTunes();
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => tuneProfilePage()));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kWhite2 ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kBlue,
                                ),
                                child: Text(s205, style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => roleProfilePage()));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(s206, style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                        ]
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,0),
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite1),
                          borderRadius: BorderRadius.circular(20.0),
                          color: !isPilot ? kBlue : kBlueLight,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.topCenter,
                                child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s243, style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(width:MediaQuery.of(context).size.width - 110,),
                                            FlutterSwitch(
                                          width: 36.0,
                                          height: 22.0,
                                          toggleColor: Color(0xFFFFFFFF),
                                          activeColor: kYellow,
                                          inactiveColor: kWhite2,
                                          padding: 2.0,
                                          toggleSize: 18.0,
                                          borderRadius: 11.0,
                                          value: isPilot,
                                          onToggle: (value) {
                                            setState(() {
                                              isPilot = value;
                                            });
                                          },
                                        ),
                                        ]),
                                      ),
                                GestureDetector(
                                    onTap: (){
                                      dialogScreen(context, 'Раздел находится в разработке');},
                                    child:Container(
                                        margin: EdgeInsets.fromLTRB(0,40,10,10),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s244, style: st10),
                                      ),
                                  ),
                                    ]),
                              ),
                          ])
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,0),
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite1),
                          borderRadius: BorderRadius.circular(20.0),
                          color: !isExPilot ? kBlue : kBlueLight,
                        ),
                        child: Column(
                            children: <Widget>[
                              Container(
                                width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.topCenter,
                                child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s245, style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            children: <Widget>[
                                              SizedBox(width:MediaQuery.of(context).size.width - 110,),
                                              FlutterSwitch(
                                                width: 36.0,
                                                height: 22.0,
                                                toggleColor: Color(0xFFFFFFFF),
                                                activeColor: kYellow,
                                                inactiveColor: kWhite2,
                                                padding: 2.0,
                                                toggleSize: 18.0,
                                                borderRadius: 11.0,
                                                value: isExPilot,
                                                onToggle: (value) {
                                                  setState(() {
                                                    isExPilot = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,40,40,10),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Беспилотные аппараты. Позволяет управлять планами SHR и SPW', style: st16),
                                      ),
                                    ]),
                              ),
                            ])
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,0),
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite1),
                          borderRadius: BorderRadius.circular(20.0),
                          color: !isExploer ? kBlue : kBlueLight,
                        ),
                        child: Column(
                            children: <Widget>[
                              Container(
                                width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.topCenter,
                                child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s246, style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            children: <Widget>[
                                              SizedBox(width:MediaQuery.of(context).size.width - 110,),
                                              FlutterSwitch(
                                                width: 36.0,
                                                height: 22.0,
                                                toggleColor: Color(0xFFFFFFFF),
                                                activeColor: kYellow,
                                                inactiveColor: kWhite2,
                                                padding: 2.0,
                                                toggleSize: 18.0,
                                                borderRadius: 11.0,
                                                value: isExploer,
                                                onToggle: (value) {
                                                  setState(() {
                                                    isExploer = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,40,40,10),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Регулярные перевозки. Позволяет управлять планами RPL', style: st16),
                                      ),

                                    ]),
                              ),
                            ])
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,0),
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite1),
                          borderRadius: BorderRadius.circular(20.0),
                          color: kBlue ,
                        ),
                        child: Column(
                            children: <Widget>[
                              Container(
                                width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.topCenter,
                                child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text('Государственная авиация МЧС', style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,50,40,10),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text('г. Наро-Фоминск, в/ч 45231', style: st16),
                                      ),
                                    ]),
                              ),
                          Container(
                                margin: EdgeInsets.fromLTRB(0,0,0,10),
                                width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.bottomLeft,
                                child: Text(s248, style: st11),
                              ),
                         ])
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,40),
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite1),
                          borderRadius: BorderRadius.circular(20.0),
                          color: kBlue ,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width:MediaQuery.of(context).size.width ,
                                alignment: Alignment.topCenter,
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s247, style: st13),
                                      ),
                                      //надо построить через лист буилдер
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,40,0,10),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget> [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0,0,15,0),
                                              padding: EdgeInsets.fromLTRB(0,0,0,0),
                                              width: 33,
                                              height: 33,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.5),
                                                color: kGreen,
                                              ),
                                              child: Text('AK', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 160,
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Константин Наумов', style: st1,),
                                                  Text('Создание планов FPL от моего имени, Использование меня в качестве КВС, Подача сообщений DEP/ARR', style: st14),
                                                ]
                                              )
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                dialogScreen(context, 'Раздел находится в разработке');
                                              },
                                              child:Container(
                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.5, color: kWhite3),
                                                color: kBlue,
                                              ),
                                              child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                            ),
                                            ),
                                          ],
                                        )
                                      ),
                                      Container(
                                          margin: EdgeInsets.fromLTRB(0,20,0,10),
                                          width:MediaQuery.of(context).size.width ,
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget> [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0,0,15,0),
                                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                width: 33,
                                                height: 33,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16.5),
                                                  color: kRed,
                                                ),
                                                child: Text('AK', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context).size.width - 160,
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text('Василий Теркин', style: st1,),
                                                        Text('Создание планов FPL от моего имени.', style: st14),
                                                      ]
                                                  )
                                              ),
                                            GestureDetector(
                                              onTap: (){
                                                dialogScreen(context, 'Раздел находится в разработке');
                                              },
                                              child:Container(
                                                padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                  color: kBlue,
                                                ),
                                                child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                              ),
                                            ),
                                            ],
                                          )
                                      ),
                                    ]),
                              ),
                              GestureDetector(
                                  onTap: (){
                                    dialogScreen(context, 'Раздел находится в разработке');
                                  },
                                 child:Container(
                                    margin: EdgeInsets.fromLTRB(0,0,0,10),
                                    width:MediaQuery.of(context).size.width ,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(s249, style: st10),
                                  ),
                            ),
                            ])
                    ),
                  ]),
            ),

      ),
    );
  }

  //запоминаем настройкип приложения при выходе из экрана настроек
  saveTunes() async{
    try {
      //записали в файл номер пользователя
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/profile.txt');
      var profile = jsonEncode(<String, dynamic>{
        //переменные для настройки пользователя
        "regEmail" : "$regEmail",
        "password" : "$password",
        "familia" : "$familia",
        "name" : "$name",
        "fatherName" : "$fatherName",
        "regPhone" : "$regPhone",
        "ikaoReg" : "$ikaoReg",
        "dopInfo" : "$dopInfo",
        "isPilot" : isPilot == false ? 0 : 1,
        "isExPilot" : isExPilot == false ? 0 : 1,
        "isExploer" : isExploer == false ? 0 : 1,
        "language" : "$language",
        "sendCode" : "$sendCode",
        "senId" : "$senId",
        "delayReason" : "$delayReason",
        "tollUnit" : "$tollUnit",
        "distanceUnit" : "$distanceUnit",
        "coordinatUnit" : "$coordinatUnit",
        "dateFormat" : "$dateFormat",
        "speedHorisontUnit" : "$speedHorisontUnit",
        "speedVerticalUnit" : "$speedVerticalUnit",
        "costUnit" : "$costUnit",
        "presureUnit" : "$presureUnit",
        "temperatureUnit" : "$temperatureUnit",
        "minAllitude" : minAllitude,
        "maxAllitude" : maxAllitude,
        "darkTheme" : darkTheme == false ? 0 : 1,
        "emailNotif" : emailNotif == false ? 0 : 1,
        "smsNotif" : smsNotif == false ? 0 : 1,
        "autorouting" : autorouting == false ? 0 : 1,
        "nafanya" : nafanya == false ? 0 : 1,
        "oneTimePassword" : oneTimePassword == false ? 0 : 1,
        "showUTC" : showUTC == false ? 0 : 1,
        "accessToken" : "$accessToken",
        "tokenType" : "$tokenType",
        "expires" : "$expires",
        "userId" : "$userId",
        "showRegistryType" : showRegistryType == false ? 0 : 1
      });
      await file.writeAsString(profile);
      print("Записали файл");
    }catch(e) {}

  }

}