import 'dart:convert';
import 'dart:ui';
import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/vocabulary/vocabulary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';

bool _listRegionsReady = false;

var regionsBackUp;
int lastChairCount = 0,count = 0;

class airportSelectPage extends StatefulWidget {
  final int routNum;
  final int inOut;

  airportSelectPage({Key key, @required this.routNum, @required this.inOut}) : super(key: key);

  @override
  _RegionSelectPageState createState() => _RegionSelectPageState(this.routNum, this.inOut);

}

class _RegionSelectPageState extends State<airportSelectPage> {
  int routNum;
  int inOut;
  _RegionSelectPageState(this.routNum, this.inOut);


  var _controllerSearchRegion = TextEditingController();

  _airports() async{
    try{
      /*HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Airports';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);*/
      String data = await rootBundle.loadString('vocabular/airport.json');
      airportsVocabulary = json.decode(data);
      regionsBackUp= json.decode(data);
    }catch(e){
      print(e);
    }
    _listRegionsReady = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _airports();
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
                          hintText: vocabular['myPhrases']['hintAeroportName'],
                          hintStyle: st8,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10.0),
                          prefixIcon: Icon(Icons.search, color: kWhite, size: 18,),
                          suffixIcon: !_controllerSearchRegion.text.contains(new RegExp(r'[0-9]')) ? IconButton(
                            onPressed: () { _controllerSearchRegion.clear(); airportsVocabulary = regionsBackUp; setState(() {});},
                            icon: Icon(Icons.clear, color: kWhite, size: 18,),
                          ) : IconButton(
                            onPressed: () { Navigator.pushNamed(context, '/fomaN');},
                            icon: Icon(Icons.done, color: Colors.green, size: 18,),
                          ),
                        ),
                        onChanged: (value){
                          if(value.length > 2 && !value.toLowerCase()
                              .contains((new RegExp(r'[0-9]')))) {
                            airportsVocabulary = regionsBackUp;
                            List tempList = [];
                            for (int i = 0; i <
                                airportsVocabulary.length; i++) {
                              if (airportsVocabulary[i]['NAMELAT'] != null) {
                                if (airportsVocabulary[i]['NAMELAT']
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                                  tempList.add(airportsVocabulary[i]);
                                }
                              }
                              if (airportsVocabulary[i]['NAMERUS'] != null) {
                                if (airportsVocabulary[i]['NAMERUS']
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                                  tempList.add(airportsVocabulary[i]);
                                }
                              }
                              if (airportsVocabulary[i]['aprthist'] != null) {
                                if (airportsVocabulary[i]['aprthist']['ICAOLAT4'] !=
                                    null) {
                                  if (airportsVocabulary[i]['aprthist']['ICAOLAT4']
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) {
                                    tempList.add(airportsVocabulary[i]);
                                  }
                                }
                              }
                            }
                            var distinctIds = tempList.toSet().toList();
                            airportsVocabulary = distinctIds;
                            setState(() {});
                          } else {
                            setState(() {
                              //if(inOut == 1){routes[routNum]['portOut'] = value;}
                              //if(inOut == 2){routes[routNum]['portIn'] = value;}
                              if(inOut == 1){routeList[routNum]['flight_information']['departure_airport_icao'] = value;}
                              if(inOut == 2){routeList[routNum]['flight_information']['landing_airport_icao'] = value;}
                            });
                          }
                          //придумать как ввести координаты
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
                          child: Text(vocabular['myPhrases']['hintAeroportName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )) : Container(),
                  ],
                ),

                _listRegionsReady == true ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: airportsVocabulary.length < 300 ? airportsVocabulary.length : 300,
                    itemBuilder: (BuildContext context, int index) {
                      airportsVocabulary[index]['NAMERUS'] != null ? count++ : null;
                      return airportsVocabulary[index]['NAMERUS'] != null ? GestureDetector(
                          onTap: () {
                            //print('in:$routNum out:$inOut');
                            setState(() {
                             if(airportsVocabulary[index]['aprthist']!= null ){ if(inOut == 1){routeList[routNum]['flight_information']['departure_airport_icao'] = airportsVocabulary[index]['aprthist']['ICAOLAT4'];routeList[routNum]['flight_information']['departure_airport_id'] = airportsVocabulary[index]['aprthist']['AIRPORTS_ID'];routeList[routNum]['flight_information']['departure_airport_namerus'] = airportsVocabulary[index]['NAMERUS'];routeList[routNum]['flight_information']['departure_airport_namelat'] = airportsVocabulary[index]['NAMELAT'];}} else {if(inOut == 1){routeList[routNum]['flight_information']['departure_airport_namerus'] = airportsVocabulary[index]['NAMERUS'];}}
                             if(airportsVocabulary[index]['aprthist']!= null ){ if(inOut == 2){routeList[routNum]['flight_information']['landing_airport_icao'] = airportsVocabulary[index]['aprthist']['ICAOLAT4'];routeList[routNum]['flight_information']['landing_airport_id'] = airportsVocabulary[index]['aprthist']['AIRPORTS_ID'];routeList[routNum]['flight_information']['landing_airport_namerus'] = airportsVocabulary[index]['NAMERUS'];routeList[routNum]['flight_information']['landing_airport_namelat'] = airportsVocabulary[index]['NAMELAT'];}} else {if(inOut == 2){routeList[routNum]['flight_information']['landing_airport_namerus'] = airportsVocabulary[index]['NAMERUS'];}}
                            });
                             Navigator.pushNamed(context, '/fomaN');
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              padding: EdgeInsets.fromLTRB(10,5,5,5),
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: count%2==0?kBlueLight:kBlue,),
                              alignment: Alignment.centerLeft,
                              child: Row( children: [ Expanded( child:Text('${airportsVocabulary[index]['NAMELAT']}',style: st17,textAlign: TextAlign.left,)),Text('${airportsVocabulary[index]['aprthist'] != null ? airportsVocabulary[index]['aprthist']['ICAOLAT4'] != null ? airportsVocabulary[index]['aprthist']['ICAOLAT4'] : '' : ''}',style: st5,textAlign: TextAlign.left,),]))
                      ): airportsVocabulary[index]['NAMELAT'] != null ? GestureDetector(
                          onTap: () {
                            //print('in:$routNum out:$inOut');
                            setState(() {
                              if(inOut == 1){routeList[routNum]['flight_information']['departure_airport_icao'] = airportsVocabulary[index]['aprthist']['ICAOLAT4'];}
                              if(inOut == 2){routeList[routNum]['flight_information']['landing_airport_icao'] = airportsVocabulary[index]['aprthist']['ICAOLAT4'];}
                            });
                            Navigator.pushNamed(context, '/fomaN');
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              padding: EdgeInsets.fromLTRB(10,5,5,5),
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: count%2==0?kBlueLight:kBlue,),
                              alignment: Alignment.centerLeft,
                              child: Row( children: [ Expanded( child:Text('${airportsVocabulary[index]['NAMELAT']}',style: st17,textAlign: TextAlign.left,)),Text('${airportsVocabulary[index]['aprthist'] != null ? airportsVocabulary[index]['aprthist']['ICAOLAT4'] != null ? airportsVocabulary[index]['aprthist']['ICAOLAT4'] : '' : ''}',style: st5,textAlign: TextAlign.left,),]))
                      ) : Container();
                    }): Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()]),
              ]
          ),
        ),
      ),
    );
  }

}


