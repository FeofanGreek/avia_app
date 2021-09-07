import 'dart:convert';
import 'dart:io';
import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/searchModule/searchAirline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List airlinesVocabulary = []; //ОК
airlines() async{
  try{
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
    //setState(() {
      listRegionsReady = true;
    //});
  }catch(e){
    print(e);
  }

}

List docTypesVocabulary = []; // ОК
docTypes() async{
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=DocTypes';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    docTypesVocabulary = json.decode(reply);
    print('тип документа: '+docTypesVocabulary[0]['NAME']);
  }catch(e){
    print(e);
  }
}

List statesVocabulary = []; // ОК
states(int numState) async{
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=States';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    statesVocabulary = json.decode(reply);
    for(int i=0; i<statesVocabulary.length; i++){
      //statesVocabulary[i]['STATES_ID'] == numState ? print(statesVocabulary[i]['NAMELAT']) : null;
      statesVocabulary[i]['STATES_ID'] == numState ? print(statesVocabulary[i]['NAMERUS']) : null;
    }
    //print('страна: '+statesVocabulary[numState]['NAMELAT']);
  }catch(e){
    print(e);
  }
}

List fleetVocabulary = []; //ОК
fleet() async{
  regionsBackUp = [];
  //http://10.95.0.65/api/v1/GetDirectory?name=Fleet //все воздушные суда
  //http://10.95.0.65/api/v1/GetDirectory?name=Fleet&AIRLINES_ID=0001 //воздушные суда заданой авиакампании
  try{
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Fleet';
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    if(airlineId == null) {
      url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Fleet';} else
    {url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Fleet&AIRLINES_ID=$airlineId';}
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    fleetVocabulary = json.decode(reply);
    regionsBackUp = json.decode(reply);
    //print(reply);
    //{"FLEET_ID":52609,"REGNO":"28980","REGISTRNO":null,"MODEL":"\u0412\u0432\u0435\u0434\u0435\u043d\u043e 11.11.2010\u0433.","MAXIMUMWEIGHT":13000,"airlflt":{"AIRLFLT_ID":226254,"FLEET_ID":52609,"AIRLINES_ID":15}},
    //setState(() {
    //  _listRegionsReady = true;
    //});
  }catch(e){
    print(e);
  }
}

 List currentFleetInfo = [];
//функция информация по конкретному судну
currentFleet(int currentFleetID) async{
  //http://10.95.0.65/api/v1/GetDirectory?name=FleetFull&FLEET_ID=0001
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    //String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Fleet';
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=FleetFull&FLEET_ID=$currentFleetID';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    currentFleetInfo = json.decode(reply);
    //print('марка модель  воздушного судна: '+currentFleetInfo[0]['REGNO']);
  }catch(e){
    print(e);
  }
}

List flightCategoriesVocabulary = []; // ОК
flightCategories() async{
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=FlightCategories';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    flightCategoriesVocabulary = json.decode(reply);
    //print('категория авиаперевозки: '+flightCategoriesVocabulary[0]['NAMELAT']);
  }catch(e){
    print(e);
  }
}

List airportsVocabulary = []; //ОК
airports() async{
  //{"AIRPORTS_ID":2,"STATES_ID":184,"NAMELAT":"Bellona (Anau)","NAMERUS":"\u0411\u0435\u043b\u043b\u043e\u043d\u0430 (\u0410\u043d\u0430\u0443)","ISSLOT":0,"aprthist":{"APRTHIST_ID":51,"AIRPORTS_ID":2,"ICAOLAT4":"GY47","ISNATIONCODE":null}},
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Airports';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    airportsVocabulary = json.decode(reply);
    //print('аэропорт: ' + airportsVocabulary[0]['NAMELAT']);
  }catch(e){
    print(e);
  }
}

List pointsVocabulary = [];
points() async{
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=Points';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    //pointsVocabulary = json.decode(reply);
    //print('точки пересечения: '+pointsVocabulary[0]['ICAOLAT5']);
  }catch(e){
    print("точки пересечения ошибка"+e);
  }
}

List cargoDangerClassVocabulary = [];
cargoDangerClass() async{
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = 'https://10.95.0.65/api/api/v1/GetDirectory?name=CargoDangerClass';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    //cargoDangerClassVocabulary = json.decode(reply);
    //print(cargoDangerClassVocabulary[0]['ICAOLAT']);
  }catch(e){
    print('класс опасности ошибка'+e);
  }
}

