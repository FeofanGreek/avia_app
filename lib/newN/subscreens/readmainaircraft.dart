import 'dart:async';
import 'dart:convert';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:avia_app/widgets/commentDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';


var _vocabular;
//var _nFormBody;
bool _loadReady = false;
bool _main = false;
bool _parameters = false;
bool _owner = false;

class readMainAircraft extends StatefulWidget {
  final List airlineList;
  final int expand;
  final int n_forms_id;
  final int id_pakus;
  final int object_id;
  final bool isReserv;

  readMainAircraft({
    this.airlineList,
    this.expand,
    this.n_forms_id,
    this.id_pakus,
    this.object_id,
    this.isReserv
  });


  @override
  _State createState() => _State();
}

class _State extends State<readMainAircraft> {
  final mainKey = new GlobalKey();
  final parametersKey = new GlobalKey();
  final onerKey = new GlobalKey();

  //подгрузили словари из файла
  void loadJsonLanguage() async {
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

  //функция разворота нужного раздела
  expandDo(){
    widget.expand == 1 ? _main = true : widget.expand == 2 ? _parameters = true : widget.expand == 3 ? _owner = true : null;
    setState(() {

    });
    new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(widget.expand == 1 ? mainKey.currentContext : widget.expand == 2 ? parametersKey.currentContext : widget.expand == 3 ? onerKey.currentContext : mainKey.currentContext));

  }

