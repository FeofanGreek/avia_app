import 'dart:convert';
import 'dart:io';
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

class reservFleetSelectPage extends StatefulWidget {
  @override
  _RegionSelectPageState createState() => _RegionSelectPageState();

}

class _RegionSelectPageState extends State<reservFleetSelectPage> {
  var _controllerSearchRegion = TextEditingController();

  _fleet() async{
    regionsBackUp = [];
    try{
      String url = '${serverURL}GetDirectory?name=Fleet';
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      if(airlineId == null) {
        String data = await rootBundle.loadString('vocabular/fleet.json');
        fleetVocabulary = json.decode(data);
        regionsBackUp = json.decode(data);} else
      {
        print('ищем самолеты по номеру $airlineId');
        String data = await rootBundle.loadString('vocabular/fleet.json');
        fleetVocabulary = json.decode(data);
        List tempList = [];
        for(int i = 0; i < fleetVocabulary.length; i++){
          //if(fleetVocabulary[i]['airlflt'] != null){
          if(fleetVocabulary[i]['airlflt']['AIRLINES_ID'] == int.parse(airlineId)) {
            //print('нашли Самолет по номеру');
            tempList.add(fleetVocabulary[i]);
          } else {}
          //}
        }
        var distinctIds = tempList.toSet().toList();
        fleetVocabulary = distinctIds;
        regionsBackUp = distinctIds;
      /*  url = '${serverURL}GetDirectory?name=Fleet&AIRLINES_ID=$airlineId';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      fleetVocabulary = json.decode(reply);
      regionsBackUp = json.decode(reply);*/
      }
      setState(() {
        _listRegionsReady = true;
      });
    }catch(e){
      print(e);
    }
  }

  _currentFleet(int currentFleetID) async{
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=FleetFull&FLEET_ID=$currentFleetID';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);
      currentFleetInfo = json.decode(reply);
      reservFleets.add(json.decode(reply));
      //print(reservFleets);
      //reservFleets.last.add(json.decode(reply));
    }catch(e){
      print(e);
    }
    reservFleetsListing = true;
    setState(() {});
    Navigator.pushNamed(context, '/fomaN');
  }

  _currentFleet2(int currentFleetID) async{
    try{
      String data = await rootBundle.loadString('vocabular/fleetFull.json');
      currentFleetInfo = json.decode(data);
      for(int i = 0; i < currentFleetInfo.length; i++){
        if(currentFleetInfo[i]['FLEET_ID'] == currentFleetID){
          //print(currentFleetInfo[i]);
          //reservFleets.add(currentFleetInfo[i]);
          fleetsList.add({"is_main": 0,"FLEET_ID": currentFleetInfo[i]['FLEET_ID'],
            "regno": "${currentFleetInfo[i]['REGNO']}",
            "type_model": "${currentFleetInfo[i]['aircraft']!= null ? currentFleetInfo[i]['aircraft']['TYPE'] : 'Не заполнено'}",
            "parameters": {
              "max_takeoff_weight": currentFleetInfo[i]['acftmod']!= null ? currentFleetInfo[i]['acftmod']['MAXIMUMWEIGHT'] : 0,
              "max_landing_weight": currentFleetInfo[i]['acftmod']!= null ?currentFleetInfo[i]['acftmod']['MAXLANDINGWEIGHT'] : 0,
              "empty_equip_weight": currentFleetInfo[i]['acftmod']!= null ?currentFleetInfo[i]['acftmod']['WEIGHTEMPTYPLAN'] : 0
            },
            "documents": [],
            "aircraft_owner": {
              "name": "",
              "full_address": "",
              "contact": "",
              "STATES_ID": 0,
              "state": {
                "STATES_ID": 0,
                "state_namelat": "",
                "state_namerus": "",
              },
              "documents": [],
            },
          });
        }
      }
      reservFleetsListing = true;
      setState(() {});
      Navigator.pushNamed(context, '/fomaN');
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fleet();
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
                          hintText: vocabular['myPhrases']['regNumPlane'],
                          hintStyle: st8,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10.0),
                          prefixIcon: Icon(Icons.search, color: kWhite, size: 18,),
                          suffixIcon: IconButton(
                            onPressed: () { _controllerSearchRegion.clear(); fleetVocabulary = regionsBackUp; setState(() {

                            });},
                            icon: Icon(Icons.clear, color: kWhite, size: 18,),
                          ),
                        ),
                        onChanged: (value){
                          fleetVocabulary = regionsBackUp;
                          List tempList = [];
                          for(int i = 0; i < fleetVocabulary.length; i++){
                            //{"FLEET_ID":52609,"REGNO":"28980","REGISTRNO":null,"MODEL":"\u0412\u0432\u0435\u0434\u0435\u043d\u043e 11.11.2010\u0433.","MAXIMUMWEIGHT":13000,"airlflt":{"AIRLFLT_ID":226254,"FLEET_ID":52609,"AIRLINES_ID":15}},

                            if(fleetVocabulary[i]['REGNO'] != null){ if(fleetVocabulary[i]['REGNO'].toLowerCase().contains(value.toLowerCase())) {
                              // print('нашли Самолет по номеру');
                              tempList.add(fleetVocabulary[i]);
                            }}
                            if(fleetVocabulary[i]['MODEL'] != null){ if(fleetVocabulary[i]['MODEL'].toLowerCase().contains(value.toLowerCase())) {
                              //print('нашли Самолет по модели');
                              tempList.add(fleetVocabulary[i]);
                            }}

                          }
                          var distinctIds = tempList.toSet().toList();
                          fleetVocabulary = distinctIds;
                          setState(() {});
                          // print(parsedJsonRegionList);
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
                          child: Text(vocabular['myPhrases']['regNumPlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )) : Container(),
                  ],
                ),


                _listRegionsReady == true ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fleetVocabulary.length < 300 ? fleetVocabulary.length : 300,
                    itemBuilder: (BuildContext context, int index) {
                      fleetVocabulary[index]['REGNO'] != null ? count++ : null;
                      return fleetVocabulary[index]['REGNO'] != null ? GestureDetector(
                          onTap: () {
                            setState(() {
                              //regNumber = fleetVocabulary[index]['REGNO'];
                              _listRegionsReady == false;
                            });
                            _currentFleet2(fleetVocabulary[index]['FLEET_ID']);
                           // Navigator.pushNamed(context, '/fomaN');
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              padding: EdgeInsets.fromLTRB(10,5,5,5),
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: count%2==0?kBlueLight:kBlue,),
                              alignment: Alignment.centerLeft,
                              //child: Row( children: [ Expanded( child:Text('${fleetVocabulary[index]}',style: st17,textAlign: TextAlign.left,)),Text('${fleetVocabulary[index]['REGNO'] != null ? fleetVocabulary[index]['REGNO'] : ''}',style: st5,textAlign: TextAlign.left,),])
                              child: Text('${fleetVocabulary[index]['REGNO'] != null ? fleetVocabulary[index]['REGNO'] : ''}',style: st5,textAlign: TextAlign.left,)
                          )
                      ) : Container();
                    }): Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()]),
              ]
          ),
        ),
      ),
    );
  }

}


