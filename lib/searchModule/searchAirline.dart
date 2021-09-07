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

bool listRegionsReady = false;

var regionsBackUp;
int lastChairCount = 0,count = 0;

class RegionSelectPage extends StatefulWidget {
  @override
  _RegionSelectPageState createState() => _RegionSelectPageState();

}

class _RegionSelectPageState extends State<RegionSelectPage> {
  var _controllerSearchRegion = TextEditingController();

  _airlines() async{
   /* try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Airlines';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      airlinesVocabulary = json.decode(reply);
      regionsBackUp = json.decode(reply);
      setState(() {
        listRegionsReady = true;
      });
    }catch(e){
      print(e);
    }*/
    String data = await rootBundle.loadString('vocabular/airlines.json');
    airlinesVocabulary = json.decode(data);
    regionsBackUp = json.decode(data);
    //print(airlinesVocabulary[0]);
    setState(() {
      listRegionsReady = true;
    });
  }

  _states(int numState) async{
    try{
      /*HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=States';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);*/
      //statesVocabulary = json.decode(reply);
      String data = await rootBundle.loadString('vocabular/states.json');
      statesVocabulary = json.decode(data);

      for(int i=0; i<statesVocabulary.length; i++){
        statesVocabulary[i]['STATES_ID'] == numState ? regCountry = statesVocabulary[i]['NAMERUS'] : null;
        statesVocabulary[i]['STATES_ID'] == numState ? regCountryLat = statesVocabulary[i]['NAMELAT'] : null;
        statesVocabulary[i]['STATES_ID'] == numState ? stateCode = numState : null;
      }
    }catch(e){
      print(e);
    }
    setState(() {});
    Navigator.pushNamed(context, '/fomaN');
  }



  @override
  void initState() {
    super.initState();
    //listRegionsReady == false ? _airlines() : null;
    _airlines();
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
                          hintText: vocabular['forms']['search'],
                          hintStyle: st8,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10.0),
                          prefixIcon: Icon(Icons.search, color: kWhite, size: 18,),
                          suffixIcon: IconButton(
                            onPressed: () { _controllerSearchRegion.clear(); airlinesVocabulary = regionsBackUp; setState(() {});},
                            icon: Icon(Icons.clear, color: kWhite, size: 18,),
                          ),
                        ),
                        onChanged: (value){

                          airlinesVocabulary = regionsBackUp;
                          List tempList = [];
                          for(int i = 0; i < airlinesVocabulary.length; i++){
                            if (airlinesVocabulary[i]['airlhist']!= null){
                              for(int ii=0; ii<airlinesVocabulary[i]['airlhist'].length; ii++ ){
                                if (airlinesVocabulary[i]['airlhist'][ii]['ICAOLAT3'] != null){if(airlinesVocabulary[i]['airlhist'][ii]['ICAOLAT3'].toLowerCase().contains(value.toLowerCase())) {
                                  tempList.add(airlinesVocabulary[i]);
                                }}}}
                            if (airlinesVocabulary[i]['FULLNAMERUS'] != null){if(airlinesVocabulary[i]['FULLNAMERUS'].toLowerCase().contains(value.toLowerCase())){
                              tempList.add(airlinesVocabulary[i]);
                            } }
                            if (airlinesVocabulary[i]['FULLNAMELAT'] != null){if(airlinesVocabulary[i]['FULLNAMELAT'].toLowerCase().contains(value.toLowerCase())){
                              tempList.add(airlinesVocabulary[i]);
                            }}

                          }
                          var distinctIds = tempList.toSet().toList();
                          airlinesVocabulary = distinctIds;
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
                          child: Text(vocabular['myPhrases']['hintAviacompanyNameOrICAO'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                          ),
                        )) : Container(),
                  ],
                ),


            listRegionsReady == true ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: airlinesVocabulary.length < 300 ? airlinesVocabulary.length : 300,
                    itemBuilder: (BuildContext context, int index) {
                      airlinesVocabulary[index]['FULLNAMERUS'] != null ? count++ : airlinesVocabulary[index]['FULLNAMELAT'] != null ? count++ :null;

                      return airlinesVocabulary[index]['FULLNAMERUS'] != null ? GestureDetector(
                          onTap: () {
                            setState(() {
                              orgId = airlinesVocabulary[index]['airlhist'][0]['AIRLINES_ID'];
                              aviaCompanyName = airlinesVocabulary[index]['FULLNAMERUS'];
                              aviaCompanyNameLat = airlinesVocabulary[index]['FULLNAMELAT'];
                              icao = airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] != null ? airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] : '';
                              airlineId = airlinesVocabulary[index]['AIRLINES_ID'].toString();
                            });
                            //print(airlineId);
                            _states(airlinesVocabulary[index]['STATES_ID']);
                            //Navigator.pushNamed(context, '/fomaN');
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            padding: EdgeInsets.fromLTRB(10,5,5,5),
                            width: MediaQuery.of(context).size.width - 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: count%2==0?kBlueLight:kBlue,),
                            alignment: Alignment.centerLeft,
                            child: Row( children: [ Expanded( child:Text('${airlinesVocabulary[index]['FULLNAMERUS']}',style: st17,textAlign: TextAlign.left,)),Text('${airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] != null ? airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] : ''}',style: st5,textAlign: TextAlign.left,),])
                          )
                      ) : airlinesVocabulary[index]['FULLNAMELAT'] != null ? GestureDetector(
                          onTap: () {
                            setState(() {
                              aviaCompanyName = airlinesVocabulary[index]['FULLNAMELAT'];
                              icao = airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] != null ? airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] : '';
                              airlineId = airlinesVocabulary[index]['AIRLINES_ID'].toString();
                            });
                            //print(airlineId);
                            _states(airlinesVocabulary[index]['STATES_ID']);
                            //Navigator.pushNamed(context, '/fomaN');
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10,0,10,0),
                              padding: EdgeInsets.fromLTRB(10,5,5,5),
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: count%2==0?kBlueLight:kBlue,),
                              alignment: Alignment.centerLeft,
                              child: Row( children: [ Expanded( child:Text('${airlinesVocabulary[index]['FULLNAMELAT']}',style: st17,textAlign: TextAlign.left,)),Text('${airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] != null ? airlinesVocabulary[index]['airlhist'][0]['ICAOLAT3'] : ''}',style: st5,textAlign: TextAlign.left,),])
                          )
                      ) : Container() ;
                    }): Column( children: [ Text('${vocabular['myPhrases']['loadListAviacompany']}\n'),CircularProgressIndicator()]),
              ]
          ),
        ),
      ),
    );
  }

}


