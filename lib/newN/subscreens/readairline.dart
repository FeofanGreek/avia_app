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
bool _doc = false;
bool _dir = false;
bool _prime = false;

class airlineReadMode extends StatefulWidget {
  final List airlineList;
  final int expand;
  final int n_forms_id;
  final int id_pakus;

  airlineReadMode({
    this.airlineList,
    this.expand,
    this.n_forms_id,
    this.id_pakus
  });


  @override
  _State createState() => _State();
}

class _State extends State<airlineReadMode> {

  final docKey = new GlobalKey();
  final dirKey = new GlobalKey();
  final primeKey = new GlobalKey();

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
    widget.expand == 1 ? _doc = true : widget.expand == 2 ? _dir = true : widget.expand == 3 ? _prime = true : null;
    setState(() {
    });
    new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(widget.expand == 1 ? docKey.currentContext : widget.expand == 2 ? dirKey.currentContext : widget.expand == 3 ? primeKey.currentContext : docKey.currentContext));
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
                child:Text('${language == 'ru' ? widget.airlineList[0]['airline_namerus'] : widget.airlineList[0]['airline_namelat']}', style: st4,),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text(widget.airlineList[0]['airline_icao'], style: st2,),
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
            //информация об авиакомпании
            Container(
              width: MediaQuery.of(context).size.width,
            height:80,
            child: Stack(
              children: [
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(10,10,10,10),
                padding: EdgeInsets.fromLTRB(10,10,10,10),
                //color: kBlueLight,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: kWhite3),
                ),
                child:Column(
                    children:[
                      Container(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          alignment: Alignment.topCenter,
                          child:RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: '${language == 'ru' ? widget.airlineList[0]['airline_namerus'] : widget.airlineList[0]['airline_namelat']}',
                                style:  st4,
                                children: <TextSpan>[
                                  TextSpan(text: '  ${widget.airlineList[0]['airline_icao']}', style: st2,)
                                ]),
                          )
                      ),
                    ])
            ),
                Container(
                  color: kBlue,
                  margin: EdgeInsets.fromLTRB(20,0,10,10),
                  padding: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Text(_vocabular['registry']['airline'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                ),
        ]),
            ),
//документы
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        _doc =!_doc;
                      });
                    }, child:Icon(_doc == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['airline']['docs'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                    ),
                    GestureDetector(onTap:(){
                      showDialog(
                          context: context,
                          builder: (_) {
                            return commentDialog(title: _vocabular['airline']['docs'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'airline_documents', object_id: widget.airlineList[0]['n_form_airlines_id']);
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

            _doc == true ? ListView.builder(
              key: docKey,
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


//руководитель
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        _dir =!_dir;
                      });
                    }, child:Icon(_dir == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['airlines']['columns']['leader'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                    ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['airlines']['columns']['leader'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'airline_represent', object_id: widget.airlineList[0]['n_form_airlines_id']);
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
            _dir == true ? Row(
              key: dirKey,
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
                                Expanded( child:Text('${widget.airlineList[0]['airline_represent']['fio']}', style: st4,),),
                                /*Container(
                                    width:22,
                                    height: 22,
                                    margin: EdgeInsets.fromLTRB(10,0,10,0),
                                    child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))*/
                              ]),
                          Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            alignment: Alignment.centerLeft,
                            child:Text('${widget.airlineList[0]['airline_represent']['position']} ${widget.airlineList[0]['airline_represent']['email']}  ${_vocabular['form_n']['general']['phone']}:${widget.airlineList[0]['airline_represent']['tel']}  ${_vocabular['form_n']['general']['fax']}:${widget.airlineList[0]['airline_represent']['fax']}  AFTN:${widget.airlineList[0]['airline_represent']['aftn']}  SITA:${widget.airlineList[0]['airline_represent']['sita']}', style: st2,),
                          ),
                        ]),
                  ),
                ]) : Container(),
//представитель
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        _prime =!_prime;
                      });
                    }, child:Icon(_prime == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['airline']['airline_representative'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                    ),
                    /*Container(
                        width:22,
                        height: 22,
                        margin: EdgeInsets.fromLTRB(10,0,10,0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                        ),
                        child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14))*/
                  ],
                )
            ),
            _prime == true ? Row(
              key: primeKey,
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
                                Expanded( child:Text('${widget.airlineList[0]['russia_represent']['fio']}', style: st4,),),
                                /*Container(
                                    width:22,
                                    height: 22,
                                    margin: EdgeInsets.fromLTRB(10,0,10,0),
                                    child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))*/
                              ]),
                          Container(
                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                            alignment: Alignment.centerLeft,
                            child:Text('${widget.airlineList[0]['russia_represent']['position']} ${widget.airlineList[0]['russia_represent']['email']}  ${_vocabular['form_n']['general']['phone']}:${widget.airlineList[0]['russia_represent']['tel']}  ${_vocabular['form_n']['general']['fax']}:${widget.airlineList[0]['russia_represent']['fax']}  AFTN:${widget.airlineList[0]['russia_represent']['aftn']}  SITA:${widget.airlineList[0]['russia_represent']['sita']}', style: st2,),
                          ),
                        ]),
                  ),
                ]) : Container(),

            SizedBox(height: 100,)
                ]),



        ):Container(),
    );
  }
}



