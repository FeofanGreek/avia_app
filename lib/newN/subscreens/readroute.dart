import 'dart:async';
import 'dart:convert';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:avia_app/newN/subscreens/subsubscreens/readcargo.dart';
import 'package:avia_app/newN/subscreens/subsubscreens/readpassenger.dart';
import 'package:avia_app/widgets/commentDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';


var _vocabular;
var transportationCategories;
//var _nFormBody;
bool _loadReady = false;
bool _routInfo = false;
bool _mainDep = false;
bool _repetition = false;
bool _crew = false;
bool _cargo = false;
bool _passenger = false;

class readRoute extends StatefulWidget {
  final List airlineList;
  final int expand;
  final int n_forms_id;
  final int id_pakus;
  final List comments;

  readRoute({
    this.airlineList,
    this.expand,
    this.n_forms_id,
    this.id_pakus,
    this.comments,
  });


  @override
  _State createState() => _State();
}

class _State extends State<readRoute> {
  final infoKey = new GlobalKey();
  final mainDateKey = new GlobalKey();
  final repetitionKey = new GlobalKey();
  final crewKey = new GlobalKey();
  final passengerKey = new GlobalKey();
  final cargoKey = new GlobalKey();



  //подгрузили словари из файла
  void loadJsonLanguage() async {
    String data = await rootBundle.loadString('vocNew/FlightCategories.json');
    transportationCategories = json.decode(data);
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

  selTransCat(int id){
    var value = '';
    for(int i =0; i< transportationCategories.length; i++){
      transportationCategories[i]['CATEGORIES_ID'] == id ? value = language == 'ru' ? transportationCategories[i]['NAMERUS'] : transportationCategories[i]['NAMELAT'] : null;
    }
    return value;
  }

  //функция разворота нужного раздела
  expandDo(){
    widget.expand == 1 ? _routInfo = true : widget.expand == 2 ? _mainDep = true : widget.expand == 3 ? _repetition = true : widget.expand == 4 ? _crew = true : widget.expand == 5 ? _cargo = true : widget.expand == 6 ? _passenger = true :widget.expand == 7 ? Timer(Duration(seconds:1), () => Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            readCargo(airlineList: [widget
                .airlineList[0]['cargos']
            ], routeInfo: '${widget
                .airlineList[0]['main_date']['date']} / ${widget
                .airlineList[0]['flight_information']['flight_num']}',)))): null;
    setState(() {

    });
    new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(widget.expand == 1 ? infoKey.currentContext: widget.expand == 2 ? mainDateKey.currentContext: widget.expand == 3 ? repetitionKey.currentContext : widget.expand == 4 ? crewKey.currentContext : widget.expand == 5 ? passengerKey.currentContext: widget.expand == 6 ? cargoKey.currentContext : null));
  }

//генератор точек вх/вых
  pointChipGenerator(){
    List<Widget> pointChip = [];
    for(int i =0; i < widget.airlineList[0]['points'].length; i++){
      pointChip.add(
          Chip(
            labelPadding: EdgeInsets.all(0.0),
            label: Container(
                height: 20,
                width:widget.airlineList[0]['points'][0]['alt_points'].length > 0 ? 150 : 100,
                padding: EdgeInsets.fromLTRB(10,0,0,0),
                alignment: Alignment.center,
                child: Row(
                    children: [
                      Text('${widget.airlineList[0]['points'][0]['name'].length > 5 ? widget.airlineList[0]['points'][0]['name'].substring(0, 5) : widget.airlineList[0]['points'][0]['name']}', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                      Text(' ${widget.airlineList[0]['points'][0]['time']} ', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite2,)),
                      widget.airlineList[0]['points'][0]['alt_points'].length > 0 ? Text('ALT(${widget.airlineList[0]['points'][0]['alt_points'].length})', style: TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kYellow)) : Container(),
                      GestureDetector( onTap: (){}, child:Icon(Icons.clear, color: kWhite, size: 16,))
                    ])
            ),
            backgroundColor: kBlueLight,
            elevation: 6.0,
            shadowColor: kBlueLight,
            //padding: EdgeInsets.all(8.0),
          )
         );

    }
    return pointChip;
  }

