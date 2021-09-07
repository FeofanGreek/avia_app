import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/pages2/homepage_other.dart';
import 'package:avia_app/profile/tuneApp.dart';
import 'package:avia_app/profile/tuneProfile.dart';
import 'package:avia_app/regauth/about.dart';
import 'package:avia_app/regauth/help.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:avia_app/widgets/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'notificationsHistrory.dart';



class profileMainPage extends StatefulWidget {
  @override
  _profileMainPageScreenState createState() => _profileMainPageScreenState();
}

class _profileMainPageScreenState extends State<profileMainPage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  kBlue,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBlue,
        automaticallyImplyLeading: false,
        /*leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showMenuSlider(context);
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kWhite1),
                ),
                child: Icon(
                  Icons.menu,
                  color: kWhite,
                ),
              ),
            ),
          ],
        ),*/
        title: Text(
          s191,
          style: st2,
        ),
        actions: [
          ],
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
                      height: 30,
                      margin: EdgeInsets.fromLTRB(0,0,40,0),
                      alignment: Alignment.centerRight,
                      child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0,8,40,0),
                                child: Image.asset('icons/ringIcon.png', width: 26, height: 26, fit: BoxFit.fitHeight),
                            ),
                            Positioned(
                                top: 0,
                                left: 20,
                                child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (context) => notificationsHistroyPage()));},
                                    child: Container(
                                  //width:40,
                                  height: 25,
                                  padding: EdgeInsets.fromLTRB(7,2,7,0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.5),
                                    color: kRed,
                                  ),
                                        child: Text('99+', style: st11),
                              )
                            )
                          )
                                ])
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(0,0,0,10),
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: kGreen,
                      ),
                      alignment: Alignment.center,
                      child: Text('${name[0]}${familia[0]}', style: TextStyle(fontSize: 47.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(0,0,0,0),
                    alignment: Alignment.center,
                    child: Text('$name $familia', style: TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => tuneProfilePage()));},
                      child:Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(0,0,0,20),
                            alignment: Alignment.center,
                              child: Text(s191, style: st12),
                          ),
                  ),
                 /* GestureDetector(
                      onTap: (){
                        dialogScreen(context, 'Раздел находится в разработке');},
                      child:Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20,17,0,0),
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Image.asset('icons/groupsIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                SizedBox(width: 20,),
                                Text(s194, style: st13),
                              ]
                            )
                          ),
                  ),
                  GestureDetector(
                      onTap: (){
                        dialogScreen(context, 'Раздел находится в разработке');},
                      child:Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20,17,0,0),
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    Image.asset('icons/usersIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                    SizedBox(width: 20,),
                                    Text(s195, style: st13),
                                  ]
                              )
                          ),
                  ),
                  GestureDetector(
                      onTap: (){
                        dialogScreen(context, 'Раздел находится в разработке');},
                      child:Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20,17,0,0),
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    Image.asset('icons/templateIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                    SizedBox(width: 20,),
                                    Text(s197, style: st13),
                                  ]
                              )
                          ),
                  ),*/
                  GestureDetector(
                      onTap: (){
                        dialogScreen(context, 'Раздел находится в разработке');},
                      child:Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20,17,0,0),
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    Image.asset('icons/userPointIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                    SizedBox(width: 20,),
                                    Text(s196, style: st13),
                                  ]
                              )
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(0,40,0,10),
                    height: 1,
                    color: kBlueLight,
                    alignment: Alignment.centerLeft,
                    child: Divider(
                      color: kWhite3,
                      height: 0.5,
                    ),
                  ),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => tuneAppPage()));},
                    child:Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(20,17,0,0),
                      alignment: Alignment.center,
                      child: Row(
                          children: <Widget>[
                            Image.asset('icons/tunesIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                            SizedBox(width: 20,),
                            Text(s198, style: st13),
                          ]
                      )
                  ),
                ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => helpPage()));},
                      child:Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20,17,0,0),
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    Image.asset('icons/helpIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                    SizedBox(width: 20,),
                                    Text(s199, style: st13),
                                  ]
                              )
                          ),
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => aboutPage()));},
                      child:Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20,17,0,0),
                              alignment: Alignment.center,
                              child: Row(
                                  children: <Widget>[
                                    Image.asset('icons/aboutIcon.png', width: 25, height: 25, fit: BoxFit.fitHeight),
                                    SizedBox(width: 20,),
                                    Text(s200, style: st13),
                                  ]
                              )
                          ),
                  ),

                ]
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
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) =>profileMainPage()));
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
}