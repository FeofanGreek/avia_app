import 'dart:convert';
import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:flutter/services.dart';

Future<String> searchAirline(int aviaCompanyId)async{
  String airline;
  String data = await rootBundle.loadString('vocabular/airlines.json');
  var statesVocabulary = json.decode(data);
  print(aviaCompanyId);
  for(int i=0; i<statesVocabulary.length; i++){
    //print('botv');
    statesVocabulary[i]['AIRLINES_ID'] == aviaCompanyId ? airline = statesVocabulary[i]['airlhist'][0]['ICAOLAT3'] : null;
    statesVocabulary[i]['AIRLINES_ID'] == aviaCompanyId ? icao = statesVocabulary[i]['airlhist'][0]['ICAOLAT3'] : null;
  }
  print(airline);
  return airline;
}