  //оформление вида дней недели
  daysWeekView(int index){
    List daysRU = ['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'];
    List daysEN = ['MO','TU','WE','TH','FR','ST','SA'];
    List selectedDays = widget.airlineList[0]['period_dates'][index]['days_of_week'];

    searchDay(int num){
      bool accept = false;
      for(int i=0; i< selectedDays.length; i++){
        selectedDays[i] == num + 1 ? accept = true : null;
      }
      return accept;
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //padding: EdgeInsets.zero,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index2) {
          return Container(
            margin: EdgeInsets.fromLTRB(0,10,8,0),
            padding: EdgeInsets.fromLTRB(8,10,8,10),
            width:MediaQuery.of(context).size.width/7-10,
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: searchDay(index2) == false ? kWhite3 : kYellow),
              color: kBlue,
            ),
            alignment: Alignment.center,
            child:Text('${language == 'ru' ? daysRU[index2] : daysEN[index2]}', style: st4),
          );});
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
                child:Text('${widget.airlineList[0]['main_date']['date']}', style: st4,), //
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text(widget.airlineList[0]['flight_information']['flight_num'], style: st2,),
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
              //информация о рейсе
              Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _routInfo =!_routInfo;
                        });
                      }, child:Icon(_routInfo == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['flight_information'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['form_n']['flight_information'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              _routInfo == true ? ListView(
                key: infoKey,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['flight_num']}',
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['registry']['flight_number'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: ' ${widget.airlineList[0]['flight_information']['purpose_is_commercial'] == 0 ? _vocabular['form_n']['purposeFlight']['none_commercial_flight'] : _vocabular['form_n']['purposeFlight']['commercial_flight']}', ///подставить из справочника текст
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['purpose_flight'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${selTransCat(widget.airlineList[0]['flight_information']['transportation_categories_id'])}', ///подставить из справочника текст
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['registry']['transportation_categories'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['departure_airport_icao']}',
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: ' ${language == 'ru' ? widget.airlineList[0]['flight_information']['departure_airport_namerus'] : widget.airlineList[0]['flight_information']['departure_airport_namelat']}', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['route_obj']['airport_departure'].substring(3), style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['departure_time']}',
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['route_obj']['departure_date_time'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['landing_airport_icao']}',
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: ' ${language == 'ru' ? widget.airlineList[0]['flight_information']['landing_airport_namerus'] : widget.airlineList[0]['flight_information']['landing_airport_namelat']}', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['route_obj']['airport_destination'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['landing_time']}',
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['route_obj']['arrival_date_time'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:60,
                    child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: kWhite3),
                              ),
                              child:Column(
                                  children:[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                                        alignment: Alignment.centerLeft,
                                        child:RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: '${widget.airlineList[0]['flight_information']['landing_type'] != null ? widget.airlineList[0]['flight_information']['landing_type'] == 0 ? _vocabular['form_n']['route_obj']['landing_type_commercial'] : _vocabular['form_n']['route_obj']['landing_type_technical'] : _vocabular['registry']['not_selected']}', /// подставить текстовый параметр
                                              style:  st4,
                                              children: <TextSpan>[
                                                TextSpan(text: '', style: st2,)
                                              ]),
                                        )
                                    ),
                                  ])
                          ),
                          Container(
                            color: kBlue,
                            margin: EdgeInsets.fromLTRB(20,0,10,10),
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Text(_vocabular['form_n']['route_obj']['landing_type'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                          ),
                        ]),
                  ),
                  /// добавить точки входа выхода
                  Container(
                    color: kBlue,
                    margin: EdgeInsets.fromLTRB(20,0,10,0),
                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                    child: Text(_vocabular['form_r']['entry_exit_points'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0 * ((widget.airlineList[0]['points'].length * 150) / (MediaQuery.of(context).size.width -20)).ceil() + 25, // ( 150 * количество точек) / (ширина экрана - 20)
                    margin: EdgeInsets.fromLTRB(10,10,10,10),
                    padding: EdgeInsets.fromLTRB(10,5,10,5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: kWhite3),
                    ),
                    child:
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: pointChipGenerator(),
                    ),
                  ),
                ],
              ) : Container(),
              //основная дата вылета
              Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _mainDep =!_mainDep;
                        });
                      }, child:Icon(_mainDep == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['main_departure_date'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
                      GestureDetector(onTap:(){
                        showDialog(
                            context: context,
                            builder: (_) {
                              return commentDialog(title: _vocabular['form_n']['main_departure_date'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight_main_date', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              _mainDep == true ? ListView(
                key: mainDateKey,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                height:60,
                child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: kWhite3),
                          ),
                          child:Column(
                              children:[
                                Container(
                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                    alignment: Alignment.centerLeft,
                                    child:RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          text: '${widget.airlineList[0]['main_date']['date']}',
                                          style:  st4,
                                          children: <TextSpan>[
                                            TextSpan(text: '', style: st2,)
                                          ]),
                                    )
                                ),
                              ])
                      ),
                      Container(
                        color: kBlue,
                        margin: EdgeInsets.fromLTRB(20,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        child: Text(_vocabular['form_n']['main_departure_date_obj']['main_date'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                      ),
                    ]),
              ),
              widget.airlineList[0]['main_date']['dep_slot_id'] != null ? Container(
                width: MediaQuery.of(context).size.width,
                height:60,
                child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: kWhite3),
                          ),
                          child:Column(
                              children:[
                                Container(
                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                    alignment: Alignment.centerLeft,
                                    child:RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          text: '${widget.airlineList[0]['main_date']['dep_slot_id']}',
                                          style:  st4,
                                          children: <TextSpan>[
                                            TextSpan(text: '', style: st2,)
                                          ]),
                                    )
                                ),
                              ])
                      ),
                      Container(
                        color: kBlue,
                        margin: EdgeInsets.fromLTRB(20,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        child: Text(_vocabular['form_n']['main_departure_date_obj']['departure_slot_id'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                      ),
                    ]),
              ) : Container(),
              widget.airlineList[0]['main_date']['land_slot_id'] != null ? Container(
                width: MediaQuery.of(context).size.width,
                height:60,
                child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: kWhite3),
                          ),
                          child:Column(
                              children:[
                                Container(
                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                    alignment: Alignment.centerLeft,
                                    child:RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          text: '${widget.airlineList[0]['main_date']['land_slot_id']}',
                                          style:  st4,
                                          children: <TextSpan>[
                                            TextSpan(text: '', style: st2,)
                                          ]),
                                    )
                                ),
                              ])
                      ),
                      Container(
                        color: kBlue,
                        margin: EdgeInsets.fromLTRB(20,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        child: Text(_vocabular['form_n']['main_departure_date_obj']['destination_slot_id'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                      ),
                    ]),
              ) : Container(),
              widget.airlineList[0]['main_date']['documents'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['main_date']['documents'].length,
                  itemBuilder: (BuildContext context, int index) {
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
                                        Expanded( child:Text('${widget.airlineList[0]['main_date']['documents'][index]['file_type_name']}', style: st6,),),
                                      ]),
                                  SizedBox(height: 5,),
                                  GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['main_date']['documents'][index]['file_path']), child:Row(
                                      children:[
                                        Transform(
                                            alignment: FractionalOffset.center,
                                            transform: new Matrix4.identity()
                                              ..rotateZ(135 * 3.1415927 / 180),
                                            child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                        SizedBox(width: 5,),
                                        Expanded( child:Text('${widget.airlineList[0]['main_date']['documents'][index]['file_name']}', style: st4,),),
                                      ]),),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,0,0,0),
                                    alignment: Alignment.centerLeft,
                                    child:Text('${widget.airlineList[0]['main_date']['documents'][index]['created_at'].substring(0,10)}', style: st2,),
                                  ),
                                ]),
                          ),
                        ]);
                  }) : Container(),
            ]) : Container(),
            //повторы
              widget.airlineList[0]['other_dates'].length > 0 || widget.airlineList[0]['period_dates'].length > 0 ? Container(
                  key: repetitionKey,
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _repetition =!_repetition;
                        });
                      }, child:Icon(_repetition == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['main_departure_date_obj']['repetitions'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['form_n']['main_departure_date_obj']['repetitions'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight_other_date', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              ): Container(),
             _repetition == true && widget.airlineList[0]['other_dates'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['other_dates'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return index == 0 || index == widget.airlineList[0]['other_dates'].length - 1 ? ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height:60,
                            child: Stack(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: kWhite3),
                                      ),
                                      child:Column(
                                          children:[
                                            Container(
                                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                      text: '${widget.airlineList[0]['other_dates'][index]['date']}',
                                                      style:  st4,
                                                      children: <TextSpan>[
                                                        TextSpan(text: '', style: st2,)
                                                      ]),
                                                )
                                            ),
                                          ])
                                  ),
                                  Container(
                                    color: kBlue,
                                    margin: EdgeInsets.fromLTRB(20,0,10,10),
                                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                                    child: Text('${index == 0 ? _vocabular['form_n']['general']['date_beginning'] : _vocabular['form_n']['general']['date_expiration']}', style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                  ),
                                ]),
                          ),
                          widget.airlineList[0]['other_dates'][index]['dep_slot_id'] != null ? Container(
                            width: MediaQuery.of(context).size.width,
                            height:60,
                            child: Stack(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: kWhite3),
                                      ),
                                      child:Column(
                                          children:[
                                            Container(
                                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                      text: '${widget.airlineList[0]['other_dates'][index]['dep_slot_id']}',
                                                      style:  st4,
                                                      children: <TextSpan>[
                                                        TextSpan(text: '', style: st2,)
                                                      ]),
                                                )
                                            ),
                                          ])
                                  ),
                                  Container(
                                    color: kBlue,
                                    margin: EdgeInsets.fromLTRB(20,0,10,10),
                                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                                    child: Text(_vocabular['form_n']['main_departure_date_obj']['departure_slot_id'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                  ),
                                ]),
                          ) : Container(),
                          widget.airlineList[0]['other_dates'][index]['land_slot_id'] != null ? Container(
                            width: MediaQuery.of(context).size.width,
                            height:60,
                            child: Stack(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: kWhite3),
                                      ),
                                      child:Column(
                                          children:[
                                            Container(
                                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                      text: '${widget.airlineList[0]['other_dates'][index]['land_slot_id']}',
                                                      style:  st4,
                                                      children: <TextSpan>[
                                                        TextSpan(text: '', style: st2,)
                                                      ]),
                                                )
                                            ),
                                          ])
                                  ),
                                  Container(
                                    color: kBlue,
                                    margin: EdgeInsets.fromLTRB(20,0,10,10),
                                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                                    child: Text(_vocabular['form_n']['main_departure_date_obj']['destination_slot_id'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                  ),
                                ]),
                          ) : Container(),
                        ]) : Container();
                  }) : Container(),
              //повторы по периодам
              _repetition == true && widget.airlineList[0]['period_dates'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['period_dates'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height:70,
                            child: Stack(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(10,20,10,10),
                                      //padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      /*decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: kWhite3),
                                      ),*/
                                      child:
                                            Row(
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
                                                      text: '${widget.airlineList[0]['period_dates'][index]['start_date']}',
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
                                                  text: '${widget.airlineList[0]['period_dates'][index]['end_date']}',
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
                                    child: Text(_vocabular['form_n']['general']['date_beginning'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                  ),
                                  Container(
                                    //color: kBlue,
                                    alignment:Alignment.topRight,
                                    margin: EdgeInsets.fromLTRB(10,0,10,10),
                                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                                    child: Text(_vocabular['form_n']['general']['date_beginning'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                                  ),
                                ]),
                          ),
                          widget.airlineList[0]['period_dates'].length > 0 ? Container(
                                width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                    height:70,
                    child: daysWeekView(index),) : Container(),
                          widget.airlineList[0]['period_dates'][index]['documents'].length > 0 ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: widget.airlineList[0]['period_dates'][index]['documents'].length,
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
                                                    Expanded( child:Text('${widget.airlineList[0]['period_dates'][index]['documents'][index2]['file_type_name']}', style: st6,),),
                                                  ]),
                                              SizedBox(height: 5,),
                                              GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['period_dates'][index]['documents'][index2]['file_path']), child:Row(
                                                  children:[
                                                    Transform(
                                                        alignment: FractionalOffset.center,
                                                        transform: new Matrix4.identity()
                                                          ..rotateZ(135 * 3.1415927 / 180),
                                                        child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                                    SizedBox(width: 5,),
                                                    Expanded( child:Text('${widget.airlineList[0]['period_dates'][index]['documents'][index2]['file_name']}', style: st4,),),
                                                  ]),),
                                              SizedBox(height: 5,),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:Text('${widget.airlineList[0]['period_dates'][index]['documents'][index2]['created_at'].substring(0,10)}', style: st2,),
                                              ),
                                            ]),
                                      ),
                                    ]);
                              }) : Container(),

                        ]);
                  }) : Container(),
              //документы по повторам
              _repetition == true && widget.airlineList[0]['dates_documents'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['dates_documents'].length,
                  itemBuilder: (BuildContext context, int index) {
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
                                        Expanded( child:Text('${widget.airlineList[0]['dates_documents'][index]['file_type_name']}', style: st6,),),
                                      ]),
                                  SizedBox(height: 5,),
                                  GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['dates_documents'][index]['file_path']), child:Row(
                                      children:[
                                        Transform(
                                            alignment: FractionalOffset.center,
                                            transform: new Matrix4.identity()
                                              ..rotateZ(135 * 3.1415927 / 180),
                                            child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                        SizedBox(width: 5,),
                                        Expanded( child:Text('${widget.airlineList[0]['dates_documents'][index]['file_name']}', style: st4,),),
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
            //экипаж
              Container(
                key: crewKey,
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _crew =!_crew;
                        });
                      }, child:Icon(_crew == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['flight_crew'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
                      GestureDetector(onTap:(){
                        showDialog(
                            context: context,
                            builder: (_) {
                              return commentDialog(title: _vocabular['form_n']['flight_crew'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight_crew', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              //экипаж группой
              _crew == true && widget.airlineList[0]['crew']['crew_groups'] != null && widget.airlineList[0]['crew']['crew_groups'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['crew']['crew_groups'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return
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
                                                  text: '${widget.airlineList[0]['crew']['crew_groups'][index]['quantity']}',
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
                                                  text: '${language == 'ru' ? widget.airlineList[0]['crew']['crew_groups'][index]['state']['state_namerus'] : widget.airlineList[0]['crew']['crew_groups'][index]['state']['state_namelat']}',
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
                                child: Text(_vocabular['form_n']['crew']['crew_number'], style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                              ),
                              Container(
                                //color: kBlue,
                                alignment:Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 2,0,10,10),
                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                child: Text(_vocabular['form_n']['crew']['nationality'].substring(3), style:TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite3)),
                              ),
                            ]),
                      );}) : Container(),
              //экипаж членами
              _crew == true && widget.airlineList[0]['crew']['crew_members'] != null && widget.airlineList[0]['crew']['crew_members'].length > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.airlineList[0]['crew']['crew_members'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        children: [
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
                                                  text: '${widget.airlineList[0]['crew']['crew_members'][index]['fio']}',
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
                                                  text: '${language == 'ru' ? widget.airlineList[0]['crew']['crew_members'][index]['state']['state_namerus'] : widget.airlineList[0]['crew']['crew_members'][index]['state']['state_namelat']}',
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
                       //lокументы на членов
                          _crew == true && widget.airlineList[0]['crew']['crew_members'][index]['documents'].length > 0 ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: widget.airlineList[0]['crew']['crew_members'][index]['documents'].length,
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
                                                    Expanded( child:Text('${widget.airlineList[0]['crew']['crew_members'][index]['documents'][index2]['file_type_name']}', style: st6,),),
                                                  ]),
                                              SizedBox(height: 5,),
                                              GestureDetector(onTap:()=>goToSite(widget.airlineList[0]['crew']['crew_members'][index]['documents'][index2]['file_path']), child:Row(
                                                  children:[
                                                    Transform(
                                                        alignment: FractionalOffset.center,
                                                        transform: new Matrix4.identity()
                                                          ..rotateZ(135 * 3.1415927 / 180),
                                                        child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                                    SizedBox(width: 5,),
                                                    Expanded( child:Text('${widget.airlineList[0]['crew']['crew_members'][index]['documents'][index2]['file_name']}', style: st4,),),
                                                  ]),),
                                              SizedBox(height: 5,),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:Text('${widget.airlineList[0]['crew']['crew_members'][index]['documents'][index2]['created_at'].substring(0,10)}', style: st2,),
                                              ),
                                            ]),
                                      ),
                                    ]);
                              }) : Container(),
                    ]);}) : Container(),
            //пассажиры
              Container(
                key: passengerKey ,
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _passenger =!_passenger;
                        });
                      }, child:Icon(_passenger == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['passengers'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['form_n']['passengers'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight_passengers', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              _passenger == true && widget.airlineList[0]['passengers']['quantity'] > 0?  GestureDetector(
              onTap:(){
                if(widget.airlineList[0]['passengers']['passengers_persons'].length > 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          readPassengers(airlineList: [widget
                              .airlineList[0]['passengers']
                          ], routeInfo: '${widget
                              .airlineList[0]['main_date']['date']} / ${widget
                              .airlineList[0]['flight_information']['flight_num']}',)));
                }
              },
              child:Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10,10,10,10),
                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                  color: kBlueLight,
                  child:Row(
                            children:[
                              Expanded( child:Text('${_vocabular['form_n']['passengers_obj']['crew_passenger']}: ${widget.airlineList[0]['passengers']['quantity']} ', style: st4,),),
                              //icons triangles
                              Container(
                                  width:22,
                                  height: 22,
                                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                                  child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                            ]),
               )): Container(),
            //груз
              Container(
                key: cargoKey,
                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          _cargo =!_cargo;
                        });
                      }, child:Icon(_cargo == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['form_n']['cargo'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                      ),
          GestureDetector(onTap:(){
            showDialog(
                context: context,
                builder: (_) {
                  return commentDialog(title: _vocabular['form_n']['cargo'], n_forms_id: widget.n_forms_id, id_pakus: widget.id_pakus, object_type: 'flight_cargo', object_id: widget.airlineList[0]['n_form_flight_global_id']);
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
              _cargo == true && widget.airlineList[0]['cargos'].length > 0?  GestureDetector(
                  onTap:(){
                    if(widget
                        .airlineList[0]['cargos'].length > 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              readCargo(airlineList: [widget
                                  .airlineList[0]['cargos']
                              ], routeInfo: '${widget
                                  .airlineList[0]['main_date']['date']} / ${widget
                                  .airlineList[0]['flight_information']['flight_num']}',)));
                    }
                  },
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10,10,10,10),
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    color: kBlueLight,
                    child:Row(
                        children:[
                          Expanded( child:Text('Едениц груза: ${widget.airlineList[0]['cargos'].length} ', style: st4,),),
                          //icons triangles
                          Container(
                              width:22,
                              height: 22,
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                        ]),
                  )): Container(),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.comments[0].length,
                  itemBuilder: (BuildContext context, int index) {
                    return widget.comments[0][index]['object_type'].contains('flight') ? Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10,0,10,0),
                        padding: EdgeInsets.fromLTRB(10,5,10,5),
                        color: widget.comments[0][index]['comment_type_id'] == 5 ? kRed.withOpacity(0.5) : widget.comments[0][index]['comment_type_id'] == 2 ? Colors.blue.withOpacity(0.5) : Colors.yellow.withOpacity(0.5),
                        child:Column(
                            children:[
                              Row(
                                  children:[
                                    Image.asset(
                                        widget.comments[0][index]['comment_type_id'] == 5 ? 'icons/triangle_red.png' : widget.comments[0][index]['comment_type_id'] == 2 ? 'icons/triangle_blue.png' : 'icons/triangle_yellow.png', width: 16,
                                        height: 16,
                                        fit: BoxFit.fitHeight),
                                    SizedBox(width: 10,),
                                    Text('${widget.comments[0][index]['comment_text']}'),
                                    Spacer(),
                                   ]),
                              Container(
                                margin: EdgeInsets.fromLTRB(25,0,0,0),
                                alignment: Alignment.centerLeft,
                                child:Text('${_vocabular['form_n']['flight_information_obj']['openly']}   ${widget.comments[0][index]['created_at'].substring(0,10)}   ${widget.comments[0][index]['author']['roles'][0]['name_lat']}  ${widget.comments[0][index]['author']['first_name']} ${widget.comments[0][index]['author']['last_name'].substring(0,1)}.', style: st2,),
                              ),
                              widget.comments[0][index]['child_comments'].length > 0 ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.comments[0][index]['child_comments'].length,
                                  itemBuilder: (BuildContext context, int indexCH) {
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.fromLTRB(30,0,0,0),
                                        padding: EdgeInsets.fromLTRB(10,5,10,5),
                                        //color: _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 5 ? kRed.withOpacity(0.5) : _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 2 ? Colors.blue.withOpacity(0.5) : Colors.yellow.withOpacity(0.5),
                                        child:Column(
                                            children:[
                                              Row(
                                                  children:[
                                                    Image.asset(
                                                        widget.comments[0][index]['child_comments'][indexCH]['comment_type_id'] == 5 ? 'icons/triangle_red.png' : widget.comments[0][index]['child_comments'][indexCH]['comment_type_id'] == 2 ? 'icons/triangle_blue.png' : 'icons/triangle_yellow.png', width: 16,
                                                        height: 16,
                                                        fit: BoxFit.fitHeight),
                                                    SizedBox(width: 10,),
                                                    Text('${widget.comments[0][index]['child_comments'][indexCH]['text']}'),
                                                    //Spacer(),
                                                    //Text(_vocabular['form_n']['general']['expand'], style: st12,)
                                                  ]),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(25,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                child:Text('${_vocabular['form_n']['flight_information_obj']['openly']}   ${widget.comments[0][index]['child_comments'][indexCH]['created_at'].substring(0,10)}   ${widget.comments[0][index]['author']['roles'][0]['name_lat']}  ${widget.comments[0][index]['author']['first_name']} ${widget.comments[0][index]['author']['last_name'].substring(0,1)}.', style: st2,),
                                              ),
                                            ])
                                    );
                                  }
                              ) : Container(),
                            ])
                    ) : Container();
                  }
              ),
              SizedBox(height: 100,)
            ]),
      ):Container(),
    );
  }
}



