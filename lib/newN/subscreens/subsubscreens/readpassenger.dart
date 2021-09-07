import 'dart:convert';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../strings.dart';
import '../../../text_styles.dart';



var _vocabular;
bool _loadReady = false;


class readPassengers extends StatefulWidget {
  final List airlineList;
  final int expand;
  final String routeInfo;

  readPassengers({
    this.airlineList,
    this.expand,
    this.routeInfo
  });


  @override
  _State createState() => _State();
}

class _State extends State<readPassengers> {

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
                  child:Text('${_vocabular['form_n']['passengers']}', style: st4,),
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
                    itemCount: widget.airlineList[0]['passengers_persons'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          children:[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:70,
                              child: Stack(
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.fromLTRB(10,20,10,10),
                                        child:Row(
                                            children:[
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  width: MediaQuery.of(context).size.width / 2-15,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${widget.airlineList[0]['passengers_persons'][index]['fio']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                              SizedBox(width: 10,),
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  width: MediaQuery.of(context).size.width / 2 -15,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child:RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: '${language == 'ru' ? widget.airlineList[0]['passengers_persons'][index]['state']['state_namerus'] : widget.airlineList[0]['passengers_persons'][index]['state']['state_namelat']}',
                                                        style:  st4,
                                                        children: <TextSpan>[
                                                          TextSpan(text: '', style: st2,)
                                                        ]),
                                                  )
                                              ),
                                            ])

                                    ),
                                    Container(
                                      //color: kBlue,
                                      alignment:Alignment.topLeft,
                                      margin: EdgeInsets.fromLTRB(10,0,10,10),
                                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                                      child: Text(_vocabular['form_n']['crew']['full_name'].substring(3), style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                    ),
                                    Container(
                                      //color: kBlue,
                                      alignment:Alignment.topLeft,
                                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 2,0,10,10),
                                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                                      child: Text(_vocabular['form_n']['crew']['nationality'].substring(3), style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                    ),
                                  ]),
                            ),
                            //документы по пассажирам персонами
                            widget.airlineList[0]['passengers_persons'][index]['documents'].length > 0 ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: widget.airlineList[0]['passengers_persons'][index]['documents'].length,
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
                                                      Expanded( child:Text('${widget.airlineList[0]['passengers_persons'][index]['documents'][index2]['file_type_name']}', style: st6,),),
                                                    ]),
                                                SizedBox(height: 5,),
                                                GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['passengers_persons'][index]['documents'][index2]['file_path']), child:Row(
                                                    children:[
                                                      Transform(
                                                          alignment: FractionalOffset.center,
                                                          transform: new Matrix4.identity()
                                                            ..rotateZ(135 * 3.1415927 / 180),
                                                          child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                                      SizedBox(width: 5,),
                                                      Expanded( child:Text('${widget.airlineList[0]['passengers_persons'][index]['documents'][index2]['file_name']}', style: st4,),),
                                                    ]),),
                                                SizedBox(height: 5,),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                  alignment: Alignment.centerLeft,
                                                  child:Text('${widget.airlineList[0]['dates_documents'][index]['created_at'].substring(0,10)}', style: st2,),
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



