import 'dart:convert';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../strings.dart';
import '../../../text_styles.dart';



var _vocabular;
var CargoDangerClass;
bool _loadReady = false;


class readCargo extends StatefulWidget {
  final List airlineList;
  final int expand;
  final String routeInfo;

  readCargo({
    this.airlineList,
    this.expand,
    this.routeInfo
  });


  @override
  _State createState() => _State();
}

class _State extends State<readCargo> {

  List expandWidgets = [];

  //подгрузили словари из файла
  void loadJsonLanguage() async {
    String data = await rootBundle.loadString('vocNew/CargoDangerClass.json');
    CargoDangerClass = json.decode(data);
    if (language == 'ru') {
      String data = await rootBundle.loadString('vocNew/ru.json');
      _vocabular = json.decode(data);
    } else {
      String data = await rootBundle.loadString('vocNew/en.json');
      _vocabular = json.decode(data);
    }
    _loadReady = true;
    setState(() {

    });
  }

  dangerClassValue(int id){
    var value ='';
    for(int i=0; i<CargoDangerClass.length; i++ ){
      CargoDangerClass[i]['CARGOCLASS_ID'] == id ? value = language == 'ru' ? CargoDangerClass[i]['ICAORUS'] : CargoDangerClass[i]['ICAOLAT'] : null;
    }
    return value;
  }




  @override
  void initState() {
    loadJsonLanguage();
    super.initState();
  } //initState

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlue,
        appBar:_loadReady == true ? AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: kBlue,
          leading: GestureDetector(
            onTap:()=> Navigator.pop(context),
            child:Container(
              margin: EdgeInsets.fromLTRB(0,0,0,0),
              alignment: Alignment.center,
              child:Text(_vocabular['registry']['user_profile']['back'], style: st12,),
            ),),
          title: Column(
              children:[
                Container(
                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                  alignment: Alignment.center,
                  child:Text('${_vocabular['form_n']['cargo']}', style: st4,),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                  alignment: Alignment.center,
                  child:Text(widget.routeInfo, style: st2,),
                ),
              ]
          ),
          actions:[
            Container(
              margin: EdgeInsets.fromLTRB(40,0,10,0),
              alignment: Alignment.center,
              child:Text('', style: st12,),
            ),
          ],
        ) : AppBar(),
        body: _loadReady == true ? SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(height: 20,),
                //список пассажиров персонами
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.airlineList[0].length,
                    itemBuilder: (BuildContext context, int index) {
                      expandWidgets.add(false);
                      return Column(
                          children:[
                            Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(onTap:(){
                                      setState(() {
                                        expandWidgets[index] =!expandWidgets[index];
                                      });
                                    }, child:Icon(expandWidgets[index] == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                                    Text(widget.airlineList[0][index]['type_and_characteristics'],style: st5,),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                                    ),

                                  ],
                                )
                            ),
                            expandWidgets[index] == true ? Wrap(
                                children:[
                                  Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['type_and_characteristics']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['type_cargo'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )),
                                  Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${dangerClassValue(widget.airlineList[0][index]['cargo_danger_classes_id'])}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['class_icao'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )),
                                  Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['weight']}', ///подставить текстовое значение
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['weight_cargo'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )),
                                  widget.airlineList[0][index]['cargo_charterer'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width /2,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['cargo_charterer']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width/2,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['charterer'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['cargo_charterer'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['cargo_charterer_fulladdress']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['charterer_address'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['cargo_charterer'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['cargo_charterer_phone']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['snipper_phone'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['receiving_party'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width /2,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['receiving_party']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width/2,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['host'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['receiving_party'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['receiving_party_fulladdress']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['host_address'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['receiving_party'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['receiving_party_phone']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['host_phone'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['consignor'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignor']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width/2,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['snipper'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['consignor'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignor_fulladdress']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['snipper_address'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['consignor'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignor_phone']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['snipper_phone'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                  widget.airlineList[0][index]['consignee'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignee']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width/2,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['consignee'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      ) ): Container(),
                                  widget.airlineList[0][index]['consignee'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignee_fulladdress']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                //color: kBlue,
                                                width: MediaQuery.of(context).size.width,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['consignee_address'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      ) ): Container(),
                                  widget.airlineList[0][index]['consignee'] != null ? Chip(
                                      backgroundColor: kBlue,
                                      elevation: 0.0,
                                      shadowColor: kBlue,
                                      labelPadding: EdgeInsets.all(2.0),
                                      label: Container(
                                        width: 150,
                                        height:70,
                                        child: Stack(
                                            children: [
                                              Container(
                                                  width: 150,
                                                  margin: EdgeInsets.fromLTRB(10,20,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0][index]['consignee_phone']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              Container(
                                                width: 150,
                                                alignment:Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(10,0,10,10),
                                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                                child: Text(_vocabular['form_n']['cargo_obj']['consignee_address'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                              ),
                                            ]),
                                      )) : Container(),
                                ]) : Container(),
                            //документы по cargo
                            expandWidgets[index] == true && widget.airlineList[0][index]['documents'].length > 0 ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: widget.airlineList[0][index]['documents'].length,
                                itemBuilder: (BuildContext context, int index2) {
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width -20 ,
                                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 0.5, color: kWhite3),
                                          ),
                                          child:Column(
                                              children:[
                                                Row(
                                                    children:[
                                                      Expanded( child:Text('${widget.airlineList[0][index]['documents'][index2]['file_type_name']}', style: st6,),),
                                                    ]),
                                                SizedBox(height: 5,),
                                                GestureDetector(onTap:()=>goToSite(widget.airlineList[0][index]['documents'][index2]['file_path']), child:Row(
                                                    children:[
                                                      Transform(
                                                          alignment: FractionalOffset.center,
                                                          transform: new Matrix4.identity()
                                                            ..rotateZ(135 * 3.1415927 / 180),
                                                          child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                                      SizedBox(width: 5,),
                                                      Expanded( child:Text('${widget.airlineList[0][index]['documents'][index2]['file_name']}', style: st4,),),
                                                    ]),),
                                                SizedBox(height: 5,),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                  alignment: Alignment.centerLeft,
                                                  child:Text('${widget.airlineList[0][index]['documents'][index2]['created_at'].substring(0,10)}', style: st2,),
                                                ),
                                              ]),
                                        ),
                                      ]);
                                }) : Container(),
                          ]);
                    }),
              ]),
        ):Container()
    );
  }
}



