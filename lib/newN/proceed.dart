import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:avia_app/newN/subscreens/readairline.dart';
import 'package:avia_app/newN/subscreens/readmainaircraft.dart';
import 'package:avia_app/newN/subscreens/readroute.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/widgets/commentDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'historyNew.dart';


var _vocabular;

bool _loadReady = false;
List selectForm = [];
bool selectColumn = false;
List<Map> proceedFunctions = [{'id':1,'title':'Отправить'},{'id':2,'title':'Согласовать'},{'id':3,'title':'Ответить'},{'id':4,'title':'Скорректировать'},{'id':5,'title':'Аннулировать'},{'id':6,'title':'Вернуть'},{'id':7,'title':'Отклонить'},{'id':8,'title':'Утвердить'},{'id':9,'title':'Отклонить'}];
List selectedFunction =[];
String sel = 'Отправить';
bool sendProcess = false;

class proceed extends StatefulWidget {
  final List airlineList;

  proceed({
    this.airlineList,
  });


  @override
  _State createState() => _State();
}

class _State extends State<proceed> {
  final commentKey = new GlobalKey();
  final payerKey = new GlobalKey();
  final aircraftMainKey = new GlobalKey();
  final aircraftReservKey = new GlobalKey();


  //подгрузили словари из файла
  void loadJsonLanguage() async {
    if (language == 'ru') {
      String data = await rootBundle.loadString('vocNew/ru.json');
      _vocabular = json.decode(data);
    } else {
      String data = await rootBundle.loadString('vocNew/en.json');
      _vocabular = json.decode(data);
    }


    for(int i =0; i < proceedFunctions.length; i++){
      selectedFunction.add({'id':1,'title':'Отправить'});
    }
    setState(() {
      _loadReady = true;
    });
  }

sendProceed()async{
    var approval_group_id = 0;

  for(int i = 0; i < rolesUser.length; i++){
    rolesUser[i]['id'] == accessRole ? approval_group_id = rolesUser[i]['approval_group_id'] : null;
  }

  for(int i=0; i<selectForm.length; i++) {
    if(selectForm[i] == true) {
      try {
        //print('первая фаза авторизации');
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
        String url = '${serverURL}api/api/v1/nFormAgreement';
        var map = [{
          "approval_group_id": approval_group_id,
          // Группа согласования
          "role_id": accessRole,
          // роль Назначенной группы (Назнач. перевозчик Грузовых чартеров)
          "n_form_flight_id": widget
              .airlineList[0]['NForm']['flights'][i]['n_form_flight_id'],
          // id Рейса
          "n_form_flight_sign_id": selectedFunction[i]['id'],
          // id Знака согласования
        }];
        HttpClientRequest request = await client.postUrl(Uri.parse(url));
        request.headers.set('content-type', 'application/json');
        request.headers.set('Mobile', 'true');
        request.add(utf8.encode(json.encode(map)));
        HttpClientResponse response = await request.close();
        String reply = await response.transform(utf8.decoder).join();
        print(reply);
        sendProcess = true;
        setState(() {

        });
        Navigator.pop(context);
      }catch(e){}


    }
  }
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
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        }, child:Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          alignment: Alignment.center,
          child:Text(_vocabular['form_n']['route_obj']['cancel'], style: st12,),),
        ),
        title: Column(
            children:[
              /*Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text('${language == 'ru' ? widget.airlineList['NForm']['airline']['airline_namerus'] : widget.airlineList['NForm']['airline']['airline_namelat']}', style: st4,),
              ),*/
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text(_vocabular['forms']['process'], style: st4,),
              ),
            ]
        ),
        actions:[
          GestureDetector(onTap: (){
            setState(() {
              selectColumn = !selectColumn;
            });
          }, child:Container(
            margin: EdgeInsets.fromLTRB(0,0,10,0),
            alignment: Alignment.center,
            child:Text(_vocabular['registry']['status_panel']['select'], style: st12,),
          ),),
        ],
      ):AppBar( automaticallyImplyLeading: false,
          centerTitle: true,
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: kBlue,
          leading:CircularProgressIndicator()),
      body: _loadReady == true ? SingleChildScrollView(
        child: Column(
          children: [

            //список рейсов
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.airlineList[0]['NForm']['flights'].length,
                itemBuilder: (BuildContext context, int index) {
                  selectForm.add(false);
                  //selectedFunction.add({'id':1,'title':'Отправить'});
                  return Row(
                      children: [
                        selectColumn == true ? GestureDetector(onTap: (){
                          setState(() {
                            selectForm[index] = !selectForm[index];
                          });
                        }, child:Container(width:50, height: 20, alignment: Alignment.center, child:Icon(selectForm[index] == true ? Icons.check_box : Icons.check_box_outline_blank, color: kYellow,)))
                        : Container(),
                      GestureDetector(
                      onTap:(){},
                      child:Container(
                          width: MediaQuery.of(context).size.width - (selectColumn == true ? 70 : 20),
                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          color: kBlueLight,
                          child:Column(
                              children:[
                                Row(
                                    children:[
                                      Image.asset(
                                          'icons/plane_grey.png', width: 16,
                                          height: 16,
                                          fit: BoxFit.fitHeight),
                                      SizedBox(width: 10,),
                                      Text('${widget.airlineList[0]['NForm']['flights'][index]['flight_information']['departure_airport_icao']} → ${widget.airlineList[0]['NForm']['flights'][index]['flight_information']['landing_airport_icao']}', style: st11,)
                                      //


                                    ]),
                                SizedBox(height:10),
                                Row(
                                    children:[
                                      Expanded( child:Text('${widget.airlineList[0]['NForm']['flights'][index]['flight_information']['flight_num']} / ${widget.airlineList[0]['NForm']['flights'][index]['main_date']['date']} ${widget.airlineList[0]['NForm']['flights'][index]['flight_information']['departure_time']}  →  ${widget.airlineList[0]['NForm']['flights'][index]['main_date']['landing_date']} ${widget.airlineList[0]['NForm']['flights'][index]['flight_information']['landing_time']}', style: st8,),),
                                     ]),
                                SizedBox(height:10),

                                Row(
                                    children:[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10,0,10,0),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 0.5, color: kWhite3),
                                            borderRadius: BorderRadius.all(Radius.circular(12.5)),
                                            //color: kYellow,
                                          ),
                                          child: Text('${language == 'ru' ? widget.airlineList[0]['NForm']['flights'][index]['status']['name_rus'] : widget.airlineList[0]['NForm']['flights'][index]['status']['name_lat']}', style: TextStyle(fontSize: 14.0,fontFamily: 'AlS Hauss', color:  statusColor(widget.airlineList[0]['NForm']['flights'][index]['status']['id']),),textAlign: TextAlign.center,)
                                      ),
                                      SizedBox(width: 10,),
                                     Container(
                                        margin: const EdgeInsets.fromLTRB(0,0,20,0),
                                        alignment: Alignment.center,
                                        child: DropdownButtonHideUnderline(
                                            child:DropdownButton<String>(
                                              iconSize: 0.0,
                                              isExpanded: false,
                                              isDense: true,
                                              value: selectedFunction[index]['id'].toString(),
                                              onChanged: (newValue) {
                                                //print(rolesUser);
                                                setState(() {
                                                  selectedFunction[index]['id'] = int.parse(newValue);
                                                });
                                              },
                                              items: proceedFunctions.map((Map map) {
                                                return DropdownMenuItem<String>(
                                                  value: map['id'].toString(),
                                                  child: Text(map['title']),
                                                );
                                              }).toList(),
                                            )),
                                      ),
                                    ])
                              ])

                      ) )
                  ]);
                }
            ),
            SizedBox(height: 10,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(10,10,10,0),
              child: TextButton(
                onPressed:(){
                  setState(() {
                    sendProcess = true;
                  });
                  sendProceed();} ,
                child: sendProcess == false ? Text(_vocabular['form_n']['flight_information_obj']['send'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,) : CircularProgressIndicator(),
                style: ElevatedButton.styleFrom(
                  primary: kYellow,
                  minimumSize: Size(MediaQuery.of(context).size.width, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ):CircularProgressIndicator(),
    );
  }
}



