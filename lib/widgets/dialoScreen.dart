import 'package:flutter/material.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';




dialogScreen(var context, String message){
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
          insetPadding: EdgeInsets.all(0),
          elevation: 0.0,
          content:Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                    child: Container(
                      width: 250,
                        //height: 250
                      height: 250,
                        margin: EdgeInsets.fromLTRB(20,20,20,20),
                      alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kWhite3,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(16.5),
                color: kBlue,
              ),
                      padding: EdgeInsets.fromLTRB(20,20,20,20),
                      child:  Column(
                      children: <Widget>[
                        //Text('У лукоморья дуб зеленый златая цепь на дубе том и днем и ночью кот ученый все ходи', textAlign: TextAlign.center, style: st17,),
                        Text(message, textAlign: TextAlign.center,style: st1,),
                        SizedBox(height: 10,),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                          child: TextButton(
                            onPressed:(){
                              Navigator.of(context).pop();
                            } ,
                            child: Text('Закрыть', style: st15,textAlign: TextAlign.center,),
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

                      ])

                  ),
        )
        );
      });

}