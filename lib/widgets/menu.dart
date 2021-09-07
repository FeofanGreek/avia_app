import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/main.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/profile/mainProfile.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../strings.dart';




showMenuSlider(var context){
  return showDialog(
    useSafeArea: true,
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return new AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
            insetPadding: EdgeInsets.all(0),
            elevation: 0.0,
            content: GestureDetector(
                onTap: (){
                  menuShow = false;
                Navigator.of(context).pop();
                },
                child:Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                padding: EdgeInsets.fromLTRB(0,0,0,0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  color: Colors.transparent,),

                alignment: Alignment.topLeft,
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: ()=> Navigator.of(context).pop(),
                        child:Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            padding: EdgeInsets.fromLTRB(10,0,0,0),
                            width: 220,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0),
                                ),
                              color: kBlueLight,
                              ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0,0,15,0),
                                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                                  width: 33,
                                  height: 33,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.5),
                                    color: kGreen,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('AK', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                ),
                                Text(headerValue, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                              ],
                            )
                          ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        width: 220,
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
                      headerValue = s251;
                      menuShow = false;
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) =>formaNFishPage()));
                    },
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        width: 220,
                        height: 40,
                        color: kBlueLight,
                        alignment: Alignment.centerLeft,
                        child: Text(s251, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                      ),
                    ),
                  GestureDetector(
                      onTap: (){
                        headerValue = s250;
                        menuShow = false;
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (context) =>HomePage()));
                      },
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        width: 220,
                        height: 40,
                        color: kBlueLight,
                        alignment: Alignment.centerLeft,
                        child: Text(s250, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                      ),),
                    GestureDetector(
                    onTap: (){
                      headerValue = s191;
                      menuShow = false;
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) =>profileMainPage()));
                    },
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        width: 220,
                        height: 40,
                        color: kBlueLight,
                        alignment: Alignment.centerLeft,
                        child: Text(s191, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                      ),
                    ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0,0,0,0),
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          width: 220,
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
                      logOut();
                      menuShow = false;
                      reciveMessage = '';
                      regSwitch = false;
                      connectingProcess = false;
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) => regAuthPage()));
                      },
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        width: 220,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5.0),
                            //  bottomRight: Radius.circular(14.0)
                          ),
                          color: kBlueLight,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(s193, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color:  kRed ,)),
                      ),
                  ),


                    ])
              )
            ),

        );
      });

}