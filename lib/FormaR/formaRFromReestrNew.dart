import 'dart:convert';
import 'dart:io';
import 'package:avia_app/FormaR/processScreen.dart';
import 'package:avia_app/searchModule/searchDoc.dart';
import 'package:avia_app/vocabulary/stringFormN.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:avia_app/searchModule/pointsInOut.dart';
import 'package:avia_app/searchModule/searchAirline.dart';
import 'package:avia_app/searchModule/searchAirport.dart';
import 'package:avia_app/searchModule/searchFleet.dart';
import 'package:avia_app/searchModule/searchReservFleets.dart';
import 'package:avia_app/widgets/expanded_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:avia_app/pages/homepage.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'fomaRfish.dart';
import 'history.dart';


ScrollController _scrollController;
final DateTime now = DateTime.now();
final DateFormat todayIs = DateFormat('dd.MM.yyyy');
final String todayIsString = todayIs.format(now);


bool isDispetcher = false;
int _errors = 0, _requests = 0, _comments = 0;
List commits = [];
List cargoItem = [];
bool formBootReady = false;
var formFromRestr;

bool mo = false, tu = false, we = false, th = false, fr = false, sa = false, su = false;

String icao;
String aviaCompanyName = '', regCountry = '', airlineId, enshuranceDate = '', enshuranceEnd = '', spgDate = '', spgEnd = '', upFio = '', upGrade = '', upEmail = '', upSITA = '', upAFTN = '', upFax = '', upPhone = '', upFios = '',upEmails = '', upSITAs = '', upAFTNs = '', upFaxs = '', upPhones = '';//рабочие переменные авиапредприятия
List aviaCompanyDocs = [];
List commentDocs = [];
List <String> commentTypes = ['Ошибка','Запрос','Приватный комментарий'];
String typeComment = 'Ошибка', valueComment = '';

String regNumber = '', AirCraftType = '', airCraftModel = ''; //рабочие переменные для основного ВС
int MAXIMUMWEIGHT, MAXLANDINGWEIGHT, WEIGHTEMPTYPLAN;
String onerFleetAddress, onerFleetContact, onerFleetControlResidence; List onerFleetDocs = [];
List majorFleetDocs = [];
List <TextEditingController> majorFleetDocsDate = [], onerFleetDocsDate = [], routesTimeOut = [],routesTimeIn = [], repeatDates = [], periodsStart = [], periodsEnd = [], fplValue = [];
bool reservFleet = false, reservFleetsListing = false; //выбор резервных ВС
List reservFleets = [], repeatsDate = [], repeatsPeriod = [], docsForSlots = [];



//String route = '[{"switch" : 1, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "00.00.0000","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс","portOut" : "", "timeOut" : "0", "portIn": "", "timeIn" : "0", "inOutPoints" : [], "landingType" : "Техническая посадка", "landingTypeDoc" : "24.11.2021", "majorDateFlight" : "00.00.0000"}]';
//List routes = json.decode(route); //массив маршрута используется
List routes=[];
List routTargets = ['${vocabular['form_n']['purposeFlight']['commercial_flight']}','${vocabular['form_n']['purposeFlight']['none_commercial_flight']}'], deliveryCategory = ['Коммерческий','Гуманитарный'];
List landingTypes = ['Техническая посадка','Коммерческая посадка'];//рабочие переменные авиапредприятия

//int colStaff = 1;
bool _lockField = true, repeats = false, datePeriod = false, fpl = false;

String commentLast, commentPreLast, payerContactPerson, payerFio, payerOrganisation, payerEmail, payerPhone, payerAFTN, majorDateFlight, idAdSlotIn, idAdSlotOut;
TextEditingController _majorDateFlight;

List passengers = [], pilots = [], fplPilots = [];
List <String> dangerClassUnits = ["Класс 1","Класс 2"];

bool e1 = true,
    e11 = false,
    e111 = false,
    e112 = false,
    e113 = false,
    e2 = false,
    e21 = false,
    e211 = false,
    e212 = false,
    e213 = false,
    e3 = false,
    e4 = false,
    e5 = false,
    e6 = false,
    e7 = false,
    e8 = false,
    e9 = false,
    e10 = false,
    _e11 = false,
    _e1 = false;

var fromReestr;

class formaRFromReestrPage extends StatefulWidget {
  @override
  _formaNFishPageScreenState createState() => _formaNFishPageScreenState();
}

