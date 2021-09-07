import 'dart:convert';
import 'dart:io';
import 'package:avia_app/downloadVocabulare/downloadProcedure.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/pages2/homepage_other.dart';
import 'package:avia_app/profile/tuneProfile.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:avia_app/widgets/expanded_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'mainProfile.dart';

List <String> showRigestryTypes = ['По рейсам', 'По заявкам'];
String showTypes = showRigestryTypes[0];


class tuneAppPage extends StatefulWidget {
  @override
  _tuneAppPageScreenState createState() => _tuneAppPageScreenState();
}

class _tuneAppPageScreenState extends State<tuneAppPage> {
  TextEditingController _sendId, _sendCode, _minAllitude, _maxAllitude;

  bool e1 = true,
      e2 = false,
      e3 = false,
      e4 = false,
      e5 = false,
      e6 = false,
      e7 = false,
      e8 = false;


  @override
  void initState() {
    _sendId = TextEditingController(text: senId);
    _sendCode = TextEditingController(text: sendCode);
    _minAllitude = TextEditingController(text: minAllitude.toString());
    _maxAllitude = TextEditingController(text: maxAllitude.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  kBlue,
        extendBodyBehindAppBar: false,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              margin: EdgeInsets.fromLTRB(10,0,10,0),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      alignment: Alignment.center,
                      child: Text('$name $familia', style: TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                    ),
                    SizedBox(height: 20,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => tuneProfilePage()));},
                            child: Container(
                                width: 300 / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kWhite2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kBlue,
                                ),
                                child: Text(vocabular['header']['profile'], style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                                width: 300 / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(vocabular['header']['settings'], style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e1 = !e1;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e1
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  s214,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e1,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: language,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: st1,
                                    underline: Container(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        language = newValue;
                                      });
                                      loadJson();

                                    },
                                    items: languages.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row( children: <Widget> [
                                          SizedBox(
                                            width: 23,
                                            height: 15,
                                            child: Image.asset(value == 'ru' ? 'images/rfFlag.png' : 'images/enFlag.png',
                                                fit: BoxFit.fitWidth),
                                          ),
                                          SizedBox(
                                            width: 10
                                          ),
                                        Text(
                                          value == 'ru' ? 'Русский' : 'English',
                                        ),

                                        ]),
                                      );
                                    }).toList(),
                                  ),
                                  title: s215,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                /*Stack(
                                  children: <Widget>[
                                    Container(
                                      width:MediaQuery.of(context).size.width ,
                                      alignment: Alignment.centerLeft,
                                      child: Text(s242, style: st13),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0,5,0,5),
                                      width:MediaQuery.of(context).size.width ,
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                          children: <Widget>[
                                            SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                            FlutterSwitch(
                                              width: 36.0,
                                              height: 22.0,
                                              toggleColor: Color(0xFFFFFFFF),
                                              activeColor: kYellow,
                                              inactiveColor: kWhite2,
                                              padding: 2.0,
                                              toggleSize: 18.0,
                                              borderRadius: 11.0,
                                              value: darkTheme,
                                              onToggle: (value) {
                                                setState(() {
                                                  darkTheme = value;
                                                });
                                              },
                                            ),
                                          ]),
                                      ),
                                    ]),
                                SizedBox(
                                  height: 12,
                                ),*/
                               Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s241, style: st1),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            children: <Widget>[
                                              SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                              FlutterSwitch(
                                                width: 36.0,
                                                height: 22.0,
                                                toggleColor: Color(0xFFFFFFFF),
                                                activeColor: kYellow,
                                                inactiveColor: kWhite2,
                                                padding: 2.0,
                                                toggleSize: 18.0,
                                                borderRadius: 11.0,
                                                value: emailNotif,
                                                onToggle: (value) {
                                                  setState(() {
                                                    emailNotif = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ),
                                    ]),
                                SizedBox(
                                  height: 12,
                                ),
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: showTypes,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: st1,
                                    underline: Container(),
                                    onChanged: (String newValue) {
                                      print(newValue);
                                      showTypes = newValue;
                                      //newValue == 'По заявкам' ? showRegistryType = false : true;
                                      showRegistryType = !showRegistryType;
                                      saveTunes();
                                      setState(() {});
                                      print(showRegistryType);
                                    },
                                    items: showRigestryTypes.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child:Text(value)
                                      );
                                    }).toList(),
                                  ),
                                  title: 'Отображать реестры',
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Настроить уведомления', style: st12,
                                      textAlign: TextAlign.center,),
                                    style: ElevatedButton.styleFrom(
                                      primary: kBlue,
                                      minimumSize: Size(MediaQuery
                                          .of(context)
                                          .size
                                          .width, 20),
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
                                ),
                                /*Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s240, style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            children: <Widget>[
                                              SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                              FlutterSwitch(
                                                width: 36.0,
                                                height: 22.0,
                                                toggleColor: Color(0xFFFFFFFF),
                                                activeColor: kYellow,
                                                inactiveColor: kWhite2,
                                                padding: 2.0,
                                                toggleSize: 18.0,
                                                borderRadius: 11.0,
                                                value: smsNotif,
                                                onToggle: (value) {
                                                  setState(() {
                                                    smsNotif = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ),
                                    ]),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      padding: EdgeInsets.fromLTRB(20,0,0,0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kWhite1),
                                      ),
                                      child: TextFormField(
                                        controller: _sendId,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s239,
                                          hintStyle: st8,
                                          contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                                          suffixIcon: IconButton(
                                            onPressed: () => _sendId.clear(),
                                            icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                          ),
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            senId = value;
                                          });
                                        },
                                        autovalidateMode: AutovalidateMode.always,
                                      ),
                                    ),
                                    _sendId.text.length > 0 ? Positioned(
                                        left: 22,
                                        top: 10,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                          color: kBlue,
                                          child: Text(
                                            s239,
                                            style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                          ),
                                        )):Container(),
                                  ],
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      padding: EdgeInsets.fromLTRB(20,0,0,0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kWhite1),
                                      ),
                                      child: TextFormField(
                                        controller: _sendCode,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s238,
                                          hintStyle: st8,
                                          contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                                          suffixIcon: IconButton(
                                            onPressed: () => _sendCode.clear(),
                                            icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                          ),
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            sendCode = value;
                                          });
                                        },
                                        autovalidateMode: AutovalidateMode.always,
                                      ),
                                    ),
                                    _sendCode.text.length > 0 ? Positioned(
                                        left: 22,
                                        top: 10,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                          color: kBlue,
                                          child: Text(
                                            s238,
                                            style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                          ),
                                        )):Container(),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(0,20,0,15),
                                  child: TextButton(
                                    onPressed:(){
                                      dialogScreen(context, 'Раздел находится в разработке');
                                    } ,
                                    child: Text(s237, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(0,0,0,25),
                                  child: TextButton(
                                    onPressed:(){
                                      dialogScreen(context, 'Раздел находится в разработке');
                                    } ,
                                    child: Text(s236, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                                ),
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerLeft,
                                        child: Text(s235, style: st13),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,5,0,5),
                                        width:MediaQuery.of(context).size.width ,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                            children: <Widget>[
                                              SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                              FlutterSwitch(
                                                width: 36.0,
                                                height: 22.0,
                                                toggleColor: Color(0xFFFFFFFF),
                                                activeColor: kYellow,
                                                inactiveColor: kWhite2,
                                                padding: 2.0,
                                                toggleSize: 18.0,
                                                borderRadius: 11.0,
                                                value: autorouting,
                                                onToggle: (value) {
                                                  setState(() {
                                                    autorouting = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ),
                                    ]),
                                Row(
                                  children:<Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width/2-20,
                                          height: 40,
                                          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                                          padding: EdgeInsets.fromLTRB(20,0,0,0),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: kWhite1),
                                          ),
                                          child: TextFormField(
                                            controller: _minAllitude,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none
                                              ),
                                              hintText: s233,
                                              hintStyle: st8,
                                              contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                                              suffixIcon: Container(
                                                alignment: Alignment.center,
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite1,
                                                ),
                                                child: Text(tollUnit[0].toUpperCase(), style: st11),
                                              )
                                            ),
                                            onChanged: (value){
                                              setState(() {
                                                minAllitude = int.parse(value);
                                              });
                                            },
                                            autovalidateMode: AutovalidateMode.always,
                                          ),
                                        ),
                                        _minAllitude.text.length > 0 ? Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                              color: kBlue,
                                              child: Text(
                                                s233,
                                                style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                              ),
                                            )):Container(),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width/2-20,
                                          height: 40,
                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          padding: EdgeInsets.fromLTRB(20,0,0,0),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: kWhite1),
                                          ),
                                          child: TextFormField(
                                            controller: _maxAllitude,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none
                                              ),
                                              hintText: s234,
                                              hintStyle: st8,
                                              contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                                              suffixIcon: Container(
                                                alignment: Alignment.center,
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite1,
                                                ),
                                                child: Text(tollUnit[0].toUpperCase(), style: st11),
                                              )
                                            ),
                                            onChanged: (value){
                                              setState(() {
                                                maxAllitude = int.parse(value);
                                              });
                                            },
                                            autovalidateMode: AutovalidateMode.always,
                                          ),
                                        ),
                                        _maxAllitude.text.length > 0 ? Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                              color: kBlue,
                                              child: Text(
                                                s234,
                                                style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                              ),
                                            )):Container(),
                                      ],
                                    ),
                                  ]
                                ),*/
                          ]))
                        ])),


                    /*Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    e2 = !e2;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      e2
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      s216,
                                      style: st8,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Divider(
                                        height: 2,
                                        thickness: 2,
                                        color: kWhite1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ExpandedSection(
                                  expand: e2,
                                  child: Column(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                alignment: Alignment.centerLeft,
                                                child: Text(s232, style: st13),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0,5,0,5),
                                                width:MediaQuery.of(context).size.width ,
                                                alignment: Alignment.centerRight,
                                                child: Row(
                                                    children: <Widget>[
                                                      SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                                      FlutterSwitch(
                                                        width: 36.0,
                                                        height: 22.0,
                                                        toggleColor: Color(0xFFFFFFFF),
                                                        activeColor: kYellow,
                                                        inactiveColor: kWhite2,
                                                        padding: 2.0,
                                                        toggleSize: 18.0,
                                                        borderRadius: 11.0,
                                                        value: nafanya,
                                                        onToggle: (value) {
                                                          setState(() {
                                                            nafanya = value;
                                                          });
                                                        },
                                                      ),
                                                    ]),
                                              ),
                                            ]),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                alignment: Alignment.centerLeft,
                                                child: Text(s230, style: st13),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0,5,0,5),
                                                width:MediaQuery.of(context).size.width ,
                                                alignment: Alignment.centerRight,
                                                child: Row(
                                                    children: <Widget>[
                                                      SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                                      FlutterSwitch(
                                                        width: 36.0,
                                                        height: 22.0,
                                                        toggleColor: Color(0xFFFFFFFF),
                                                        activeColor: kYellow,
                                                        inactiveColor: kWhite2,
                                                        padding: 2.0,
                                                        toggleSize: 18.0,
                                                        borderRadius: 11.0,
                                                        value: oneTimePassword,
                                                        onToggle: (value) {
                                                          setState(() {
                                                            oneTimePassword = value;
                                                          });
                                                        },
                                                      ),
                                                    ]),
                                              ),
                                            ]),
                                        oneTimePassword ?Container(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.fromLTRB(0,20,0,15),
                                          child: TextButton(
                                            onPressed:(){
                                              dialogScreen(context, 'Раздел находится в разработке');
                                            } ,
                                            child: Text(s229, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                                            style: ElevatedButton.styleFrom(
                                              primary: kYellow,
                                              minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: kYellow,
                                                    width: 1,
                                                    style: BorderStyle.solid
                                                ),
                                                borderRadius: BorderRadius.circular(0.0),
                                              ),
                                            ),
                                          ),
                                         ): Container(),

                                      ]))
                            ])),*/

                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    e3 = !e3;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      e3
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      vocabular['header']['roles'],
                                      style: st8,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Divider(
                                        height: 2,
                                        thickness: 2,
                                        color: kWhite1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ExpandedSection(
                                  expand: e3,
                                  child: Column(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                        ),
                                        ListView.builder(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: rolesUser.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                  onTap:()async{
                                                    try {
                                                      HttpClient client = new HttpClient();
                                                      client.badCertificateCallback =
                                                      ((X509Certificate cert, String host, int port) => true);
                                                      String url = '${serverURL}api/api/v1/roles/set-active-role/$userId/${rolesUser[index]['id']}';
                                                      HttpClientRequest request = await client.getUrl(
                                                          Uri.parse(url));
                                                      request.headers.set('content-type', 'application/json');
                                                      request.headers.set('Mobile', 'true');
                                                      request.headers.set(
                                                          'Authorization', 'Bearer $accessToken');
                                                      HttpClientResponse response = await request.close();
                                                      String reply = await response.transform(utf8.decoder)
                                                          .join();
                                                      print(reply);
                                                      //debugPrint(reply, wrapWidth: 1024);
                                                      setState(() {
                                                        accessRole = rolesUser[index]['id'];
                                                      });
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  child:Container(
                                                                color: accessRole == rolesUser[index]['id'] ? kYellow : kWhite1,
                                                                width: MediaQuery.of(context).size.width/3*2-12,
                                                                margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children:[
                                                                      Text(rolesUser[index]['name_rus'], style: st4,),
                                                                      SizedBox(width: 5,),
                                                                      //Expanded( child:
                                                                        //Text('Группы согласования: ${approvalGroupsList(index)}', style: st9,),
                                                                      //),
                                                                    ])));
                                            }) ,

                                      ])),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.fromLTRB(0,20,0,0),
                                child: TextButton(
                                  onPressed:(){
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) => loadVocabulary()));
                                  } ,
                                  child: Text('Обновить справочники', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                                  style: ElevatedButton.styleFrom(
                                    primary: kYellow,
                                    minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                  ),
                                ),
                              )
                            ])),
                    /*Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    e4 = !e4;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      e4
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      s218,
                                      style: st8,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Divider(
                                        height: 2,
                                        thickness: 2,
                                        color: kWhite1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ExpandedSection(
                                  expand: e4,
                                  child: Column(
                                      children: [
                                        //еденицы измерения высота
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: tollUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                tollUnit = newValue;
                                              });
                                            },
                                            items: tollUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:Text(value),
                                              );
                                            }).toList(),
                                          ),
                                          title: s227,
                                        ),
                                        //еденицы измерения расстояния
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: distanceUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                distanceUnit = newValue;
                                              });
                                            },
                                            items: distanceUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s226,
                                        ),
                                        //еденицы измерения координат
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: coordinatUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                coordinatUnit = newValue;
                                              });
                                            },
                                            items: coordinatUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value,
                                                  ),
                                              );
                                            }).toList(),
                                          ),
                                          title: s225,
                                        ),
                                        //формат даты
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dateFormat,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dateFormat = newValue;
                                              });
                                            },
                                            items: dateFormats.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s224,
                                        ),
                                        //еденицы измерения горизонтальной скорости взлета
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: speedHorisontUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                speedHorisontUnit = newValue;
                                              });
                                            },
                                            items: speedHorisontUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s223,
                                        ),
                                        //еденицы измерения вертикальной скорости полета
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: speedVerticalUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                speedVerticalUnit = newValue;
                                              });
                                            },
                                            items: speedVerticalUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s222,
                                        ),
                                        //еденицы измерения стоимости топлива
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: costUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                costUnit = newValue;
                                              });
                                            },
                                            items: costUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s221,
                                        ),
                                        //еденицы измерения давления
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: presureUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                presureUnit = newValue;
                                              });
                                            },
                                            items: presureUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s220,
                                        ),
                                        //еденицы измерения температуры
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomBorderTitleContainer(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: temperatureUnit,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: kWhite2,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: st1,
                                            underline: Container(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                temperatureUnit = newValue;
                                              });
                                            },
                                            items: temperatureUnits.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                          title: s219,
                                        ),
                                      ]))
                            ])),*/

                    SizedBox(
                      height: 40,
                    ),

                  ]))
        ),
      ),
        bottomNavigationBar: BottomAppBar(
            elevation: 20.0,
            color: Colors.transparent,
            shape: CircularNotchedRectangle(),
            child: Container(
                color: Colors.transparent,
                height: 60,
                //alignment: Alignment.bottomCenter,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                    children: [
                      Divider(height: 2,thickness: 2,color: kWhite1,),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          //Spacer(),
                          GestureDetector(onTap:(){
                            dialogScreen(context, 'Раздел находится в разработке');
                          }, child:Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 18.0, top:15, right: 0),
                            child:Column(
                                children:[
                                  Container(
                                      width:20,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kWhite3 , width:2),
                                        borderRadius: BorderRadius.circular(4.0),
                                        //color: kBlue,
                                      ),
                                      child: Text('A',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kWhite3))
                                  ),
                                  Text(vocabular['myPhrases']['aviacompany'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                                ]),
                          )),
                          //Spacer(),
                          GestureDetector(onTap:(){
                            headerValue = s191;
                            menuShow = false;
                            //Navigator.of(context).pop();
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) =>HomePage()));
                          }, child:Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 0.0, top:15),
                            child:Column(
                                children:[
                                  Container(
                                      width:20,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kWhite3 , width:2),
                                        borderRadius: BorderRadius.circular(4.0),
                                        //color: kBlue,
                                      ),
                                      child: Text('H',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kWhite3))
                                  ),
                                  Text(vocabular['form_n']['general']['forms_n'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                                ]),
                          )),
                          //Spacer(),
                          GestureDetector(onTap:(){
                            headerValue = s191;
                            menuShow = false;
                            //Navigator.of(context).pop();
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) =>HomePageOther()));
                          }, child:Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 0.0, top:15),
                            child:Column(
                                children:[
                                  Container(
                                      width:20,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kWhite3 , width:2),
                                        borderRadius: BorderRadius.circular(4.0),
                                        //color: kBlue,
                                      ),
                                      child: Text('Р',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kWhite3))
                                  ),
                                  Text(vocabular['form_n']['general']['forms_r'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                                ]),
                          )),
                          //Spacer(),
                          GestureDetector(onTap:(){
                            headerValue = s191;
                            menuShow = false;
                            //Navigator.of(context).pop();
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => tuneProfilePage()));
                          }, child:Container(
                            height: 50,
                            padding: EdgeInsets.only(right: 25.0, top:15),
                            child:Column(
                                children:[
                                  Container(
                                    width:10,
                                    height: 10,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kYellow , width:2),
                                      borderRadius: BorderRadius.circular(5.0),
                                      //color: kBlue,
                                    ),

                                  ),
                                  Container(
                                    width:18,
                                    height: 11,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kYellow , width:2),
                                      borderRadius: BorderRadius.all(Radius.elliptical(10, 5),
                                        //color: kBlue,
                                      ),

                                    ),),
                                  Text(vocabular['header']['profile'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kYellow))
                                ]),
                          )),

                          //Spacer(),
                        ],
                      ),
                    ]))
        )
    );
  }

  loadJson() async {
    if(language == 'ru'){
      String data = await rootBundle.loadString('vocabular/ru.json');
      vocabular = json.decode(data);} else {String data = await rootBundle.loadString('vocabular/en.json');
    vocabular = json.decode(data);}
    //print(vocabular);
    setState(() {});
    reloadLanguage();
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
        "accessRole" : accessRole,
        "showRegistryType" : showRegistryType == false ? 0 : 1
      });
      await file.writeAsString(profile);
      print("Записали файл");
    }catch(e) {}

  }

approvalGroupsList(int index){
    print(rolesUser);
    List signs =[];
    for(int i = 0; i < rolesUser[index]['approval_group']['signs'].length; i++){
      signs.add(rolesUser[index]['approval_group']['signs'][i]['name_rus']);

    }
    return signs.toString();
}

}