import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/vocabulary/vocabulary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';


final DateTime _now = DateTime.now();
final DateFormat _todayIs = DateFormat('dd.MM.yyyy');
final String _todayIsString = todayIs.format(_now);

bool _listRegionsReady = false;
FilePickerResult result;
String path;

var regionsBackUp;
int lastChairCount = 0,count = 0;

class docTypeSelectPage extends StatefulWidget {
  final int routNum;
  final int stringNum;
  final String doc_object;
  docTypeSelectPage({Key key, @required this.routNum, this.stringNum, this.doc_object}) : super(key: key);
  @override
  _RegionSelectPageState createState() => _RegionSelectPageState(this.routNum, this.stringNum, this.doc_object);

}

class _RegionSelectPageState extends State<docTypeSelectPage> {
  int routNum;
  int stringNum;
  String doc_object;
  _RegionSelectPageState(this.routNum, this.stringNum, this.doc_object);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  _docTypes() async{
    try{
      /*HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '$serverURL/api/api/v1/GetDirectory?name=DocTypes';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);
      debugPrint(reply, wrapWidth: 1024);*/
      String data = await rootBundle.loadString('vocabular/doc.json');

      //docTypesVocabulary = json.decode(reply);
      docTypesVocabulary = json.decode(data);
      if(doc_object != null) {
        List tempList =[];
        for (int i = 0; i < docTypesVocabulary.length; i++) {
          docTypesVocabulary[i]['doc_object'] == doc_object ? tempList.add(docTypesVocabulary[i]) : null;
        }
        docTypesVocabulary = tempList;
        regionsBackUp = tempList;
      }
      //regionsBackUp = json.decode(reply);
      regionsBackUp = json.decode(data);

      setState(() {
        _listRegionsReady = true;
      });
      //print('тип документа: '+docTypesVocabulary[0]['NAME']);
    }catch(e){
      print(e);
    }
  }


  // функция для основного воздушного судна, которая выводид номер строки в массиве принадлежащей осноному ВС
  majorVSStringNum(){
    int num;
    for(int i = 0; i< fleetsList.length; i++){
      fleetsList[i]['is_main'] == 1 ? num = i : null;
    }
    return num;
  }
  whereChangeField(){
    int num;
    for(int i = 0; i< routes.length; i++){
      routes[i]['switch'] == 1 ? num = i : null;
    }
    return num;
  }

  @override
  void initState() {
    super.initState();
    _docTypes();
    _controller.addListener(() => _extension = _controller.text);
  }



  void _openFileExplorer(String docType) async {
    final docTypeSearched = await searchDocType(docType);
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Не поддерживаемая операция" + e.toString());
    } catch (ex) {
      print(ex);
    }
    var _image = File(_paths.first.path);
    var base64Image = base64Encode(_image.readAsBytesSync());
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      //if(_paths != null){print(_paths.first.extension);}
      _fileName =
      _paths != null ? _paths.map((e) => e.name).toString() : '...';

      if(_paths != null){
        if(routNum == 1){
        aviaCompanyDocs.add(
            {"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
                "required_attributes_json": [
                  { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
                  { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
                  ]
            });
      }
      else if(routNum == 2){commentDocs.add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
          "required_attributes_json": [
            { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
            { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
          ]
        });}
      else if(routNum == 3){routeList[whereChangeField()]['passengers']['passengers_persons'][stringNum]['documents'].add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
          "required_attributes_json": [
            { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
            { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
          ]
        });}
      else if(routNum == 4){routeList[whereChangeField()]['crew']['crew_mebers'][stringNum]['documents'].add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
          "required_attributes_json": [
            { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
            { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
          ]
        });}

     else if(routNum == 5){routeList[whereChangeField()]['cargos'][stringNum]['documents'].add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
          "required_attributes_json": [
            { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
            { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
          ]
        });}

      else if(routNum == 6){ fleetsList[majorVSStringNum()]['documents'].add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
        "required_attributes_json": [
          { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
          { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
        ]
      });}

      else if(routNum == 7){ fleetsList[whereChangeField()]['aircraft_owner']['documents'].add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
        "required_attributes_json": [
          { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
          { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
        ]
      });}

      else if(routNum == 8){ docsForSlots.add({"file_type_name": "$docType", "file_type_id": docTypeSearched, "file_name": "$_fileName", "file_body": "$base64Image", "created_at": "$_todayIsString",
          "required_attributes_json": [
            { "rus": "Дата начала действия", "eng": "Effective date", "format": "date", "value": "20-05-2021"},
            { "rus": "Дата окончания действия", "eng": "Expiration date", "format": "date","value": "20-05-2022"}
          ]
        });}
      }
    });
    Navigator.pushNamed(context, '/fomaN');
  }

  searchDocType(String docName)async{
    var docType = 0;
    String data = await rootBundle.loadString('vocabular/doctypes.json');
    var doc = json.decode(data);
    for(int i=0; i < doc.length; i++){
      doc[i]['NAME'] == docName ? docType = doc[i]['DOCTYPE_ID'] : null;
    }

    return docType;
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Временные удалены.'
              : 'Ошибка при очистке папки')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
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
                _listRegionsReady == true ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: docTypesVocabulary.length,
                    itemBuilder: (BuildContext context, int index) {
                      count++;
                      return  GestureDetector(
                          onTap: () {
                            _openFileExplorer(docTypesVocabulary[index]['name_rus']);
                          },
                          child: Container(
                                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                                  padding: EdgeInsets.fromLTRB(10,5,5,5),
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: count%2==0?kBlueLight:kBlue,),
                                  alignment: Alignment.centerLeft,
                                  child: Row( children: [ Expanded( child:Text('${language == 'ru' ? docTypesVocabulary[index]['name_rus'] : docTypesVocabulary[index]['name_lat']}',style: st17,textAlign: TextAlign.left,)),SizedBox(width: 30,),GestureDetector(
                                    onTap: () {
                                      //_openFileExplorer(language == 'ru' ? docTypesVocabulary[index]['name_rus'] : docTypesVocabulary[index]['name_lat']);
                                      _openFileExplorer(docTypesVocabulary[index]['name_rus']);
                                    },
                                      child: Icon(CupertinoIcons.share)),SizedBox(width: 10,)])
                              ),

                      );
                    }): Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()]),
              ]
          ),
        ),
      ),
    );
  }

}