class _formaNFishPageScreenState extends State<formaRFromReestrPage> {
  TextEditingController _regCountry, _colStaff;
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  @override
  buildListCommits(){
    print('Делаем комментарии');
    commits = [];
    if(dispetcherComments[formInListNum]['formaComment']['aviacompany'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompany'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompany'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['dateFlight'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['dateFlight'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['dateFlight'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['repeats'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['repeats'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['repeats'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['crew'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['сrew'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['сrew'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['pasengers'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['pasengers'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['pasengers'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['cargoItems'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['cargoItems'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['cargoItems'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['payer'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['payer'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['payer'][i]);
      }
    }
    if(dispetcherComments[formInListNum]['formaComment']['comment'].length > 0) {
      for(int i = 0; i < dispetcherComments[formInListNum]['formaComment']['comment'].length; i++){
        commits.add(dispetcherComments[formInListNum]['formaComment']['comment'][i]);
      }
    }
    setState(() {

    });
    calculateStatus();
  }

  calculateStatus(){
    _errors = 0; _requests = 0; _comments=0;
    for(int i =0; i<commits.length; i++){
      commits[i]["type"] == 'Ошибка' ? _errors++ : commits[i]["type"] == 'Запрос' ? _requests++ : commits[i]["type"] == 'Приватный комментарий' ? _comments++ : null;
    }
    setState(() {

    });
  }

  //получаем данные для заполнения полей конкректной формы
  @override
  getFormNData() async{
    print('Берем данные формы');
    //fish = 0;
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      //String url = 'https://permit.matfmc.ru/api/api/v1/GetFormN?id=$formId';
      String url = '${serverURL}api/api/v1/GetFormN?id=120';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      //formFromRestr = json.decode(reply);
      formFromRestr = json.decode(formNbackup);
      //formFromRestr = formN;
      regNumber = formFromRestr['NForm']['aircrafts'][0]['regno'];
      AirCraftType = formFromRestr['NForm']['aircrafts'][0]['type_model'];
      airCraftModel = formFromRestr['NForm']['aircrafts'][0]['type_model'];
      MAXIMUMWEIGHT = formFromRestr['NForm']['aircrafts'][0]['parameters']['max_takeoff_weight'];
      MAXLANDINGWEIGHT = formFromRestr['NForm']['aircrafts'][0]['parameters']['max_landing_weight'];
      WEIGHTEMPTYPLAN = formFromRestr['NForm']['aircrafts'][0]['parameters']['empty_equip_weight'];
      onerFleetAddress = formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['full_address'];
      onerFleetContact = formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['contact'];
      language == 'ru' ? onerFleetControlResidence = formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['state']['state_namerus'] : onerFleetControlResidence = formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['state']['state_namelat'];
      for(int i =0; i < formFromRestr['NForm']['flights'].length; i++){
        routes.add(json.decode('{"switch" : 0, "switchMenu" : 0, "marshruteName" : "${formFromRestr['NForm']['flights'][i]['flight_information']['flight_num']}", "marshruteDate" : "28.04.2021","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "${formFromRestr['NForm']['flights'][i]['flight_information']['flight_num']}", "marshruteTarget" : "${formFromRestr['NForm']['flights'][i]['flight_information']['purpose_is_commercial'] == 1 ? 'Коммерческий рейс' : 'Не коммерческий рейс'}", "transferCategory" : "${formFromRestr['NForm']['flights'][i]['flight_information']['purpose_is_commercial'] == 1 ? 'Коммерческий рейс' : 'Не коммерческий рейс'}","portOut" : "${formFromRestr['NForm']['flights'][i]['flight_information']['departure_airport_icao']}", "timeOut" : "${formFromRestr['NForm']['flights'][i]['flight_information']['departure_time']}", "portIn": "${formFromRestr['NForm']['flights'][i]['flight_information']['landing_airport_icao']}", "timeIn" : "${formFromRestr['NForm']['flights'][i]['flight_information']['landing_time']}", "inOutPoints" : [{"pointName" : "0", "pointTime" : "0"}], "landingType" : "${formFromRestr['NForm']['flights'][i]['flight_information']['landing_type']}"}'));
      }

        _searchAirline(formFromRestr['NForm']['airline']['AIRLINES_ID']);


    }catch(e){
      print('ошибка тут $e');
    }
  }

  @override
  _searchAirline(int aviaCompanyId)async{
    print('Ищем авиакомпанию');
    String data = await rootBundle.loadString('vocabular/airlines.json');
    var statesVocabulary = json.decode(data);
    for(int i=0; i<statesVocabulary.length; i++){
      statesVocabulary[i]['AIRLINES_ID'] == aviaCompanyId ? icao = statesVocabulary[i]['airlhist'][0]['ICAOLAT3'] : null;
      statesVocabulary[i]['AIRLINES_ID'] == aviaCompanyId ? aviaCompanyName = statesVocabulary[i]['FULLNAMERUS'] : null;
      statesVocabulary[i]['AIRLINES_ID'] == aviaCompanyId ? _searchCountry(statesVocabulary[i]['STATES_ID']) : null;
    }
    //setState(() {});
  }

  @override
  _searchCountry(int countryId)async{
    print('Ищем страну');
    String data = await rootBundle.loadString('vocabular/states.json');
    var statesVocabulary = json.decode(data);
    for(int i=0; i<statesVocabulary.length; i++){
      statesVocabulary[i]['STATES_ID'] == countryId ? language == 'ru' ? regCountry = statesVocabulary[i]['NAMERUS'] :  regCountry = statesVocabulary[i]['NAMELAT'] : null;
      statesVocabulary[i]['STATES_ID'] == countryId ? language == 'ru' ? onerFleetControlResidence = statesVocabulary[i]['NAMERUS'] :  onerFleetControlResidence = statesVocabulary[i]['NAMELAT'] : null;
    }
    _regCountry = TextEditingController(text: regCountry);
    formBootReady = true;
    setState(() {});
  }

  @override
  void initState() {
    routes=[];
    getFormNData();
    _regCountry = TextEditingController(text: regCountry);
    super.initState();
    buildListCommits();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
        title: Container(
            width:MediaQuery.of(context).size.width ,
            height: 40,
            child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      headerValue = s251;
                      Navigator.pushNamed(context, '/HomePageOther');},
                    child:Container(
                      margin: EdgeInsets.fromLTRB(0,7,0,0),
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child:Icon(CupertinoIcons.chevron_left, color: kYellow, size: 20,),
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //regSwitch = false;
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 4 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(s252, style: st17,textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(onTap: (){
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) => historyPage()));
                          }, child:Container(
                                width: MediaQuery.of(context).size.width / 4 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kWhite2),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kBlue,
                                ),
                                child: Text(s253, style: st17,textAlign: TextAlign.center,)
                            ),
                          ),

                          Container(
                            height: 40,
                            //width: 100,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(30,0,0,0),
                            child: TextButton(
                              onPressed:(){
                                Navigator.pushReplacement(context,
                                    CupertinoPageRoute(builder: (context) =>proceedScreenR()));
                              } ,
                              child: Text(vocabular['myPhrases']['process'], style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                              style: ElevatedButton.styleFrom(
                                primary: kYellow,
                                minimumSize: Size(20, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),

                ])
        ),
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: Stack(
            children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: formBootReady == true ? Container(
                margin: EdgeInsets.fromLTRB(10,10,10,0),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(

                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e1 = !e1;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e1? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s54,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompany', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ): Container()
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e1,
                                    child: Column(
                                        children: [                                          
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompany'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.2),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompany'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompany'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: BoxDecoration(
                                                  color: kBlue,
                                                ),
                                                child:Container(
                                                    padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                    width:MediaQuery.of(context).size.width,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                      color: kBlue,
                                                    ),
                                                    child:Row( children: [Text(icao != null ? icao : ''),SizedBox(width:10,),Expanded(child:Text(aviaCompanyName != null ? aviaCompanyName : '', style:st5)),])
                                                ),
                                              ),
                                              Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(s262,style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )),

                                            ],
                                          ),

                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 40,
                                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: kWhite1),
                                                ),
                                                child: TextFormField(
                                                  style: !_lockField ? st1 : st8,
                                                  controller: _regCountry,
                                                  readOnly: _lockField,
                                                  decoration: InputDecoration(
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide.none
                                                    ),
                                                    hintText: s263,
                                                    hintStyle: st8,
                                                    contentPadding: new EdgeInsets.symmetric(
                                                        vertical: 2, horizontal: 10.0),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {},
                                                      icon: Image.asset(
                                                          'icons/lockIcon.png', width: 16,
                                                          height: 16,
                                                          fit: BoxFit.fitHeight),
                                                    ),
                                                  ),
                                                  onChanged: (value) {},
                                                  autovalidateMode: AutovalidateMode.always,
                                                ),
                                              ),
                                             Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(s263,style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          //подсекция карточка авиапредприятия
                                          Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              child: Container(padding: EdgeInsets.fromLTRB(0,10,0,10), color: kBlueLight, child:Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          e11 = !e11;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 5,),
                                                          Text(vocabular['myPhrases']['renewed'],style: st8,),
                                                          SizedBox(width: 5,),
                                                          Text(todayIs.format(DateTime.parse(formFromRestr['NForm']['airline']['airline_represent']['updated_at'])),style: st8,),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                            child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text(e11 ? vocabular['form_n']['general']['collapse'] : vocabular['form_n']['general']['expand'], style: st10),
                                                          SizedBox(width: 5,),
                                                        ],
                                                      ),
                                                    ),
                                                    ExpandedSection(
                                                        expand: e11,
                                                        child: Column(
                                                            children: [
                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e111 = !e111;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e111? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['documents_obj']['documents'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                    isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                                                    isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyDoc', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e111,
                                                                  child: Column(
                                                                      children: [
                                                                        ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'].length, //formInListNum
                                                                            itemBuilder: (context, index) {
                                                                              return Container(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                  color: dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                                                  child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children:[
                                                                                        Row(
                                                                                            children:[
                                                                                              Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["value"]}'),),
                                                                                              Spacer(),
                                                                                              GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                                                            ]
                                                                                        ),
                                                                                        Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyDoc'][index]["oner"]}', style: st2,)
                                                                                      ]
                                                                                  ));}),
                                                                        ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: aviaCompanyDocs.length,
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return Stack(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    width:MediaQuery.of(context).size.width ,
                                                                                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                                    decoration: BoxDecoration(
                                                                                      color: kBlueLight,
                                                                                    ),
                                                                                    child: Row(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                                            width:MediaQuery.of(context).size.width - 90,
                                                                                            decoration: BoxDecoration(
                                                                                              border: Border.all(width: 0.5, color: kWhite3),
                                                                                              color: kBlueLight,
                                                                                            ),
                                                                                            child:Text(aviaCompanyDocs[index]['loaded']),
                                                                                          ),
                                                                                          SizedBox(width: 10,),
                                                                                          GestureDetector(
                                                                                            onTap: (){
                                                                                              aviaCompanyDocs.removeAt(index);setState(() {});
                                                                                            },
                                                                                            child:Container(
                                                                                              padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                                                color: kBlueLight,
                                                                                              ),
                                                                                              child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                                            ),
                                                                                          ),
                                                                                        ]),
                                                                                  ),
                                                                                  Positioned(
                                                                                      left: 22,
                                                                                      top: 2,
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(
                                                                                            bottom: 0, left: 10, right: 10),
                                                                                        color: kBlueLight,
                                                                                        child: Text(aviaCompanyDocs[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              );}),

                                                                        Container(
                                                                          height: 40,
                                                                          width: MediaQuery.of(context).size.width,
                                                                          alignment: Alignment.bottomCenter,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,10),
                                                                          child: TextButton(
                                                                            onPressed:(){
                                                                              Navigator.pushReplacement(context,
                                                                                  CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 1)));
                                                                            } ,
                                                                            child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                                                            style: ElevatedButton.styleFrom(
                                                                              primary: kBlueLight,
                                                                              minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                    color: kWhite2,
                                                                                    width: 1,
                                                                                    style: BorderStyle.solid
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(0.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ])),

                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e112 = !e112;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e112? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['documents_obj']['representativeAirline'].substring(0, 20),style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                    isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                                                    isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyPerson', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e112,
                                                                  child: Column(
                                                                      children: [
                                                                        ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'].length, //formInListNum
                                                                            itemBuilder: (context, index) {
                                                                              return Container(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                  color: dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                                                  child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children:[
                                                                                        Row(
                                                                                            children:[
                                                                                              Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["value"]}'),),
                                                                                              Spacer(),
                                                                                              GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                                                            ]
                                                                                        ),
                                                                                        Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyPerson'][index]["oner"]}', style: st2,)
                                                                                      ]
                                                                                  ));}),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['airline_represent']['fio'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['full_name'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['full_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['airline_represent']['position'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['flight_information_obj']['position'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['flight_information_obj']['position'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['airline_represent']['email'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'E-mail',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('E-mail',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:formFromRestr['NForm']['airline']['airline_represent']['tel'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['phone'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['phone'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:formFromRestr['NForm']['airline']['airline_represent']['fax'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['fax'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['fax'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['airline_represent']['sita'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'SITA',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('SITA',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['airline_represent']['aftn'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'AFTN',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('AFTN',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),

                                                                      ])),

                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e113 = !e113;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e113? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['documents_obj']['appointedRepresentative'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e113,
                                                                  child: Column(
                                                                      children: [

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['russia_represent']['fio'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['full_name'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['full_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['russia_represent']['email'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'E-mail',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('E-mail',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:formFromRestr['NForm']['airline']['russia_represent']['tel'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['phone'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['phone'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:formFromRestr['NForm']['airline']['russia_represent']['fax'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['fax'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['fax'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['russia_represent']['sita'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'SITA',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('SITA',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:formFromRestr['NForm']['airline']['russia_represent']['aftn'],decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'AFTN',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                ),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('AFTN',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                      ])),
                                                            ])),
                                                  ]))),

                                        ]))
                              ])),
                      //Секция ОСНОВНОЕ ВОЗДУШНОЕ СУДНО
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e2 = !e2;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e2? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s254,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyMajorFleet', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e2,
                                    child: Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleet'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: BoxDecoration(
                                                  color: kBlue,
                                                ),
                                                child:Container(
                                                  padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                  width:MediaQuery.of(context).size.width,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                    color: kBlue,
                                                  ),
                                                  child:Text(regNumber != null ? regNumber : ''),
                                                ),
                                              ),
                                              Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(vocabular['myPhrases']['regNumPlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: BoxDecoration(
                                                  color: kBlue,
                                                ),
                                                child:Container(
                                                  padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                  width:MediaQuery.of(context).size.width,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                    color: kBlue,
                                                  ),
                                                  child:Text(AirCraftType != null ? AirCraftType : ''),
                                                ),
                                              ),
                                              Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(vocabular['myPhrases']['typePlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )),

                                            ],
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width:MediaQuery.of(context).size.width ,
                                                padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                decoration: BoxDecoration(
                                                  color: kBlue,
                                                ),
                                                child:Container(
                                                  padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                  width:MediaQuery.of(context).size.width,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                    color: kBlue,
                                                  ),
                                                  child:Text(airCraftModel),
                                                ),
                                              ),
                                              Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(vocabular['myPhrases']['modelPlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )),

                                            ],
                                          ),

                                          SizedBox(height: 10,),
                                          Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              child: Container(padding: EdgeInsets.fromLTRB(0,10,0,10), color: kBlueLight, child:Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          e21 = !e21;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 5,),
                                                          Text(vocabular['myPhrases']['renewed'],style: st8,),
                                                          SizedBox(width: 5,),
                                                          Text(formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['updated_at'] != null ? todayIs.format(DateTime.parse(formFromRestr['NForm']['aircrafts'][0]['aircraft_owner']['updated_at'])) : 'No date',style: st8,),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                            child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text(e21 ? vocabular['form_n']['general']['collapse'] : vocabular['form_n']['general']['expand'], style: st10),
                                                          SizedBox(width: 5,),
                                                        ],
                                                      ),
                                                    ),
                                                    ExpandedSection(
                                                        expand: e21,
                                                        child: Column(
                                                            children: [
                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e211 = !e211;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e211? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['air_craft']['parameters'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                    isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                                                    isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyMajorFleetParams', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e211,
                                                                  child: Column(
                                                                      children: [
                                                                        ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'].length, //formInListNum
                                                                            itemBuilder: (context, index) {
                                                                              return Container(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                  color: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                                                  child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children:[
                                                                                        Row(
                                                                                            children:[
                                                                                              Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["value"]}'),),
                                                                                              Spacer(),
                                                                                              GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                                                            ]
                                                                                        ),
                                                                                        Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetParams'][index]["oner"]}', style: st2,)
                                                                                      ]
                                                                                  ));}),
                                                                        Row(
                                                                            children: <Widget>[
                                                                              Stack(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width / 2 -25,
                                                                                    height: 40,
                                                                                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                                    padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: kWhite1),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      initialValue: MAXIMUMWEIGHT != null ? MAXIMUMWEIGHT.toString() : '',
                                                                                      decoration: InputDecoration(
                                                                                          border: UnderlineInputBorder(
                                                                                              borderSide: BorderSide.none
                                                                                          ),
                                                                                          hintText: s233,
                                                                                          hintStyle: st8,
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                          suffixIcon: Container(
                                                                                            alignment: Alignment.center,
                                                                                            height: 20,
                                                                                            width: 20,
                                                                                            margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              color: kWhite1,
                                                                                            ),
                                                                                            child: Text(tollUnit[0].toUpperCase(), style: st11),
                                                                                          )
                                                                                      ),
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          MAXIMUMWEIGHT = int.parse(value);
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                      left: 20,
                                                                                      top: 12,
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                        color: kBlueLight,
                                                                                        child: Text(
                                                                                          vocabular['form_n']['air_craft']['takeoff_weight'],
                                                                                          style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              Stack(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width / 2 -25,
                                                                                    height: 40,
                                                                                    margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                                                    padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: kWhite1),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      initialValue:MAXLANDINGWEIGHT!= null ?  MAXLANDINGWEIGHT.toString() : '',
                                                                                      decoration: InputDecoration(
                                                                                          border: UnderlineInputBorder(
                                                                                              borderSide: BorderSide.none
                                                                                          ),
                                                                                          hintText: s233,
                                                                                          hintStyle: st8,
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                          suffixIcon: Container(
                                                                                            alignment: Alignment.center,
                                                                                            height: 20,
                                                                                            width: 20,
                                                                                            margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              color: kWhite1,
                                                                                            ),
                                                                                            child: Text(tollUnit[0].toUpperCase(), style: st11),
                                                                                          )
                                                                                      ),
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          MAXLANDINGWEIGHT = int.parse(value);
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                      left: 5,
                                                                                      top: 12,
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                        color: kBlueLight,
                                                                                        child: Text(
                                                                                          vocabular['form_n']['air_craft']['posad_weight'],
                                                                                          style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),

                                                                            ]),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 40,
                                                                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                              padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: kWhite1),
                                                                              ),
                                                                              child: TextFormField(
                                                                                initialValue: WEIGHTEMPTYPLAN != null ? WEIGHTEMPTYPLAN.toString() : '',
                                                                                decoration: InputDecoration(
                                                                                    border: UnderlineInputBorder(
                                                                                        borderSide: BorderSide.none
                                                                                    ),
                                                                                    hintText: s233,
                                                                                    hintStyle: st8,
                                                                                    contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                    suffixIcon: Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                      margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        color: kWhite1,
                                                                                      ),
                                                                                      child: Text(tollUnit[0].toUpperCase(), style: st11),
                                                                                    )
                                                                                ),
                                                                                onChanged: (value){
                                                                                  setState(() {
                                                                                    WEIGHTEMPTYPLAN = int.parse(value);
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                                left: 10,
                                                                                top: 12,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                  color: kBlueLight,
                                                                                  child: Text(
                                                                                    vocabular['form_n']['air_craft']['weight_equipment'],
                                                                                    style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),

                                                                      ])),

                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e212 = !e212;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e212? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['air_craft']['aircraft_documents'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                expand: e212,
                                                                child: Column(
                                                                    children: [
                                                                      ListView.builder(
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          shrinkWrap: true,
                                                                          itemCount: majorFleetDocs.length,
                                                                          itemBuilder: (BuildContext context, int index) {
                                                                            majorFleetDocsDate.add(TextEditingController());
                                                                            return Row(
                                                                                children: <Widget>[
                                                                                  Stack(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width / 3+5 ,
                                                                                        height: 40,
                                                                                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                                        padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: kWhite1),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          initialValue:majorFleetDocs[index]['loaded'],
                                                                                          decoration: InputDecoration(
                                                                                            border: UnderlineInputBorder(
                                                                                                borderSide: BorderSide.none
                                                                                            ),
                                                                                            hintText: vocabular['myPhrases']['loaded'],
                                                                                            hintStyle: st8,
                                                                                            contentPadding: new EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
                                                                                          ),
                                                                                          onChanged: (value){
                                                                                            setState(() {
                                                                                              majorFleetDocs[index]['loaded'] = value;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                          left: 15,
                                                                                          top: 12,
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                            color: kBlueLight,
                                                                                            child: Text(
                                                                                              majorFleetDocs[index]['docName'],
                                                                                              style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                            ),
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                  Stack(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width / 3+5,
                                                                                        height: 40,
                                                                                        margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                                                        padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: kWhite1),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          enabled: true,
                                                                                          showCursor: false,
                                                                                          readOnly: true,
                                                                                          //initialValue: majorFleetDocs[index]['expired'],
                                                                                          decoration: InputDecoration(
                                                                                              border: UnderlineInputBorder(
                                                                                                  borderSide: BorderSide.none
                                                                                              ),
                                                                                              hintText: vocabular['form_n']['general']['date_expiration'],
                                                                                              hintStyle: st8,
                                                                                              contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                              suffixIcon: IconButton(
                                                                                                onPressed: () {
                                                                                                  DatePicker.showDatePicker(context,
                                                                                                      showTitleActions: true,
                                                                                                      minTime: DateTime.now(),
                                                                                                      maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                                                                      onChanged: (date) {}, onConfirm: (date) {
                                                                                                        String monthBolb = '';
                                                                                                        String dayBolb = '';
                                                                                                        if(date.month < 10){monthBolb = '0';}
                                                                                                        if(date.day < 10){dayBolb = '0';}
                                                                                                        majorFleetDocsDate[index] = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                                                        majorFleetDocs[index]['expired'] = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                                                        setState(() {});
                                                                                                      }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                                icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                                          ),
                                                                                          onChanged: (value){
                                                                                            setState(() {
                                                                                              majorFleetDocs[index]['expired'] = value;
                                                                                            });
                                                                                          },
                                                                                          controller: majorFleetDocsDate[index],
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                          left: 15,
                                                                                          top: 12,
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                            color: kBlueLight,
                                                                                            child: Text(
                                                                                              vocabular['form_n']['general']['date_expiration'],
                                                                                              style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                            ),
                                                                                          )),
                                                                                    ],
                                                                                  ),

                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      majorFleetDocs.removeAt(index);setState(() {});
                                                                                    },
                                                                                    child:Container(
                                                                                      margin: EdgeInsets.fromLTRB(0,20,0,0),
                                                                                      padding: EdgeInsets.fromLTRB(12,12,12,12),
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(width: 0.5, color: kWhite3),
                                                                                        color: kBlueLight,
                                                                                      ),
                                                                                      child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                                    ),
                                                                                  ),
                                                                                ]);}),

                                                                      Container(
                                                                        height: 40,
                                                                        width: MediaQuery.of(context).size.width,
                                                                        alignment: Alignment.bottomCenter,
                                                                        margin: EdgeInsets.fromLTRB(10,20,10,10),
                                                                        child: TextButton(
                                                                          onPressed:(){
                                                                            Navigator.pushReplacement(context,
                                                                                CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 6)));
                                                                          } ,
                                                                          child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                                                          style: ElevatedButton.styleFrom(
                                                                            primary: kBlueLight,
                                                                            minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                  color: kWhite2,
                                                                                  width: 1,
                                                                                  style: BorderStyle.solid
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(0.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),

                                                              SizedBox(height: 15,),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    e213 = !e213;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(e213? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Text(vocabular['form_n']['owner_obj']['owner_data'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                    isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                                                    isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyMajorFleetOner', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e213,
                                                                  child: Column(
                                                                      children: [
                                                                        ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'].length, //formInListNum
                                                                            itemBuilder: (context, index) {
                                                                              return Container(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                  color: dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                                                  child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children:[
                                                                                        Row(
                                                                                            children:[
                                                                                              Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["value"]}'),),
                                                                                              Spacer(),
                                                                                              GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                                                            ]
                                                                                        ),
                                                                                        Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyMajorFleetOner'][index]["oner"]}', style: st2,)
                                                                                      ]
                                                                                  ));}),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 40,
                                                                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    color: kWhite1),),
                                                                              child: TextFormField(
                                                                                initialValue: onerFleetAddress,
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['owner_obj']['address_owner'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    onerFleetAddress = value;
                                                                                  });
                                                                                },),),
                                                                            Positioned(
                                                                                left: 15, top: 12,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                                  color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['owner_obj']['address_owner'],
                                                                                    style: TextStyle(
                                                                                        color: kWhite.withOpacity(0.3),
                                                                                        fontFamily: 'AlS Hauss',
                                                                                        fontSize: 12),),)),
                                                                          ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 40,
                                                                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    color: kWhite1),),
                                                                              child: TextFormField(
                                                                                initialValue: onerFleetContact,
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['owner_obj']['contact_owner'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    onerFleetContact = value;
                                                                                  });
                                                                                },),),
                                                                            Positioned(
                                                                                left: 15, top: 12,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                                  color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['owner_obj']['contact_owner'],
                                                                                    style: TextStyle(
                                                                                        color: kWhite.withOpacity(0.3),
                                                                                        fontFamily: 'AlS Hauss',
                                                                                        fontSize: 12),),)),
                                                                          ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 40,
                                                                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    color: kWhite1),),
                                                                              child: TextFormField(
                                                                                initialValue: onerFleetControlResidence,
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['general']['supervising_state'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    onerFleetControlResidence = value;
                                                                                  });
                                                                                },),),
                                                                            Positioned(
                                                                                left: 15, top: 12,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                                  color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['supervising_state'],
                                                                                    style: TextStyle(
                                                                                        color: kWhite.withOpacity(0.3),
                                                                                        fontFamily: 'AlS Hauss',
                                                                                        fontSize: 12),),)),
                                                                          ],),
                                                                        Column(
                                                                            children: [
                                                                              ListView.builder(
                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                  shrinkWrap: true,
                                                                                  itemCount: onerFleetDocs.length,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    onerFleetDocsDate.add(TextEditingController());
                                                                                    return Row(
                                                                                        children: <Widget>[
                                                                                          Stack(
                                                                                            children: <Widget>[
                                                                                              Container(
                                                                                                width: MediaQuery.of(context).size.width / 3+5 ,
                                                                                                height: 40,
                                                                                                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                                                padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(color: kWhite1),
                                                                                                ),
                                                                                                child: TextFormField(
                                                                                                  initialValue:onerFleetDocs[index]['loaded'],
                                                                                                  decoration: InputDecoration(
                                                                                                    border: UnderlineInputBorder(
                                                                                                        borderSide: BorderSide.none
                                                                                                    ),
                                                                                                    hintText: vocabular['myPhrases']['loaded'],
                                                                                                    hintStyle: st8,
                                                                                                    contentPadding: new EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
                                                                                                  ),
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      onerFleetDocs[index]['loaded'] = value;
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              Positioned(
                                                                                                  left: 15,
                                                                                                  top: 12,
                                                                                                  child: Container(
                                                                                                    padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                                    color: kBlueLight,
                                                                                                    child: Text(
                                                                                                      onerFleetDocs[index]['docName'],
                                                                                                      style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                                    ),
                                                                                                  )),
                                                                                            ],
                                                                                          ),
                                                                                          Stack(
                                                                                            children: <Widget>[
                                                                                              Container(
                                                                                                width: MediaQuery.of(context).size.width / 3+5,
                                                                                                height: 40,
                                                                                                margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                                                                padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(color: kWhite1),
                                                                                                ),
                                                                                                child: TextFormField(
                                                                                                  enabled: true,
                                                                                                  showCursor: false,
                                                                                                  readOnly: true,
                                                                                                  //initialValue: majorFleetDocs[index]['expired'],
                                                                                                  decoration: InputDecoration(
                                                                                                      border: UnderlineInputBorder(
                                                                                                          borderSide: BorderSide.none
                                                                                                      ),
                                                                                                      hintText: vocabular['form_n']['general']['date_expiration'],
                                                                                                      hintStyle: st8,
                                                                                                      contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                                      suffixIcon: IconButton(
                                                                                                        onPressed: () {
                                                                                                          DatePicker.showDatePicker(context,
                                                                                                              showTitleActions: true,
                                                                                                              minTime: DateTime.now(),
                                                                                                              maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                                                                              onChanged: (date) {}, onConfirm: (date) {
                                                                                                                String monthBolb = '';
                                                                                                                String dayBolb = '';
                                                                                                                if(date.month < 10){monthBolb = '0';}
                                                                                                                if(date.day < 10){dayBolb = '0';}
                                                                                                                onerFleetDocsDate[index] = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                                                                onerFleetDocs[index]['expired'] = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                                                                setState(() {});
                                                                                                              }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                                        icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                                                  ),
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      onerFleetDocs[index]['expired'] = value;
                                                                                                    });
                                                                                                  },
                                                                                                  controller: onerFleetDocsDate[index],
                                                                                                ),
                                                                                              ),
                                                                                              Positioned(
                                                                                                  left: 15,
                                                                                                  top: 12,
                                                                                                  child: Container(
                                                                                                    padding: EdgeInsets.only(bottom: 0, left: 5, right: 0),
                                                                                                    color: kBlueLight,
                                                                                                    child: Text(
                                                                                                      vocabular['form_n']['general']['date_expiration'],
                                                                                                      style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                                                    ),
                                                                                                  )),
                                                                                            ],
                                                                                          ),

                                                                                          GestureDetector(
                                                                                            onTap: (){
                                                                                              onerFleetDocs.removeAt(index);setState(() {});
                                                                                            },
                                                                                            child:Container(
                                                                                              margin: EdgeInsets.fromLTRB(0,20,0,0),
                                                                                              padding: EdgeInsets.fromLTRB(12,12,12,12),
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                                                color: kBlueLight,
                                                                                              ),
                                                                                              child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                                            ),
                                                                                          ),
                                                                                        ]);}),

                                                                              Container(
                                                                                height: 40,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                alignment: Alignment.bottomCenter,
                                                                                margin: EdgeInsets.fromLTRB(10,20,10,10),
                                                                                child: TextButton(
                                                                                  onPressed:(){
                                                                                    Navigator.pushReplacement(context,
                                                                                        CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 7)));
                                                                                  } ,
                                                                                  child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    primary: kBlueLight,
                                                                                    minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      side: BorderSide(
                                                                                          color: kWhite2,
                                                                                          width: 1,
                                                                                          style: BorderStyle.solid
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),

                                                                      ])),
                                                            ])),
                                                  ]))),
                                        ]))
                              ])),
                      //секция РЕЗЕРВНЫЕ ВОЗДУШНЫЕ СУДА
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e3 = !e3;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e3? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s255,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'aviacompanyReservFleets', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e3,
                                    child: Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['aviacompanyReservFleets'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          SizedBox(height: 10,),
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                  width:MediaQuery.of(context).size.width - 100 ,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(vocabular['form_n']['aircraft_reserve_obj']['use_aircraft_backup'], style: st14),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,5,0,5),
                                                  width:MediaQuery.of(context).size.width ,
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                                        FlutterSwitch(
                                                          width: 36.0,
                                                          height: 22.0,
                                                          toggleColor: Color(0xFFFFFFFF),
                                                          activeColor: kYellow,
                                                          inactiveColor: kWhite2,
                                                          padding: 2.0,
                                                          toggleSize: 18.0,
                                                          borderRadius: 11.0,
                                                          value: reservFleet, //изменить переменную
                                                          onToggle: (value) {
                                                            setState(() {
                                                              reservFleet = value; //изменить переменную
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                              ]),
                                          !reservFleet ? reservFleetsListing ? ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: reservFleets.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                    child: Column(
                                                        children:[
                                                          SizedBox(height: 10,),
                                                          Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width ,
                                                                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                                  decoration: BoxDecoration(
                                                                    color: kBlue,
                                                                  ),
                                                                  child:Container(
                                                                    padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                                    width:MediaQuery.of(context).size.width,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlue,
                                                                    ),
                                                                    child:Text(reservFleets[index][0]['REGNO']),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    left: 10,
                                                                    top: 2,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(vocabular['myPhrases']['regNumPlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                      ),
                                                                    )),
                                                                Positioned(
                                                                  right:0, top:0, child:
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    reservFleets.removeAt(index);setState(() {});
                                                                  },
                                                                  child:Container(
                                                                    margin: EdgeInsets.fromLTRB(0,10.5,0,0),
                                                                    padding: EdgeInsets.fromLTRB(12.5,12.5,12.5,12.5),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlueLight,
                                                                    ),
                                                                    child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                  ),
                                                                ),
                                                                )
                                                              ]),
                                                          Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width ,
                                                                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                                  decoration: BoxDecoration(
                                                                    color: kBlue,
                                                                  ),
                                                                  child:Container(
                                                                    padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                                    width:MediaQuery.of(context).size.width,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlue,
                                                                    ),
                                                                    child:Text('${reservFleets[index][0]['aircraft']['acfthist']['ICAOLAT4'] != null ? reservFleets[index][0]['aircraft']['acfthist']['ICAOLAT4']  : 'Не заполнено'}'),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    left: 10,
                                                                    top: 2,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(vocabular['myPhrases']['typePlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                      ),
                                                                    )),

                                                              ]),
                                                          Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width ,
                                                                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                                  decoration: BoxDecoration(
                                                                    color: kBlue,
                                                                  ),
                                                                  child:Container(
                                                                    padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                                    width:MediaQuery.of(context).size.width,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlue,
                                                                    ),
                                                                    child:Text('${reservFleets[index][0]['aircraft']['TYPE'] != null ? reservFleets[index][0]['aircraft']['TYPE']  : 'Не заполнено'}'),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    left: 10,
                                                                    top: 2,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(vocabular['myPhrases']['modelPlane'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                      ),
                                                                    )),

                                                              ]),
                                                          Divider(),
                                                        ])
                                                );}) : Container(): Container(),
                                          !reservFleet ? Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(0,20,0,15),
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.pushReplacement(context,
                                                    CupertinoPageRoute(builder: (context) => reservFleetSelectPage()));
                                              } ,
                                              child: Text(vocabular['form_n']['air_craft']['add_reserve_aircraft'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ) : Container(),

                                        ]))
                              ])),
                      //секция МАРШРУТ
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e4 = !e4;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e4? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s113,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e4,
                                    child: Column(
                                        children: [
                                          SizedBox(height: 20),

                                         //драгалка
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                                            height:  150.0 * (routes.length / (MediaQuery.of(context).size.width > 720 ? (MediaQuery.of(context).size.width / 360).ceil() : 1)).ceil() + 40,
                                            child: DragAndDropGridView(
                                              controller: _scrollController,
                                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 360,
                                                  mainAxisExtent: 150,
                                                  crossAxisSpacing: 5,
                                                  mainAxisSpacing: 10),
                                              //padding: EdgeInsets.all(20),
                                              itemBuilder: (context, index) => Card(
                                                elevation: 2,
                                                child: Container( child:
                                                GestureDetector( onTap: (){
                                                  if(routes[index]['switch'] == 0) {
                                                    for (int i = 0; i <routes.length; i++) {routes[i]['switch'] =0;}
                                                    setState(() {
                                                      routes[index]['switch'] =1;
                                                      routes[index]['switchMenu'] = 0;
                                                    });
                                                  }else{setState(() {routes[index]['switch'] =0;
                                                  routes[index]['switchMenu'] = 0;
                                                  });}
                                                } ,child:Container(
                                                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                    color: routes[index]['switch'] == 1 ? kBlueLight : kBlue,
                                                  ),
                                                  child:Stack(
                                                      children: [
                                                        Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    Text('${formFromRestr['NForm']['flights'][index]['flight_information']['departure_airport_icao'].substring(0, formFromRestr['NForm']['flights'][index]['flight_information']['departure_airport_icao'].length > 4 ? 4 : formFromRestr['NForm']['flights'][index]['flight_information']['departure_airport_icao'].length)}',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                    Text(' → ',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                    Text('${formFromRestr['NForm']['flights'][index]['flight_information']['landing_airport_icao'].substring(0, formFromRestr['NForm']['flights'][index]['flight_information']['landing_airport_icao'].length > 4 ? 4 : formFromRestr['NForm']['flights'][index]['flight_information']['landing_airport_icao'].length)}',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                    Spacer(),
                                                                    /*GestureDetector(onTap: (){setState(() {
                                                                      routes[index]['switchMenu'] = 1;
                                                                    });}, child:Text(' . . . ',style:TextStyle(fontSize: 25.0,fontFamily: 'AlS Hauss', color:  kWhite,)),),*/
                                                                  ]),
                                                              Container( padding: EdgeInsets.fromLTRB(0,0,30,0), child:Text('${formFromRestr['NForm']['flights'][index]['flight_information']['flight_num']} / ${todayIs.format(DateTime.parse(formFromRestr['NForm']['flights'][index]['main_date']['date']))} ${vocabular['myPhrases']['to']} ${formFromRestr['NForm']['flights'][index]['flight_information']['departure_time'].substring(0,5)} ➔ ${todayIs.format(DateTime.parse(formFromRestr['NForm']['flights'][index]['main_date']['date']))} ${vocabular['myPhrases']['to']} ${formFromRestr['NForm']['flights'][index]['flight_information']['landing_time'].substring(0,5)}', style:st14),),
                                                              Row(
                                                                  children: <Widget>[
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        //Text('${vocabular['form_n']['flight_crew']}: ${pilots.length + fplPilots.length}', style: st14),
                                                                        Text('${vocabular['form_n']['flight_crew']}: ${formFromRestr['NForm']['flights'][index]['crew'].length}', style: st14),
                                                                        //Text('${vocabular['form_n']['cargo']}: ${cargoItem.length}', style: st14),
                                                                        Text('${vocabular['form_n']['cargo']}: ${formFromRestr['NForm']['flights'][index]['cargos'].length}', style: st14),
                                                                      ],
                                                                    ),
                                                                    SizedBox(width:20),
                                                                    Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text('${vocabular['form_n']['passengers']}: 0', style: st14),
                                                                          Text('${vocabular['form_n']['main_departure_date_obj']['repetitions']}: 0', style: st14),
                                                                          //Text('${vocabular['form_n']['passengers']}: ${passengers.length}', style: st14),
                                                                          //Text('${vocabular['form_n']['main_departure_date_obj']['repetitions']}: ${repeatsDate.length+repeatsPeriod.length}', style: st14),
                                                                        ]),
                                                                  ]),
                                                              Text(vocabular['myPhrases']['draft'])
                                                            ]),
                                                        routes[index]['switchMenu'] == 1 ? Positioned(top:10, right:20, child: Container(
                                                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                            alignment: Alignment.centerLeft,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(width: 0.5, color: kWhite3),
                                                              color: kBlueLight,
                                                            ),
                                                            child:Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children:[
                                                                  GestureDetector(onTap: (){
                                                                    routes.add(json.decode(json.encode(routes[index])));
                                                                    setState(() {
                                                                      routes[index]['switchMenu'] = 0;
                                                                    });
                                                                  }, child:Text(vocabular['form_n']['route_obj']['duplicate'], style: st17)),
                                                                  GestureDetector(onTap: (){
                                                                    routes.add(json.decode(json.encode(routes[index])));
                                                                    routes.last['portOut'] = routes[index]['portIn'];
                                                                    routes.last['portIn'] = routes[index]['portOut'];
                                                                    setState(() {
                                                                      routes[index]['switchMenu'] = 0;
                                                                    });
                                                                  }, child:Text(vocabular['form_n']['route_obj']['add_return_flight'], style: st17)),
                                                                  GestureDetector(onTap: (){setState(() {
                                                                    routes.removeAt(index);setState(() {});
                                                                  });}, child:Text(vocabular['myPhrases']['delete'], style: st17)),
                                                                  GestureDetector(onTap: (){setState(() {
                                                                    routes[index]['switchMenu'] = 0;
                                                                  });}, child:Text(vocabular['form_n']['route_obj']['cancel'], style: st17)),
                                                                ]
                                                            )
                                                        )) : Container()
                                                      ]),
                                                ),),

                                                ),),
                                              isCustomChildWhenDragging: true,
                                              childWhenDragging: (pos) => Container(
                                                margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                  color: kBlueLight,
                                                ),

                                              ),
                                              itemCount: formFromRestr['NForm']['flights'].length, //formFromRestr['NForm']['flights']['airline_represent']['updated_at']
                                              onWillAccept: (oldIndex, newIndex) {
                                                // Implement you own logic
                                                // Example reject the reorder if the moving item's value is something specific
                                                if (formFromRestr['NForm']['flights'][newIndex] == "something") {
                                                  return false;
                                                }
                                                return true; // If you want to accept the child return true or else return false
                                              },
                                              onReorder: (oldIndex, newIndex) {
                                                final temp = formFromRestr['NForm']['flights'][oldIndex];
                                                formFromRestr['NForm']['flights'][oldIndex] = formFromRestr['NForm']['flights'][newIndex];
                                                formFromRestr['NForm']['flights'][newIndex] = temp;
                                                setState(() {});
                                              },
                                            ),
                                          ),

                                          //драгалка

                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: formFromRestr['NForm']['flights'].length,
                                              itemBuilder: (BuildContext context, int index) {
                                                routesTimeOut.add(TextEditingController());
                                                routesTimeIn.add(TextEditingController());
                                                return Container( child: Column ( children: <Widget> [

                                                  routes[index]['switch'] != 0 ?Container(
                                                      child:Column(
                                                          children: <Widget>[
                                                            //номер рейса
                                                            Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 50,
                                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: kWhite1),
                                                                  ),
                                                                  child: TextFormField(
                                                                    initialValue: formFromRestr['NForm']['flights'][0]['flight_num'],
                                                                    decoration: InputDecoration(
                                                                      border: UnderlineInputBorder(
                                                                          borderSide: BorderSide.none
                                                                      ),
                                                                      hintText: vocabular['registry']['flight_number'],
                                                                      hintStyle: st8,
                                                                      contentPadding: EdgeInsets.only(bottom: 5, left: 0, right: 10),
                                                                    ),
                                                                    
                                                                  ),
                                                                ),
                                                                routes[index]['marshruteNumber'].length > 0 ? Positioned(
                                                                    left: 12,
                                                                    top: 12,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(
                                                                        vocabular['registry']['flight_number'],
                                                                        style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                      ),
                                                                    )):Container(),
                                                              ],
                                                            ),
                                                            Row(
                                                                children:<Widget>[
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      //цель превозки
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width/2-15,
                                                                        height: 50,
                                                                        margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                                        padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: kWhite1),
                                                                        ),
                                                                        child:  DropdownButton<String>(
                                                                          isExpanded: true,
                                                                          value: routes[index]['marshruteTarget'],
                                                                          icon: Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color: kWhite2,
                                                                          ),
                                                                          iconSize: 24,
                                                                          elevation: 16,
                                                                          style: st1,
                                                                          underline: Container(),
                                                                          onChanged: (String newValue) {
                                                                            setState(() {
                                                                              routes[index]['marshruteTarget'] = newValue;
                                                                            });
                                                                          },
                                                                          items: routTargets.map<DropdownMenuItem<String>>((dynamic value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child:Text(value),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ),
                                                                      routes[index]['marshruteTarget'].length > 0 ? Positioned(
                                                                          left: 12,
                                                                          top: 12,
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                            color: kBlue,
                                                                            child: Text(vocabular['form_n']['purpose_flight'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                          )):Container(),
                                                                    ],
                                                                  ),
                                                                  //категория преевозки
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width/2-15,
                                                                        height: 50,
                                                                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                        padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: kWhite1),
                                                                        ),
                                                                        child:  DropdownButton<String>(
                                                                          isExpanded: true,
                                                                          //value: routes[index]['transferCategory'],
                                                                          value: 'Коммерческий',
                                                                          icon: Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color: kWhite2,
                                                                          ),
                                                                          iconSize: 24,
                                                                          elevation: 16,
                                                                          style: st1,
                                                                          underline: Container(),
                                                                          onChanged: (String newValue) {
                                                                            setState(() {
                                                                              routes[index]['transferCategory'] = newValue;
                                                                            });
                                                                          },
                                                                          items: deliveryCategory.map<DropdownMenuItem<String>>((dynamic value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Text(value),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ),
                                                                      routes[index]['transferCategory'].length > 0 ? Positioned(
                                                                          left: 12,
                                                                          top: 12,
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                            color: kBlue,
                                                                            child: Text(vocabular['myPhrases']['transferCategory'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                          )):Container(),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),

                                                            Row(
                                                                children: <Widget>[
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        width:MediaQuery.of(context).size.width /3*2-20,
                                                                        padding: EdgeInsets.fromLTRB(0,30,10,10),
                                                                        decoration: BoxDecoration(
                                                                          color: kBlue,
                                                                        ),
                                                                        child:Container(
                                                                          padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                                          width:MediaQuery.of(context).size.width,
                                                                          height: 50,
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(width: 0.5, color: kWhite3),
                                                                            color: kBlue,
                                                                          ),
                                                                          child:Text('${formFromRestr['NForm']['flights'][index]['departure_airport_icao'].substring(0, formFromRestr['NForm']['flights'][index]['departure_airport_icao'].length > 4 ? 4 : formFromRestr['NForm']['flights'][index]['departure_airport_icao'].length)}'),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                          left: 10,
                                                                          top: 20,
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(
                                                                                bottom: 0, left: 10, right: 10),
                                                                            color: kBlue,
                                                                            child: Text(vocabular['myPhrases']['airportFlight'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                            ),
                                                                          )),
                                                                      Positioned(
                                                                        right: 0,
                                                                        top: 40,
                                                                        child: Container(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 0, left: 10, right: 10),
                                                                          color: Colors.transparent,
                                                                          child: Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color: kWhite2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //аэродром вылета

                                                                  //время вылета
                                                                  Stack(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width/3-10,
                                                                          height: 50,
                                                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                          padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: formFromRestr['NForm']['flights'][index]['departure_time'],
                                                                            enabled: true,
                                                                            showCursor: false,
                                                                            readOnly: true,
                                                                            decoration: InputDecoration(
                                                                                border: UnderlineInputBorder(
                                                                                    borderSide: BorderSide.none
                                                                                ),
                                                                                hintText: vocabular['registry']['departure_time'],
                                                                                hintStyle: st8,
                                                                                contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                /*suffixIcon: IconButton(
                                                                                  onPressed: () {
                                                                                    DatePicker.showTimePicker(context,
                                                                                        showTitleActions: true,
                                                                                        onChanged: (date) {}, onConfirm: (date) {
                                                                                          String minuteBolb = '';
                                                                                          String hourBolb = '';
                                                                                          if(date.minute < 10){minuteBolb = '0';}
                                                                                          if(date.hour < 10){hourBolb = '0';}
                                                                                          routesTimeOut[index] = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                                                          routes[index]['timeOut'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                                                          setState(() {});
                                                                                        }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                  icon: Icon(Icons.access_time, size: 16),)*/
                                                                            ),
                                                                            /*onChanged: (value){
                                                                              setState(() {
                                                                                routes[index]['timeOut'] = value;
                                                                              });
                                                                            },*/
                                                                            //controller: routesTimeOut[index],
                                                                          ),
                                                                        ),
                                                                        routes[index]['timeOut'].length > 0 ? Positioned(
                                                                            left: 12,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                              color: kBlue,
                                                                              child: Text(vocabular['registry']['departure_time'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                            )):Container(),
                                                                      ]),
                                                                ]),
                                                            Row(
                                                                children: <Widget>[
                                                                  //аэродром посадки
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        width:MediaQuery.of(context).size.width /3*2-20,
                                                                        padding: EdgeInsets.fromLTRB(0,30,10,10),
                                                                        decoration: BoxDecoration(
                                                                          color: kBlue,
                                                                        ),
                                                                        child:Container(
                                                                          padding: EdgeInsets.fromLTRB(10,10,40,10),
                                                                          width:MediaQuery.of(context).size.width /3*2-20,
                                                                          height: 50,
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(width: 0.5, color: kWhite3),
                                                                            color: kBlue,
                                                                          ),
                                                                          child:Text('${formFromRestr['NForm']['flights'][index]['landing_airport_icao'].substring(0, formFromRestr['NForm']['flights'][index]['landing_airport_icao'].length > 4 ? 4 : formFromRestr['NForm']['flights'][index]['landing_airport_icao'].length)}'),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                          left: 10,
                                                                          top: 20,
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(
                                                                                bottom: 0, left: 10, right: 10),
                                                                            color: kBlue,
                                                                            child: Text(vocabular['myPhrases']['airportLanding'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                            ),
                                                                          )),
                                                                      Positioned(
                                                                        right: 0,
                                                                        top: 40,
                                                                        child: Container(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 0, left: 10, right: 10),
                                                                          color: Colors.transparent,
                                                                          child: Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color: kWhite2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //время посадки
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width/3-10,
                                                                        height: 50,
                                                                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                        padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: kWhite1),
                                                                        ),
                                                                        child: TextFormField(
                                                                          initialValue: formFromRestr['NForm']['flights'][index]['landing_time'],
                                                                          enabled: true,
                                                                          showCursor: false,
                                                                          readOnly: true,
                                                                          decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['registry']['boarding_time'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                              /*suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                  DatePicker.showTimePicker(context,
                                                                                      showTitleActions: true,
                                                                                      onChanged: (date) {}, onConfirm: (date) {
                                                                                        String minuteBolb = '';
                                                                                        String hourBolb = '';
                                                                                        if(date.minute < 10){minuteBolb = '0';}
                                                                                        if(date.hour < 10){hourBolb = '0';}
                                                                                        routesTimeIn[index] = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                                                        routes[index]['timeIn'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                                                        setState(() {});
                                                                                      }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                icon: Icon(Icons.access_time, size: 16),)*/
                                                                          ),
                                                                          /*onChanged: (value){
                                                                            setState(() {
                                                                              routes[index]['timeIn'] = value;
                                                                            });
                                                                          },*/
                                                                          //controller: routesTimeIn[index],
                                                                        ),
                                                                      ),
                                                                      routes[index]['timeIn'].length > 0 ? Positioned(
                                                                          left: 12,
                                                                          top: 12,
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                            color: kBlue,
                                                                            child: Text(vocabular['registry']['boarding_time'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                          )):Container(),
                                                                    ],
                                                                  ),
                                                                ]),

                                                            //точки маршрута
                                                            GestureDetector( onTap: (){
                                                              if(selectedPoints.length > 0){selectedPoints.removeAt(0);}
                                                              Navigator.pushReplacement(context,
                                                                  CupertinoPageRoute(builder: (context) => pointSelectPage(routNum: index, )));
                                                            },child:Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 100,
                                                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: kWhite1),
                                                                    ),
                                                                    child:routes[index]['inOutPoints'].length > 0 ? GridView.builder(
                                                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                            maxCrossAxisExtent: 200,
                                                                            childAspectRatio: 3 / 0.6,
                                                                            crossAxisSpacing: 10,
                                                                            mainAxisSpacing: 10),
                                                                        itemCount: routes[index]['inOutPoints'].length,
                                                                        itemBuilder: (BuildContext ctx, index2) {
                                                                          return
                                                                            routes[index]['inOutPoints'][index2]['point'] != null ? Container(
                                                                                height: 40,
                                                                                padding: EdgeInsets.fromLTRB(10,5,5,5),
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(width: 0.5, color: kBlueLight),
                                                                                  borderRadius: BorderRadius.circular(14.0),
                                                                                  color: kBlueLight,
                                                                                ),child: Row(
                                                                                children: [
                                                                                  Text('${routes[index]['inOutPoints'][index2]['point'].substring(0, 5)}', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                                  Text('${routes[index]['inOutPoints'][index2]['time']}', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite2,)),
                                                                                  routes[index]['inOutPoints'][index2]['reservPoints'] != null ? routes[index]['inOutPoints'][index2]['reservPoints'].length > 0 ? Text('ALT(${routes[index]['inOutPoints'][index2]['reservPoints'].length})', style: TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kYellow)) : Container():Container(),
                                                                                  GestureDetector( onTap: (){ routes[index]['inOutPoints'].removeAt(index2); /*selectedPoints.removeAt(index2);*/ setState(() {});}, child:Icon(Icons.clear, color: kWhite, size: 16,))
                                                                                ])
                                                                            ): Container()/*)*/;}) : Text(vocabular['form_n']['route_obj']['points_entry_exit_rf'])
                                                                ),
                                                                Positioned(
                                                                    left: 12,
                                                                    top: 12,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(vocabular['form_n']['route_obj']['points_entry_exit_rf'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                    )),
                                                              ],
                                                            ),),
                                                            //тип посадки
                                                            Stack(
                                                              children: <Widget>[
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 50,
                                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: kWhite1),
                                                                  ),
                                                                  child:  DropdownButton<String>(
                                                                    isExpanded: true,
                                                                    value: /*routes[index]['landingType'] != null ? routes[index]['landingType'] :*/'Коммерческая посадка' ,
                                                                    icon: Icon(
                                                                      Icons.keyboard_arrow_down,
                                                                      color: kWhite2,
                                                                    ),
                                                                    iconSize: 24,
                                                                    elevation: 16,
                                                                    style: st1,
                                                                    underline: Container(),
                                                                    onChanged: (String newValue) {
                                                                      setState(() {
                                                                        routes[index]['landingType'] = newValue;
                                                                      });
                                                                    },
                                                                    items: landingTypes.map<DropdownMenuItem<String>>((dynamic value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child:Text(value),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                                routes[index]['landingType'].length > 0 ? Positioned(
                                                                    left: 12,
                                                                    top: 12,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                      color: kBlue,
                                                                      child: Text(vocabular['form_n']['route_obj']['landing_type'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                    )):Container(),
                                                              ],
                                                            ),
                                                            /*Container(
                                                        width:MediaQuery.of(context).size.width ,
                                                        margin: EdgeInsets.fromLTRB(0,10,0,0),
                                                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                        decoration: BoxDecoration(
                                                          color: kBlueLight,
                                                        ),
                                                        child: Text('Посадка вне регламента работы АД требует предоставления документа, подтверждающего право посадки в указанные даты')),

                                                    Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          width:MediaQuery.of(context).size.width ,
                                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                          decoration: BoxDecoration(
                                                            color: kBlueLight,
                                                          ),
                                                          child: Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                  width:MediaQuery.of(context).size.width - 90,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(width: 0.5, color: kWhite3),
                                                                    color: kBlueLight,
                                                                  ),
                                                                  child:Text(routes[index]['landingTypeDoc'] != null ? routes[index]['landingTypeDoc'] : ''),
                                                                ),
                                                                SizedBox(width: 10,),
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    dialogScreen(context, 'Раздел находится в разработке');
                                                                  },
                                                                  child:Container(
                                                                    padding: EdgeInsets.fromLTRB(12,12,12,12),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlueLight,
                                                                    ),
                                                                    child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Positioned(
                                                            left: 22,
                                                            top: 2,
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: 0, left: 10, right: 10),
                                                              color: kBlueLight,
                                                              child: Text('Документ, подтверждающий право посадки',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                              ),
                                                            )),
                                                      ],
                                                    ),*/
                                                          ]
                                                      )
                                                  ):Container(),
                                                ])
                                                );
                                              }),
                                          //кнопка добавить рейс
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                                            child: TextButton(
                                              onPressed:(){
                                                routes.add(json.decode('{"switch" : 0, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "28.04.2021","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс","portOut" : "", "timeOut" : "0", "portIn": "", "timeIn" : "0", "inOutPoints" : [{"pointName" : "0", "pointTime" : "0"}], "landingType" : "Техническая посадка"}'));
                                                setState(() {

                                                });
                                              } ,
                                              child: Text(vocabular['form_n']['route_obj']['add_new_flight'], style: st12,textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]))
                              ])),
                      //секция ОСНОВНАЯ ДАТА ВЫЛЕТА
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e5 = !e5;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e5? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s256,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'dateFlight', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e5,
                                    child: Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['dateFlight'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['dateFlight'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['dateFlight'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 40,
                                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: kWhite1),
                                                ),
                                                child: TextFormField(
                                                  enabled: true,
                                                  showCursor: false,
                                                  readOnly: true,
                                                  initialValue: formFromRestr['NForm']['flights'][0]['main_date']['date'],
                                                  decoration: InputDecoration(
                                                      border: UnderlineInputBorder(
                                                          borderSide: BorderSide.none
                                                      ),
                                                      hintText: vocabular['form_n']['main_departure_date_obj']['main_date'],
                                                      hintStyle: st8,
                                                      contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                      /*suffixIcon: IconButton(
                                                        onPressed: () {
                                                          DatePicker.showDatePicker(context,
                                                              showTitleActions: true,
                                                              minTime: DateTime.now(),
                                                              maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                              onChanged: (date) {}, onConfirm: (date) {
                                                                String monthBolb = '';
                                                                String dayBolb = '';
                                                                if(date.month < 10){monthBolb = '0';}
                                                                if(date.day < 10){dayBolb = '0';}
                                                                _majorDateFlight = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                majorDateFlight = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                setState(() {});
                                                              }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                        icon: Icon(CupertinoIcons.calendar, size: 16),)*/
                                                  ),
                                                  /*onChanged: (value){
                                                    setState(() {
                                                      majorDateFlight = value;
                                                    });
                                                  },*/
                                                  //controller: _majorDateFlight,
                                                ),
                                              ),
                                              Positioned(
                                                  left: 15,
                                                  top: 12,
                                                  child: Container(
                                                    padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(
                                                      vocabular['form_n']['main_departure_date_obj']['main_date'],
                                                      style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                    ),
                                                  )),
                                            ],
                                          ),

                                          Row(
                                              children: [
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/2-15,
                                                      height: 40,
                                                      margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: kWhite1),
                                                      ),
                                                      child: TextFormField(
                                                        style: st1,
                                                        readOnly: true,
                                                        decoration: InputDecoration(
                                                          border: UnderlineInputBorder(
                                                              borderSide: BorderSide.none
                                                          ),
                                                          hintText: 'Идентификатор слота АД вылета',
                                                          hintStyle: st8,
                                                          contentPadding: new EdgeInsets.symmetric(
                                                              vertical: 2, horizontal: 10.0),
                                                          suffixIcon: IconButton(
                                                            onPressed: () {},
                                                            icon: Image.asset(
                                                                'icons/lockIcon.png', width: 16,
                                                                height: 16,
                                                                fit: BoxFit.fitHeight),
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            idAdSlotOut = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                        left: 15,
                                                        top: 10,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(
                                                            'ИС АД вылета',
                                                            style: TextStyle(color: kWhite.withOpacity(0.3),
                                                                fontFamily: 'AlS Hauss',
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 2 - 15,
                                                      height: 40,
                                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                                          hintText: 'Идентификатор слота АД посадки',
                                                          hintStyle: st8,
                                                          contentPadding: new EdgeInsets.symmetric(
                                                              vertical: 12, horizontal: 10.0),

                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            idAdSlotIn = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                        left: 15,
                                                        top: 10,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(
                                                            'ИС АД посадки',
                                                            style: TextStyle(color: kWhite.withOpacity(0.3),
                                                                fontFamily: 'AlS Hauss',
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ]),
                                          SizedBox(height: 20,),
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                  width:MediaQuery.of(context).size.width - 100 ,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(vocabular['form_n']['main_departure_date_obj']['recurring_flight'], style: st14),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,5,0,5),
                                                  width:MediaQuery.of(context).size.width ,
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width:MediaQuery.of(context).size.width - 60,),
                                                        FlutterSwitch(
                                                          width: 36.0,
                                                          height: 22.0,
                                                          toggleColor: Color(0xFFFFFFFF),
                                                          activeColor: kYellow,
                                                          inactiveColor: kWhite2,
                                                          padding: 2.0,
                                                          toggleSize: 18.0,
                                                          borderRadius: 11.0,
                                                          value: repeats, //изменить переменную
                                                          onToggle: (value) {
                                                            setState(() {
                                                              repeats = value; //изменить переменную
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                              ]),

                                        ]))
                              ])),
                      //секция ПОВТОРЫ
                      repeats == true ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e6 = !e6;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e6? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s257,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'repeats', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e6,
                                    child: Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['repeats'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['repeats'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['repeats'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['repeats'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.5),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['repeats'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['repeats'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['repeats'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['repeats'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['repeats'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['repeats'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          SizedBox(height: 10,),
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,8,0,0),
                                                  width:MediaQuery.of(context).size.width - 100 ,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(vocabular['form_n']['main_departure_date_obj']['specify_dates'], style: !datePeriod ? st4 : st14),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,5,0,5),
                                                  width:MediaQuery.of(context).size.width ,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width:MediaQuery.of(context).size.width/2-36,),
                                                        FlutterSwitch(
                                                          width: 36.0,
                                                          height: 22.0,
                                                          toggleColor: Color(0xFFFFFFFF),
                                                          activeColor: kYellow,
                                                          inactiveColor: kWhite2,
                                                          padding: 2.0,
                                                          toggleSize: 18.0,
                                                          borderRadius: 11.0,
                                                          value: datePeriod, //изменить переменную
                                                          onToggle: (value) {
                                                            setState(() {
                                                              datePeriod = value; //изменить переменную
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,8,0,0),
                                                  width:MediaQuery.of(context).size.width ,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(vocabular['form_n']['main_departure_date_obj']['specify_period'], style: datePeriod ? st4 : st14),
                                                ),
                                              ]),
                                          SizedBox(height:10),
                                          //ctкция указать датами
                                          !datePeriod ? Column(
                                              children: [
                                                ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: repeatsDate.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      repeatDates.add(TextEditingController());
                                                      return Row(
                                                          children: <Widget>[
                                                            Stack(
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width -90,
                                                                    height: 40,
                                                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                    alignment: Alignment.centerLeft,
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
                                                                          hintText: 'Дата №${index+1}',
                                                                          hintStyle: st8,
                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                          suffixIcon: IconButton(
                                                                            onPressed: () {
                                                                              DatePicker.showDatePicker(context,
                                                                                  showTitleActions: true,
                                                                                  minTime: DateTime.now(),
                                                                                  maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                                                  onChanged: (date) {}, onConfirm: (date) {
                                                                                    String monthBolb = '';
                                                                                    String dayBolb = '';
                                                                                    if(date.month < 10){monthBolb = '0';}
                                                                                    if(date.day < 10){dayBolb = '0';}
                                                                                    repeatDates[index] = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                                    repeatsDate[index] = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                                    setState(() {});
                                                                                  }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                            icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                      ),
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          repeatsDate[index] = value;
                                                                        });
                                                                      },
                                                                      controller: repeatDates[index],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                      left: 15,
                                                                      top: 12,
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                        color: kBlue,
                                                                        child: Text(
                                                                          'Дата №${index+1}',
                                                                          style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                        ),
                                                                      )),
                                                                ]),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: () {
                                                                repeatsDate.removeAt(index);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.5,color: kWhite3),
                                                                  color: kBlue,
                                                                ),
                                                                child: Image.asset('icons/delete.png',width: 12,height: 12,fit: BoxFit.fitHeight),
                                                              ),
                                                            ),
                                                          ]);}),
                                                Row(
                                                    children: [
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width/2-15,
                                                            height: 40,
                                                            margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                                                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: kWhite1),
                                                            ),
                                                            child: TextFormField(
                                                              style: st1,
                                                              readOnly: true,
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none
                                                                ),
                                                                hintText: 'Идентификатор слота АД вылета',
                                                                hintStyle: st8,
                                                                contentPadding: new EdgeInsets.symmetric(
                                                                    vertical: 2, horizontal: 10.0),
                                                                suffixIcon: IconButton(
                                                                  onPressed: () {},
                                                                  icon: Image.asset(
                                                                      'icons/lockIcon.png', width: 16,
                                                                      height: 16,
                                                                      fit: BoxFit.fitHeight),
                                                                ),
                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  idAdSlotOut = value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Positioned(
                                                              left: 15,
                                                              top: 10,
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: 0, left: 10, right: 10),
                                                                color: kBlue,
                                                                child: Text(
                                                                  'ИС АД вылета',
                                                                  style: TextStyle(color: kWhite.withOpacity(0.3),
                                                                      fontFamily: 'AlS Hauss',
                                                                      fontSize: 12),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width / 2 - 15,
                                                            height: 40,
                                                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                                                hintText: 'Идентификатор слота АД посадки',
                                                                hintStyle: st8,
                                                                contentPadding: new EdgeInsets.symmetric(
                                                                    vertical: 12, horizontal: 10.0),

                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  idAdSlotIn = value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Positioned(
                                                              left: 15,
                                                              top: 10,
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: 0, left: 10, right: 10),
                                                                color: kBlue,
                                                                child: Text(
                                                                  'ИС АД посадки',
                                                                  style: TextStyle(color: kWhite.withOpacity(0.3),
                                                                      fontFamily: 'AlS Hauss',
                                                                      fontSize: 12),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ]),
                                                Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.bottomCenter,
                                                  margin: EdgeInsets.fromLTRB(0,20,0,0),
                                                  child: TextButton(
                                                    onPressed:(){repeatsDate.add('00.00.000');setState(() {});print(repeatsDate);} ,
                                                    child: Text(vocabular['form_n']['route_obj']['add_departure_date'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: kBlue,
                                                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: kWhite2,
                                                            width: 1,
                                                            style: BorderStyle.solid
                                                        ),
                                                        borderRadius: BorderRadius.circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ])
                                          //раздел конструктор дат периодов
                                              :Column(
                                              children:[


                                                //период
                                                ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: repeatsPeriod.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      periodsEnd.add(TextEditingController());
                                                      periodsStart.add(TextEditingController());
                                                      return Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Text('Период № ${index+1}',style: st8,),
                                                                SizedBox(width: 5,),
                                                                Expanded(
                                                                  child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                                children: [
                                                                  Spacer(),
                                                                  Stack(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width /2-45,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          alignment: Alignment.centerLeft,
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
                                                                                hintText: vocabular['form_n']['general']['date_beginning'],
                                                                                hintStyle: st8,
                                                                                contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                suffixIcon: IconButton(
                                                                                  onPressed: () {
                                                                                    DatePicker.showDatePicker(context,
                                                                                        showTitleActions: true,
                                                                                        minTime: DateTime.now(),
                                                                                        maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                                                        onChanged: (date) {}, onConfirm: (date) {
                                                                                          String monthBolb = '';
                                                                                          String dayBolb = '';
                                                                                          if(date.month < 10){monthBolb = '0';}
                                                                                          if(date.day < 10){dayBolb = '0';}
                                                                                          periodsStart[index] = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                                          repeatsPeriod[index]['start'] = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                                          setState(() {});
                                                                                        }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                  icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                            ),
                                                                            onChanged: (value){
                                                                              setState(() {
                                                                                repeatsPeriod[index]['start'] = value;
                                                                              });
                                                                            },
                                                                            controller: periodsStart[index],
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 10,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0, left: 5, right: 5),
                                                                              color: kBlue,
                                                                              child: Text(
                                                                                vocabular['form_n']['general']['date_beginning'],
                                                                                style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                  Spacer(),
                                                                  Stack(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width /2-45,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          alignment: Alignment.centerLeft,
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
                                                                                hintText: vocabular['form_n']['general']['date_expiration'],
                                                                                hintStyle: st8,
                                                                                contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                                suffixIcon: IconButton(
                                                                                  onPressed: () {
                                                                                    DatePicker.showDatePicker(context,
                                                                                        showTitleActions: true,
                                                                                        minTime: DateTime.now(),
                                                                                        maxTime: DateTime.now().add(new Duration(days: 1460)),
                                                                                        onChanged: (date) {}, onConfirm: (date) {
                                                                                          String monthBolb = '';
                                                                                          String dayBolb = '';
                                                                                          if(date.month < 10){monthBolb = '0';}
                                                                                          if(date.day < 10){dayBolb = '0';}
                                                                                          periodsEnd[index] = TextEditingController(text: '${dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString()}');
                                                                                          repeatsPeriod[index]['end'] = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                                                                          setState(() {});
                                                                                        }, currentTime: DateTime.now(), locale: LocaleType.ru);},

                                                                                  icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                            ),
                                                                            onChanged: (value){
                                                                              setState(() {
                                                                                repeatsPeriod[index]['end'] = value;
                                                                              });
                                                                            },
                                                                            controller: periodsEnd[index],
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 10,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0, left: 5, right: 5),
                                                                              color: kBlue,
                                                                              child: Text(
                                                                                vocabular['form_n']['general']['date_expiration'],
                                                                                style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                  Spacer(),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      repeatsPeriod.removeAt(index);setState(() {});
                                                                    },
                                                                    child:Container(
                                                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                      padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(width: 0.5, color: kWhite3),
                                                                        color: kBlueLight,
                                                                      ),
                                                                      child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                ]),
                                                            Row(children:[
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['mo'] ? repeatsPeriod[index]['mo'] = true : repeatsPeriod[index]['mo'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(8,10,8,10),
                                                                width:MediaQuery.of(context).size.width/7-11,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['mo'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['mo'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['tu'] ? repeatsPeriod[index]['tu'] = true : repeatsPeriod[index]['tu'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['tu'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['tu'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['we'] ? repeatsPeriod[index]['we'] = true : repeatsPeriod[index]['we'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(8,10,8,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['we'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['we'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['th'] ? repeatsPeriod[index]['th'] = true : repeatsPeriod[index]['th'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['th'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['th'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['fr'] ? repeatsPeriod[index]['fr'] = true : repeatsPeriod[index]['fr'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['fr'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['fr'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['sa'] ? repeatsPeriod[index]['sa'] = true : repeatsPeriod[index]['sa'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['sa'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['sa'], style: st4),
                                                              ),),
                                                              GestureDetector(onTap: (){ setState(() {
                                                                !repeatsPeriod[index]['su'] ? repeatsPeriod[index]['su'] = true : repeatsPeriod[index]['su'] = false;
                                                              });}, child:Container(
                                                                margin: EdgeInsets.fromLTRB(0,10,0,0),
                                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                                                width:MediaQuery.of(context).size.width/7-12,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1.5, color: repeatsPeriod[index]['su'] ? kWhite3 : kYellow),
                                                                  color: kBlue,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child:Text(vocabular['myPhrases']['su'], style: st4),
                                                              ),),
                                                            ]),
                                                            SizedBox(height: 20,)
                                                          ]);}),
                                                //период

                                                Container(
                                                    width:MediaQuery.of(context).size.width ,
                                                    margin: EdgeInsets.fromLTRB(0,10,0,0),
                                                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                    decoration: BoxDecoration(
                                                      color: kBlueLight,
                                                    ),
                                                    child: Text(vocabular['form_n']['main_departure_date_obj']['provision_slots1'])),

                                                ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: docsForSlots.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width:MediaQuery.of(context).size.width ,
                                                            padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                            decoration: BoxDecoration(
                                                              color: kBlueLight,
                                                            ),
                                                            child: Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                    width:MediaQuery.of(context).size.width - 70,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(width: 0.5, color: kWhite3),
                                                                      color: kBlueLight,
                                                                    ),
                                                                    child:Text(docsForSlots[index]['loaded']),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      docsForSlots.removeAt(index);setState(() {});
                                                                    },
                                                                    child:Container(
                                                                      padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(width: 0.5, color: kWhite3),
                                                                        color: kBlueLight,
                                                                      ),
                                                                      child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                          Positioned(
                                                              left: 22,
                                                              top: 2,
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: 0, left: 10, right: 10),
                                                                color: kBlueLight,
                                                                child: Text(docsForSlots[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                ),
                                                              )),
                                                        ],
                                                      );}),

                                                Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  color:kBlueLight,
                                                  child: TextButton(
                                                    onPressed:(){
                                                      Navigator.pushReplacement(context,
                                                          CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 8)));
                                                    } ,
                                                    child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: kBlueLight,
                                                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: kWhite2,
                                                            width: 1,
                                                            style: BorderStyle.solid
                                                        ),
                                                        borderRadius: BorderRadius.circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.bottomCenter,
                                                  margin: EdgeInsets.fromLTRB(0,20,0,0),
                                                  child: TextButton(
                                                    onPressed:(){repeatsPeriod.add({"start":"00.00.0000" , "end":"00.00.0000", "mo": false, "tu":false, "we":false, "th":true, "fr":false, "sa":false, "su":false}); setState(() {

                                                    });} ,
                                                    child: Text(vocabular['form_n']['route_obj']['add_period'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: kBlue,
                                                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: kWhite2,
                                                            width: 1,
                                                            style: BorderStyle.solid
                                                        ),
                                                        borderRadius: BorderRadius.circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                //Секция конструктор периода
                                              ]),



                                        ])),

                              ])): Container(),
                      //для формы Р
                      //секция Пункты посадки стоп-овер
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e7 = !e7;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e7? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Пункты посадки stop-over',style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e7,
                                    child: Column(
                                        children: [

                                          Row(
                                              children: <Widget>[
                                                GestureDetector( onTap: (){
                                                  Navigator.pushReplacement(context,
                                                      CupertinoPageRoute(builder: (context) => airportSelectPage(routNum:0, inOut:1)));
                                                },child:Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width:MediaQuery.of(context).size.width /3*2-20,
                                                      padding: EdgeInsets.fromLTRB(0,30,10,10),
                                                      decoration: BoxDecoration(
                                                        color: kBlue,
                                                      ),
                                                      child:Container(
                                                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                        width:MediaQuery.of(context).size.width,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(width: 0.5, color: kWhite3),
                                                          color: kBlue,
                                                        ),
                                                        child:Text('UUDD'),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        left: 10,
                                                        top: 20,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(vocabular['myPhrases']['airportFlight'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                          ),
                                                        )),
                                                    Positioned(
                                                      right: 0,
                                                      top: 40,
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            bottom: 0, left: 10, right: 10),
                                                        color: Colors.transparent,
                                                        child: Icon(
                                                          Icons.keyboard_arrow_down,
                                                          color: kWhite2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),),
                                                //аэродром вылета

                                                //время вылета
                                                Stack(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/3-10,
                                                        height: 50,
                                                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                        padding: EdgeInsets.fromLTRB(10,0,0,10),
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
                                                              hintText: vocabular['registry']['departure_time'],
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
                                                                        //timeStopOver = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                                        timeStopOver = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                                        setState(() {});
                                                                      }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                                icon: Icon(Icons.access_time, size: 16),)
                                                          ),
                                                          onChanged: (value){
                                                            setState(() {
                                                              timeStopOver = value;
                                                            });
                                                          },
                                                          //controller: routesTimeOut[index],
                                                          initialValue: timeStopOver,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          left: 12,
                                                          top: 12,
                                                          child: Container(
                                                            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                            color: kBlue,
                                                            child: Text(vocabular['registry']['departure_time'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                          )),
                                                    ]),
                                              ]),
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: commentDocs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width:MediaQuery.of(context).size.width ,
                                                      padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                      decoration: BoxDecoration(
                                                        color: kBlue,
                                                      ),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                              width:MediaQuery.of(context).size.width - 70,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                color: kBlue,
                                                              ),
                                                              child:Text(commentDocs[index]['loaded']),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                commentDocs.removeAt(index);setState(() {});
                                                              },
                                                              child:Container(
                                                                padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                                  color: kBlue,
                                                                ),
                                                                child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    Positioned(
                                                        left: 22,
                                                        top: 2,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(commentDocs[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                );}),

                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,0,10,10),
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.pushReplacement(context,
                                                    CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 2)));
                                              } ,
                                              child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ]))
                              ])),
                      //секция Пункты технической посадки
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e8 = !e8;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e8? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Пункты технических посадок',style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e8,
                                    child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Добавить пункт технической посадки', style: st12,
                                                textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ]))
                              ])),
                      //секция участки с коммерческими правами
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e9 = !e9;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e9? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Участки с коммерческими правами',style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e9,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            //color: !switchToRoute[index] ? kWhite1 : kWhite3,
                                              width: MediaQuery.of(context).size.width/3*2-12,
                                              margin: EdgeInsets.fromLTRB(5,5,5,5),
                                              padding: EdgeInsets.fromLTRB(5,5,5,5),
                                              child: Row(
                                                  children:[
                                                    Icon(CupertinoIcons.chevron_down_circle_fill),
                                                    SizedBox(width: 5,),
                                                    Text('LFPG → UUDD', style: st4,),
                                                  ])),

                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: commentDocs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width:MediaQuery.of(context).size.width ,
                                                      padding: EdgeInsets.fromLTRB(0,10,0,0),
                                                      decoration: BoxDecoration(
                                                        color: kBlue,
                                                      ),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                              width:MediaQuery.of(context).size.width - 70,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                color: kBlue,
                                                              ),
                                                              child:Text(commentDocs[index]['loaded']),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                commentDocs.removeAt(index);setState(() {});
                                                              },
                                                              child:Container(
                                                                padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                                  color: kBlue,
                                                                ),
                                                                child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    Positioned(
                                                        left: 22,
                                                        top: 2,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(commentDocs[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                );}),

                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,0,10,10),
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.pushReplacement(context,
                                                    CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 2)));
                                              } ,
                                              child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),




                                          Container(
                                            //color: !switchToRoute[index] ? kWhite1 : kWhite3,
                                              width: MediaQuery.of(context).size.width/3*2-12,
                                              margin: EdgeInsets.fromLTRB(5,5,5,5),
                                              padding: EdgeInsets.fromLTRB(5,5,5,5),
                                              child: Row(
                                                  children:[
                                                    Icon(CupertinoIcons.chevron_down_circle),
                                                    SizedBox(width: 5,),
                                                    Text('LFPG → UUDD', style: st4,),
                                                  ])),

                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: commentDocs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width:MediaQuery.of(context).size.width ,
                                                      padding: EdgeInsets.fromLTRB(0,10,0,0),
                                                      decoration: BoxDecoration(
                                                        color: kBlue,
                                                      ),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                              width:MediaQuery.of(context).size.width - 70,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                color: kBlue,
                                                              ),
                                                              child:Text(commentDocs[index]['loaded']),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                commentDocs.removeAt(index);setState(() {});
                                                              },
                                                              child:Container(
                                                                padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                                  color: kBlue,
                                                                ),
                                                                child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    Positioned(
                                                        left: 22,
                                                        top: 2,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(commentDocs[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                );}),

                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,0,10,10),
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.pushReplacement(context,
                                                    CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 2)));
                                              } ,
                                              child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]))
                              ])),
                      //конец для формы Р
                      // секция КОММЕНТАРИЙ
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      e10 = !e10;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(e10? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(s261,style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                      isDispetcher == true ? SizedBox(width: 5,) : Container(),
                                      isDispetcher == true ? GestureDetector(onTap: (){commentDialog(context, formInListNum, 'comment', '');}, child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14) ) : Container()

                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e10,
                                    child: Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dispetcherComments[formInListNum]['formaComment']['comment'].length, //formInListNum
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                    color: dispetcherComments[formInListNum]['formaComment']['comment'][index]["type"] == 'Ошибка' ? Color(0xFF422A36) : dispetcherComments[formInListNum]['formaComment']['comment'][index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : dispetcherComments[formInListNum]['formaComment']['comment'][index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.2),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                              children:[
                                                                Expanded( child: Text('${dispetcherComments[formInListNum]['formaComment']['comment'][index]["type"]}: ${dispetcherComments[formInListNum]['formaComment']['comment'][index]["value"]}'),),
                                                                Spacer(),
                                                                GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['comment'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st6))
                                                              ]
                                                          ),
                                                          Text('${dispetcherComments[formInListNum]['formaComment']['comment'][index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(dispetcherComments[formInListNum]['formaComment']['comment'][index]["date"]))} ${dispetcherComments[formInListNum]['formaComment']['comment'][index]["oner"]}', style: st2,)
                                                        ]
                                                    ));}),
                                          Stack(
                                            children: <Widget>[
                                              Container(width: MediaQuery.of(context).size.width , height: 100,margin: EdgeInsets.fromLTRB(0, 20, 0, 10),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                child: TextFormField(maxLines: 3, minLines:1, initialValue:commentLast,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['myPhrases']['commentToReceipt'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                  onChanged: (value){setState(() {commentLast = value;});},),),
                                              Positioned( left: 15, top: 12,
                                                  child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                    child: Text(formFromRestr['NForm']['comment'] == null ? vocabular['myPhrases']['commentText'] : formFromRestr['NForm']['comment'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),


                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: commentDocs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width:MediaQuery.of(context).size.width ,
                                                      padding: EdgeInsets.fromLTRB(0,10,0,10),
                                                      decoration: BoxDecoration(
                                                        color: kBlue,
                                                      ),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                              width:MediaQuery.of(context).size.width - 70,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                color: kBlue,
                                                              ),
                                                              child:Text(commentDocs[index]['loaded']),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                commentDocs.removeAt(index);setState(() {});
                                                              },
                                                              child:Container(
                                                                padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.5, color: kWhite3),
                                                                  color: kBlue,
                                                                ),
                                                                child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    Positioned(
                                                        left: 22,
                                                        top: 2,
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: 0, left: 10, right: 10),
                                                          color: kBlue,
                                                          child: Text(commentDocs[index]['docName'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                          ),
                                                        )),
                                                  ],
                                                );}),

                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,10,10,10),
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.pushReplacement(context,
                                                    CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 2)));
                                              } ,
                                              child: Text(s264, style: st12,textAlign: TextAlign.center,),
                                              style: ElevatedButton.styleFrom(
                                                primary: kBlue,
                                                minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: kWhite2,
                                                      width: 1,
                                                      style: BorderStyle.solid
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ]))
                              ])),

                      SizedBox(height: 50)
                    ])) : Container( width: MediaQuery.of(context).size.width, alignment: Alignment.center, child:Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()]))
        ),
            Positioned(
              top:0,
              left:0,
                child: //информер примечаний
                commits.length > 0 ? Container(
                          //padding: const EdgeInsets.symmetric(vertical: 16),
                width: MediaQuery.of(context).size.width,
                          child: Column(
                              children: [
                                Container( color: Color(0xFF422A36), child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _e1 = !_e1;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(_e1? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Ошибки: $_errors',style: st17,),
                                      SizedBox(width: 5,),
                                      Text('Запросы: $_requests',style: st17,),
                                      SizedBox(width: 5,),
                                      Text('Комментарии:  $_comments',style: st17,),

                                    ],
                                  ),
                                ),),
                                ExpandedSection(
                                    expand: _e1,
                                    child: Container(
                                        child:ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: commits.length, //formInListNum
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                                                  color: commits[index]["type"] == 'Ошибка' ? Color(0xFF422A36).withOpacity(0.8) : commits[index]["type"] == 'Запрос' ? Color(0xFFFFFE39).withOpacity(0.2) : commits[index]["type"] == 'Приватный комментарий' ? Color(0xFF4378FF).withOpacity(0.2) : Color(0xFF4378FF).withOpacity(0.2),
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:[
                                                        Row(
                                                            children:[
                                                              Expanded( child: Text('${commits[index]["type"]}: ${commits[index]["value"]}'),),
                                                              Spacer(),
                                                              //GestureDetector(onTap: (){dispetcherComments[formInListNum]['formaComment']['aviacompany'].removeAt(index); buildListCommits(); }, child:Text('Удалить', style: st17))
                                                            ]
                                                        ),
                                                        Text('${commits[index]["status"]} ${DateFormat.MMMMEEEEd('ru').format(DateTime.parse(commits[index]["date"]))} ${commits[index]["oner"]}', style: st2,)
                                                      ]
                                                  ));})))])) : Container(),
        ),
            ]),
      ),
    );
  }


  commentDialog(var context, int formaNum, String commentTypeNum, String commentSubType){

    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
                    insetPadding: EdgeInsets.all(0),
                    elevation: 0.0,
                    content:Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 380,
                          margin: EdgeInsets.fromLTRB(20,20,20,20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kWhite3,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(16.5),
                            color: kBlue,
                          ),
                          padding: EdgeInsets.fromLTRB(20,20,20,20),
                          child:  Column(
                              children: <Widget>[
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: typeComment,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: kWhite2,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: st1,
                                    underline: Container(),
                                    onChanged: (String newValue) {
                                      typeComment = newValue;
                                      setState(() {});
                                    },
                                    items: commentTypes.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                              value
                                          )
                                      );
                                    }).toList(),
                                  ),
                                  title: 'Тип примечания',
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(width: MediaQuery.of(context).size.width , height: 100,margin: EdgeInsets.fromLTRB(0, 20, 0, 10),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                      child: TextFormField(maxLines: 3, minLines:1, decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'Комментарий к заявке',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                        onChanged: (value){valueComment = value;},),),
                                    Positioned( left: 10, top: 12,
                                        child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                          child: Text('Текст комментария',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 14),),)), ],),

                                SizedBox(height: 10,),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(0,10,0,0),
                                  child: TextButton(
                                    onPressed:(){

                                      dispetcherComments[formInListNum]['formaComment']['$commentTypeNum'].add({
                                        "type": "$typeComment",
                                        "value": "$valueComment",
                                        "status": "Открыто",
                                        "date": "${DateTime.now()}",
                                        "oner": "Колдашев Д.Ю."

                                      });
                                      commits.add({
                                        "type": "$typeComment",
                                        "value": "$valueComment",
                                        "status": "Открыто",
                                        "date": "${DateTime.now()}",
                                        "oner": "Колдашев Д.Ю."

                                      });
                                      print(dispetcherComments[formInListNum]);
                                      setState(() {});
                                      Navigator.of(context).pop();
                                      calculateStatus();
                                    } ,
                                    child: Text('Сохранить', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                                    style: ElevatedButton.styleFrom(
                                      primary: kYellow,
                                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(0,20,0,0),
                                  child: TextButton(
                                    onPressed:(){
                                      Navigator.of(context).pop();
                                    } ,
                                    child: Text('Не сохранять', style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                                    style: ElevatedButton.styleFrom(
                                      primary: kBlue,
                                      minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0.0),
                                        side: BorderSide(
                                            color: kWhite2,
                                            width: 1,
                                            style: BorderStyle.solid
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])

                      ),
                    )
                );
              });
        });
  }

}