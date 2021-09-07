import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avia_app/FormaN/processScreen.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/searchModule/searchDoc.dart';
import 'package:avia_app/vocabulary/stringFormN.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
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
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';

ScrollController scrollController = ScrollController();

//для драгабле гридвью
int variableSet = 0;
ScrollController _scrollController;
double width;
double height;


bool sendProcess = false;
bool showReserveFleets = false; //gjrfpывать или нет раздел резервных воздушных судов (если не выбрано основное не показываем резервные)
final DateTime now = DateTime.now();
final DateFormat todayIs = DateFormat('dd.MM.yyyy');
final String todayIsString = todayIs.format(now);

int stateCode = 0, orgId = 0, fleetId = 0;
List cargoItem = [];

bool mo = true, tu = true, we = true, th = true, fr = true, sa = true, su = true;

String aviaCompanyName = '', aviaCompanyNameLat = '', regCountry = '', regCountryLat = '', icao = '', airlineId, enshuranceDate = '', enshuranceEnd = '', spgDate = '', spgEnd = '', upFio = '', upGrade = '', upEmail = '', upSITA = '', upAFTN = '', upFax = '', upPhone = '', upFios = '',upEmails = '', upSITAs = '', upAFTNs = '', upFaxs = '', upPhones = '';//рабочие переменные авиапредприятия

List aviaCompanyDocs = [];
List commentDocs = [];

String regNumber = '', AirCraftType = '', airCraftModel = ''; //рабочие переменные для основного ВС
int MAXIMUMWEIGHT, MAXLANDINGWEIGHT, WEIGHTEMPTYPLAN;
String onerFleetAddress, onerFleetContact, onerFleetControlResidence;

List onerFleetDocs = [];
List majorFleetDocs = [];
List <TextEditingController> majorFleetDocsDate = [], onerFleetDocsDate = [], routesTimeOut = [],routesTimeIn = [], repeatDates = [], periodsStart = [], periodsEnd = [], fplValue = [];
bool reservFleet = false, reservFleetsListing = false; //выбор резервных ВС
List reservFleets = [], repeatsDate = [], repeatsPeriod = [{"start":"" , "end":"", "mo": true, "tu":true, "we":true, "th":true, "fr":true, "sa":true, "su":true}], docsForSlots = [], fleetsList = [], pointsList = [];

List routeList = [{
  "dates_is_repeat" : 1, // 0 - Нет повторов, 1 - Есть повторы
  "dates_or_periods" : 1, // 0 - Указать датами, 1 - Указать периодами
  "status_id" : 0,
  "status_change_datetime" : "00:00:00 00-00-0000",
  "flight_information": {
    "status_change_datetime": "00:00:00 00-00-0000",
    "flight_num": "",
    "purpose_is_commercial": 1,
    "transportation_categories_id": 1,
    "is_found_departure_airport": 1,
    "departure_airport_id": 0,
    "departure_airport_icao": "",
    "departure_airport_namelat": "",
    "departure_airport_namerus": "",
    "departure_platform_coordinates": "",
    "departure_time": "",
    "is_found_landing_airport": 1,
    "landing_airport_id": 0,
    "landing_airport_icao": "",
    "landing_airport_namelat": "",
    "landing_airport_namerus": "",
    "landing_platform_coordinates": "1234N12345E",
    "landing_time": "04:00",
    "landing_type": 0
  },
  "status": {
    "id": 1,
    "name_rus": "Черновик"
  },
  "points": [],
  "main_date": {
    "date": "",
    "landing_date": "2021-05-17",
    "is_required_dep_slot": 1,
    "dep_slot_id": "СТРОКА",
    "is_required_land_slot": 1,
    "land_slot_id": "СТРОКА",
    "documents": []
  },
  "other_dates": [
    {
      "date": "2021-05-17",
      "landing_date": "2021-05-17",
      "is_required_dep_slot": 1,
      "dep_slot_id": "СТРОКА",
      "is_required_land_slot": 1,
      "land_slot_id": "СТРОКА",
    }
  ],
  "period_dates": [
    {
      "start_date": "2021-05-17",
      "end_date": "2021-05-17",
      "days_of_week": [ 1, 2, 3 ],
      "days_of_week_objects": [{"number": 1, "clicked": 1},{"number": 2, "clicked": 1},{"number": 3, "clicked": 1},{"number": 4, "clicked": 1},{"number": 5, "clicked": 1},{"number": 6, "clicked": 1},{"number": 7, "clicked": 1}],
    }
  ],
  "documents": docsForSlots,
  "dates_documents": docsForSlots,
  "crew": {
    "is_fpl": 1, //switch state make
    "crew_groups": [
      {
        "STATES_ID": 94,
        "quantity": 10,
        "state": {
          "STATES_ID": 94,
          "state_namelat": "RUSSIA",
          "state_namerus": "РОССИЯ",
        },
      }
    ],
    "crew_mebers": [
      {
        "fio": "ФИО",
        "state": {
          "STATES_ID": 94,
          "state_namelat": "RUSSIA",
          "state_namerus": "РОССИЯ",
        },
        "documents": []
      }
    ]
  },
  "passengers": {
    "quantity": 1,
    "passengers_persons": [
      {
        "fio": "ФИО",
        "state": {
          "STATES_ID": 94,
          "state_namelat": "RUSSIA",
          "state_namerus": "РОССИЯ",
        },
        "documents": []
      }
    ]
  },
  "cargos": [
    {
      "type_and_characteristics": "JackDaniel's",
      "cargo_danger_classes_id": 1,
      "weight": 1000,
      "cargo_charterer": "ОАО Бормотуха",
      "cargo_charterer_fulladdress": "Красная площадь д.3",
      "cargo_charterer_phone": "222-22-33",
      "receiving_party": "ЗАО Стакан",
      "receiving_party_fulladdress": "Кострома",
      "receiving_party_phone": "5-16-39",
      "consignor": "ИП Губастый",
      "consignor_fulladdress": "Федино 9",
      "consignor_phone": "5-16-98",
      "consignee": "ООО Лафетник",
      "consignee_fulladdress": "Вологда",
      "consignee_phone": "336-58-19",
      "documents": []
    }
  ]
}];

String route = '[{"switch" : 1, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "00.00.0000","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс", "inOutPoints" : [], "landingType" : "Техническая посадка", "landingTypeDoc" : "24.11.2021", "majorDateFlight" : "00.00.0000"}]';
List routes = json.decode(route); //массив маршрута используется


List routTargets = ['${vocabular['form_n']['purposeFlight']['commercial_flight']}','${vocabular['form_n']['purposeFlight']['none_commercial_flight']}'], deliveryCategory = ['Чартерный рейс', 'Нерегулярный рейс', 'Регулярный рейс'];
List landingTypes = ['Техническая посадка','Коммерческая посадка'];//рабочие переменные авиапредприятия
List <String> payerPerson = ['0','1','2']; //заявитель, авакомпания, владелец

//int colStaff = 1;
bool _lockField = true, repeats = false, datePeriod = false, fpl = false;

String commentLast, commentPreLast,  payerFio, payerOrganisation, payerEmail, payerPhone,payerAddress, payerAFTN, majorDateFlight, idAdSlotIn, idAdSlotOut;
int payerContactPerson =0;
TextEditingController _majorDateFlight;

//List passengers = [], pilots = [], fplPilots = [];
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
    _e11 = false;

class formaNFishPage extends StatefulWidget {
  @override
  _formaNFishPageScreenState createState() => _formaNFishPageScreenState();
}