  @override
  void initState() {
    loadJsonLanguage();
    super.initState();
    widget.expand != null ? expandDo() : null;
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
                child:Text('${widget.airlineList[0]['regno']}', style: st4,),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text('${widget.airlineList[0]['type']}', style: st2,),
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
              //информация о ВС
              Container(
                key: mainKey,
                width: MediaQuery.of(context).size.width,
                height:70,
                child: Stack(
                    children: [
              Container(
                alignment:Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10,10,10,10),
                  padding: EdgeInsets.fromLTRB(10,15,10,10),
                  //color: kBlueLight,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: kWhite3),
                  ),
                  child:Column(
                      children:[
                        Container(
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                            alignment: Alignment.topLeft,
                            child:RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: '${widget.airlineList[0]['regno']}',
                                  style:  st4,
                                  children: <TextSpan>[
                                    TextSpan(text: '  ${widget.airlineList[0]['type']}', style: st2,)
                                  ]),
                            )
                        ),
                      ])
              ),
              Container(
                color: kBlue,
                margin: EdgeInsets.fromLTRB(20,0,10,10),
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: Text(_vocabular['airline']['aircraft_data']['reg_numb'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
              ),
            ]),
      ),
              //параметры ВС
              Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _parameters =!_parameters;
                        });
                      }, child:Icon(_parameters == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['air_craft']['parameters'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['form_n']['air_craft']['parameters'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: '${widget.isReserv == false ? 'aircraft_main_parameters' : 'aircraft_reserve_parameters'}', object_id: widget.object_id);
                });


          }, child:Container(
                          width:22,
                          height: 22,
                          margin: EdgeInsets.fromLTRB(10,0,10,0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                          ),
                          child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                    ],
                  )
              ),
              _parameters == true ? Row(
                key: parametersKey,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 55,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: kWhite3),
                      ),
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Expanded( child:Text('${widget.airlineList[0]['type_model']} / ${widget.airlineList[0]['tacft_type']}', style: st4,),),
                                  /*Container(
                                    width:22,
                                    height: 22,
                                    margin: EdgeInsets.fromLTRB(10,0,10,0),
                                    child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))*/
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${_vocabular['form_n']['air_craft']['reserve_takeoff_weight']}: ${widget.airlineList[0]['parameters']['max_takeoff_weight']}\n${_vocabular['form_n']['air_craft']['reserve_posad_weight']}: ${widget.airlineList[0]['parameters']['max_landing_weight']}\n${_vocabular['form_n']['air_craft']['reserve_weight_equipment']}: ${widget.airlineList[0]['parameters']['empty_equip_weight']}', style: st2,),
                            ),
                          ]),
                    ),
                  ]) : Container(),
              //документы
              Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*GestureDetector(onTap:(){
                        setState(() {
                          _doc =!_doc;
                        });
                      }, child:Icon(_doc == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),*/
                      Text(_vocabular['form_n']['air_craft']['aircraft_documents'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
                      GestureDetector(onTap:(){
                        showDialog(
                            context: context,
                            builder: (_) {
                              return commentDialog(title: _vocabular['form_n']['air_craft']['aircraft_documents'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: '${widget.isReserv == false ? 'aircraft_main_documents' : 'aircraft_reserve_documents'}', object_id: widget.object_id);
                            });


                      }, child:Container(
                          width:22,
                          height: 22,
                          margin: EdgeInsets.fromLTRB(10,0,10,0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                          ),
                          child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                    ],
                  )
              ),

              widget.airlineList[0]['documents'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['documents'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 55,
                            margin: EdgeInsets.fromLTRB(10,10,10,10),
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: kWhite3),
                            ),
                            child:Column(
                                children:[
                                  Row(
                                      children:[
                                        Expanded( child:Text('${widget.airlineList[0]['documents'][index]['file_type_name']}', style: st6,),),
                                      ]),
                                  SizedBox(height: 5,),
                                  GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['documents'][index]['file_path']), child:Row(
                                      children:[
                                        Transform(
                                            alignment: FractionalOffset.center,
                                            transform: new Matrix4.identity()
                                              ..rotateZ(135 * 3.1415927 / 180),
                                            child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                        SizedBox(width: 5,),
                                        Expanded( child:Text('${widget.airlineList[0]['documents'][index]['file_name']}', style: st4,),),
                                      ]),),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,0,0,0),
                                    alignment: Alignment.centerLeft,
                                    child:Text('${_vocabular['form_n']['general']['loaded']}:${widget.airlineList[0]['documents'][index]['created_at'].substring(0,10)}', style: st2,),
                                  ),
                                ]),
                          ),
                        ]);
                  }) : Container(),
              //владелец
              Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child:
                      Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _owner =!_owner;
                        });
                      }, child:Icon(_owner == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['airline']['owner_data']['title'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
                      GestureDetector(onTap:(){
                        showDialog(
                            context: context,
                            builder: (_) {
                              return commentDialog(title: _vocabular['airline']['owner_data']['title'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: '${widget.isReserv == false ? 'aircraft_main' : 'aircraft_reserve'}', object_id: widget.object_id);
                            });


                      }, child:Container(
                          width:22,
                          height: 22,
                          margin: EdgeInsets.fromLTRB(10,0,10,0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                          ),
                          child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                    ]),
              ),
              _owner == true ? Row(
                key: onerKey,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 55,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: kWhite3),
                      ),
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Expanded( child:Text('${widget.airlineList[0]['aircraft_owner']['name']}', style: st4,),),
                                  /*Container(
                                    width:22,
                                    height: 22,
                                    margin: EdgeInsets.fromLTRB(10,0,10,0),
                                    child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))*/
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${widget.airlineList[0]['aircraft_owner']['full_address']} ${widget.airlineList[0]['aircraft_owner']['contact']}', style: st2,),
                            ),
                            //документы владельца ВС
                            widget.airlineList[0]['aircraft_owner']['documents'].length > 0 ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: widget.airlineList[0]['aircraft_owner']['documents'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width - 97,
                                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 0.5, color: kWhite3),
                                          ),
                                          child:Column(
                                              children:[
                                                Row(
                                                    children:[
                                                      Expanded( child:Text('${widget.airlineList[0]['aircraft_owner']['documents'][index]['file_type_name']}', style: st6,),),
                                                    ]),
                                                SizedBox(height: 5,),
                                                GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['aircraft_owner']['documents'][index]['file_path']), child:Row(
                                                    children:[
                                                      Transform(
                                                          alignment: FractionalOffset.center,
                                                          transform: new Matrix4.identity()
                                                            ..rotateZ(135 * 3.1415927 / 180),
                                                          child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                                      SizedBox(width: 5,),
                                                      Expanded( child:Text('${widget.airlineList[0]['aircraft_owner']['documents'][index]['file_name']}', style: st4,),),
                                                    ]),),
                                                SizedBox(height: 5,),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                  alignment: Alignment.centerLeft,
                                                  child:Text('${_vocabular['form_n']['general']['loaded']}:${widget.airlineList[0]['aircraft_owner']['documents'][index]['created_at'].substring(0,10)}', style: st2,),
                                                ),
                                              ]),
                                        ),
                                      ]);
                                }):Container()
                          ]),
                    ),
                  ]) : Container(),
              SizedBox(height: 100,)
            ]),



      ):Container(),
    );
  }
}



