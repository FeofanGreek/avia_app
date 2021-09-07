import 'dart:async';
import 'dart:io';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/profile/mainProfile.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
//import 'package:avia_app/widgets/ipadView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:ui';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';


int  passNotCompare = 0;
bool regSwitch = false, rulesAccepted = false, connectingProcess = false;
bool webNativ = false;
int accessRole = 0, approvalGroup = 0;
List rolesUser =[];


class regAuthPage extends StatefulWidget {
  @override
  _regAuthPageScreenState createState() => _regAuthPageScreenState();
}

class _regAuthPageScreenState extends State<regAuthPage> {
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });


  TextEditingController _email, _password, _passwordR, _familia, _name, _fatherName, _phone, _ikao;

  loadJson() async {
    if(language == 'ru'){
    String data = await rootBundle.loadString('vocabular/ru.json');
    vocabular = json.decode(data);} else {String data = await rootBundle.loadString('vocabular/en.json');
    vocabular = json.decode(data);}
    //print(vocabular);
    reloadLanguage();
    setState(() {

    });
  }

  @override
  void initState() {
    /*_fatherName = TextEditingController(text: fatherName);
    _name = TextEditingController(text: name);
    _familia = TextEditingController(text: familia);
    _passwordR = TextEditingController(text: passwordR);
    _password = TextEditingController(text: password);
    _email = TextEditingController(text: regEmail);
    _phone = TextEditingController(text: regPhone);
    _ikao = TextEditingController(text: ikaoReg);*/
    _fatherName = TextEditingController(text: '');
    _name = TextEditingController(text: '');
    _familia = TextEditingController(text: '');
    _passwordR = TextEditingController(text: '');
    _password = TextEditingController(text: '');
    _email = TextEditingController(text: regEmail);
    _phone = TextEditingController(text: '');
    _ikao = TextEditingController(text: '');
    //passFieldVisible = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        elevation: 0.0,
        title: Text(
          s175,
          style: TextStyle(
            color: kWhite,
            fontFamily: 'AlS Hauss',
            fontSize: 12.8,
              height: 1.5,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        leading: Container(
            padding: EdgeInsets.fromLTRB(9,8,0,0),
              child: SizedBox(
                  width: 45,
                  height: 45,
                  child: Image.asset('images/logoReg.png',
                      fit: BoxFit.fitWidth)
          )
        ),
        actions: [
          Container(
            width: 67,
            height: 40,
            margin: EdgeInsets.fromLTRB(0,8,9,0),
              padding: EdgeInsets.fromLTRB(8,3,0,3),
              decoration: BoxDecoration(
                  border: Border.all(color: kWhite.withOpacity(0.2), width: 2)
              ),
              child: DropdownButton<String>(
                //menuMaxHeight: 67,
                isExpanded: false,
                value: language,
                icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                iconSize: 30,
                elevation: 10,
                underline: Container(
                  height: 0,
                  color: kBlueLight,
                ),
                onChanged: (String newValue){
                  setState(() {
                    language = newValue;

                  });
                  loadJson();
                },
                items: languages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                      SizedBox(
                        width: 23,
                        height: 15,
                        child: Image.asset(value == 'ru' ? 'images/rfFlag.png' : 'images/enFlag.png',
                            fit: BoxFit.fitWidth),
                    ),
                        //Text(value == 'ru' ? 'Русский' : 'English'),
                    ]),
                  );
                }).toList(),
              )
          )
        ],
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/regBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width:MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: kBlue.withOpacity(0.6),
          ),
          child: Container(
            width:MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(0,130,0,0),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              //child:Center(
                child: Column(
                    children: <Widget>[
                      Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            child:Text(vocabular['auth']['login'],
                              style: TextStyle(
                                  color: kWhite,
                                  fontFamily: 'AlS Hauss',
                                  fontSize: 36.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),
                      /*Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0,8,0,0),
                              width:MediaQuery.of(context).size.width - 100 ,
                              alignment: Alignment.centerLeft,
                              child: Text('Приложение', style: !webNativ ? st4 : st14),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,5,0,5),
                              width:MediaQuery.of(context).size.width ,
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    SizedBox(width:MediaQuery.of(context).size.width/2-36,),
                                    FlutterSwitch(
                                      width: 36.0,
                                      height: 22.0,
                                      toggleColor: Color(0xFFFFFFFF),
                                      activeColor: kYellow,
                                      inactiveColor: kWhite2,
                                      padding: 2.0,
                                      toggleSize: 18.0,
                                      borderRadius: 11.0,
                                      value: webNativ, //изменить переменную
                                      onToggle: (value) {
                                        setState(() {
                                          webNativ = value; //изменить переменную
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,8,0,0),
                              width:MediaQuery.of(context).size.width ,
                              alignment: Alignment.centerRight,
                              child: Text('web версия', style: webNativ ? st4 : st14),
                            ),
                          ]),*/
                      Container(
                        margin: EdgeInsets.fromLTRB(10,20,10,0),
                          padding: EdgeInsets.fromLTRB(10,10,10, 10),
                          constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
                          height: regSwitch == false ? 400 : MediaQuery.of(context).size.height,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: kBlue,
                          ),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0.0),
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              GestureDetector(
                              onTap: () {
                                setState(() {
                                  regSwitch = false;
                                });
                              },
                                  child: Container(
                                      width: 300 / 2 -20,
                                    height: 31,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: regSwitch == false ? kYellow : kWhite2),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14.0),
                                          bottomLeft: Radius.circular(14.0)),
                                      color: regSwitch == false ? kYellow : kBlue,
                                    ),
                                    child: Text(vocabular['auth']['login'], style: st11,textAlign: TextAlign.center,)
                                ),
                              ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        regSwitch = true;
                                      });
                                    },
                                    child: Container(
                                        width: 300 / 2 -20,
                                    height: 31,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: regSwitch == true ? kYellow : kWhite2),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(14.0),
                                          bottomRight: Radius.circular(14.0)),
                                      color: regSwitch == true ? kYellow : kBlue,
                                    ),
                                    child: Text(vocabular['auth']['register'], style: st11,textAlign: TextAlign.center,)
                                ),
                                ),
                              ]
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                    //readOnly: name.length > 0 ? true : false,
                                    controller: _email,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide.none
                                        ),
                                        hintText: 'E-mail *',
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                      suffixIcon: IconButton(
                                        onPressed: () => _email.clear(),
                                        icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                      ),
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        regEmail = value;
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.always,

                                  ),
                                ),
                                regEmail.length > 0 ? Positioned(
                                    left: 22,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: _email.text.length > 0 ? _email.text.contains('@') && _email.text.contains('.') && _email.text.length > 10 ? Text(
                                        'E-mail *',
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ) : Text(
                                        'E-mail должен содержать @ и .',
                                        style: TextStyle(color: Colors.redAccent,fontFamily: 'AlS Hauss', fontSize: 12),
                                      ) : Container(),
                                    )):Container(),
                              ],
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
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
                                        hintText: vocabular['auth']['login_page']['password'],
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
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
                                            icon: Icon(CupertinoIcons.eye, color: kWhite3, size: 16,),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value){
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
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        vocabular['auth']['login_page']['password'],
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ),
                            regSwitch == true ? passNotCompare == 1 ? Text(s210,style: TextStyle(color: Colors.redAccent,fontFamily: 'AlS Hauss', fontSize: 12),) : Container():Container(),
                            regSwitch == true ? !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(_password.text) ? _password.text.length > 5? Text('Пароль не содержит символов и заглавных букв',style: TextStyle(color: Colors.redAccent,fontFamily: 'AlS Hauss', fontSize: 12),) : Container():Container():Container(),
                            (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(_password.text) && regSwitch == true)? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
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
                                        hintText: vocabular['auth']['password']['confirmation'],
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
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
                                          icon: Icon(CupertinoIcons.eye, color: kWhite3, size: 16,),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        passwordR = value;
                                        password == passwordR ? passNotCompare = 0 : passNotCompare = 1;
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.always,
                                  ),
                                ),
                                passwordR.length > 0 ? Positioned(
                                    left: 22,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        vocabular['auth']['password']['confirmation'],
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ) : Container(),
                            regSwitch == true ? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
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
                                        hintText: vocabular['auth']['register_page']['phone'],
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                        suffixIcon: IconButton(
                                        onPressed: () => _phone.clear(),
                                          icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                        ),
                                    ),
                                    onChanged: (value){
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
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        vocabular['auth']['register_page']['phone'],
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ):Container(),
                            regSwitch == true ? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                    controller: _familia,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide.none
                                        ),
                                        hintText: s179,
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                      suffixIcon: IconButton(
                                        onPressed: () => _familia.clear(),
                                        icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                      ),
                                    ),
                                    onChanged: (value){
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
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        s179,
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ):Container(),
                            regSwitch == true ? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                    controller: _name,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide.none
                                        ),
                                        hintText: s180,
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                      suffixIcon: IconButton(
                                        onPressed: () => _name.clear(),
                                        icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                      ),
                                    ),
                                    onChanged: (value){
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
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        s180,
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ):Container(),
                            regSwitch == true ? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                    controller: _fatherName,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide.none
                                        ),
                                        hintText: vocabular['auth']['register_page']['lastname'],
                                        hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                      suffixIcon: IconButton(
                                        onPressed: () => _fatherName.clear(),
                                        icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                      ),
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        fatherName = value;
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.always,
                                  ),
                                ),
                                _fatherName.text.length > 0 ? Positioned(
                                    left: 22,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        vocabular['auth']['register_page']['lastname'],
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ):Container(),
                            /*regSwitch == true ? Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                    controller: _ikao,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      hintText: s190,
                                      hintStyle: st8,
                                      contentPadding: new EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
                                      suffixIcon: IconButton(
                                        onPressed: () => _ikao.clear(),
                                        icon: Icon(Icons.clear, color: kWhite3, size: 16,),
                                      ),
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        ikaoReg = value;
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.always,
                                  ),
                                ),
                                ikaoReg.length > 0 ? Positioned(
                                    left: 22,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                      color: kBlue,
                                      child: Text(
                                        s190,
                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                      ),
                                    )):Container(),
                              ],
                            ):Container(),*/
                            //кнопка войти
                            regSwitch == false ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.fromLTRB(0,20,0,0),
                              child: TextButton(
                                onPressed:(){
                                  setState(() {
                                    passFieldVisible = true;
                                    connectingProcess = true;
                                  });
                                 password.length > 0 ? logIn() : dialogScreen(context, vocabular['myPhrases']['notInput']);
                                } ,
                                child: connectingProcess == false ? Text(vocabular['auth']['login_page']['login'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,),textAlign: TextAlign.center,) : SizedBox( width:18, height: 18, child:CircularProgressIndicator()),
                                style: ElevatedButton.styleFrom(
                                  primary: password.length > 0 ? kYellow : kWhite1,
                                  minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                            ):Container(),
                            //кнопка восттановить доступ
                            regSwitch == false ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.fromLTRB(0,20,0,0),
                              child: TextButton(
                                onPressed:(){
                                  dialogScreen(context, regEmail.length > 0 ? vocabular['myPhrases']['linkSended'] : vocabular['myPhrases']['cleanEmail']);
                                  emailRestore();
                                } ,
                                child: Text(vocabular['auth']['login_page']['restore_access'], style: st12,textAlign: TextAlign.center,),
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
                            ):Container(),
                            //кнопка зарегистрироваться
                            regSwitch == true ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.fromLTRB(0,20,0,0),
                              child: TextButton(
                                onPressed:(){
                                  //familia.length > 0 && password == passwordR && rulesAccepted == true ?
                                  //newUserRegistration() : Navigator.pushNamed(context, '/rules');
                                  _password.text.length > 0 && name.length > 0 && regEmail.length > 0 && familia.length > 0 && _password.text == _passwordR.text ? rulesAccepted = false : null;
                                  _password.text.length > 0 && name.length > 0 && regEmail.length > 0 && familia.length > 0 && _password.text == _passwordR.text ? Navigator.pushNamed(context, '/rules') : dialogScreen(context, 'Заполните все поля формы');
                                } ,
                                child: Text(s182, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                                style: ElevatedButton.styleFrom(
                                  primary: _fatherName.text.length > 0 && _password.text == _passwordR.text && rulesAccepted == true ? kYellow : kWhite1 ,
                                  minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                            ):Container(),

                            Container(
                              height: 30,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.fromLTRB(20,20,20,10),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, '/rules');
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(text: '${vocabular['auth']['info']} ',
                                      style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color: kWhite2,),
                                      children: <TextSpan>[
                                        TextSpan(text: vocabular['auth']['private_policy'], style: TextStyle(fontSize: 12.0, color: kYellow, )),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(20,0,20,10),
                                child:Text(reciveMessage,
                                  style: TextStyle(
                                    color: kWhite,
                                    fontFamily: 'AlS Hauss',
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),

                          ],
                        )
                      )
                    ]
                )
           // ),
          ),
          ),
        ),
      ),
    );
  }

  newUserRegistration() async{
    String phone = regPhone.trim();
    phone = phone.replaceAll(' ','');
    phone = phone.replaceAll('-','');
    phone = phone.replaceAll('(','');
    phone = phone.replaceAll(')','');
    dialogScreen(context, '${vocabular['auth']['verify']['sent_to_mail.']}');
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/auth/register';
      Map map = {
        "name": "$name",
        "surname": "$familia",
        "patronymic": "$fatherName",
        "email": "$regEmail",
        "phone": "$phone",
        "password": "$password",
        "password_confirmation": "$passwordR"
      };
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      var parsedList = json.decode(reply);
      if(reply.contains('message')){
        //print(parsedList["message"]);
        reciveMessage = parsedList["message"];
        //получили сообщение, что такой пользователь уже есть, пока всеравно запишем файл профиля
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
            "isPilot" : 0,
            "isExPilot" : 0,
            "isExploer" : 0,
            "language" : "en",
            "sendCode" : "",
            "senId" : "",
            "delayReason" : "Не выбрана",
            "tollUnit" : "Метры",
            "distanceUnit" : "Километры",
            "coordinatUnit" : "ГГММ N/S ГГГMM E/W",
            "dateFormat" : "ДД/ММ/ГГГГ",
            "speedHorisontUnit" : "км/ч",
            "speedVerticalUnit" : "м/с",
            "costUnit" : "Р/литр",
            "presureUnit" : "мм.рт.ст.",
            "temperatureUnit" : "Градусы Цельсия",
            "minAllitude" : 0,
            "maxAllitude" : 10000,
            "darkTheme" : 1,
            "emailNotif" : 1,
            "smsNotif" : 1,
            "autorouting" : 1,
            "nafanya" : 1,
            "oneTimePassword" : 1,
            "showUTC" : 0,
            "accessToken" : "",
            "tokenType" : "",
            "expires" : "",
            "userId" : "",
            "showRegistryType" : 1
          });
          await file.writeAsString(profile);
          //print("Записали файл");
        }catch(e) {
          showDialog(context: context, builder: (BuildContext context) {
            return Dialog(
                child: new Text('Не удалось записать файл $e'));
          });
        }
      }else{
        setState(() {
          regSwitch = false;
          reciveMessage = '${vocabular['auth']['verify']['sent_to_mail.']}';
        });
        //записываем файл профиля
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
          "isPilot" : 0,
          "isExPilot" : 0,
          "isExploer" : 0,
          "language" : "en",
          "sendCode" : "",
          "senId" : "",
          "delayReason" : "Не выбрана",
          "tollUnit" : "Метры",
          "distanceUnit" : "Километры",
          "coordinatUnit" : "ГГММ N/S ГГГMM E/W",
          "dateFormat" : "ДД/ММ/ГГГГ",
          "speedHorisontUnit" : "км/ч",
          "speedVerticalUnit" : "м/с",
          "costUnit" : "Р/литр",
          "presureUnit" : "мм.рт.ст.",
          "temperatureUnit" : "Градусы Цельсия",
          "minAllitude" : 0,
          "maxAllitude" : 10000,
          "darkTheme" : 1,
          "emailNotif" : 1,
          "smsNotif" : 1,
          "autorouting" : 1,
          "nafanya" : 1,
          "oneTimePassword" : 1,
          "showUTC" : 0,
          "accessToken" : "",
          "tokenType" : "",
          "expires" : "",
            "accessRole" : accessRole,
          "userId" : "${parsedList["user_id"]}",
            "showRegistryType" : showRegistryType == false ? 0 : 1
          });
          //print(parsedList["user_id"]);
          await file.writeAsString(profile);
          //print("Записали файл");
        }catch(e) {
          showDialog(context: context, builder: (BuildContext context) {
            return Dialog(
                child: new Text('Не удалось записать файл $e'));
          });
        }
      }


    }catch(e){
      setState(() {
        regSwitch = false;
        reciveMessage = '${vocabular['myPhrases']['serverError']}';
      });
      //print('Ошибка обращения к серверу $e');
      print(e);
    }
  }

  getActiveRole(int userid)async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}/api/api/v1/roles/get-active-role/$userid';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);
      var _parsedList = json.decode(reply);
      accessRole=_parsedList['active_role_id'] != null ? _parsedList['active_role_id'] : 4;
    }catch(e){
      setState(() {
        regSwitch = false;
        reciveMessage = '${vocabular['myPhrases']['serverError']}';
      });
      //print('Ошибка обращения к серверу $e');
      print(e);
    }
  }

  logIn() async{
    //print('ошибка вот тут');
    try {
      //print('первая фаза авторизации');
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      //String url = 'https://10.95.0.65/api/api/auth/login';
      String url = '${serverURL}api/api/auth/login';
      Map map = {
        "email": "$regEmail",
        "password": "$password"
      };
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(response);
     print(reply);
      setState(() {
        regSwitch = false;
        reciveMessage = '';
      });
      //получили значение ID и Status для данного пользователя
      var parsedList = json.decode(reply);
      if(reply.contains('message')){
       //print(parsedList["message"]);
      reciveMessage = parsedList["message"];
      connectingProcess = false;
      //Navigator.push(context,CupertinoPageRoute(builder: (context) => formaNFishPage()));
      }else{
        //заглушка если пользователь admin@celado.ru
        if(reply.contains('token')){
            Url = '${serverURL}auth/authentication/${parsedList["token"]}';
            //print('Пробуем отправить ссылку подтверждения');
            String url = '${serverURL}api/api/auth/login/${parsedList["uuid"]}/${parsedList["token"]}';
            HttpClientRequest request = await client.getUrl(Uri.parse(url));
            HttpClientResponse response = await request.close();
            String reply = await response.transform(utf8.decoder).join();
            parsedList = json.decode(reply);
            reciveMessage = parsedList["message"];

        }

          reciveMessage = '${vocabular['auth']['verify']['twofactor_authentication']}';
          accessToken = parsedList["access_token"];
          tokenType = parsedList["token_type"];
          expires = parsedList["expires_atexpires_at"];
        String url = '${serverURL}/api/api/v1/getuser';
        HttpClientRequest request = await client.getUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('Mobile', 'true');
        request.headers.set('Authorization', 'Bearer $accessToken');
        HttpClientResponse response = await request.close();
        String reply2 = await response.transform(utf8.decoder).join();
        var _parsedList = json.decode(reply2);
        //debugPrint(_parsedList['roles'][0].toString(), wrapWidth: 1024);
        //print(_parsedList['roles']);
        accessRole = _parsedList['roles'][0]['id'];
        getActiveRole(_parsedList['user']['id']); //получить активную роль
        approvalGroup = _parsedList['roles'][0]['approval_group_id'];
        rolesUser = _parsedList['roles'];
        //print(rolesUser );
        //approvalGroup = 3;
        userId = _parsedList['user']['id'].toString();
        regEmail =_parsedList['user']['email'];
        familia =_parsedList['user']['surname'];
        name =_parsedList['user']['name'];
        fatherName =_parsedList['user']['patronymic'];
        regPhone =_parsedList['user']['phone'];
          setState(() {});
          //обновляем профиль
          try {
            //записали в файл номер пользователя
            final Directory directory = await getApplicationDocumentsDirectory();
            final File file = File('${directory.path}/profile.txt');
            var profile = jsonEncode(<String, dynamic>{
              //переменные для настройки пользователя
              "accessRole" : accessRole,
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
              //"language": "$language",
              "language": "en",
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
              "userId": "$userId",
              "showRegistryType" : showRegistryType == false ? 0 : 1
            });
            await file.writeAsString(profile);

            //print("Записали файл");
          } catch (e) {}
          connectingProcess = false;
          //смотрим, если профиль не заполнен, а авторизация удачна, то шлем в профиль, если профиль заполнен, шлем на главный экран
          if (name.length > 0) {
            Navigator.pushReplacement(context,
                 CupertinoPageRoute(builder: (context) => HomePage()));
                //CupertinoPageRoute(builder: (context) => formaNFishPage()));
          } else {
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => profileMainPage()));
          }

     }
      setState(() {
        //reciveMessage = '';
        regSwitch = false;
        connectingProcess = false;
      });
    }catch(e){
      setState(() {
        regSwitch = false;
        connectingProcess = false;
        reciveMessage = '${vocabular['myPhrases']['serverError']}';
      });
      //print('Ошибка обращения к серверу $e');
      print(e);
    }
  }

  emailRestore()async{
    try {
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
     // print(reply);

    }catch(e){
      setState(() {
        regSwitch = false;
        reciveMessage = '${vocabular['myPhrases']['serverError']}';
      });
      //print('Ошибка обращения к серверу $e');
      print(e);
    }

  }

}