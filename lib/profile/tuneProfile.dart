import 'dart:convert';
import 'dart:io';
import 'package:avia_app/main.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/pages2/homepage_other.dart';
import 'package:avia_app/profile/roleProfile.dart';
import 'package:avia_app/profile/tuneApp.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'mainProfile.dart';


int  passNotCompare = 0;
bool passFieldVisible = true, lockField = true;

String passChangeStatus = '', profileUpdateStatus ='';

class tuneProfilePage extends StatefulWidget {
  @override
  _tuneProfilePageScreenState createState() => _tuneProfilePageScreenState();
}

class _tuneProfilePageScreenState extends State<tuneProfilePage> {
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  TextEditingController _email, _password, _passwordR, _passwordOld, _familia,
      _name, _fatherName, _phone, _dopInfo;

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
        backgroundColor:  kBlue,
        extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
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
                            onTap: () {},
                            child: Container(
                                width: 300 / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(vocabular['header']['profile'], style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => tuneAppPage()));},
                            child: Container(
                                width: 300 / 2 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kWhite2),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kBlue ,
                                ),
                                child: Text(vocabular['header']['settings'], style: st11,textAlign: TextAlign.center,)
                            ),
                          ),
                        ]
                    ),
                    /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) =>
                                      tuneProfilePage()));
                            },
                            child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2 - 20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5,
                                      color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(s205, style: st11,
                                  textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) =>
                                      roleProfilePage()));
                            },
                            child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2 - 20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5,
                                      color: kWhite2),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kBlue,
                                ),
                                child: Text(s206, style: st11,
                                  textAlign: TextAlign.center,)
                            ),
                          ),
                        ]
                    ),*/
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      alignment: Alignment.topLeft,
                      child: Text(s207, style: st13),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            style: !lockField ? st1 : st8,
                            controller: _email,
                            readOnly: lockField,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: 'E-mail *',
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    !lockField ? lockField = true : lockField =
                                    false;
                                  });
                                },
                                icon: Image.asset(
                                    'icons/lockIcon.png', width: 16,
                                    height: 16,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                regEmail = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _email.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                'E-mail *',
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            style: !lockField ? st1 : st8,
                            readOnly: lockField,
                            controller: _name,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s180,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    !lockField ? lockField = true : lockField =
                                    false;
                                  });
                                },
                                icon: Image.asset(
                                    'icons/lockIcon.png', width: 16,
                                    height: 16,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _name.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s180,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            style: !lockField ? st1 : st8,
                            readOnly: lockField,
                            controller: _fatherName,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s181,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    !lockField ? lockField = true : lockField =
                                    false;
                                  });
                                },
                                icon: Image.asset(
                                    'icons/lockIcon.png', width: 16,
                                    height: 16,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                fatherName= value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _fatherName.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s181,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            style: !lockField ? st1 : st8,
                            readOnly: lockField,
                            controller: _familia,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s179,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    !lockField ? lockField = true : lockField =
                                    false;
                                  });
                                },
                                icon: Image.asset(
                                    'icons/lockIcon.png', width: 16,
                                    height: 16,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                familia = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _familia.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s179,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),

                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            controller: _phone,
                            inputFormatters: [maskFormatterPhone],
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false,
                                signed: false),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s189,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () => _phone.clear(),
                                icon: Icon(
                                  Icons.clear, color: kWhite3, size: 16,),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                regPhone = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _phone.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s189,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    //поле дополнительная информация
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 90,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            maxLines: 3,
                            minLines: 3,
                            controller: _dopInfo,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s213,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dopInfo = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _dopInfo.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s213,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text('$profileUpdateStatus'), //статус смены пароля
                    ),
                    //кнопка обновить данные
                    Container(
                      height: 40,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          updateUserProfile();
                        },
                        child: Text(
                          s208, style: st12, textAlign: TextAlign.center,),
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
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.fromLTRB(0, 45, 0, 10),
                      alignment: Alignment.topLeft,
                      child: Text(s209, style: st13),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            controller: _passwordOld,
                            //obscuringCharacter: '*',
                            obscureText: passFieldVisible,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: vocabular['myPhrases']['oldPassword'],
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    passFieldVisible = false;
                                  });
                                },
                                onLongPressUp: () {
                                  setState(() {
                                    passFieldVisible = true;
                                  });
                                },
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.eye, color: kWhite3,
                                    size: 16,),
                                ),
                              ),
                            ),

                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _passwordOld.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                vocabular['myPhrases']['oldPassword'],
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            controller: _password,
                            //obscuringCharacter: '*',
                            obscureText: passFieldVisible,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: vocabular['myPhrases']['newPassword'],
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    passFieldVisible = false;
                                  });
                                },
                                onLongPressUp: () {
                                  setState(() {
                                    passFieldVisible = true;
                                  });
                                },
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.eye, color: kWhite3,
                                    size: 16,),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _password.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                vocabular['myPhrases']['newPassword'],
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    passNotCompare == 1 ? Text(s210) : Container(),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            controller: _passwordR,
                            obscureText: passFieldVisible,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s178,
                              hintStyle: st8,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10.0),
                              suffixIcon: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    passFieldVisible = false;
                                  });
                                },
                                onLongPressUp: () {
                                  setState(() {
                                    passFieldVisible = true;
                                  });
                                },
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.eye, color: kWhite3,
                                    size: 16,),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                passwordR = value;
                                _password.text == _passwordR.text ?
                                passNotCompare = 0 : passNotCompare = 1;
                              });
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                        ),
                        _passwordR.text.length > 0 ? Positioned(
                            left: 22,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 10, right: 10),
                              color: kBlue,
                              child: Text(
                                s178,
                                style: TextStyle(color: kWhite.withOpacity(0.3),
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 12),
                              ),
                            )) : Container(),
                      ],
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(passChangeStatus), //статус смены пароля
                    ),
                    //кнопка изменить пароль
                    Container(
                      height: 40,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          changePassword();
                        },
                        child: Text(
                          s211, style: passNotCompare == 1 ? st16 : st12,
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
                    //кнопка выйти из аккаунта
                    Container(
                      height: 40,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
                      child: TextButton(
                        onPressed: () {
                          headerValue = s191;
                          logOut();
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/regAuthPage');
                        },
                        child: Text(
                          s212, style: st15, textAlign: TextAlign.center,),
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
                  ]),
            )
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

  updateUserProfile() async {
    String phone = regPhone.trim();
    phone = phone.replaceAll(' ', '');
    phone = phone.replaceAll('-', '');
    phone = phone.replaceAll('(', '');
    phone = phone.replaceAll(')', '');
    profileUpdateStatus = '';

    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/users/$userId';
      Map map = {
        "Active": true,
        "name": "$name",
        "patronymic": "$fatherName",
        "surname": "$familia",
        "phone": "$phone",
        "email": "$regEmail"
      };

      HttpClientRequest request = await client.patchUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization' , 'Bearer $accessToken');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      //получили значение ID и Status для данного пользователя
      var parsedList = json.decode(reply);
      profileUpdateStatus = parsedList["message"];
      setState(() {});
      dialogScreen(context, 'Профиль пользователя успешно обновлен');
      //обновляем профиль
      try {
        //записали в файл номер пользователя
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/profile.txt');
        var profile = jsonEncode(<String, dynamic>{
          //переменные для настройки пользователя
          "regEmail": "$regEmail",
          "password": "$password",
          "familia": "$familia",
          "name": "$name",
          "fatherName": "$fatherName",
          "regPhone": "$regPhone",
          "ikaoReg": "$ikaoReg",
          "dopInfo": "$dopInfo",
          "isPilot": isPilot == false ? 0 : 1,
          "isExPilot": isExPilot == false ? 0 : 1,
          "isExploer": isExploer == false ? 0 : 1,
          "language": "$language",
          "sendCode": "$sendCode",
          "senId": "$senId",
          "delayReason": "$delayReason",
          "tollUnit": "$tollUnit",
          "distanceUnit": "$distanceUnit",
          "coordinatUnit": "$coordinatUnit",
          "dateFormat": "$dateFormat",
          "speedHorisontUnit": "$speedHorisontUnit",
          "speedVerticalUnit": "$speedVerticalUnit",
          "costUnit": "$costUnit",
          "presureUnit": "$presureUnit",
          "temperatureUnit": "$temperatureUnit",
          "minAllitude": minAllitude,
          "maxAllitude": maxAllitude,
          "darkTheme": darkTheme == false ? 0 : 1,
          "emailNotif": emailNotif == false ? 0 : 1,
          "smsNotif": smsNotif == false ? 0 : 1,
          "autorouting": autorouting == false ? 0 : 1,
          "nafanya": nafanya == false ? 0 : 1,
          "oneTimePassword": oneTimePassword == false ? 0 : 1,
          "showUTC": showUTC == false ? 0 : 1,
          "accessToken": "$accessToken",
          "tokenType": "$tokenType",
          "expires": "$expires",
          "userId" : "$userId",
          "accessRole" : accessRole,
          "showRegistryType" : showRegistryType == false ? 0 : 1
        });
        await file.writeAsString(profile);
        print("Записали файл");
      } catch (e) {}
    } catch (e) {
      profileUpdateStatus =
      'Произошла ошибка при обновлении данных пользователя';
      setState(() {});
      print('Ошибка обращения к серверу для обновления данных пользователя $e');
    }

  }


  changePassword() async {
    passChangeStatus = '';
      try {
        //отправляем запрос на смену емайл
          HttpClient client = new HttpClient();
          client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
            String url = '${serverURL}api/api/auth/password/email';
          Map map = {
            "email": "$regEmail",
          };
          HttpClientRequest request = await client.postUrl(Uri.parse(url));
          request.headers.set('content-type', 'application/json');
          request.headers.set('Mobile', 'true');
          request.add(utf8.encode(json.encode(map)));
          HttpClientResponse response = await request.close();
          String reply = await response.transform(utf8.decoder).join();
          print('Отправили заявку на смену емайл $reply');
          //должны получить токен для смены емайл
          var parsedList = json.decode(reply);
          if (reply.contains('message')) {
            passChangeStatus = parsedList["message"];
            setState(() {});
            dialogScreen(context, passChangeStatus);
          } else {
            if (reply.contains('token')) {
              //отправили подтверждающий токен
              String url = '${serverURL}api/api/auth/password/email/${parsedList["token"]}';
              HttpClientRequest request = await client.getUrl(Uri.parse(url));
              HttpClientResponse response = await request.close();
              String reply = await response.transform(utf8.decoder).join();
              parsedList = json.decode(reply);
              print('Отправили токен подтверждение $reply');
                //отправляем пароль на замену
              url = '${serverURL}api/api/auth/password/reset';
              Map map = {
                "email": "$regEmail",
                "password": "$password",
                "password_confirmation": "$passwordR"
              };

              request = await client.postUrl(Uri.parse(url));
              request.headers.set('content-type', 'application/json');
              request.headers.set('Mobile', 'true');
              request.add(utf8.encode(json.encode(map)));
              response = await request.close();
              reply = await response.transform(utf8.decoder).join();
              print('Отправили новый пароль $reply');
              parsedList = json.decode(reply);
              if (reply.contains('message')) {
                passChangeStatus = parsedList["message"];
                setState(() {});
                dialogScreen(context, passChangeStatus);
              } else {
                passChangeStatus = 'Выполняем двухфакторную авторизацию';
                setState(() {});
                //обновляем профиль
                  final Directory directory = await getApplicationDocumentsDirectory();
                  final File file = File('${directory.path}/profile.txt');
                  var profile = jsonEncode(<String, dynamic>{
                    //переменные для настройки пользователя
                    "regEmail": "$regEmail",
                    "password": "$password",
                    "familia": "$familia",
                    "name": "$name",
                    "fatherName": "$fatherName",
                    "regPhone": "$regPhone",
                    "ikaoReg": "$ikaoReg",
                    "dopInfo": "$dopInfo",
                    "isPilot": isPilot == false ? 0 : 1,
                    "isExPilot": isExPilot == false ? 0 : 1,
                    "isExploer": isExploer == false ? 0 : 1,
                    "language": "$language",
                    "sendCode": "$sendCode",
                    "senId": "$senId",
                    "delayReason": "$delayReason",
                    "tollUnit": "$tollUnit",
                    "distanceUnit": "$distanceUnit",
                    "coordinatUnit": "$coordinatUnit",
                    "dateFormat": "$dateFormat",
                    "speedHorisontUnit": "$speedHorisontUnit",
                    "speedVerticalUnit": "$speedVerticalUnit",
                    "costUnit": "$costUnit",
                    "presureUnit": "$presureUnit",
                    "temperatureUnit": "$temperatureUnit",
                    "minAllitude": minAllitude,
                    "maxAllitude": maxAllitude,
                    "darkTheme": darkTheme == false ? 0 : 1,
                    "emailNotif": emailNotif == false ? 0 : 1,
                    "smsNotif": smsNotif == false ? 0 : 1,
                    "autorouting": autorouting == false ? 0 : 1,
                    "nafanya": nafanya == false ? 0 : 1,
                    "oneTimePassword": oneTimePassword == false ? 0 : 1,
                    "showUTC": showUTC == false ? 0 : 1,
                    "accessToken": "$accessToken",
                    "tokenType": "$tokenType",
                    "expires": "$expires",
                    "accessRole" : accessRole,
                    "userId" : "$userId",
                  "showRegistryType" : showRegistryType == false ? 0 : 1
                  });
                  await file.writeAsString(profile);
                  print("Записали файл 2");
                passChangeStatus =
                'Пароль успешно изменен. Выполните вход в приложение.';
                setState(() {});
                dialogScreen(context, passChangeStatus);
                }
              }
            }
      }catch(e){
        passChangeStatus = 'Произошла ошибка при запросе на смену пароля';
        setState(() {});
        print('Ошибка обращения к серверу для смены пароля $e');

      }
  }

}
