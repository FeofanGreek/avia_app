import 'dart:convert';
import 'dart:ui';
import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/vocabulary/vocabulary.dart';
import 'package:avia_app/widgets/dialoScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';

bool _listRegionsReady = false;
List selectedPoints = [];
List <TextEditingController> _routesTimeOut = [];
TextEditingController _routesTimeOutMajor;


var regionsBackUp;
int lastChairCount = 0,count = 0;

class pointSelectPage extends StatefulWidget {
  final int routNum;
  final int pointNum;
  pointSelectPage({Key key, @required this.routNum, this.pointNum}) : super(key: key);
  @override
  _RegionSelectPageState createState() => _RegionSelectPageState(this.routNum, this.pointNum);

}

class _RegionSelectPageState extends State<pointSelectPage> {

  int routNum, pointNum;

  _RegionSelectPageState(this.routNum, this.pointNum);

  var _controllerSearchRegion = TextEditingController();
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });

  _points() async{
    //if(pointsVocabulary.length == 0) {
      /*try {
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
        String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Points';
        HttpClientRequest request = await client.getUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('Mobile', 'true');
        HttpClientResponse response = await request.close();
        String reply = await response.transform(utf8.decoder).join();
        pointsVocabulary = json.decode(reply);
        regionsBackUp = json.decode(reply);
      } catch (e) {
        print("точки пересечения ошибка" + e);
      }*/
      String data = await rootBundle.loadString('vocabular/pointsNew.json');
      pointsVocabulary = json.decode(data);
      regionsBackUp = json.decode(data);
      _listRegionsReady = true;
    //}
    setState(() {});
  }

  addPointsList(){
    pointNum != null ? routeList[routNum]['points'][pointNum]=[]: null;
//добавили главную точку
    pointNum == null ? routeList[routNum]['points'].add({
      "name": "${selectedPoints[0]['name']}",//уточнить что это
      "is_found_point": selectedPoints[0]['is_found_point'],
      "is_coordinates": selectedPoints[0]['is_coordinates'],
      "departure_time_error": 0, //как то посчитать !!!!!!!!!!!!!!
      "landing_time_error": 0, //как то посчитать !!!!!!!!!!!!!
      "POINTS_ID": selectedPoints[0]['POINTS_ID'],
      "ISGATEWAY": selectedPoints[0]['ISGATEWAY'],
      "ISINOUT": selectedPoints[0]['ISINOUT'],
      "icao": "${selectedPoints[0]['is_found_point'] == 1 ? selectedPoints[0]['name'] : ''}",
      "time": "${selectedPoints[0]['time'].replaceAll(':','')}",
      "coordinates": "${selectedPoints[0]['is_coordinates'] == 1 ? selectedPoints[0]['coordinates'] : ''}",
      "alt_points": []
    }) : routeList[routNum]['points'][pointNum]= {
      "name": "${selectedPoints[0]['name']}",//уточнить что это
      "is_found_point": selectedPoints[0]['is_found_point'],
      "is_coordinates": selectedPoints[0]['is_coordinates'],
      "departure_time_error": 0, //как то посчитать !!!!!!!!!!!!!!
      "landing_time_error": 0, //как то посчитать !!!!!!!!!!!!!
      "POINTS_ID": selectedPoints[0]['POINTS_ID'],
      "ISGATEWAY": selectedPoints[0]['ISGATEWAY'],
      "ISINOUT": selectedPoints[0]['ISINOUT'],
      "icao": "${selectedPoints[0]['is_found_point'] == 1 ? selectedPoints[0]['name'] : ''}",
      "time": "${selectedPoints[0]['time'].replaceAll(':','')}",
      "coordinates": "${selectedPoints[0]['is_coordinates'] == 1 ? selectedPoints[0]['coordinates'] : ''}",
      "alt_points": []
    };
//добавляем альтернативные
  for(int i = 0; i < selectedPoints[0]['alt_points'].length; i++){
    routeList[routNum]['points'][pointNum != null ? pointNum : routeList[routNum]['points'].length-1]['alt_points'].add(
        {
          "POINTS_ID": selectedPoints[0]['alt_points'][i]['POINTS_ID'],
          "icao": "${selectedPoints[0]['alt_points'][i]['is_found_point'] == 1 ? selectedPoints[0]['alt_points'][i]['name'] : ''}",
          "name": "${selectedPoints[0]['alt_points'][i]['is_found_point'] == 1 ? selectedPoints[0]['alt_points'][i]['name'] : selectedPoints[0]['alt_points'][i]['coordinates']}",
          "is_found_point": selectedPoints[0]['alt_points'][i]['is_found_point'],
          "is_coordinates": selectedPoints[0]['alt_points'][i]['is_coordinates'],
          "ISINOUT": selectedPoints[0]['alt_points'][i]['ISINOUT'],
          "ISGATEWAY": selectedPoints[0]['alt_points'][i]['ISGATEWAY'],
          "coordinates": "${selectedPoints[0]['alt_points'][i]['is_coordinates'] == 1 ? selectedPoints[0]['alt_points'][i]['coordinates'] : ''}"
           });
    }
  print(routeList[routNum]['points']);
    _routesTimeOutMajor.clear();
  }

  parseField(String value){
    bool toFreeString = true;
    //превратить строку в массив
    List result = value.split(' ');
    for(int i = 0; i < result.length; i++) {
      //понять что это точка
      if(result[i].length <= 5) {
        print('point');
        //найти точку в списке и добавить в массив точек
        for(int ii = 0; ii < pointsVocabulary.length; ii++){
          if (pointsVocabulary[ii]['pnthist'] != null) {
            if (pointsVocabulary[ii]['pnthist']['ICAOLAT6']
                .toLowerCase()
                .startsWith(result[i].toLowerCase())) {
              setState(() {
                if (selectedPoints.length == 0) {
                  selectedPoints.add({
                    "name": "${pointsVocabulary[ii]['pnthist']['ICAOLAT6']}",
                    "is_found_point": 1, // если найденая точка
                    "is_coordinates": 0, //если координаты
                    "departure_time_error": 0, //как то посчитать
                    "landing_time_error": 0, //как то посчитать
                    "time": "00:00",
                    "coordinates": "",
                    "POINTS_ID": pointsVocabulary[ii]['pnthist']['POINTS_ID'],
                    "ISGATEWAY": pointsVocabulary[ii]['ISGATEWAY'],
                    "ISINOUT": pointsVocabulary[ii]['ISINOUT'],
                    "pnthist": pointsVocabulary[ii]['pnthist'],
                    "alt_points": []
                  });
                } else {
                  selectedPoints[selectedPoints.length > 0 ? selectedPoints
                      .length - 1 : 0]['alt_points'].add({
                    "name": "${pointsVocabulary[ii]['pnthist']['ICAOLAT6']}",
                    "is_found_point": 1,
                    "is_coordinates": 0,
                    "time": "00:00",
                    "coordinates": "",
                    "POINTS_ID": pointsVocabulary[ii]['pnthist']['POINTS_ID'],
                    "ISGATEWAY": pointsVocabulary[ii]['ISGATEWAY'],
                    "ISINOUT": pointsVocabulary[ii]['ISINOUT']
                  });
                }
              });
            }
          }
        }
      }//понять что это координата
      else if(result[i].contains(new RegExp(r'[0-9]'))){
        print('coordinates');
        setState(() {
          if (selectedPoints.length == 0) {
            selectedPoints.add({
              "name": "${result[i].toUpperCase()}",
              "is_found_point": 0, // если найденая точка
              "is_coordinates": 1, //если координаты
              "departure_time_error": 0, //как то посчитать
              "landing_time_error": 0, //как то посчитать
              "time": "00:00",
              "POINTS_ID": 0,
              "ISGATEWAY": 0,
              "ISINOUT":0,
              "coordinates": "${result[i].toUpperCase()}",
              "alt_points": []
            });
          } else {
            selectedPoints[selectedPoints.length > 0 ? selectedPoints.length-1 : 0]['alt_points'].add({
              "name": "${result[i].toUpperCase()}",
              "is_found_point": 0,
              "is_coordinates": 1,
              "coordinates": "${result[i].toUpperCase()}",
              "time": "00:00",
              "POINTS_ID": 0,
              "ISGATEWAY": 0,
              "ISINOUT":0,
              "pnthist": []
            });
          }
        });

      }
      //понять что это белеберда
      else {
        //print('beleberda ${result[i].toUpperCase()}');
        setState(() {
          if (selectedPoints.length == 0) {
            selectedPoints.add({
              "name": "${result[i].toUpperCase()}",
              "is_found_point": 0, // если найденая точка
              "is_coordinates": 0, //если координаты
              "departure_time_error": 0, //как то посчитать
              "landing_time_error": 0, //как то посчитать
              "time": "00:00",
              "POINTS_ID": 0,
              "ISGATEWAY": 0,
              "ISINOUT":0,
              "coordinates": "",
              "alt_points": []
            });
          } else {
            selectedPoints[selectedPoints.length > 0 ? selectedPoints.length-1 : 0]['alt_points'].add({
              "name": "${result[i].toUpperCase()}",
              "is_found_point": 0,
              "is_coordinates": 0,
              "coordinates": "",
              "time": "00:00",
              "POINTS_ID": 0,
              "ISGATEWAY": 0,
              "ISINOUT":0,
              "pnthist": []
            });
          }
        });
        //print(selectedPoints);
      }
    }
    //_controllerSearchRegion.clear();
  }

  @override
  void initState() {
    super.initState();
    _points();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
        title: Container(
            width:MediaQuery.of(context).size.width ,
            child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/fomaN');
                    },
                    child:Container(
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child:  Row(
                          children: <Widget>[
                            Icon(CupertinoIcons.chevron_left, color: kYellow, size: 20,),
                            Text(vocabular['form_n']['route_obj']['cancel'],style: st10,),
                          ]),
                    ),
                  ),

                ])
        ),),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child:Center(
          child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: kWhite1),
                      ),
                      child: selectedPoints.length > 0 ? Row( children: [
                        //Text('${selectedPoints.length > 0 ? selectedPoints[pointNum == null  ? 0 : pointNum]['name'] : ''}${selectedPoints.length > 0 ? selectedPoints[pointNum == null  ? 0 : pointNum]['coordinates'] : ''}'),
                        Text('${selectedPoints.length > 0 ? selectedPoints[0]['name'] : ''}'),

                        Spacer(),
                        Container(
                          width: 120,
                          height: 50,
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite1),
                          ),
                          child: TextFormField(
                            enabled: true,
                            showCursor: false,
                            readOnly: true,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                hintText: vocabular['myPhrases']['timeOut'],
                                hintStyle: st8,
                                contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        onChanged: (date) {}, onConfirm: (date) {
                                          String minuteBolb = '';
                                          String hourBolb = '';
                                          if(date.minute < 10){minuteBolb = '0';}
                                          if(date.hour < 10){hourBolb = '0';}
                                          _routesTimeOutMajor = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                          selectedPoints[0]['time'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                          setState(() {});
                                        }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                  icon: Icon(Icons.access_time, size: 16),)
                            ),
                            onChanged: (value){
                              setState(() {
                                selectedPoints[0]['time'] = value;
                              });
                            },
                            controller: _routesTimeOutMajor,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            selectedPoints.removeAt(0);
                            setState(() {});
                            },
                          child:Container(
                            padding: EdgeInsets.fromLTRB(17,17,17,17),
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: kWhite3),
                              color: kBlue,
                            ),
                            child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                          ),
                        ),
                      ]): Container()
                    ),
                    Positioned(
                        left: 22,
                        top: 10,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: 0, left: 10, right: 10),
                          color: kBlue,
                          child: Text(vocabular['myPhrases']['majorPoint'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 150,
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: kWhite1),
                        ),
                        //child: selectedPoints.length > 0 && selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'] != null ? ListView.builder(
                          child: selectedPoints.length > 0 && selectedPoints[0]['alt_points'] != null ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              //itemCount: selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'].length,
                              itemCount: selectedPoints[0]['alt_points'].length,
                              itemBuilder: (BuildContext context, int index2) {
                                _routesTimeOut.add(TextEditingController());
                              return Row( children: [ //"status":"major"
                                //Text('${selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'][index2]['name']}${selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'][index2]['coordinates']}'),
                                Text('${selectedPoints[0]['alt_points'][index2]['name']}'),

                                Spacer(),
                                /*Container(
                                  width: 120,
                                  height: 50,
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite1),
                                  ),
                                  child: TextFormField(
                                          enabled: true,
                                          showCursor: false,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none
                                              ),
                                              hintText: vocabular['myPhrases']['timeOut'],
                                              hintStyle: st8,
                                              contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  DatePicker.showTimePicker(context,
                                                      showTitleActions: true,
                                                      onChanged: (date) {}, onConfirm: (date) {
                                                        String minuteBolb = '';
                                                        String hourBolb = '';
                                                        if(date.minute < 10){minuteBolb = '0';}
                                                        if(date.hour < 10){hourBolb = '0';}
                                                        _routesTimeOut[index2] = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                       //selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'][index2]['time'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                        selectedPoints[0]['alt_points'][index2]['time'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                        setState(() {});
                                                      }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                icon: Icon(Icons.access_time, size: 16),)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              //selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'][index2]['time'] = value;
                                              selectedPoints[0]['alt_points'][index2]['time'] = value;
                                            });
                                          },
                                          controller: _routesTimeOut[index2],
                                        ),
                                      ),*/

                                GestureDetector(
                                  onTap: (){
                                    //selectedPoints[pointNum == null  ? 0 : pointNum]['alt_points'].removeAt(index2);
                                    selectedPoints[0]['alt_points'].removeAt(index2);
                                    setState(() {});
                                    },
                                  child:Container(
                                    padding: EdgeInsets.fromLTRB(18,18,18,18),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: kWhite3),
                                      color: kBlue,
                                    ),
                                    child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                  ),
                                ),
                              ]);}) : Container(),
                      ),
                    Positioned(
                        left: 22,
                        top: 10,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: 0, left: 10, right: 10),
                          color: kBlue,
                          child: Text(vocabular['myPhrases']['reservPoints'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )),
                  ],
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.fromLTRB(10,0,10,20),
                  child: TextButton(
                    onPressed:(){
                      //routes[routNum]['inOutPoints'].add(selectedPoints[pointNum == null  ? 0 : pointNum]);
                       selectedPoints.length > 0 ? selectedPoints[0]['time'] != '00:00' ? addPointsList() : dialogScreen(context, 'Не заполнено время перехода точки') : null;
                       selectedPoints.length > 0 ? setState(() {}) : null;
                       selectedPoints.length > 0 && selectedPoints[0]['time'] != '00:00' ? Navigator.pushNamed(context, '/fomaN') : selectedPoints.length > 0 ? null : dialogScreen(context, 'Укажите хотя бы одну точку');
                    } ,
                    child: Text(vocabular['myPhrases']['apply'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                    style: ElevatedButton.styleFrom(
                      primary: kYellow,
                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: kWhite1),
                      ),
                      child: TextFormField(
                        style: st1,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          hintText: vocabular['myPhrases']['pointCode'],
                          hintStyle: st8,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10.0),
                          prefixIcon: Icon(Icons.search, color: kWhite, size: 18,),
                          suffixIcon:!_controllerSearchRegion.text.contains(new RegExp(r'[0-9]')) && !_controllerSearchRegion.text.contains(' ') && _controllerSearchRegion.text.length < 5 ? IconButton(
                            onPressed: () {
                              _controllerSearchRegion.clear();
                              pointsVocabulary = regionsBackUp;
                              setState(() {});
                              },
                            icon: Icon(Icons.clear, color: kWhite, size: 18,),
                          ) : IconButton(
                            onPressed: () {
                              _controllerSearchRegion.text.contains(new RegExp(r'[0-9]')) && !_controllerSearchRegion.text.contains(' ') ?
                              setState(() {
                                if (selectedPoints.length == 0) {
                                  selectedPoints.add({
                                    "name": "${_controllerSearchRegion.text.toUpperCase()}",
                                    "is_found_point": 0, // если найденая точка
                                    "is_coordinates": 1, //если координаты
                                    "departure_time_error": 0, //как то посчитать
                                    "landing_time_error": 0, //как то посчитать
                                    "time": "00:00",
                                    "POINTS_ID": 0,
                                    "ISGATEWAY": 0,
                                    "ISINOUT":0,
                                    "coordinates": "${_controllerSearchRegion.text.toUpperCase()}",
                                    "alt_points": []
                                  });
                                } else {
                                  selectedPoints[selectedPoints.length > 0 ? selectedPoints.length-1 : 0]['alt_points'].add({
                                    "name": "${_controllerSearchRegion.text.toUpperCase()}",
                                    "is_found_point": 0,
                                    "is_coordinates": 1,
                                    "coordinates": "${_controllerSearchRegion.text.toUpperCase()}",
                                    "time": "00:00",
                                    "POINTS_ID": 0,
                                    "ISGATEWAY": 0,
                                    "ISINOUT":0,
                                    "pnthist": []
                                  });
                                }

                              }) : parseField(_controllerSearchRegion.text);
                              _controllerSearchRegion.clear();
                            },
                            icon: Icon(Icons.done, color: Colors.green, size: 18,),
                          ),
                        ),
                        onChanged: (value){
                          List tempList = [];
                              if(value.length > 3 && !value.toLowerCase()
                                  .contains((new RegExp(r'[0-9]')))) {
                                pointsVocabulary = regionsBackUp;
                                for (int i = 0; i < pointsVocabulary.length; i++) {
                                  if (pointsVocabulary[i]['pnthist'] != null) {
                                    if (pointsVocabulary[i]['pnthist']['ICAOLAT6'] != null) {
                                      if (pointsVocabulary[i]['pnthist']['ICAOLAT6']
                                          .toLowerCase()
                                          .startsWith(value.toLowerCase())) {
                                        tempList.add(pointsVocabulary[i]);
                                      }
                                    }
                                  }
                                }
                                var distinctIds = tempList.toSet().toList();
                                pointsVocabulary = distinctIds;
                                setState(() {});
                              }else{
                                setState(() {});
                                //тут нам надо что то сделать с введенными в строку точками???
                                //tempList.add('{"POINTS_ID":0,"ISGATEWAY":0,"pnthist":{"POINTS_ID":0,"PNTHIST_ID":0,"ICAOLAT5":"${value.toLowerCase()}","ICAOLAT6":"${value.toLowerCase()}"}}');
                              }
                        },
                        autovalidateMode: AutovalidateMode.always,
                        controller: _controllerSearchRegion,
                      ),
                    ),
                    _controllerSearchRegion.text.length > 0 ? Positioned(
                        left: 22,
                        top: 10,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: 0, left: 10, right: 10),
                          color: kBlue,
                          child: Text(vocabular['myPhrases']['pointCode'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )) : Container(),
                  ],
                ),
                _listRegionsReady == true ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pointsVocabulary.length < 300 ? pointsVocabulary.length : 300,
                    itemBuilder: (BuildContext context, int index) {
                      pointsVocabulary[index]['pnthist']['ICAOLAT6'] != null ? count++ : null;
                      return pointsVocabulary[index]['pnthist']['ICAOLAT6'] != null ? GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedPoints.length == 0) {
                                selectedPoints.add({
                                  "name": "${pointsVocabulary[index]['pnthist']['ICAOLAT6']}",
                                  "is_found_point": 1, // если найденая точка
                                  "is_coordinates": 0, //если координаты
                                  "departure_time_error": 0, //как то посчитать
                                  "landing_time_error": 0, //как то посчитать
                                  "time": "00:00",
                                  "coordinates": "",
                                  "POINTS_ID": pointsVocabulary[index]['pnthist']['POINTS_ID'],
                                  "ISGATEWAY": pointsVocabulary[index]['ISGATEWAY'],
                                  "ISINOUT":pointsVocabulary[index]['ISINOUT'],
                                  "pnthist": pointsVocabulary[index]['pnthist'],
                                  "alt_points": []
                                });
                              } else {
                                  selectedPoints[selectedPoints.length > 0 ? selectedPoints.length-1 : 0]['alt_points'].add({
                                    "name": "${pointsVocabulary[index]['pnthist']['ICAOLAT6']}",
                                    "is_found_point": 1,
                                    "is_coordinates": 0,
                                    "time": "00:00",
                                    "coordinates": "",
                                    "POINTS_ID": pointsVocabulary[index]['pnthist']['POINTS_ID'],
                                    "ISGATEWAY": pointsVocabulary[index]['ISGATEWAY'],
                                    "ISINOUT": pointsVocabulary[index]['ISINOUT']
                                  });
                              }

                            });
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              padding: EdgeInsets.fromLTRB(10,5,5,5),
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: count%2==0?kBlueLight:kBlue,),
                              alignment: Alignment.centerLeft,
                              child: Text('${pointsVocabulary[index]['pnthist']['ICAOLAT6']}',style: st17,textAlign: TextAlign.left,)),

                      ) : Container();
                    }): Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()]),
              ]
          ),
        ),
      ),
    );
  }

}


