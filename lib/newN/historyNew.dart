import 'dart:convert';
import 'dart:io';

import 'package:avia_app/FormaN/formaNFromReestrNew.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_7.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';

bool _loadReady = false;
var _historyBody;
var _vocabular;


List switcher = [];

class historyPageNew extends StatefulWidget {
  final int id_pakus;
  final String permit_num;
  final String flight_num;
  final String main_date;
  final String departure_airport_icao;
  final String landing_airport_icao;
  final String landing_time;

  historyPageNew({
    this.id_pakus,
    this.permit_num,
    this.flight_num,
    this.main_date,
    this.departure_airport_icao,
    this.landing_airport_icao,
    this.landing_time
  });

  @override
  _history createState() => _history();
}

class _history extends State<historyPageNew> {

  //подгрузили словари из файла
  void loadJsonLanguage() async {
    if (language == 'ru') {
      String data = await rootBundle.loadString('vocNew/ru.json');
      _vocabular = json.decode(data);
    } else {
      String data = await rootBundle.loadString('vocNew/en.json');
      _vocabular = json.decode(data);
    }
  }

//получаем данные истории
  @override
  getFormNData() async{
    print('Берем данные формы');
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/getNFormHistory/${widget.id_pakus}';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      _historyBody = json.decode(reply); // форма с сервера
      _loadReady = true;
      setState(() {});
    }catch(e){
      print('ошибка тут 3$e');
    }
  }


  @override
  void initState() {
    loadJsonLanguage();
    getFormNData();
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
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
            child:Text(_vocabular['registry']['user_profile']['back'], style: st12,),),
          ),
          title: Column(
              children:[
                Container(
                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                  alignment: Alignment.center,
                  child:Text(widget.permit_num, style: st4,),
                ),
              ]
          ),
          actions:[
            Container(
              margin: EdgeInsets.fromLTRB(0,0,10,0),
              alignment: Alignment.center,
              child:Text(_vocabular['forms']['process'], style: st12,),
            ),
          ],
        ):AppBar( automaticallyImplyLeading: false,
            centerTitle: true,
            brightness: Brightness.light,
            elevation: 0,
            backgroundColor: kBlue,
            leading:CircularProgressIndicator()),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
            children: [
              Container(
                width:MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(20,20,20,20),
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2 -20,
                            height: 31,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color:kWhite2 ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14.0),
                                  bottomLeft: Radius.circular(14.0)),
                              color:kBlue ,
                            ),
                            child: Text(_vocabular['forms']['form'], style: st17,textAlign: TextAlign.center,)
                        ),
                      ),
                      GestureDetector(onTap: (){}, child:Container(
                          width: MediaQuery.of(context).size.width / 2 -20,
                          height: 31,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color:kYellow ),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(14.0),
                                bottomRight: Radius.circular(14.0)),
                            color:kYellow ,
                          ),
                          child: Text(_vocabular['history'], style: st17,textAlign: TextAlign.center,)
                      ),
                      ),
                    ]),
              ),
            _loadReady == true && _historyBody['nForm']['histories'].length > 0 ? Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child:ListView.builder(
                    padding: EdgeInsets.only(left: 8),
                    //scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _historyBody.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(onTap: () {
                          }, child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              SizedBox(height: 10,),
                              Row(
                                children:[
                              Text(
                                '${_historyBody['nForm']['histories'][index]['updated_at'].substring(0,10)}',
                                style: st6,
                              ),
                                  Spacer(),
                                  Text(
                                    '${language == 'ru' ? _historyBody['nForm']['histories'][index]['status']['name_rus'] : _historyBody['nForm']['histories'][index]['status']['name_lat']}',
                                    style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss',color: _historyBody['nForm']['histories'][index]['status']['id'] == 1 ? Color(0xFFFF5A43) : _historyBody['nForm']['histories'][index]['status']['id'] == 2 ? Color(0xFF00FF2C) : _historyBody['nForm']['histories'][index]['status']['id'] == 3 ? Color(0xFFCF9400) : _historyBody['nForm']['histories'][index]['status']['id'] == 13 ? Color(0xFF337AD9) : kWhite),
                                  )
                              ]),
                              SizedBox(height: 5,),
                              Row(
                                children:[
                                  //Spacer(),
                                  //SizedBox(width: 10,),
                                  Expanded( child:Text(
                                    '${widget.flight_num} - ${widget.main_date}',
                                    style: TextStyle(fontSize: 16,fontFamily: 'AlS Hauss',),
                                  )),
                                  SizedBox(width: 10,),
                                  //,
                                ]
                              ),
                              SizedBox(height: 5,),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: [
                                        Expanded( child:Text(
                                          '${widget.departure_airport_icao.substring(0, widget.departure_airport_icao.length > 4 ? 4 : widget.departure_airport_icao.length)} → ${widget.landing_airport_icao.substring(0,widget.landing_airport_icao.length > 4 ? 4 : widget.landing_airport_icao.length)} ${widget.landing_time.substring(0,5)}',
                                          style: st14, textAlign: TextAlign.left,
                                        )),
                                      ])),
                              SizedBox(height: 5,),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: [
                                        Text(
                                          '${language == 'ru' ? _historyBody['nForm']['histories'][index]['role']['name_rus'] : _historyBody['nForm']['histories'][index]['role']['name_lat']} ${_historyBody['nForm']['histories'][index]['role']['name_lat']}',
                                          style: st14,
                                        ),
                                      ])),
                              /*historyList[index]['historyBody'].length > 0 ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children:[
                                    Image.asset(
                                        'icons/triangle_red.png', width: 16,
                                        height: 16,
                                        fit: BoxFit.fitHeight),
                                    SizedBox(width: 5,),
                                    Text('${historyList[index]['historyBody'].length} примечани${historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '1' ? 'е' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '2' ? 'я' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '3' ? 'я' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '4' ? 'я' : 'й'}', style:st15),
                                    Spacer(),
                                    Icon(CupertinoIcons.chevron_right, size: 15, color: kWhite3,)
                                      ]): Container(),*/
                              SizedBox(height: 5,),
                              Divider(height: 2,thickness: 2,color: kWhite1,),
                              /*Container(
                                child:ListView.builder(
                                    padding: EdgeInsets.only(left: 8),
                                    //scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: historyList[index]['historyBody'].length,
                                    itemBuilder: (context, index2) {
                                        return switcher[index] == true ? Container( margin: EdgeInsets.fromLTRB(20,0,0,0),child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              SizedBox(height: 10,),
                                                    Text(
                                                      '${historyList[index]['historyBody'][index2]['header']}',
                                                      style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: historyList[index]['historyBody'][index2]['type'] == 'Ошибка' ? Color(0xFFEB5757) : historyList[index]['historyBody'][index2]['type'] == 'Примечание' ? Color(0xFF337AD9) : kWhite), textAlign: TextAlign.left,
                                                    ),
                                                    Row(
                                                      children: [
                                                         Text(
                                                            '${historyList[index]['historyBody'][index2]['partOfForm']}',
                                                            style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite2), textAlign: TextAlign.left,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  '${historyList[index]['historyBody'][index2]['status']}',
                                                                  style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss',color: Color(0xFFCF9400)),
                                                                ),
                                                              Text(
                                                                historyList[index]['historyBody'][index2]['autor'],
                                                                style: st17, textAlign: TextAlign.left,
                                                              ),
                                                          ]),
                                                    ]),
                                              SizedBox(height: 5,),
                                              Divider(height: 1,thickness: 1,color: kWhite1,),
                                          ])) : Container();}
                                      )),*/
                              //switcher[index] == true ? SizedBox(height: 30,) : Container(),
                                  ]));
                    }
          )
        ):CircularProgressIndicator(),
      ])
      ),
    ));
  }
}