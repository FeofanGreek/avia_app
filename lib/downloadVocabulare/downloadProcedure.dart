import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';
import '../constants.dart';

bool _flightcat = false;
bool _cargoDangerCl = false;
bool _statesVoc = false;
bool _pointsVoc = false;
bool _fleetVoc = false;
bool _fleetFullVoc = false;
bool _airlinesVoc = false;
bool _airlinesFullVoc = false;
bool _airportsVoc = false;
bool _fileTypesVoc = false;
bool _aircraftTypesVoc = false;
bool _aircraftModifVoc = false;

class loadVocabulary extends StatefulWidget {
  @override
  launchScreenState createState() => launchScreenState();
}

class launchScreenState extends State<loadVocabulary> {

  loadJson() async {
    if(language == 'ru'){
      String data = await rootBundle.loadString('vocabular/ru.json');
      vocabular = json.decode(data);} else {String data = await rootBundle.loadString('vocabular/en.json');
    vocabular = json.decode(data);}
    setState(() {});
    loadFlightCat();
  }

loadFlightCat()async{
  try {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = '${serverURL}api/api/v1/GetDirectory?name=FlightCategories';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      print(directory.path);
      final File file = File('${directory.path}/FlightCategories.json');
      await file.writeAsString(reply);
      _flightcat = true;
    }catch(e){
      print(e);
      _flightcat = false;
    }
  }catch(e){
    print(e);
    _flightcat = false;
  }
  setState(() {});
  loadStates();
}
  loadStates()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=States';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/States.json');
        await file.writeAsString(reply);
        _statesVoc = true;
      }catch(e){
        print(e);
        _statesVoc = false;
      }
    }catch(e){
      print(e);
      _statesVoc = false;
    }
    setState(() {});
    loadCargoDangerCat();
  }

  loadCargoDangerCat()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=CargoDangerClass';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/CargoDangerClass.json');
        await file.writeAsString(reply);
        _cargoDangerCl = true;
      }catch(e){
        print(e);
        _cargoDangerCl = false;
      }
    }catch(e){
      print(e);
      _cargoDangerCl = false;
    }
    setState(() {});
    loadPoints();
  }


  loadPoints()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=Points';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/Points.json');
        await file.writeAsString(reply);
        _pointsVoc = true;
      }catch(e){
        print(e);
        _pointsVoc = false;
      }
    }catch(e){
      print(e);
      _pointsVoc = false;
    }
    setState(() {});
    loadFleet();
  }

  loadFleet()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=Fleet';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/Fleet.json');
        await file.writeAsString(reply);
        _fleetVoc = true;
      }catch(e){
        print(e);
        _fleetVoc = false;
      }
    }catch(e){
      print(e);
      _fleetVoc = false;
    }
    setState(() {});
    loadFleetFull();
  }


  loadFleetFull()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=FleetFull';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/FleetFull.json');
        await file.writeAsString(reply);
        _fleetFullVoc = true;
      }catch(e){
        print(e);
        _fleetFullVoc = false;
      }
    }catch(e){
      print(e);
      _fleetFullVoc = false;
    }
    setState(() {});
    loadAirlines();
  }

  loadAirlines()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=Airlines';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/Airlines.json');
        await file.writeAsString(reply);
        _airlinesVoc = true;
      }catch(e){
        print(e);
        _airlinesVoc = false;
      }
    }catch(e){
      print(e);
      _airlinesVoc = false;
    }
    setState(() {});
    loadAirlinesFull();
  }


  loadAirlinesFull()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=AirlinesFull';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/AirlinesFull.json');
        await file.writeAsString(reply);
        _airlinesFullVoc = true;
      }catch(e){
        print(e);
        _airlinesFullVoc = false;
      }
    }catch(e){
      print(e);
      _airlinesFullVoc = false;
    }
    setState(() {});
    loadAirports();
  }

  loadAirports()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=Airports';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/Airports.json');
        await file.writeAsString(reply);
        _airportsVoc = true;
      }catch(e){
        print(e);
        _airportsVoc = false;
      }
    }catch(e){
      print(e);
      _airportsVoc = false;
    }
    setState(() {});
    loadFileTypes();
  }

  loadFileTypes()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=FileTypes';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/FileTypes.json');
        await file.writeAsString(reply);
        _fileTypesVoc = true;
      }catch(e){
        print(e);
        _fileTypesVoc = false;
      }
    }catch(e){
      print(e);
      _fileTypesVoc = false;
    }
    setState(() {});
    loadTYPE_AIRCRAFT();
  }

  loadTYPE_AIRCRAFT()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=TYPE_AIRCRAFT';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/TYPE_AIRCRAFT.json');
        await file.writeAsString(reply);
        _aircraftTypesVoc = true;
      }catch(e){
        print(e);
        _aircraftTypesVoc = false;
      }
    }catch(e){
      print(e);
      _aircraftTypesVoc = false;
    }
    setState(() {});
    loadACFTMOD();
  }

  loadACFTMOD()async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetDirectory?name=ACFTMOD';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/ACFTMOD.json');
        await file.writeAsString(reply);
        _aircraftModifVoc = true;
      }catch(e){
        print(e);
        _aircraftModifVoc = false;
      }
    }catch(e){
      print(e);
      _aircraftModifVoc = false;
    }
    setState(() {});
    const twentyMillis = const Duration(seconds:3);
    new Timer(twentyMillis, () => Navigator.pushNamed(context, '/launchScreen'));
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }//initState

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kBlueLight,
      body:Container(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/regBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 120, width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      height: 53, width: 53,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/logoReg.png"),
                            fit:BoxFit.fitWidth, alignment: Alignment(0.0, 0.0)
                        ),
                      ),),
                    Text('Renewing vocabularies, please wait...',textAlign: TextAlign.left,),
                    _flightcat == false ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                        Text('Loading flight categories...'),
                        SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Flight categories loaded'),
                    _cargoDangerCl == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading cargo danger class...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Cargo danger class loaded'),
                    _statesVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading states...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('States loaded'),
                    _pointsVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading points...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Points loaded'),
                    _fleetVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading fleets...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Fleets loaded'),
                    _fleetFullVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading fleets full information...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Fleets full information loaded'),
                    _airlinesVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading airlines...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Airlines loaded'),
                    _airlinesFullVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading airlines full information...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Airlines full information loaded'),
                    _airportsVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading airports...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Airports loaded'),
                    _fileTypesVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading file types...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('File types loaded'),
                    _aircraftTypesVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading aircraft types...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Aircraft types loaded'),
                    _aircraftModifVoc == false ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text('Loading aircraft modifications...'),
                          SizedBox(width: 20, height: 20, child:CircularProgressIndicator())
                        ]) : Text('Aircraft modifications loaded'),
                  ]),
            ),
      ),
    );
  }

}