class _formaNFishPageScreenState extends State<formaNFishPage> {
  TextEditingController _regCountry, _colStaff ;
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  //удаление списка резервных ВС
  reservVSDel(){
    for(int i = 0; i < fleetsList.length; i++){
      fleetsList[i]['is_main'] == 0 ? fleetsList.removeAt(i) : null;
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
    int num = 0;
    for(int i = 0; i< routes.length; i++){
      routes[i]['switch'] == 1 ? num = i : null;
    }
    return num;
  }

  countDayOfPeriod(){
    for(int ii = 0; ii < routeList[whereChangeField()]['period_dates'].length; ii++) {
      routeList[whereChangeField()]['period_dates'][ii]['days_of_week'] = [];
      for (int i = 0; i < 7; i++) {
        routeList[whereChangeField()]['period_dates'][ii]['days_of_week_objects'][i]['clicked'] ==
            1
            ? routeList[whereChangeField()]['period_dates'][ii]['days_of_week'].add(
            routeList[whereChangeField()]['period_dates'][ii]['days_of_week_objects'][i]['number'])
            : null;
      }
    }
  }

  @override
  void initState() {
    //cargoItem = json.decode(cargo);
    _regCountry = TextEditingController(text: regCountry);
    super.initState();
    //fplPilots.add({"col":1, "residence":""});
    //pilots.add({"fio":"", "residence":"", "documents": []});
    //passengers.add({"fio":"", "residence":"", "documents": []});
    cargoItem.add({"view":false,"cargoId":"${cargoItem.length+1}","cargoType": "", "ICAOclass":"Класс 1", "cargoMassa":"","frahtName":"","frahtAddress":"","frahtPhone":"","reciveSend":"", "reciveSendAddress":"", "reciveSendPhone":"", "cargoSender":"", "cargoSenderAddress":"", "cargoSenderPhone":"","cargoReciver":"", "cargoReciverAddress":"","cargoReciverPhone":"","otherDoc": []});
  /*if(mounted){
    const twentyMillis = const Duration(seconds:2);
    new Timer(twentyMillis, () =>
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.ease));
  }*/
  }

  //якоря для прокрутки
  final dataKey0 = new GlobalKey();
  final dataKey1 = new GlobalKey();
  List<GlobalKey> dataKey2 = [new GlobalKey()];
  final dataKey3 = new GlobalKey();
  final dataKey4 = new GlobalKey();
  final dataKey5 = new GlobalKey();
  final dataKey6 = new GlobalKey();
  final dataKey7 = new GlobalKey();
  final dataKey8 = new GlobalKey();


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
            child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      headerValue = s251;
                      Navigator.pushNamed(context, '/HomePage');},
                    child:Container(
                        margin: EdgeInsets.fromLTRB(0,7,0,0),
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child:
                      //Column(
                      //  children: <Widget>[
                        Icon(CupertinoIcons.chevron_left, color: kYellow, size: 20,),
                        //Text(s4,style: st10,),
                      //]),
                    ),
                  ),
                  Container(
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child:
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              //width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(0,0,0,0),
                              alignment: Alignment.centerLeft,
                              child: Text(s53, style: TextStyle(fontSize: 18.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                            ),
                            
                            Container(
                              height: 40,
                              //width: 100,
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.fromLTRB(20,0,0,0),
                              child: TextButton(
                                onPressed:(){
                                  //не отправлять пустую форму
                                  aviaCompanyName == '' ? dialogScreen(context, 'Наименование авиакомпании не заполнено'):null;
                                  aviaCompanyName == '' ?Scrollable.ensureVisible(dataKey0.currentContext):null;
                                  AirCraftType == '' ? dialogScreen(context, 'Воздушное судно не выбрано'):null;
                                  AirCraftType == '' ?Scrollable.ensureVisible(dataKey1.currentContext):null;
                                  routeList[0]['flight_num'] == '' ?  dialogScreen(context, 'Номер рейса не указан'):null;
                                  routeList[0]['flight_num'] == '' ? Scrollable.ensureVisible(dataKey2[0].currentContext):null;
                                  routeList[0]['main_date']['date'] == '' ?  dialogScreen(context, 'Основная дата вылета не указана'):null;
                                  routeList[0]['main_date']['date'] == '' ? Scrollable.ensureVisible(dataKey3.currentContext):null;
                                  //routeList[0]['main_date']['landing_date'] == '' ?  dialogScreen(context, 'Дата посадки не указана'):null;
                                  //routeList[0]['main_date']['landing_date'] == '' ? Scrollable.ensureVisible(dataKey4.currentContext):null;
                                  routeList[0]['flight_information']['departure_time'] == '' ?  dialogScreen(context, 'Время вылета не указано'):null;
                                  routeList[0]['flight_information']['departure_time'] == '' ? Scrollable.ensureVisible(dataKey5.currentContext):null;
                                  routeList[0]['flight_information']['departure_airport_id'] == 0 ?  dialogScreen(context, 'Аэропорт вылета не выбран'):null;
                                  routeList[0]['flight_information']['departure_airport_id'] == 0 ? Scrollable.ensureVisible(dataKey6.currentContext):null;
                                  routeList[0]['flight_information']['landing_airport_id'] == 0 ?  dialogScreen(context, 'Аэропорт посадки не выбран'):null;
                                  routeList[0]['flight_information']['landing_airport_id'] == 0 ? Scrollable.ensureVisible(dataKey7.currentContext):null;
                                  routeList[0]['points'].length == 0 ?  dialogScreen(context, 'Не указаны точки входа/выхода'):null;
                                  routeList[0]['points'].length == 0 ? Scrollable.ensureVisible(dataKey8.currentContext):null;
                                  aviaCompanyName != '' && AirCraftType != '' && routeList[0]['flight_num'] != '' && routeList[0]['main_date']['date'] != '' && /*routeList[0]['main_date']['landing_date'] != '' &&*/ routeList[0]['flight_information']['departure_time'] != '' && routeList[0]['flight_information']['departure_airport_id'] != 0 && routeList[0]['flight_information']['landing_airport_id'] != 0 && routeList[0]['points'].length > 0 ? sendFormN() : null;

                                  /*Navigator.pushReplacement(context,
                                      CupertinoPageRoute(builder: (context) =>proceedScreenN()));*/
                                } ,
                                child: sendProcess == false ? Text(vocabular['form_n']['general']['send_form'], style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,) : SizedBox( width:18, height: 18, child:CircularProgressIndicator()),
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
        child: SingleChildScrollView(
                controller: scrollController,
            physics: ScrollPhysics(),
            child: Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[                      
                      //секция ИНФОРМАЦИЯ О авиакомпании
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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e1,
                                    child: Column(
                                        children: [

                                          GestureDetector( onTap: (){
                                            Navigator.pushReplacement(context,
                                              CupertinoPageRoute(builder: (context) => RegionSelectPage()));
                                            },child:Stack(
                                            children: <Widget>[
                                              Container(
                                                key: dataKey0,
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
                                                  child:Row( children: [
                                                    Text(icao),SizedBox(width:10,),
                                                    Expanded(child:Text(aviaCompanyName != null ? language == 'ru' ? aviaCompanyName : aviaCompanyNameLat != null ?aviaCompanyNameLat:  aviaCompanyName :'', style:st5)),
                                                  ])
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
                                              Positioned(
                                                  right: 0,
                                                  top: 20,
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
                                                      onPressed: () {
                                                        setState(() {
                                                          !_lockField ? _lockField = true : _lockField =
                                                          false;
                                                        });
                                                      },
                                                      icon: Image.asset(
                                                          'icons/lockIcon.png', width: 16,
                                                          height: 16,
                                                          fit: BoxFit.fitHeight),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      regCountry = value;
                                                    });
                                                  },
                                                  autovalidateMode: AutovalidateMode.always,
                                                ),
                                              ),
                                              _regCountry.text.length > 0 ? Positioned(
                                                  left: 10,
                                                  top: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 10, right: 10),
                                                    color: kBlue,
                                                    child: Text(s263,style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                    ),
                                                  )) : Container(),
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
                                                          Text(todayIsString,style: st8,),
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
                                                                                        child:Text(aviaCompanyDocs[index]['created_at']),
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
                                                                                    child: Text(aviaCompanyDocs[index]['file_type_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
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
                                                                                  CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 1,doc_object: 'n_form_airline')));
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
                                                                    Text(vocabular['form_n']['documents_obj']['representativeAirline'],style: st8,),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(
                                                                      child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e112,
                                                                  child: Column(
                                                                      children: [
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upFio,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['full_name'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upFio = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['full_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upGrade,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['flight_information_obj']['position'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upGrade = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['flight_information_obj']['position'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upEmail,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'E-mail',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upEmail = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('E-mail',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:upPhone,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['phone'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upPhone = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['phone'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:upFax,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['fax'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upFax = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['fax'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upSITA,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'SITA',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upSITA = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('SITA',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upAFTN,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'AFTN',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upAFTN = value;});},),),
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
                                                                              child: TextFormField(initialValue:upFios,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['full_name'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upFios = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['full_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upEmails,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'E-mail',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upEmails = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('E-mail',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:upPhones,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['phone'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upPhones = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['phone'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                    decimal: false,
                                                                                    signed: false),initialValue:upFaxs,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['fax'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upFaxs = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text(vocabular['form_n']['general']['fax'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upSITAs,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'SITA',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upSITAs = value;});},),),
                                                                            Positioned( left: 15, top: 12,
                                                                                child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlueLight,
                                                                                  child: Text('SITA',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                                                        Stack(
                                                                          children: <Widget>[
                                                                            Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                                              child: TextFormField(initialValue:upAFTNs,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'AFTN',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                                                onChanged: (value){setState(() {upAFTNs = value;});},),),
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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e2,
                                    child: Column(
                                        children: [
                                          GestureDetector( onTap: (){
                                            Navigator.pushReplacement(context,
                                                CupertinoPageRoute(builder: (context) => FleetSelectPage()));
                                          },child:Stack(
                                            children: <Widget>[
                                              Container(
                                                key: dataKey1,
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
                                                    child:Text(fleetsList.length > 0  ? fleetsList[majorVSStringNum()]['regno'] != null ? fleetsList[majorVSStringNum()]['regno'] : ''  : ''),
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
                                                right: 0,
                                                top: 20,
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
                                                  child:Text(AirCraftType),
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
                                                  child:Text(fleetsList.length > 0  ? fleetsList[majorVSStringNum()]['type_model'] != null ? fleetsList[majorVSStringNum()]['type_model'] : ''  : ''),
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
                                                          Text(todayIsString,style: st8,),
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
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e211,
                                                                  child: Column(
                                                                      children: [
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
                                                                                        //initialValue: MAXIMUMWEIGHT != null ? MAXIMUMWEIGHT.toString() : '',
                                                                                          initialValue: fleetsList.length > 1  ? fleetsList[majorVSStringNum()]['parameters']['max_takeoff_weight'].toString() : '',
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
                                                                                            fleetsList[majorVSStringNum()]['parameters']['max_takeoff_weight'] = int.parse(value);
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
                                                                                    //initialValue:MAXLANDINGWEIGHT!= null ?  MAXLANDINGWEIGHT.toString() : '',
                                                                                    initialValue: fleetsList.length > 1  ? fleetsList[majorVSStringNum()]['parameters']['max_landing_weight'].toString() : '',
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
                                                                                        fleetsList[majorVSStringNum()]['parameters']['max_landing_weight'] = int.parse(value);
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
                                                                                //initialValue: WEIGHTEMPTYPLAN != null ? WEIGHTEMPTYPLAN.toString() : '',
                                                                                initialValue: fleetsList.length > 1  ? fleetsList[majorVSStringNum()]['parameters']['empty_equip_weight'].toString() : '',
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
                                                                                    fleetsList[majorVSStringNum()]['parameters']['empty_equip_weight'] = int.parse(value);
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
                                                                        fleetsList.length > 0 ? ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            //itemCount: majorFleetDocs.length,
                                                                            itemCount: fleetsList[majorVSStringNum()]['documents'].length,
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
                                                                                            initialValue:fleetsList[majorVSStringNum()]['documents'][index]['created_at'],
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
                                                                                                fleetsList[majorVSStringNum()]['documents'][index]['created_at'] = value;
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
                                                                                                fleetsList[majorVSStringNum()]['documents'][index]['file_type_name'],
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
                                                                                                          majorFleetDocsDate[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                                                                          fleetsList[majorVSStringNum()]['documents'][index]['required_attributes_json'][1]['value'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                                                                          setState(() {});
                                                                                                        }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                                                                    icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                                            ),
                                                                                            onChanged: (value){
                                                                                              setState(() {
                                                                                                fleetsList[majorVSStringNum()]['documents'][index]['required_attributes_json'][1]['value'] = value;
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
                                                                                        fleetsList[majorVSStringNum()]['documents'].removeAt(index);
                                                                                        setState(() {});
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
                                                                                  ]);}) : Container(),

                                                                        Container(
                                                                          height: 40,
                                                                          width: MediaQuery.of(context).size.width,
                                                                          alignment: Alignment.bottomCenter,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,10),
                                                                          child: TextButton(
                                                                            onPressed:(){
                                                                              Navigator.pushReplacement(context,
                                                                                  CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 6,  doc_object: 'aircraft')));
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
                                                                  ],
                                                                ),
                                                              ),
                                                              ExpandedSection(
                                                                  expand: e213,
                                                                  child: Column(
                                                                      children: [
                                                                        //onerFleetAddress, onerFleetContact, onerFleetControlResidence; List onerFleetDocs = [];
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
                                                                                initialValue: fleetsList.length > 1 ? fleetsList[majorVSStringNum()]['aircraft_owner']['full_address'] == '' ? onerFleetAddress : fleetsList[majorVSStringNum()]['aircraft_owner']['full_address'] : onerFleetAddress,
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['owner_obj']['address_owner'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                     fleetsList[majorVSStringNum()]['aircraft_owner']['full_address']= value;
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
                                                                                initialValue: fleetsList.length > 1 ? fleetsList[majorVSStringNum()]['aircraft_owner']['contact'] == '' ? onerFleetContact : fleetsList[majorVSStringNum()]['aircraft_owner']['contact'] : onerFleetContact,
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['owner_obj']['contact_owner'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    fleetsList[majorVSStringNum()]['aircraft_owner']['contact'] = value;
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
                                                                                initialValue: fleetsList.length > 1 ? language == 'ru' ? fleetsList[majorVSStringNum()]['aircraft_owner']['state']['state_namerus'] : fleetsList[majorVSStringNum()]['aircraft_owner']['state']['state_namelat'] : '',
                                                                                decoration: InputDecoration(
                                                                                  border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none),
                                                                                  hintText: vocabular['form_n']['general']['supervising_state'],
                                                                                  hintStyle: st8,
                                                                                  contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    fleetsList[majorVSStringNum()]['aircraft_owner']['state']['state_namerus'] = value;
                                                                                    fleetsList[majorVSStringNum()]['aircraft_owner']['state']['state_namelat'] = value;
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
                                                                              fleetsList.length > 0 ? ListView.builder(
                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                  shrinkWrap: true,
                                                                                  itemCount: fleetsList[majorVSStringNum()]['aircraft_owner']['documents'].length,
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
                                                                                                  initialValue:fleetsList[majorVSStringNum()]['aircraft_owner']['documents'][index]['created_at'],
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
                                                                                                      fleetsList[majorVSStringNum()]['aircraft_owner']['documents'][index]['created_at'] = value;
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
                                                                                                      fleetsList[majorVSStringNum()]['aircraft_owner']['documents'][index]['file_type_name'],
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
                                                                                                                onerFleetDocsDate[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                                                                                fleetsList[majorVSStringNum()]['aircraft_owner']['documents'][index]['required_attributes_json'][1]['value'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                                                                                setState(() {});
                                                                                                              }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                                                                        icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                                                                  ),
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      fleetsList[majorVSStringNum()]['aircraft_owner']['documents'][index]['required_attributes_json'][1]['value'] = value;
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
                                                                                              fleetsList[majorVSStringNum()]['aircraft_owner']['documents'].removeAt(index);setState(() {});
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
                                                                                        ]);}) : Container(),

                                                                              Container(
                                                                                height: 40,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                alignment: Alignment.bottomCenter,
                                                                                margin: EdgeInsets.fromLTRB(10,20,10,10),
                                                                                child: TextButton(
                                                                                  onPressed:(){
                                                                                    Navigator.pushReplacement(context,
                                                                                        CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 7, doc_object: 'aircraft_owner')));
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
                        showReserveFleets == true ? Padding(
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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e3,
                                    child: Column(
                                        children: [
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
                                                            value == true ? dialogScreen(context, 'Данные о резервных ВС будут очищены') : null;
                                                            setState(() {
                                                              reservFleet = value; //изменить переменную
                                                              value == true ? reservFleetsListing = false : null;
                                                              value == true ? reservVSDel() : null;
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                              ]),
                                          !reservFleet ? reservFleetsListing ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                          //itemCount: reservFleets.length,
                                              itemCount: fleetsList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                                return fleetsList[index]['is_main'] == 0 ? Container(
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
                                                                  child:Text(fleetsList[index]['regno']),
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
                                                                fleetsList.removeAt(index);
                                                                setState(() {});
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
                                                        child:Text('${fleetsList[index]['type_model']}'),
                                                        //child:Text('${reservFleets[index]['aircraft']['acfthist']['ICAOLAT4'] != null ? reservFleets[index]['aircraft']['acfthist']['ICAOLAT4']  : 'Не заполнено'}'),
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
                                                          //child:Text('${reservFleets[index]['aircraft']['TYPE'] != null ? reservFleets[index]['aircraft']['TYPE']  : 'Не заполнено'}'),
                                                      child:Text('${fleetsList[index]['type_model']}'),
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
                                                ): Container();}) : Container(): Container(),
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
                              ])):Container(),
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
                                                          mainAxisExtent: 160,
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 10),
                                                      itemBuilder: (context, index) => Card(
                                                        elevation: 2,
                                                        child: Container( child:
                                                          GestureDetector( onTap: (){
                                                            if(routes[index]['switch'] == 0) {
                                                              for (int i = 0; i <routes.length; i++) {routes[i]['switch'] = 0;}
                                                              setState(() {
                                                                routes[index]['switch'] =1;
                                                                routes[index]['switchMenu'] = 0;
                                                              });
                                                            }else{
                                                              setState(() {
                                                                routes[index]['switch'] = 0;
                                                                routes[index]['switchMenu'] = 0;
                                                            });}
                                                          } ,child:Container(
                                                            margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                            padding: EdgeInsets.fromLTRB(6,8,6,8),
                                                            width: 340,
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
                                                                              GestureDetector(onTap: (){
                                                                                Navigator.pushReplacement(context,
                                                                                    CupertinoPageRoute(builder: (context) => airportSelectPage(routNum:index, inOut:1)));
                                                                              }, child:Text('${routeList[index]['flight_information']['departure_airport_icao'].substring(0, routeList[index]['flight_information']['departure_airport_icao'].length > 4 ? 4 : routeList[index]['flight_information']['departure_airport_icao'].length)}',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),),
                                                                              Text('→',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                              GestureDetector(onTap: (){
                                                                                Navigator.pushReplacement(context,
                                                                                    CupertinoPageRoute(builder: (context) => airportSelectPage(routNum:index, inOut:2)));
                                                                              }, child:Text('${routeList[index]['flight_information']['landing_airport_icao'].substring(0, routeList[index]['flight_information']['landing_airport_icao'].length > 4 ? 4 : routeList[index]['flight_information']['landing_airport_icao'].length)}',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),),
                                                                              Spacer(),
                                                                              GestureDetector(onTap: (){
                                                                                setState(() {
                                                                                routes[index]['switchMenu'] = 1;
                                                                              });
                                                                                }, child:Text(' . . . ',style:TextStyle(fontSize: 21.0,fontFamily: 'AlS Hauss', color:  kWhite,)),),
                                                                            ]),
                                                                        Container( padding: EdgeInsets.fromLTRB(0,0,30,0), child:Text('${routeList[index]['flight_information']['flight_num']} / ${routeList[index]['main_date']['date']} в ${routeList[index]['flight_information']['departure_time']} ➔ ${routeList[index]['main_date']['landing_date']} в ${routeList[index]['flight_information']['landing_time']}', style:st14),),
                                                                        Row(
                                                                            children: <Widget>[
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text('${vocabular['form_n']['flight_crew']}: ${( routeList[index]['crew_groups'] != null ? routeList[index]['crew_groups'].length : 0 ) + (routeList[index]['crew_mebers'] != null ? routeList[index]['crew_mebers'].length : 0)}', style: st14),
                                                                                  Text('${vocabular['form_n']['cargo']}: ${routeList[index]['cargos'].length}', style: st14),
                                                                                ],
                                                                              ),
                                                                              Spacer(),
                                                                              Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('${vocabular['form_n']['passengers']}: ${routeList[index]['passengers']['passengers_persons'].length}', style: st14),
                                                                                    Text('${vocabular['form_n']['main_departure_date_obj']['repetitions']}: ${repeatsDate.length+repeatsPeriod.length}', style: st14),
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
                                                                              //дублирование на потом
                                                                                routes.add({"switch" : 1, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "00.00.0000","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс", "inOutPoints" : [], "landingType" : "Техническая посадка", "landingTypeDoc" : "24.11.2021", "majorDateFlight" : "00.00.0000"});
                                                                                routeList.add(json.decode(jsonEncode(routeList[index])));
                                                                                dataKey2.add(new GlobalKey());
                                                                                routes.last['switch'] = 0;
                                                                                routes.last['switchMenu'] = 0;
                                                                                setState(() {});

                                                                            }, child:Text(vocabular['form_n']['route_obj']['duplicate'], style: st17)),
                                                                            GestureDetector(onTap: (){
                                                                              //обратный рейс на потом
                                                                              routes.add({"switch" : 1, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "00.00.0000","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс", "inOutPoints" : [], "landingType" : "Техническая посадка", "landingTypeDoc" : "24.11.2021", "majorDateFlight" : "00.00.0000"});
                                                                              dataKey2.add(new GlobalKey());
                                                                              routes.last['switch'] = 0;
                                                                              routes.last['switchMenu'] = 0;
                                                                              routeList.add(json.decode(jsonEncode(routeList[index])));
                                                                              routeList.last['flight_information'] =
                                                                                {
                                                                                  "status_change_datetime": "00:00:00 00-00-0000",
                                                                                  "flight_num": "${routeList[index]['flight_information']['flight_num']}",
                                                                                  "purpose_is_commercial": routeList[index]['flight_information']['purpose_is_commercial'],
                                                                                  "transportation_categories_id": routeList[index]['flight_information']['transportation_categories_id'],
                                                                                  "is_found_departure_airport": routeList[index]['flight_information']['is_found_landing_airport'],
                                                                                  "departure_airport_id": routeList[index]['flight_information']['landing_airport_id'],
                                                                                  "departure_airport_icao": "${routeList[index]['flight_information']['landing_airport_icao']}",
                                                                                  "departure_airport_namelat": "${routeList[index]['flight_information']['landing_airport_namelat']}",
                                                                                  "departure_airport_namerus": "${routeList[index]['flight_information']['landing_airport_namerus']}",
                                                                                  "departure_platform_coordinates": "${routeList[index]['flight_information']['landing_platform_coordinates']}",
                                                                                  "departure_time": "${routeList[index]['flight_information']['departure_time']}",
                                                                                  "is_found_landing_airport": routeList[index]['flight_information']['is_found_departure_airport'],
                                                                                  "landing_airport_id": routeList[index]['flight_information']['departure_airport_id'],
                                                                                  "landing_airport_icao": "${routeList[index]['flight_information']['departure_airport_icao']}",
                                                                                  "landing_airport_namelat": "${routeList[index]['flight_information']['departure_airport_namelat']}",
                                                                                  "landing_airport_namerus": "${routeList[index]['flight_information']['departure_airport_namerus']}",
                                                                                  "landing_platform_coordinates": "${routeList[index]['flight_information']['departure_platform_coordinates']}",
                                                                                  "landing_time": "${routeList[index]['flight_information']['landing_time']}",
                                                                                  "landing_type": 0
                                                                                };
                                                                              setState(() {});

                                                                            }, child:Text(vocabular['form_n']['route_obj']['add_return_flight'], style: st17)),
                                                                            GestureDetector(onTap: (){setState(() {
                                                                              routes.removeAt(index);
                                                                              dataKey2.removeAt(index);
                                                                              routeList.removeAt(index);
                                                                              setState(() {});
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
                                                      itemCount: routes.length,
                                                      onWillAccept: (oldIndex, newIndex) {
                                                        // Implement you own logic
                                                        // Example reject the reorder if the moving item's value is something specific
                                                        if (routes[newIndex] == "something") {
                                                          return false;
                                                        }
                                                        return true; // If you want to accept the child return true or else return false
                                                      },
                                                      onReorder: (oldIndex, newIndex) {
                                                        final temp = routes[oldIndex];
                                                        final temp2 = routeList[oldIndex];
                                                        routes[oldIndex] = routes[newIndex];
                                                        routeList[oldIndex] = routeList[newIndex];
                                                        routes[newIndex] = temp;
                                                        routeList[newIndex] = temp2;
                                                        setState(() {});
                                                      },
                                                    ),
                                                ),
                                          //драгалка
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: routes.length,
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
                                                          //key: dataKey2[index],
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 50,
                                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                          padding: EdgeInsets.fromLTRB(10,0,0,10),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: kWhite1),
                                                          ),
                                                          child: TextFormField(
                                                            initialValue:  routeList[index]['flight_information']['flight_num'],
                                                            decoration: InputDecoration(
                                                              border: UnderlineInputBorder(
                                                                  borderSide: BorderSide.none
                                                              ),
                                                              hintText: vocabular['registry']['flight_number'],
                                                              hintStyle: st8,
                                                              contentPadding: EdgeInsets.only(bottom: 5, left: 0, right: 10),
                                                            ),
                                                            onChanged: (value){
                                                              setState(() {
                                                                routeList[index]['flight_information']['flight_num'] = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        routeList[index]['flight_information']['flight_num'].length > 0 ? Positioned(
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
                                                                    routeList[index]['flight_information']['purpose_is_commercial'] = newValue == vocabular['form_n']['purposeFlight']['commercial_flight'] ? 1 : 0;
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
                                                                value: routes[index]['transferCategory'],
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
                                                                    routeList[index]['flight_information']['transportation_categories_id'] = newValue == 'Чартерный рейс' ? 1 : newValue == 'Регулярный рейс' ? 0 : 2;
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
                                                          GestureDetector( onTap: (){
                                                            Navigator.pushReplacement(context,
                                                                CupertinoPageRoute(builder: (context) => airportSelectPage(routNum:index, inOut:1)));
                                                          },child:Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                key: dataKey6,
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
                                                                  child:Text(routeList[index]['flight_information']['departure_airport_icao']),
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
                                                                key: dataKey4,
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
                                                                              showSecondsColumn: false,
                                                                              showTitleActions: true,
                                                                              onChanged: (date) {}, onConfirm: (date) {
                                                                                String minuteBolb = '';
                                                                                String hourBolb = '';
                                                                                if(date.minute < 10){minuteBolb = '0';}
                                                                                if(date.hour < 10){hourBolb = '0';}
                                                                                routesTimeOut[index] = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                                                routeList[index]['flight_information']['departure_time'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                                                setState(() {});
                                                                              }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                                        icon: Icon(Icons.access_time, size: 16),)
                                                                  ),
                                                                  onChanged: (value){
                                                                    setState(() {
                                                                      routeList[index]['flight_information']['departure_time'] = value;
                                                                    });
                                                                  },
                                                                  controller: routesTimeOut[index],
                                                                ),
                                                              ),
                                                              routeList[index]['flight_information']['departure_time'].length > 0 ? Positioned(
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
                                                          GestureDetector( onTap: (){
                                                            Navigator.pushReplacement(context,
                                                                CupertinoPageRoute(builder: (context) => airportSelectPage(routNum:index, inOut:2)));
                                                          },child:Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                key: dataKey7,
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
                                                                  child:Text(routeList[index]['flight_information']['landing_airport_icao']),
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
                                                          ),),
                                                          //время посадки
                                                          Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                key: dataKey5,
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
                                                                      hintText: vocabular['registry']['boarding_time'],
                                                                      hintStyle: st8,
                                                                      contentPadding: new EdgeInsets.symmetric(vertical: 5, horizontal: 0.0),
                                                                      suffixIcon: IconButton(
                                                                        onPressed: () {
                                                                          DatePicker.showTimePicker(context,
                                                                              showSecondsColumn: false,
                                                                              showTitleActions: true,
                                                                              onChanged: (date) {}, onConfirm: (date) {
                                                                                String minuteBolb = '';
                                                                                String hourBolb = '';
                                                                                if(date.minute < 10){minuteBolb = '0';}
                                                                                if(date.hour < 10){hourBolb = '0';}
                                                                                routesTimeIn[index] = TextEditingController(text: '${hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString()}');
                                                                                routeList[index]['flight_information']['landing_time'] = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                                                                setState(() {});
                                                                              }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                                        icon: Icon(Icons.access_time, size: 16),)
                                                                  ),
                                                                  onChanged: (value){
                                                                    setState(() {
                                                                      routeList[index]['flight_information']['landing_time'] = value;
                                                                    });
                                                                  },
                                                                  controller: routesTimeIn[index],
                                                                ),
                                                              ),
                                                              routeList[index]['flight_information']['landing_time'].length > 0 ? Positioned(
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
                                                GestureDetector(
                                                    onTap: (){
                                                      if(selectedPoints.length > 0){selectedPoints.removeAt(0);}
                                                      Navigator.pushReplacement(context,
                                                          CupertinoPageRoute(builder: (context) => pointSelectPage(routNum: index, )));
                                                    },
                                                    child:Stack(
                                                      children: <Widget>[
                                                        //драгалка
                                                        Container(
                                                            key: dataKey8,
                                                            width: MediaQuery.of(context).size.width,
                                                            height:  40.0 * (routeList[index]['points'].length / (MediaQuery.of(context).size.width > 720 ? (MediaQuery.of(context).size.width / 360).ceil() : 1)).ceil() + 40,
                                                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: kWhite1),
                                                            ), child:routeList[index]['points'].length > 0 ? Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                          height:  40.0 * (routeList[index]['points'].length / (MediaQuery.of(context).size.width > 720 ? (MediaQuery.of(context).size.width / 360).ceil() : 1)).ceil() + 40,
                                                          child: DragAndDropGridView(
                                                            controller: _scrollController,
                                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent: 200,
                                                                mainAxisExtent: 40,
                                                                crossAxisSpacing: 10,
                                                                mainAxisSpacing: 10),
                                                            itemBuilder: (context, index2) => Card(
                                                                color: Colors.transparent,
                                                                elevation: 0,
                                                                child: routeList[index]['points'][index2]['name'] != null ? GestureDetector(
                                                                    onTap: (){
                                                                      selectedPoints = [];
                                                                      selectedPoints.add(routeList[index]['points'][index2]);
                                                                      Navigator.pushReplacement(context,
                                                                          CupertinoPageRoute(builder: (context) => pointSelectPage(routNum: index, pointNum: index2,)));
                                                                    },
                                                                    child:Container(
                                                                        height: 40,
                                                                        padding: EdgeInsets.fromLTRB(10,5,5,5),
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(width: 0.5, color: kBlueLight),
                                                                          borderRadius: BorderRadius.circular(14.0),
                                                                          color: kBlueLight,
                                                                        ),
                                                                        child: Row(
                                                                            children: [
                                                                              Text('${routeList[index]['points'][index2]['name'].length > 5 ? routeList[index]['points'][index2]['name'].substring(0, 5) : routeList[index]['points'][index2]['name']}', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite,)),
                                                                              Text('${routeList[index]['points'][index2]['time']}', style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color:  kWhite2,)),
                                                                              routeList[index]['points'][index2]['alt_points'] != null ? routeList[index]['points'][index2]['alt_points'].length > 0 ? Text('ALT(${routeList[index]['points'][index2]['alt_points'].length})', style: TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kYellow)) : Container():Container(),
                                                                              GestureDetector( onTap: (){ /*routes[index]['inOutPoints'].removeAt(index2);*/ routeList[index]['points'].removeAt(index2); setState(() {});}, child:Icon(Icons.clear, color: kWhite, size: 16,))
                                                                            ])
                                                                    )): Container()),
                                                            isCustomChildWhenDragging: true,
                                                            childWhenDragging: (pos) => Container(
                                                              margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                              width: 200,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 0.5, color: kWhite3),
                                                                color: kBlueLight,
                                                              ),

                                                            ),
                                                            itemCount: routeList[index]['points'].length,
                                                            onWillAccept: (oldIndex, newIndex) {
                                                              // Implement you own logic
                                                              // Example reject the reorder if the moving item's value is something specific
                                                              if (routeList[index]['points'][newIndex] == "something") {
                                                                return false;
                                                              }
                                                              return true; // If you want to accept the child return true or else return false
                                                            },
                                                            onReorder: (oldIndex, newIndex) {
                                                              //final temp = routes[index]['inOutPoints'][oldIndex];
                                                              final temp2 = routeList[index]['points'][oldIndex];
                                                              //routes[index]['inOutPoints'][oldIndex] = routes[index]['inOutPoints'][newIndex];
                                                              routeList[index]['points'][oldIndex] = routeList[index]['points'][newIndex];
                                                              //routes[index]['inOutPoints'][newIndex] = temp;
                                                              routeList[index]['points'][newIndex] = temp2;
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ) : Text(vocabular['form_n']['route_obj']['points_entry_exit_rf'])
                                                        ),

                                                              //драгалка
                                                              Positioned(
                                                                  left: 12,
                                                                  top: 12,
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                                                                    color: kBlue,
                                                                    child: Text(vocabular['form_n']['route_obj']['points_entry_exit_rf'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                  )),
                                                      ],
                                                    )),
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
                                                            value: routes[index]['landingType'],
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
                                                                routeList[index]['flight_information']['landing_type'] = newValue == 'Техническая посадка' ? 1 : newValue == 'Коммерческая посадка' ? 0 : 2;
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
                                                routes.add(json.decode('{"switch" : 0, "switchMenu" : 0, "marshruteName" : "Новый рейс", "marshruteDate" : "28.04.2021","staffCol" : "0", "bagage" : "0", "pasengers" : "0", "repeats" : "0", "marshruteNumber" : "0", "marshruteTarget" : "${vocabular['form_n']['purposeFlight']['commercial_flight']}", "transferCategory" : "Чартерный рейс","inOutPoints" : [{"pointName" : "0", "pointTime" : "0"}], "landingType" : "Техническая посадка"}'));
                                                routeList.add({ "dates_is_repeat" : 0,"dates_or_periods" : 0,"status_id" : 0,"status_change_datetime" : "00:00:00 00-00-0000","flight_information": {"status_change_datetime": "00:00:00 00-00-0000","flight_num": "SU1234","purpose_is_commercial": 1,"transportation_categories_id": 1,"is_found_departure_airport": 1,"departure_airport_id": 0,"departure_airport_icao": "","departure_airport_namelat": "","departure_airport_namerus": "","departure_platform_coordinates": "","departure_time": "00:00","is_found_landing_airport": 1,"landing_airport_id": 0,"landing_airport_icao": "","landing_airport_namelat": "","landing_airport_namerus": "","landing_platform_coordinates": "1234N12345E","landing_time": "04:00","landing_type": 0},"status": {"id": 1,"name_rus": "Черновик"},"points": [{"name": "СТРОКА","is_found_point": 1,"is_coordinates": 0,"departure_time_error": 0,"landing_time_error": 0,"POINTS_ID": 73,"ISGATEWAY": 1,"ISINOUT": 1,"icao": "AGAMO","time": "0300","coordinates": "1234S12345E","alt_points": [{"POINTS_ID": 73,"icao": "AGAMO","name": "string","is_found_point": 1,"is_coordinates": 0,"ISINOUT": 1,"ISGATEWAY": 1,"coordinates": "string"},{"POINTS_ID": 74,"icao": "AGAMO","name": "string","is_found_point": 1,"is_coordinates": 0,"ISINOUT": 1,"ISGATEWAY": 1,"coordinates": "string"}]}],"main_date": {"date": "2021-05-17","landing_date": "2021-05-17","is_required_dep_slot": 1,"dep_slot_id": "СТРОКА","is_required_land_slot": 1,"land_slot_id": "СТРОКА","documents": []},"other_dates": [{"date": "2021-05-17","landing_date": "2021-05-17","is_required_dep_slot": 1,"dep_slot_id": "СТРОКА","is_required_land_slot": 1,"land_slot_id": "СТРОКА",}],"period_dates": [{"start_date": "2021-05-17T17:32:43.748Z","end_date": "2021-05-17T17:32:43.748Z","days_of_week": [ 1, 2, 3 ],"days_of_week_objects": [{"number": 1, "clicked": 1},{},{},{},{},{},{}],}],"documents": [],"dates_documents": [],"crew": {"is_fpl": 1,"crew_groups": [{"STATES_ID": 94,"quantity": 10,"state": {"STATES_ID": 94,"state_namelat": "RUSSIA","state_namerus": "РОССИЯ", },}], "crew_mebers": [{"fio": "ФИО","state": {"STATES_ID": 94,"state_namelat": "RUSSIA","state_namerus": "РОССИЯ",},"documents": []}]},"passengers": { "quantity": 1,"passengers_persons": [{"fio": "ФИО","state": {"STATES_ID": 94,"state_namelat": "RUSSIA","state_namerus": "РОССИЯ",},"documents": [] }]}, "cargos": [ {"type_and_characteristics": "","cargo_danger_classes_id": 1,"weight": 0, "cargo_charterer": "","cargo_charterer_fulladdress": "","cargo_charterer_phone": "","receiving_party": "","receiving_party_fulladdress": "","receiving_party_phone": "","consignor": "","consignor_fulladdress": "","consignor_phone": "","consignee": "","consignee_fulladdress": "","consignee_phone": "","documents": []} ]});
                                                setState(() {});
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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e5,
                                    child: Column(
                                        children: [
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                key: dataKey3,
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
                                                  decoration: InputDecoration(
                                                      border: UnderlineInputBorder(
                                                          borderSide: BorderSide.none
                                                      ),
                                                      hintText: vocabular['form_n']['main_departure_date_obj']['main_date'],
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
                                                                _majorDateFlight = TextEditingController(text: '${date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                                //routeList[whereChangeField()]['main_date']['date'] = '${date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()+'T00:00:00.000Z'}';
                                                                routeList[whereChangeField()]['main_date']['date'] = '${date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}';
                                                                print(date.toString());
                                                                setState(() {});
                                                              }, currentTime: DateTime.now(),
                                                              //locale: language == 'ru' ? LocaleType.ru : LocaleType.en);
                                                          locale:  LocaleType.ru);
                                                          },
                                                        icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                  ),
                                                  onChanged: (value){
                                                    setState(() {
                                                      routeList[whereChangeField()]['main_date']['date']= value;
                                                    });
                                                  },
                                                  controller: _majorDateFlight,
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
                                                              routeList[whereChangeField()]['dates_is_repeat'] = value == false ? 0 : 1;
                                                              value == false ? dialogScreen(context, 'Данные о повторах будут очищены') : null;
                                                              value == false ? routeList[whereChangeField()]['other_dates'] = [{
                                                                "date": "2021-05-17",
                                                                "landing_date": "2021-05-17",
                                                                "is_required_dep_slot": 1,
                                                                "dep_slot_id": "СТРОКА",
                                                                "is_required_land_slot": 1,
                                                                "land_slot_id": "СТРОКА",
                                                              }] : null; //удалили даты вылетов
                                                              value == true ? routeList[whereChangeField()]['period_dates'] = [{
                                                                "start_date": "2021-05-17",
                                                                "end_date": "2021-05-17",
                                                                "days_of_week": [ 1, 2, 3 ],
                                                                "days_of_week_objects": [{"number": 1, "clicked": 1},{"number": 2, "clicked": 1},{"number": 3, "clicked": 1},{"number": 4, "clicked": 1},{"number": 5, "clicked": 1},{"number": 6, "clicked": 1},{"number": 7, "clicked": 1}],
                                                              }] : null; //удалил периоды вылетов

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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e6,
                                    child: Column(
                                        children: [
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
                                                              routeList[whereChangeField()]['dates_or_periods'] = !value ? 0 : 1;
                                                              value == false ? dialogScreen(context, 'Данные о периодах будут очищены') : dialogScreen(context, 'Данные о датах будут очищены');
                                                              //value == false ? routeList[whereChangeField()]['other_dates'] = [] : routeList[whereChangeField()]['period_dates'] = []; //удалили даты вылетов
                                                              value == false ? routeList[whereChangeField()]['other_dates'] = [{
                                                                "date": "2021-05-17",
                                                                "landing_date": "2021-05-17",
                                                                "is_required_dep_slot": 1,
                                                                "dep_slot_id": "СТРОКА",
                                                                "is_required_land_slot": 1,
                                                                "land_slot_id": "СТРОКА",
                                                              }] : null; //удалили даты вылетов
                                                              value == true ? routeList[whereChangeField()]['period_dates'] = [{
                                                                "start_date": "2021-05-17",
                                                                "end_date": "2021-05-17",
                                                                "days_of_week": [ 1, 2, 3 ],
                                                                "days_of_week_objects": [{"number": 1, "clicked": 1},{"number": 2, "clicked": 1},{"number": 3, "clicked": 1},{"number": 4, "clicked": 1},{"number": 5, "clicked": 1},{"number": 6, "clicked": 1},{"number": 7, "clicked": 1}],
                                                              }] : null;
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
                              itemCount: routeList[whereChangeField()]['other_dates'].length,
                              itemBuilder: (BuildContext context, int index) {
                                repeatDates.add(TextEditingController());
                              return Column(
                                    children: [
                                    Row(
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
                                                hintText: 'Flight №${index+1}',
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
                                                          repeatDates[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                          routeList[whereChangeField()]['other_dates'][index]['date'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                          setState(() {});
                                                        }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                  icon: Icon(CupertinoIcons.calendar, size: 16),)
                                            ),
                                            onChanged: (value){
                                              setState(() {
                                                routeList[whereChangeField()]['other_dates'][index]['date']  = value;
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
                                                'Flight №${index+1}',
                                                style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                              ),
                                            )),
                                      ]),
                                        SizedBox(width: 10,),
                                      ]),
                                      Row(
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
                                                      hintText: 'Landing №${index+1}',
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
                                                                repeatDates[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                                routeList[whereChangeField()]['other_dates'][index]['landing_date'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                                setState(() {});
                                                              }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                        icon: Icon(CupertinoIcons.calendar, size: 16),)
                                                  ),
                                                  onChanged: (value){
                                                    setState(() {
                                                      routeList[whereChangeField()]['other_dates'][index]['landing_date']  = value;
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
                                                      'Landing №${index+1}',
                                                      style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                    ),
                                                  )),
                                            ]),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            routeList[whereChangeField()]['other_dates'].removeAt(index);
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
                                      ]),
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
                                                        routeList[whereChangeField()]['other_dates'][index]['dep_slot_id'] = value;
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
                                                        routeList[whereChangeField()]['other_dates'][index]['land_slot_id'] = value;
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
                                ]);
                              }),

                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.fromLTRB(0,20,0,0),
                                      child: TextButton(
                                        onPressed:(){
                                          routeList[whereChangeField()]['other_dates'].add({
                                            "date": "",
                                            "landing_date": "2021-05-17",
                                            "is_required_dep_slot": 1,
                                            "dep_slot_id": "",
                                            "is_required_land_slot": 1,
                                            "land_slot_id": "",
                                          });
                                          setState(() {});
                                          },
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
                              itemCount: routeList[whereChangeField()]['period_dates'].length,
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
                                                            periodsStart[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                            routeList[whereChangeField()]['period_dates'][index]['start_date'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                            setState(() {});
                                                          }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                    icon: Icon(CupertinoIcons.calendar, size: 16),)
                                              ),
                                              onChanged: (value){
                                                setState(() {
                                                  routeList[whereChangeField()]['period_dates'][index]['start_date'] = value;
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
                                                            periodsEnd[index] = TextEditingController(text: '${dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString()}');
                                                            routeList[whereChangeField()]['period_dates'][index]['end_date'] = dayBolb + date.year.toString()+"-"+ monthBolb + date.month.toString()+"-"+ date.day.toString();
                                                            setState(() {});
                                                          }, currentTime: DateTime.now(), locale: language == 'ru' ? LocaleType.ru : LocaleType.en);},

                                                    icon: Icon(CupertinoIcons.calendar, size: 16),)
                                              ),
                                              onChanged: (value){
                                                setState(() {
                                                  routeList[whereChangeField()]['period_dates'][index]['end_date'] = value;
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
                                        routeList[whereChangeField()]['period_dates'].removeAt(index);
                                        setState(() {});
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
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['mo'] = !repeatsPeriod[index]['mo'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][0]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][0]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][0]['clicked'] = 0;
                                              });
                                              countDayOfPeriod();
                                              }, child:Container(
                                                margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                padding: EdgeInsets.fromLTRB(8,10,8,10),
                                                width:MediaQuery.of(context).size.width/7-11,
                                                decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['mo'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                                ),
                                                  alignment: Alignment.center,
                                                  child:Text(vocabular['myPhrases']['mo'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['tu'] = !repeatsPeriod[index]['tu'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][1]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][1]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][1]['clicked'] = 0;
                                                });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,10,0),
                                                padding: EdgeInsets.fromLTRB(9,10,9,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['tu'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['tu'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['we'] = !repeatsPeriod[index]['we'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][2]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][2]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][2]['clicked'] = 0;
                                                });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,10,0),
                                              padding: EdgeInsets.fromLTRB(8,10,8,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['we'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['we'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['th'] = !repeatsPeriod[index]['th'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][3]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][3]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][3]['clicked'] = 0;
                                              });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,10,0),
                                              padding: EdgeInsets.fromLTRB(9,10,9,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['th'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['th'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['fr'] = !repeatsPeriod[index]['fr'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][4]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][4]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][4]['clicked'] = 0;
                                              });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,10,0),
                                              padding: EdgeInsets.fromLTRB(9,10,9,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['fr'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['fr'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['sa'] = !repeatsPeriod[index]['sa'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][5]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][5]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][5]['clicked'] = 0;
                                              });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,10,0),
                                              padding: EdgeInsets.fromLTRB(9,10,9,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['sa'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['sa'], style: st4),
                                            ),),
                                            GestureDetector(onTap: (){
                                              setState(() {
                                              repeatsPeriod[index]['su'] = !repeatsPeriod[index]['su'];
                                              routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][6]['clicked'] == 0 ? routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][6]['clicked'] = 1 : routeList[whereChangeField()]['period_dates'][index]['days_of_week_objects'][6]['clicked'] = 0;
                                              });
                                              countDayOfPeriod();
                                              }, child:Container(
                                              margin: EdgeInsets.fromLTRB(0,10,0,0),
                                              padding: EdgeInsets.fromLTRB(9,10,9,10),
                                              width:MediaQuery.of(context).size.width/7-12,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1.5, color: !repeatsPeriod[index]['su'] ? kWhite3 : kYellow),
                                                color: kBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(vocabular['myPhrases']['su'], style: st4),
                                            ),),
                                  ]),
                                    SizedBox(height: 20,)
                            ]);
                             }),
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
                                                   child:Text(docsForSlots[index]['created_at']),
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
                                               child: Text(docsForSlots[index]['file_type_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
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
                                         CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 8,  doc_object: 'n_form_flight')));
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
                                              onPressed:(){
                                                repeatsPeriod.add({"start":"" , "end":"", "mo": true, "tu":true, "we":true, "th":true, "fr":true, "sa":true, "su":true});
                                                routeList[whereChangeField()]['period_dates'].add({
                                                  "start_date": "",
                                                  "end_date": "",
                                                  "days_of_week": [],
                                                  "days_of_week_objects": [{"number": 1, "clicked": 1},{"number": 2, "clicked": 1},{"number": 3, "clicked": 1},{"number": 4, "clicked": 1},{"number": 5, "clicked": 1},{"number": 6, "clicked": 1},{"number": 7, "clicked": 1}],
                                                });
                                                setState(() {});
                                                } ,
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
                      //секция ЭКИПАЖ
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
                                      Text(vocabular['form_n']['flight_crew'],style: st8,),
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
                                          SizedBox(height: 20,),
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0,10,0,0),
                                                  width:MediaQuery.of(context).size.width - 100 ,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('Согласно FPL', style: st14),
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
                                                          value: fpl, //изменить переменную
                                                          onToggle: (value) {
                                                            setState(() {
                                                              fpl = value; //изменить переменную
                                                              routeList[whereChangeField()]['crew']['is_fpl'] = value == true ? 1 : 0;
                                                              value == true ? dialogScreen(context, 'Данные о членах экипажа будут очищены') : dialogScreen(context, 'Данные о списках экипажа будут очищены');
                                                              value == true ? routeList[whereChangeField()]['crew']['crew_groups'] = [] : routeList[whereChangeField()]['crew']['crew_mebers'] = [];
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                              ]),

                                          //секция согласно ФПЛ
                                          fpl ? Column(
                                                children: [
                                                    ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: routeList[whereChangeField()]['crew']['crew_groups'].length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        fplValue.add(TextEditingController());
                                                        return Row(
                                                          children: [
                                                            Stack(
                                                            children: <Widget>[
                                                                Container(
                                                                  width: 150,
                                                                  height: 40,
                                                                  margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                                                  padding: EdgeInsets.fromLTRB(20,0,0,0),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: kWhite1),
                                                                  ),
                                                                    child: TextFormField(
                                                                      keyboardType: TextInputType.numberWithOptions(
                                                                          decimal: false,
                                                                          signed: false),
                                                                      decoration: InputDecoration(
                                                                          border: UnderlineInputBorder(
                                                                          borderSide: BorderSide.none
                                                                        ),
                                                                        hintText: vocabular['form_n']['crew']['crew_number'],
                                                                        hintStyle: st8,
                                                                          suffixIcon: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [GestureDetector( onTap: (){routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity']++;fplValue[index] = TextEditingController(text: routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity'].toString());setState(() {});}, child:Icon(Icons.add)),GestureDetector( onTap: (){routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity'] > 0 ? routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity']-- : null;fplValue[index] = TextEditingController(text: routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity'].toString());setState(() {});}, child:Icon(Icons.remove,))]),
                                                                        contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                                                                            ),
                                                                            onChanged: (value){
                                                                            setState(() {
                                                                              //fplPilots[index]['col'] = int.parse(value);
                                                                              routeList[whereChangeField()]['crew']['crew_groups'][index]['quantity'] = int.parse(value);
                                                                            });
                                                                            },
                                                                          autovalidateMode: AutovalidateMode.always,
                                                                      controller: fplValue[index],
                                                                          ),
                                                                        ),
                                                                Positioned(
                                                                  left: 10,
                                                                  top: 3,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 0, left: 7, right: 7),
                                                                        color: kBlue,
                                                                          child: Text(vocabular['form_n']['crew']['crew_number'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),
                                                                      )),
                                                                    ],),
                                                              Stack(
                                                                children: <Widget>[
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width /3,
                                                                    height: 40,
                                                                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: kWhite1),
                                                                    ),
                                                                    child: TextFormField(
                                                                      initialValue: routeList[whereChangeField()]['crew']['crew_groups'][index]['state']['state_namelat'],
                                                                      decoration: InputDecoration(
                                                                        border: UnderlineInputBorder(
                                                                            borderSide: BorderSide
                                                                                .none
                                                                        ),
                                                                        hintText: vocabular['form_n']['crew']['nationality'],
                                                                        hintStyle: st8,
                                                                        contentPadding: new EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 12,
                                                                            horizontal: 5.0),
                                                                      ),
                                                                      onChanged: (
                                                                          value) {
                                                                        setState(() {
                                                                          //fplPilots[index]['residence'] = value;
                                                                          routeList[whereChangeField()]['crew']['crew_groups'][index]['state']['state_namelat'] = value;
                                                                          routeList[whereChangeField()]['crew']['crew_groups'][index]['state']['state_namerus'] = value;
                                                                          routeList[whereChangeField()]['crew']['crew_groups'][index]['state']['STATES_ID'] = 94;

                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                      left: 10,
                                                                      top: 3,
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(bottom: 0, left: 7, right: 7),
                                                                        color: kBlue,
                                                                        child: Text(
                                                                          vocabular['form_n']['crew']['nationality'],
                                                                          style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),
                                                                        ),
                                                                      )),
                                                                ]),
                                                            GestureDetector(
                                                              onTap: (){
                                                                //fplPilots.removeAt(index);
                                                                routeList[whereChangeField()]['crew']['crew_groups'].removeAt(index);
                                                                setState(() {});
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

                                                    ]);}),
                                                  Container(
                                                    height: 40,
                                                    width: MediaQuery.of(context).size.width,
                                                    alignment: Alignment.bottomCenter,
                                                    margin: EdgeInsets.fromLTRB(0,20,0,0),
                                                    child: TextButton(
                                                      onPressed:(){
                                                        setState(() {
                                                          //fplPilots.add({"col":1, "residence":""});
                                                          routeList[whereChangeField()]['crew']['crew_groups'].add({
                                                            "STATES_ID": 0,
                                                            "quantity": 1,
                                                            "state": {
                                                              "STATES_ID": 0,
                                                              "state_namelat": "",
                                                              "state_namerus": "",
                                                            },
                                                          });
                                                        });
                                                      } ,
                                                      child: Text(vocabular['form_n']['crew']['add'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                                            ]
                                          ) : 
                                          //секция ручного ввода
                                          routeList[whereChangeField()]['crew']['crew_mebers'].length != null ? ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: routeList[whereChangeField()]['crew']['crew_mebers'].length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                    children: [
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 40,
                                                            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: kWhite1),),
                                                            child: TextFormField(
                                                              initialValue: routeList[whereChangeField()]['crew']['crew_mebers'][index]['fio'],
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: vocabular['form_n']['general']['full_name'],
                                                                hintStyle: st8,
                                                                contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  //pilots[index]['fio'] = value;
                                                                  routeList[whereChangeField()]['crew']['crew_mebers'][index]['fio'] = value;
                                                                });
                                                              },),),
                                                          Positioned(
                                                              left: 15, top: 12,
                                                              child: Container(
                                                                padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                color: kBlue,
                                                                child: Text(vocabular['form_n']['general']['full_name'],
                                                                  style: TextStyle(
                                                                      color: kWhite.withOpacity(0.3),
                                                                      fontFamily: 'AlS Hauss',
                                                                      fontSize: 12),),)),
                                                          Positioned(
                                                            right:10, top:10, child:
                                                          GestureDetector(
                                                            onTap: (){
                                                              routeList[whereChangeField()]['crew']['crew_mebers'].removeAt(index);setState(() {});
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
                                                        ],),
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 40,
                                                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: kWhite1),),
                                                            child: TextFormField(
                                                              initialValue: routeList[whereChangeField()]['crew']['crew_mebers'][index]['state']['state_namelat'],
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: vocabular['form_n']['crew']['nationality'],
                                                                hintStyle: st8,
                                                                contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  //pilots[index]['residence'] = value;
                                                                  routeList[whereChangeField()]['crew']['crew_mebers'][index]['state']['STATES_ID'] = 94;
                                                                  routeList[whereChangeField()]['crew']['crew_mebers'][index]['state']['state_namerus'] = value;
                                                                  routeList[whereChangeField()]['crew']['crew_mebers'][index]['state']['state_namerus'] = value;
                                                                });
                                                              },),),
                                                          Positioned(
                                                              left: 15, top: 12,
                                                              child: Container(
                                                                padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                color: kBlue,
                                                                child: Text(
                                                                  vocabular['form_n']['crew']['nationality'],
                                                                  style: TextStyle(
                                                                      color: kWhite.withOpacity(0.3),
                                                                      fontFamily: 'AlS Hauss',
                                                                      fontSize: 12),),)),
                                                        ],),
                                                      routeList[whereChangeField()]['crew']['crew_mebers'][index]['documents'].length > 0 ? ListView.builder(
                                                          physics: NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: routeList[whereChangeField()]['crew']['crew_mebers'][index]['documents'].length,
                                                          itemBuilder: (BuildContext context,int index2) {
                                                            return Stack(
                                                              children: <Widget>[
                                                                Container(width: MediaQuery.of(context).size.width,
                                                                  padding: EdgeInsets.fromLTRB(10, 10, 10,10),
                                                                  decoration: BoxDecoration(
                                                                    color: kBlue,
                                                                  ),
                                                                  child: Row(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                          width: MediaQuery.of(context).size.width -90,
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(width: 0.5,color: kWhite3),
                                                                            color: kBlue,
                                                                          ),
                                                                          child: Text(routeList[whereChangeField()]['crew']['crew_mebers'][index]['documents'][index2]['created_at']),),
                                                                        SizedBox(width: 10,),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            routeList[whereChangeField()]['crew']['crew_mebers'][index]['documents'].removeAt(index2);
                                                                            setState(() {});
                                                                          },
                                                                          child: Container(
                                                                            padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(width: 0.5,color: kWhite3),
                                                                              color: kBlue,
                                                                            ),
                                                                            child: Image.asset('icons/delete.png',width: 12,height: 12,fit: BoxFit.fitHeight),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                                Positioned(
                                                                    left: 22,
                                                                    top: 2,
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                      color: kBlue,
                                                                      child: Text(
                                                                        routeList[whereChangeField()]['crew']['crew_mebers'][index]['documents'][index2]['file_type_name'],
                                                                        style: TextStyle(
                                                                            color: kWhite
                                                                                .withOpacity(
                                                                                0.3),
                                                                            fontFamily: 'AlS Hauss',
                                                                            fontSize: 12),
                                                                      ),
                                                                    )),
                                                              ],
                                                            );
                                                          }):Container(),
                                                      Container(height: 40,width: MediaQuery.of(context).size.width,
                                                        alignment: Alignment.bottomCenter,
                                                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                        child: TextButton(
                                                          onPressed: () {Navigator.pushReplacement(context,
                                                              CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 4, stringNum: index,  doc_object: 'n_form_crew_member')));},
                                                          child: Text(
                                                            s264,
                                                            style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss',color: kYellow,),
                                                            textAlign: TextAlign.center,),style: ElevatedButton.styleFrom(primary: kBlue,minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: kWhite2,width: 1,style: BorderStyle.solid),
                                                            borderRadius: BorderRadius.circular(0.0),
                                                          ),
                                                        ),
                                                        ),
                                                      ),
                                                    ]);
                                              }):Container(),
                                          !fpl ? Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,30,10,0),
                                            child: TextButton(
                                              onPressed:(){
                                                setState(() {
                                                  //pilots.add({"fio":"", "residence":"", "documents": []});
                                                  routeList[whereChangeField()]['crew']['crew_mebers'].add({
                                                    "fio": "ФИО",
                                                    "state": {
                                                      "STATES_ID": 0,
                                                      "state_namelat": "",
                                                      "state_namerus": "",
                                                    },
                                                    "documents": []
                                                  });
                                                });

                                              } ,
                                              child: Text(vocabular['form_n']['crew']['add_crew_member'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                                          ): Container(),
                                     ]))
                              ])),
                      // секция Пассажиры
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _e11 = !_e11;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(_e11? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                                        color: kWhite2,
                                      ),
                                      SizedBox(width: 5,),
                                      Text("${vocabular['form_n']['passengers']}",style: st8,),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Divider(height: 2,thickness: 2,color: kWhite1,),
                                      ),
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: _e11,
                                    child: Column(
                                        children: [
                                          routeList[whereChangeField()]['passengers'].length != null ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: routeList[whereChangeField()]['passengers']['passengers_persons'].length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                  children: [
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
                                                            initialValue: routeList[whereChangeField()]['passengers']['passengers_persons'][index]['fio'],
                                                            decoration: InputDecoration(
                                                              border: UnderlineInputBorder(
                                                                  borderSide: BorderSide.none),
                                                              hintText: vocabular['form_n']['general']['full_name'],
                                                              hintStyle: st8,
                                                              contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                routeList[whereChangeField()]['passengers']['passengers_persons'][index]['fio'] = value;
                                                              });
                                                            },),),
                                                        Positioned(
                                                            left: 15, top: 12,
                                                            child: Container(
                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                              color: kBlue,
                                                              child: Text(vocabular['form_n']['general']['full_name'],
                                                                style: TextStyle(
                                                                    color: kWhite.withOpacity(0.3),
                                                                    fontFamily: 'AlS Hauss',
                                                                    fontSize: 12),),)),
                                                        Positioned(
                                                          right:10, top:10, child:
                                                        GestureDetector(
                                                          onTap: (){
                                                            routeList[whereChangeField()]['passengers']['passengers_persons'].removeAt(index);
                                                            setState(() {});
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
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 40,
                                                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: kWhite1),),
                                                          child: TextFormField(
                                                            initialValue: routeList[whereChangeField()]['passengers']['passengers_persons'][index]['state']['state_namelat'],
                                                            decoration: InputDecoration(
                                                              border: UnderlineInputBorder(
                                                                  borderSide: BorderSide.none),
                                                              hintText: vocabular['form_n']['passengers_obj']['nationality'],
                                                              hintStyle: st8,
                                                              contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10),),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                routeList[whereChangeField()]['passengers']['passengers_persons'][index]['state']['state_namelat'] = value;
                                                                routeList[whereChangeField()]['passengers']['passengers_persons'][index]['state']['state_namerus'] = value;
                                                                routeList[whereChangeField()]['passengers']['passengers_persons'][index]['state']['STATES_ID'] = 94;
                                                              });
                                                            },),),
                                                        Positioned(
                                                            left: 15, top: 12,
                                                            child: Container(
                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                              color: kBlue,
                                                              child: Text(
                                                                vocabular['form_n']['passengers_obj']['nationality'],
                                                                style: TextStyle(
                                                                    color: kWhite.withOpacity(0.3),
                                                                    fontFamily: 'AlS Hauss',
                                                                    fontSize: 12),),)),
                                                      ],),
                                                    routeList[whereChangeField()]['passengers']['passengers_persons'][index]['documents'] != null ? ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: routeList[whereChangeField()]['passengers']['passengers_persons'][index]['documents'].length,
                                                        itemBuilder: (BuildContext context,int index2) {
                                                          return Stack(
                                                            children: <Widget>[
                                                              Container(width: MediaQuery.of(context).size.width,
                                                                padding: EdgeInsets.fromLTRB(10, 10, 10,10),
                                                                decoration: BoxDecoration(
                                                                  color: kBlue,
                                                                ),
                                                                child: Row(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                        width: MediaQuery.of(context).size.width -90,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(width: 0.5,color: kWhite3),
                                                                          color: kBlue,
                                                                        ),
                                                                        child: Text(routeList[whereChangeField()]['passengers']['passengers_persons'][index]['documents'][index2]['created_at']),),
                                                                      SizedBox(width: 10,),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          routeList[whereChangeField()]['passengers']['passengers_persons'][index]['documents'].removeAt(index2);
                                                                          setState(() {});
                                                                        },
                                                                        child: Container(
                                                                          padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(width: 0.5,color: kWhite3),
                                                                            color: kBlue,
                                                                          ),
                                                                          child: Image.asset('icons/delete.png',width: 12,height: 12,fit: BoxFit.fitHeight),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                              Positioned(
                                                                  left: 22,
                                                                  top: 2,
                                                                  child: Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        bottom: 0,
                                                                        left: 10,
                                                                        right: 10),
                                                                    color: kBlue,
                                                                    child: Text(
                                                                      routeList[whereChangeField()]['passengers']['passengers_persons'][index]['documents'][index2]['file_type_name'],
                                                                      style: TextStyle(
                                                                          color: kWhite
                                                                              .withOpacity(
                                                                              0.3),
                                                                          fontFamily: 'AlS Hauss',
                                                                          fontSize: 12),
                                                                    ),
                                                                  )),
                                                            ],
                                                          );
                                                        }):Container(),
                                                    Container(height: 40,width: MediaQuery.of(context).size.width,
                                                      alignment: Alignment.bottomCenter,
                                                      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                                                      child: TextButton(
                                                        onPressed: () {Navigator.pushReplacement(context,
                                                            CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 3, stringNum: index)));},
                                                        child: Text(
                                                          s264,
                                                          style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss',color: kYellow,),
                                                          textAlign: TextAlign.center,),style: ElevatedButton.styleFrom(primary: kBlue,minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: kWhite2,width: 1,style: BorderStyle.solid),
                                                            borderRadius: BorderRadius.circular(0.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]);
                                            }):Container(),
                                       Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,30,10,0),
                                            child: TextButton(
                                              onPressed:(){
                                                setState(() {
                                                  routeList[whereChangeField()]['passengers']['passengers_persons'].add({
                                                    "fio": "ФИО",
                                                    "state": {
                                                      "STATES_ID": 94,
                                                      "state_namelat": "RUSSIA",
                                                      "state_namerus": "РОССИЯ",
                                                    },
                                                    "documents": []
                                                  });
                                                });
                                                routeList[whereChangeField()]['passengers']['quantity'] = routeList[whereChangeField()]['passengers']['passengers_persons'].length;
                                              } ,
                                              child: Text(vocabular['form_n']['passengers_obj']['add_passenger'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                      // секция ГРУЗ
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
                                      Text(vocabular['form_n']['cargo'],style: st8,),
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
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: routeList[whereChangeField()]['cargos'].length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Container(
                                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    color: kBlueLight,
                                                    child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                cargoItem[index]['view'] =
                                                                !cargoItem[index]['view'];
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: 5,),
                                                                Text(
                                                                  '${routeList[whereChangeField()]['cargos'][index]['type_and_characteristics']}',
                                                                  style: st8,),
                                                                SizedBox(width: 5,),
                                                                Expanded(
                                                                  child: Divider(
                                                                    height: 2,
                                                                    thickness: 2,
                                                                    color: kWhite1,),
                                                                ),
                                                                SizedBox(width: 5,),
                                                                Text(
                                                                    cargoItem[index]['view'] ==
                                                                        true
                                                                        ? vocabular['form_n']['general']['collapse']
                                                                        : vocabular['form_n']['general']['expand'],
                                                                    style: st10),
                                                                SizedBox(
                                                                  width: 5,),

                                                                GestureDetector(
                                                                  onTap: (){
                                                                    cargoItem.removeAt(index);setState(() {});
                                                                  },
                                                                  child:Container(
                                                                    margin: EdgeInsets.fromLTRB(20,0,20,0),
                                                                    child:Image.asset('icons/delete.png', width: 12, height: 12, fit: BoxFit.fitHeight),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                          ExpandedSection(
                                                              expand: cargoItem[index]['view'] == true ? true : false,
                                                              child: Column(
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['cargo_danger_classes_id'].toString(),
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['type_cargo'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets.symmetric(vertical: 5,horizontal: 0.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['cargo_danger_classes_id'] = int.parse(value);
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(left: 20,top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 5,right: 0),
                                                                              color: kBlueLight,
                                                                              child: Text(vocabular['form_n']['cargo_obj']['type_cargo'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                        children: <Widget>[
                                                                          Stack(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width /2 -25,
                                                                                height: 40,
                                                                                margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                                padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: kWhite1),
                                                                                ),
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  value: cargoItem[index]['ICAOclass'],
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
                                                                                      cargoItem[index]['ICAOclass'] = newValue;
                                                                                      routeList[whereChangeField()]['cargos'][index]['cargo_danger_classes_id'] = newValue == 'Класс 1' ? 0 : 1;
                                                                                    });
                                                                                  },
                                                                                  items: dangerClassUnits.map<DropdownMenuItem<String>>((String value) {
                                                                                    return DropdownMenuItem<String>(
                                                                                        value: value,
                                                                                        child: Text(
                                                                                            value
                                                                                        )
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                            ),

                                                                              Positioned(
                                                                                  left: 20,
                                                                                  top: 12,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.only(bottom: 0,left: 5,right: 0),
                                                                                    color: kBlueLight,
                                                                                    child: Text(vocabular['form_n']['cargo_obj']['class_icao'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
                                                                                    ),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Stack(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                  width: MediaQuery.of(context).size.width /2 -25,
                                                                                  height: 40,
                                                                                  margin: EdgeInsets.fromLTRB(0,20,10,0),
                                                                                  padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                                  decoration: BoxDecoration(
                                                                                  border: Border.all(color: kWhite1),
                                                                                  ),
                                                                                child: TextFormField(
                                                                                  initialValue: routeList[whereChangeField()]['cargos'][index]['weight'].toString(),
                                                                                  decoration: InputDecoration(
                                                                                      border: UnderlineInputBorder(
                                                                                          borderSide: BorderSide.none
                                                                                      ),
                                                                                      hintText: vocabular['form_n']['cargo_obj']['weight_cargo'],
                                                                                      hintStyle: st8,
                                                                                      contentPadding: new EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 5,
                                                                                          horizontal: 0.0),
                                                                                      suffixIcon: Container(
                                                                                        alignment: Alignment
                                                                                            .center,
                                                                                        height: 20,
                                                                                        width: 20,
                                                                                        margin: EdgeInsets.fromLTRB(5,5,5,5),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: kWhite1,
                                                                                        ),
                                                                                        child: Text(
                                                                                            'КГ',
                                                                                            style: st11),
                                                                                      )
                                                                                  ),
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      routeList[whereChangeField()]['cargos'][index]['weight'] = int.parse(value);
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                  left: 5,
                                                                                  top: 12,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.only(
                                                                                        bottom: 0,
                                                                                        left: 5,
                                                                                        right: 0),
                                                                                    color: kBlueLight,
                                                                                    child: Text(
                                                                                      vocabular['form_n']['cargo_obj']['weight_cargo'],
                                                                                      style: TextStyle(
                                                                                          color: kWhite
                                                                                              .withOpacity(
                                                                                              0.3),
                                                                                          fontFamily: 'AlS Hauss',
                                                                                          fontSize: 12),
                                                                                    ),
                                                                                  )),
                                                                            ],
                                                                          ),

                                                                        ]),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['cargo_charterer'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['charterer'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['cargo_charterer'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['charterer'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 50,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['cargo_charterer_fulladdress'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide
                                                                                      .none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['charterer_address'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['cargo_charterer_fulladdress'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['charterer_address'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            inputFormatters: [maskFormatterPhone],
                                                                            keyboardType: TextInputType.phone,
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['cargo_charterer_phone'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['freighter_phone'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['cargo_charterer_phone'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: 0,
                                                                                  left: 10,
                                                                                  right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['freighter_phone'],
                                                                                style: TextStyle(
                                                                                    color: kWhite
                                                                                        .withOpacity(
                                                                                        0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['receiving_party'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide
                                                                                      .none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['host'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['receiving_party'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['host'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 50,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['receiving_party_fulladdress'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide
                                                                                      .none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['host_address'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['receiving_party_fulladdress'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['host_address'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            inputFormatters: [maskFormatterPhone],
                                                                            keyboardType: TextInputType.phone,
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['receiving_party_phone'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['host_phone'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets.symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['receiving_party_phone'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: 0,
                                                                                  left: 10,
                                                                                  right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['host_phone'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignor'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['snipper'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignor'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['snipper'],
                                                                                style: TextStyle(
                                                                                    color: kWhite
                                                                                        .withOpacity(
                                                                                        0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 50,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignor_fulladdress'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide
                                                                                      .none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['snipper_address'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignor_fulladdress'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: 0,
                                                                                  left: 10,
                                                                                  right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['snipper_address'],
                                                                                style: TextStyle(
                                                                                    color: kWhite
                                                                                        .withOpacity(
                                                                                        0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            inputFormatters: [maskFormatterPhone],
                                                                            keyboardType: TextInputType.phone,
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignor_phone'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['snipper_phone'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignor_phone'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: 0,
                                                                                  left: 10,
                                                                                  right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['snipper_phone'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignee'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['consignee'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets.symmetric(vertical: 12,horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignee'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['consignee'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 50,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignee_fulladdress'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide
                                                                                      .none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['consignee_address'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignee_fulladdress'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: 0,
                                                                                  left: 10,
                                                                                  right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['consignee_address'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          height: 40,
                                                                          margin: EdgeInsets.fromLTRB(10,20,10,20),
                                                                          padding: EdgeInsets.fromLTRB(5,0,0,0),
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: kWhite1),
                                                                          ),
                                                                          child: TextFormField(
                                                                            inputFormatters: [maskFormatterPhone],
                                                                            keyboardType: TextInputType.phone,
                                                                            initialValue: routeList[whereChangeField()]['cargos'][index]['consignee_phone'],
                                                                            decoration: InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide.none
                                                                              ),
                                                                              hintText: vocabular['form_n']['cargo_obj']['consignee_phone'],
                                                                              hintStyle: st8,
                                                                              contentPadding: new EdgeInsets.symmetric(
                                                                                  vertical: 12,
                                                                                  horizontal: 10.0),
                                                                            ),
                                                                            onChanged: (
                                                                                value) {
                                                                              setState(() {
                                                                                routeList[whereChangeField()]['cargos'][index]['consignee_phone'] = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            left: 20,
                                                                            top: 12,
                                                                            child: Container(
                                                                              padding: EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                                                              color: kBlueLight,
                                                                              child: Text(
                                                                                vocabular['form_n']['cargo_obj']['consignee_phone'],
                                                                                style: TextStyle(
                                                                                    color: kWhite.withOpacity(0.3),
                                                                                    fontFamily: 'AlS Hauss',
                                                                                    fontSize: 12),
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    routeList[whereChangeField()]['cargos'][index]['documents'] != null ? ListView.builder(
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: routeList[whereChangeField()]['cargos'][index]['documents'].length,
                                                                        itemBuilder: (BuildContext context,int index2) {
                                                                          return Stack(
                                                                            children: <Widget>[
                                                                              Container(width: MediaQuery.of(context).size.width,
                                                                                padding: EdgeInsets.fromLTRB(10, 10, 10,10),
                                                                                decoration: BoxDecoration(
                                                                                  color: kBlueLight,
                                                                                ),
                                                                                child: Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                                                        width: MediaQuery.of(context).size.width -90,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(width: 0.5,color: kWhite3),
                                                                                          color: kBlueLight,
                                                                                        ),
                                                                                        child: Text(routeList[whereChangeField()]['cargos'][index]['documents'][index2]['created_at']),),
                                                                                      SizedBox(width: 10,),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          routeList[whereChangeField()]['cargos'][index]['documents'].removeAt(index2);
                                                                                          setState(() {});
                                                                                        },
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.fromLTRB(13.5,13.5,13.5,13.5),
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(width: 0.5,color: kWhite3),
                                                                                            color: kBlueLight,
                                                                                          ),
                                                                                          child: Image.asset('icons/delete.png',width: 12,height: 12,fit: BoxFit.fitHeight),
                                                                                        ),
                                                                                      ),
                                                                                    ]),
                                                                              ),
                                                                              Positioned(
                                                                                  left: 22,
                                                                                  top: 2,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: 0,
                                                                                        left: 10,
                                                                                        right: 10),
                                                                                    color: kBlueLight,
                                                                                    child: Text(
                                                                                      routeList[whereChangeField()]['cargos'][index]['documents'][index2]['file_type_name'],
                                                                                      style: TextStyle(
                                                                                          color: kWhite
                                                                                              .withOpacity(
                                                                                              0.3),
                                                                                          fontFamily: 'AlS Hauss',
                                                                                          fontSize: 12),
                                                                                    ),
                                                                                  )),
                                                                            ],
                                                                          );
                                                                        }):Container(),
                                                                    Container(height: 40,width: MediaQuery.of(context).size.width,
                                                                      alignment: Alignment.bottomCenter,
                                                                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                      child: TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pushReplacement(context,
                                                                            CupertinoPageRoute(builder: (context) => docTypeSelectPage(routNum: 5, stringNum: index)));},
                                                                        child: Text(
                                                                          s264,
                                                                          style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss',color: kYellow,),
                                                                          textAlign: TextAlign.center,),style: ElevatedButton.styleFrom(primary: kBlueLight,minimumSize: Size(MediaQuery.of(context).size.width, 20),
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(color: kWhite2,width: 1,style: BorderStyle.solid),
                                                                          borderRadius: BorderRadius.circular(0.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ])),
                                                        ])));
                                          }),
                                      Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.fromLTRB(10,30,10,0),
                                            child: TextButton(
                                              onPressed:(){
                                                setState(() {
                                                  cargoItem.add({"view":false,"cargoId":"${cargoItem.length+1}","cargoType": "", "ICAOclass":"Класс 1", "cargoMassa":"","frahtName":"","frahtAddress":"","frahtPhone":"","reciveSend":"", "reciveSendAddress":"", "reciveSendPhone":"", "cargoSender":"", "cargoSenderAddress":"", "cargoSenderPhone":"","cargoReciver":"", "cargoReciverAddress":"","cargoReciverPhone":"","otherDoc": []});
                                                  routeList[whereChangeField()]['cargos'].add({
                                                    "type_and_characteristics": "",
                                                    "cargo_danger_classes_id": 1,
                                                    "weight": 1000,
                                                    "cargo_charterer": "",
                                                    "cargo_charterer_fulladdress": "",
                                                    "cargo_charterer_phone": "",
                                                    "receiving_party": "",
                                                    "receiving_party_fulladdress": "",
                                                    "receiving_party_phone": "",
                                                    "consignor": "",
                                                    "consignor_fulladdress": "",
                                                    "consignor_phone": "",
                                                    "consignee": "",
                                                    "consignee_fulladdress": "",
                                                    "consignee_phone": "",
                                                    "documents": []
                                                  });
                                                });
                                                //print(cargoItem);
                                              } ,
                                              child: Text(vocabular['form_n']['cargo_obj']['add_cargo'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kYellow,),textAlign: TextAlign.center,),
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
                      // секция ЛИЦО ОПЛАЧИВАЮЩЕЕ АЭРОНАВИГАЦИОННЫЕ СБОРЫ
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
                                      Text(s260,style: st8,),
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
                                        children: [
                                          Stack(
                                              children: <Widget>[
                                          Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                          child: DropdownButton<String>(
                                            //menuMaxHeight: 67,
                                            isExpanded: true,
                                            value: payerContactPerson.toString(),
                                            icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                                            iconSize: 30,
                                            elevation: 10,
                                            underline: Container(
                                              height: 0,
                                              color: kBlueLight,
                                            ),
                                            onChanged: (String newValue){
                                              setState(() {
                                                payerContactPerson = int.parse(newValue);
                                              });
                                            },
                                            items: payerPerson.map<DropdownMenuItem<String>>((String value) {
                                              //payerPerson = [0,1,2]; //заявитель, авакомпания, владелец
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text('${value == '0' ? 'Заявитель' : value == '1' ? 'Авиакомпания' : 'Владелец'}', style: st4,),
                                              );
                                            }).toList(),
                                          ),),
                                                Positioned( left: 15, top: 12,
                                                    child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                      child: Text(vocabular['form_n']['person_paying_obj']['contact_person'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)),
                                              ]),
                                              /*Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(keyboardType: TextInputType.number, initialValue:payerContactPerson,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['person_paying_obj']['contact_person'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerContactPerson = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text(vocabular['form_n']['person_paying_obj']['contact_person'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                              */
Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(initialValue:payerFio,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['form_n']['general']['full_name'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerFio = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text(vocabular['form_n']['general']['full_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                              Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(initialValue: payerOrganisation,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'Организация',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerOrganisation = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text('Организация',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                              Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(initialValue:payerEmail,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'E-mail',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerEmail = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text('E-mail',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                              Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(inputFormatters: [maskFormatterPhone],
                                                      keyboardType: TextInputType.numberWithOptions(
                                                          decimal: false,
                                                          signed: false),initialValue:payerPhone,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: s189,hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerPhone = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text(s189,style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                              Stack(
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                    child: TextFormField(initialValue:payerAFTN,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'AFTN',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                      onChanged: (value){setState(() {payerAFTN = value;});},),),
                                                  Positioned( left: 15, top: 12,
                                                      child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                        child: Text('AFTN',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                          Stack(
                                            children: <Widget>[
                                              Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                child: TextFormField(initialValue:payerAddress,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'Address',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                  onChanged: (value){setState(() {payerAddress = value;});},),),
                                              Positioned( left: 15, top: 12,
                                                  child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                    child: Text('Address',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                          Stack(
                                            children: <Widget>[
                                                Container(width: MediaQuery.of(context).size.width , height: 100,margin: EdgeInsets.fromLTRB(10, 20, 10, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                child: TextFormField(maxLines: 3, minLines:1, initialValue:commentPreLast,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['myPhrases']['hintNotesText'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                  onChanged: (value){setState(() {commentPreLast = value;});},),),
                                                Positioned( left: 15, top: 12,
                                                  child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                    child: Text(s265,style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),
                                        ]))
                              ])),
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
                                    ],
                                  ),
                                ),
                                ExpandedSection(
                                    expand: e10,
                                    child: Column(
                                        children: [
                                          
                                          Stack(
                                            children: <Widget>[
                                              Container(width: MediaQuery.of(context).size.width , height: 100,margin: EdgeInsets.fromLTRB(0, 20, 0, 10),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                                                child: TextFormField(maxLines: 3, minLines:1, initialValue:commentLast,decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: vocabular['myPhrases']['commentToReceipt'],hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                                                  onChanged: (value){setState(() {commentLast = value;});},),),
                                              Positioned( left: 15, top: 12,
                                                  child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                                    child: Text(vocabular['myPhrases']['commentText'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],),


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
                                                              child:Text(commentDocs[index]['created_at']),
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
                                                          child: Text(commentDocs[index]['file_type_name'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss',fontSize: 12),
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
                      /*Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.fromLTRB(0,20,0,0),
                        child: TextButton(
                          onPressed:(){
                            sendFormN();
                          } ,
                          child: Text(vocabular['form_n']['general']['send_form'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                          style: ElevatedButton.styleFrom(
                            primary: kYellow,
                            minimumSize: Size(MediaQuery.of(context).size.width, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                      ),*/
                      SizedBox(height: 50)
                    ]))
        ),
      ),
    );
  }

  sendFormN()async{
    setState(() {
      sendProcess = true;
    });

    formN = {
      //"n_forms_id" : 1234, //Передавать при обновлении
      //"id_pakus": 1234, //Передавать при обновлении
      //"permit_num": 1234, //Передавать при обновлении
      "author_id": int.parse(userId),// получить айди автора заявки
      "source_id": 1,
      //"taken_by_id":1234, //кем заявка взята
      //"take_time": "2021-05-28 15:57:13", //когда заявка взята
      "selected_role_id": 1, // Роль заявителя (Обычный заявитель, ФАВТ, МИД, Минпромторг)!!!!!!!!!!!!!!!! установить в диалоге выбора
      "airline": {
        //"n_forms_id" : 1234, //Передавать при обновлении
        //"n_form_airlines_id" : 1234, //Передавать при обновлении
        "AIRLINES_ID": airlineId,
        "STATES_ID" : stateCode,
        "airline_icao": "$icao",
        "airline_namelat": "$aviaCompanyNameLat",
        "airline_namerus": "$aviaCompanyName",
        "ano_is_paid": 0, //сделать проверку !!!!!!!!!!!!!!!!!!!!
        //"airline_represent_id" : 1234, //Передавать при обновлении
        //"russia_represent_id" : 1234, //Передавать при обновлении
        "state": {
          "STATE_ID": stateCode,
          "state_namelat": "$regCountryLat",
          "state_namerus": "$regCountry",
        },
        "documents": aviaCompanyDocs,
        "airline_represent": {
          //"person_info_id" : 1234, //Передавать при обновлении
          "fio": "$upFio",
          "position": "$upGrade",
          "email": "$upEmail",
          "tel": "$upPhone",
          "fax": "$upFax",
          "sita": "$upSITA",
          "aftn": "$upAFTN"
        },
        "russia_represent": {
          //"person_info_id" : 1234, //Передавать при обновлении
          "fio": "$upFios",
          "email": "$upEmails",
          "tel": "$upPhones",
          "fax": "$upFaxs",
          "sita": "$upSITAs",
          "aftn": "$upAFTNs"
        },
      },
      "is_entire_fleet": 0, //внутренний полет или нет мы решим перебрав STATE_ID всех рейсов !!!!!!!!!!!!!!!!!
      "aircrafts": fleetsList,
      "flights": routeList,
      "airnav_payer": {
        //"n_form_airnav_payer_id" : 1234, //Передавать при обновлении
        "contact_person": payerContactPerson,
        "fio": payerFio,
        "organization": payerOrganisation,
        "tel": payerPhone,
        "email": payerEmail,
        "aftn": payerAFTN,
        "address": payerAddress,
        "remarks": commentPreLast,
      },
      "n_form_remarks": commentLast,
      "documents": commentDocs,
    };

    int id = DateTime.now().microsecondsSinceEpoch;
    //трансформируем список груза
    List listCargos = [];
    for(int i = 0; i < cargoItem.length; i++){
      listCargos.add({
        "id": id,
          "cargoTypeCargo": "${cargoItem[i]['cargoType']}",
          "cargoClassDangerICAO": "${cargoItem[i]['ICAOclass']}",
          "cargoClassDangerId" : 1,//надо передавать из меню видимо
          "cargoWeightCargo": "${cargoItem[i]['cargoMassa']}",
          "cargoCharterer": "${cargoItem[i]['frahtName']}",
          "cargoChartererFullAddress": "${cargoItem[i]['frahtAddress']}",
          "cargoChartererPhone": "${cargoItem[i]['frahtPhone']}",
          "cargoHost": "${cargoItem[i]['reciveSend']}",
          "cargoHostFullAddress": "${cargoItem[i]['reciveSendAddress']}",
          "cargoHostPhone": "${cargoItem[i]['reciveSendPhone']}",
          "cargoShipper": "${cargoItem[i]['cargoSender']}",
          "cargoShipperPhone": "${cargoItem[i]['cargoSenderPhone']}",
          "cargoShipperFullAddress": "${cargoItem[i]['cargoSenderAddress']}",
          "cargoConsignee": "${cargoItem[i]['cargoReciver']}",
          "cargoConsigneePhone": "${cargoItem[i]['cargoReciverPhone']}",
          "cargoConsigneeFullAddress": "${cargoItem[i]['cargoReciverAddress']}",
          "panel": false,
          "documents": []
      });
    }
//трансформация списка точек пересечения
    List listPoints = [];
    for(int i = 0; i < routes[0]['inOutPoints'].length; i++){
      listPoints.add({
        "name": "${routes[0]['inOutPoints'][i]['point']}",
        "mainPoint": {
          "POINTS_ID": 73,
          "ISGATEWAY": 1,
          "pnthist": routes[0]['inOutPoints'][i]['pnthist']
          },
        "time": "${routes[0]['inOutPoints'][i]['time']}",
        "error": false,
        "alternatePoints": []
      });
    }
    //print(toSend['informationFlight']);
    //print(formN);
    //debugPrint(json.encode(formN), wrapWidth: 3024);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/testFormaN.json');
    var profile = jsonEncode(formN);
    await file.writeAsString(profile);
    //отправляем собраный лист
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/saveNForm';
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      request.add(utf8.encode(json.encode(formN))); //ручная форма
      //request.add(utf8.encode(json.encode(toSend)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      //debugPrint(reply, wrapWidth: 1024);
    }catch(e){
      print(e);
    }
    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) =>HomePage()));
    sendProcess = false;
  }

}

