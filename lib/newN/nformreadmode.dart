import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avia_app/newN/proceed.dart';
import 'package:avia_app/newN/servicefunctions.dart';
import 'package:avia_app/newN/subscreens/readairline.dart';
import 'package:avia_app/newN/subscreens/readmainaircraft.dart';
import 'package:avia_app/newN/subscreens/readroute.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/widgets/commentDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'historyNew.dart';


var _vocabular;
var _nFormBody;
bool loadReady = false;
bool commetShow = false;
bool partInfo = false;
bool partAircraft = false;
bool partReservAircraft = false;
bool partPayer = false;
bool partComment = false;
bool partDoc = false;
bool rejectedFilter = false;
List commentsExpander = [];

class formNreadMode extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<formNreadMode> {
  final commentKey = new GlobalKey();
  final payerKey = new GlobalKey();
  final aircraftMainKey = new GlobalKey();
  final aircraftReservKey = new GlobalKey();

 //обновление страницы после всплывающего окна (например после отправки примечания или смены статуса)
  @override
  FutureOr onGoBack(dynamic value) {
    _timer.cancel();
    getFormNData();
  }

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

  //подгрузили форму Н из файла
  getNformData() async {
    String data = await rootBundle.loadString('vocNew/formN.json');
    _nFormBody = json.decode(data);
    loadReady = true;
    setState(() {});
  }

  //получаем данные для заполнения полей конкректной формы
  @override
  getFormNData() async{
    print('Берем данные формы');
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/GetFormN?id=$formId&user_id=$userId';
      //String url = '${serverURL}api/api/v1/GetFormN?id=120';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      _nFormBody = json.decode(reply); // форма с сервера
      //print(_nFormBody['NForm']['airline']);
      //print(_nFormBody['NForm']['version']);
      //print(_nFormBody['NForm']['n_forms_id']);
      loadReady = true;
      startTimer();
      setState(() {});
    }catch(e){
      print('ошибка тут 3$e');
    }
  }

  //ищем глобал обджект ИД для отправки коммента по основному ВС
  objID(){int num = 0; for(int i = 0; i < _nFormBody['NForm']['aircrafts'].length; i++){ _nFormBody['NForm']['aircrafts'][i]['is_main'] == 1 ? num = _nFormBody['NForm']['aircrafts'][i]['n_form_aircrafts_global_id'] : null;} return num;}

  //определяем строку с самолетом в массиве содержащую ссылку из коментариев
  searchMainAircraft(int id){
    var num = 0;
    for(int i= 0; i < _nFormBody['NForm']['aircrafts'].length; i++){
      _nFormBody['NForm']['aircrafts'][i]['n_form_aircrafts_global_id'] == id ? num = i : null;
    }
    return num;
  }

  //определяем строку с рейсом в массиве содержащую ссылку из коментариев
  searchRoute(int id){
    var num = 0;
    for(int i= 0; i < _nFormBody['NForm']['aircrafts'].length; i++){
      _nFormBody['NForm']['flights'][i]['n_form_flight_global_id'] == id ? num = i : null;
    }
    return num;
  }

  //определяем куда скролить для каждого типа коммента
  crollRoute(String type, int id){
    setState(() {
      commetShow == false;
    });
    //print(type);
    // Информация об АК перекинуть на экран
    // - airline
    if(type == 'airline'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => airlineReadMode(n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['airline']],)));
    }
    // АК документы перекинуть на экран и проскролить в раздел
    // - airline_documents
    else if(type == 'airline_documents'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => airlineReadMode(n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] , airlineList: [_nFormBody['NForm']['airline']], expand: 1,)));
    }

    // АК Уполномоченный представитель перекинуть на экран и проскролить в раздел
    // - airline_represent
    else if(type == 'airline_represent'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => airlineReadMode(n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['airline']], expand: 2,)));
    }
    // Основное ВС перекинуть на экран
    // - aircraft_main
    else if(type == 'aircraft_main'){
      setState(() {
        partAircraft = true;
      });
      new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(aircraftMainKey.currentContext));

    }
    // Параметры перекинуть на экран и проскролить в раздел
    // - aircraft_main_parameters
    else if(type == 'aircraft_main_parameters'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]['n_form_aircrafts_global_id'], isReserv: false, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]],expand: 2,)));
    }
    // Владелец перекинуть на экран и проскролить в раздел
    // - aircraft_main_owner
    else if(type == 'aircraft_main_owner'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]['n_form_aircrafts_global_id'],isReserv: false, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]],expand: 3,)));
    }
    // Резервные ВС перекинуть на экран
    // - aircraft_reserve
    else if(type == 'aircraft_reserve'){
      setState(() {
        partReservAircraft = true;
      });
      new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(aircraftReservKey.currentContext));
    }
    // Параметры перекинуть на экран и проскролить в раздел
    // - aircraft_reserve_parameters
    else if(type == 'aircraft_reserve_parameters'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]['n_form_aircrafts_global_id'], isReserv: true, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]],expand: 2,)));
    }
    // Владелец перекинуть на экран и проскролить в раздел
    // - aircraft_reserve_owner
    else if(type == 'aircraft_reserve_owner'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]['n_form_aircrafts_global_id'], isReserv: true, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][searchMainAircraft(id)]],expand: 3,)));
    }
    // Информация о рейсе перекинуть на экран конкретного рейса n_form_flight_global_id
    // - flight
    else if(type == 'flight'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']], n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 1,)));
    }
    // Основная дата перекинуть на экран конкртного рейса и проскролить в раздел
    // - flight_main_date
    else if(type == 'flight_main_date'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 2,)));
    }
    // Повторы  перекинуть на экран конкртного рейса, на экран раздела
    // - flight_other_date
    else if(type == 'flight_other_date'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 3,)));
    }
    // Экипаж перекинуть на экран конкртного рейса, на экран раздела
    // - flight_crew
    else if(type == 'flight_crew'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 4,)));
    }
    // Пассажиры перекинуть на экран конкртного рейса, на экран раздела
    // - flight_passengers
    else if(type == 'flight_passengers'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 5,)));
    }
    // Груз перекинуть на экран конкртного рейса, на экран раздела
    // - flight_cargo
    else if(type == 'flight_cargo'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 6,)));
    }
    // Параметры груза перекинуть на экран конкртного рейса, на экран раздела, и проскролить в раздел
    // - flight_cargo_parameters
    else if(type == 'flight_cargo_parameters'){ ///это не сюда
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][searchRoute(id)]],expand: 7,)));
    }
    // Лицо оплачивающее сборы перекинуть на экран конкртного рейса, на экран раздела
    // - airnav_payer
    else if(type == 'airnav_payer'){
      setState(() {
        partPayer = true;
      });
      new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(payerKey.currentContext));
    }
    // Комментарий проскролить
    // - n_form_remarks
    else if(type == 'n_form_remarks'){
      setState(() {
        partComment = true;
      });
      new Timer(Duration(seconds:1), () => Scrollable.ensureVisible(commentKey.currentContext));
    }

  }


  //таймер продления занятия заявки
  Timer _timer;
  int _start = 600;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          addTime();
          setState(() {
            _start = 600;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }


  @override
  void dispose() {
    _timer != null ? _timer.cancel() : null;
    super.dispose();
  }

  @override
  void initState() {
    loadJsonLanguage();
    //getNformData(); //локальная форма
    getFormNData(); //форма с сервера
    super.initState();
  } //initState

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      appBar:loadReady == true ? AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: kBlue,
        leading: GestureDetector(onTap: (){
          workComplite();//освобождаем форму
          _timer.cancel(); //выключаем таймер обновления формы
          Navigator.pop(context);
        }, child:Container(
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          alignment: Alignment.center,
          child:Text(_vocabular['registry']['user_profile']['back'], style: st12,),),
        ),
        title: Column(
            children:[
              /*Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text('${language == 'ru' ? _nFormBody['NForm']['airline']['airline_namerus'] : _nFormBody['NForm']['airline']['airline_namelat']}', style: st4,),
              ),*/
              Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                alignment: Alignment.center,
                child:Text(_nFormBody['NForm']['permit_num'], style: st4,),
              ),
            ]
        ),
        actions:[
          GestureDetector(onTap:(){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => proceed(airlineList: [_nFormBody],))).then(onGoBack);

  }, child:Container(
            margin: EdgeInsets.fromLTRB(0,0,10,0),
            alignment: Alignment.center,
            child:Text(_vocabular['forms']['process'], style: st12,),
          )),
        ],
      ):AppBar( automaticallyImplyLeading: false,
          centerTitle: true,
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: kBlue,
          leading:CircularProgressIndicator()),
      body: loadReady == true ? SingleChildScrollView(
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
                      onTap: () {},
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2 -20,
                          height: 31,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: kYellow),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14.0),
                                bottomLeft: Radius.circular(14.0)),
                            color: kYellow,
                          ),
                          child: Text(_vocabular['forms']['form'], style: st17,textAlign: TextAlign.center,)
                      ),
                    ),
                    GestureDetector(onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => historyPageNew(id_pakus: _nFormBody['NForm']['id_pakus'], permit_num: _nFormBody['NForm']['permit_num'], flight_num: _nFormBody['NForm']['flights'][0]['flight_information']['flight_num'], main_date: _nFormBody['NForm']['flights'][0]['main_date']['date'], departure_airport_icao:_nFormBody['NForm']['flights'][0]['flight_information']['departure_airport_icao'] , landing_airport_icao: _nFormBody['NForm']['flights'][0]['flight_information']['landing_airport_icao'], landing_time: _nFormBody['NForm']['flights'][0]['flight_information']['landing_time'],)));





                    }, child:Container(
                        width: MediaQuery.of(context).size.width / 2 -20,
                        height: 31,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kWhite2),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(14.0),
                              bottomRight: Radius.circular(14.0)),
                          color: kBlue,
                        ),
                        child: Text(_vocabular['history'], style: st17,textAlign: TextAlign.center,)
                    ),
                    ),
                  ]),
            ),
            //индикатор коментариев (примечаний)
            _nFormBody['NForm']['comments'].length > 0? Container(
                margin: EdgeInsets.fromLTRB(10,10,10,5),
                padding: EdgeInsets.fromLTRB(10,5,10,5),
                color:  comment(_nFormBody['NForm']['comments'])[1] > 0 ? Colors.blue.withOpacity(0.5) : comment(_nFormBody['NForm']['comments'])[2] > 0 ? Colors.yellow.withOpacity(0.5) : comment(_nFormBody['NForm']['comments'])[0] > 0 ? kRed.withOpacity(0.5) : kBlue,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    children:[
                      Image.asset(
                    comment(_nFormBody['NForm']['comments'])[1] > 0 ? 'icons/triangle_blue.png' : comment(_nFormBody['NForm']['comments'])[2] > 0 ? 'icons/triangle_red.png' : 'icons/triangle_yellow.png', width: 16,
                          height: 16,
                          fit: BoxFit.fitHeight),
                      SizedBox(width: 10,),
                      Expanded( child:Text('${comment(_nFormBody['NForm']['comments'])[0] > 0 ? '${_vocabular['form_n']['flight_information_obj']['notes']}: ${comment(_nFormBody['NForm']['comments'])[0]}': ''}  ${comment(_nFormBody['NForm']['comments'])[1] > 0 ? '${_vocabular['form_n']['flight_information_obj']['information_request']}: ${comment(_nFormBody['NForm']['comments'])[1]}': ''}  ${comment(_nFormBody['NForm']['comments'])[2] > 0 ? '${_vocabular['form_n']['flight_information_obj']['fault']}: ${comment(_nFormBody['NForm']['comments'])[2]}': ''}'),),
                      Spacer(),
                      GestureDetector( onTap:(){
                        setState(() {
                          commetShow = !commetShow;
                        });
                      },child:Text(commetShow == false ? _vocabular['form_n']['general']['expand'] : _vocabular['form_n']['general']['collapse'], style: st12,)),
                    ])
            ) : Container(),
            commetShow == true ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _nFormBody['NForm']['comments'].length,
                itemBuilder: (BuildContext context, int index) {
                  commentsExpander.add(false);
                  return GestureDetector(onTap: () => crollRoute(_nFormBody['NForm']['comments'][index]['object_type'], _nFormBody['NForm']['comments'][index]['object_id']), child:Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                      padding: EdgeInsets.fromLTRB(10,5,10,5),
                      color: _nFormBody['NForm']['comments'][index]['comment_type_id'] == 5 ? kRed.withOpacity(0.5) : _nFormBody['NForm']['comments'][index]['comment_type_id'] == 2 ? Colors.blue.withOpacity(0.5) : Colors.yellow.withOpacity(0.5),
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Image.asset(
                                      _nFormBody['NForm']['comments'][index]['comment_type_id'] == 5 ? 'icons/triangle_red.png' : _nFormBody['NForm']['comments'][index]['comment_type_id'] == 2 ? 'icons/triangle_blue.png' : 'icons/triangle_yellow.png', width: 16,
                                      height: 16,
                                      fit: BoxFit.fitHeight),
                                  SizedBox(width: 10,),
                                  Text('${_nFormBody['NForm']['comments'][index]['comment_text']}'),
                                  Spacer(),
                                  _nFormBody['NForm']['comments'][index]['child_comments'].length > 0 ? GestureDetector(
                                    onTap:(){
                                      setState(() {
                                    commentsExpander[index] = !commentsExpander[index];
                                  });
                                    },
                                      child:Text(commentsExpander[index] == false ? _vocabular['form_n']['general']['expand'] : _vocabular['form_n']['general']['collapse'], style: st12,)) : Container(),
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(25,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${_vocabular['form_n']['flight_information_obj']['openly']}   ${_nFormBody['NForm']['comments'][index]['created_at'].substring(0,10)}   ${_nFormBody['NForm']['comments'][index]['author']['roles'][0]['name_lat']}  ${_nFormBody['NForm']['comments'][index]['author']['first_name']} ${_nFormBody['NForm']['comments'][index]['author']['last_name'].substring(0,1)}.', style: st2,),
                            ),
                            _nFormBody['NForm']['comments'][index]['child_comments'].length > 0 && commentsExpander[index] == true ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: _nFormBody['NForm']['comments'][index]['child_comments'].length,
                                itemBuilder: (BuildContext context, int indexCH) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(30,0,0,0),
                                      padding: EdgeInsets.fromLTRB(10,5,10,5),
                                      //color: _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 5 ? kRed.withOpacity(0.5) : _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 2 ? Colors.blue.withOpacity(0.5) : Colors.yellow.withOpacity(0.5),
                                      child:Column(
                                          children:[
                                            Row(
                                                children:[
                                                  Image.asset(
                                                      _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 5 ? 'icons/triangle_red.png' : _nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['comment_type_id'] == 2 ? 'icons/triangle_blue.png' : 'icons/triangle_yellow.png', width: 16,
                                                      height: 16,
                                                      fit: BoxFit.fitHeight),
                                                  SizedBox(width: 10,),
                                                  Text('${_nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['text']}'),
                                                  //Spacer(),
                                                  //Text(_vocabular['form_n']['general']['expand'], style: st12,)
                                                ]),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(25,0,0,0),
                                              alignment: Alignment.centerLeft,
                                              child:Text('${_vocabular['form_n']['flight_information_obj']['openly']}   ${_nFormBody['NForm']['comments'][index]['child_comments'][indexCH]['created_at'].substring(0,10)}   ${_nFormBody['NForm']['comments'][index]['author']['roles'][0]['name_lat']}  ${_nFormBody['NForm']['comments'][index]['author']['first_name']} ${_nFormBody['NForm']['comments'][index]['author']['last_name'].substring(0,1)}.', style: st2,),
                                            ),
                                          ])
                                  );
                                }
                            ) : Container(),
                          ])
                  ));
                }
            ) : Container(),
            SizedBox(height: 20,),
            //информация об авиакомпании
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        partInfo =!partInfo;
                      });
                    }, child:Icon(partInfo == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['form_n']['information_about_airline'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                    ),
                    GestureDetector(onTap:(){
                      showDialog(
                          context: context,
                          builder: (_) {
                            return commentDialog(title: _vocabular['form_n']['information_about_airline'], n_forms_id: _nFormBody['NForm']['n_forms_id'], id_pakus: _nFormBody['NForm']['id_pakus'], object_type: 'airline', object_id: 0);
                          }).then(onGoBack);


                    }, child:Container(
                        width:22,
                        height: 22,
                        margin: EdgeInsets.fromLTRB(10,0,10,0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                        ),
                        child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                  ],
                )
            ),
            partInfo == true ? GestureDetector(
                onTap:(){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => airlineReadMode(n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['airline']],)));

                },
                child:Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(10,10,10,10),
                padding: EdgeInsets.fromLTRB(10,10,10,10),
                color: kBlueLight,
                child:Column(
                    children:[
                      Row(
                          children:[
                            Transform(
                                alignment: FractionalOffset.center,
                                transform: new Matrix4.identity()
                                  ..rotateZ(135 * 3.1415927 / 180),
                                child:Icon(Icons.link_rounded, color:kYellow, size: 25)),
                            SizedBox(width: 10,),
                            Expanded( child:Text('${language == 'ru' ? _nFormBody['NForm']['airline']['airline_namerus'] : _nFormBody['NForm']['airline']['airline_namelat']}', style: st4,),),
                            _nFormBody['NForm']['airline']['akvs_airlines_id'] != null ? Image.asset(
                                _nFormBody['NForm']['airline']['akvs_airlines_id'] == 0 ? 'icons/verifed.png' : _nFormBody['NForm']['airline']['akvs_airlines_id'] == 1 ? 'icons/ask.png' : 'icons/warning.png', width: 16,
                                height: 16,
                                fit: BoxFit.fitHeight) : Container(),
                            SizedBox(width: 5,),
                            _nFormBody['NForm']['airline']['airline_lock'] != null ? Image.asset(
                                _nFormBody['NForm']['airline']['airline_lock'] == 0 ? 'icons/unlock.png' : 'icons/lock.png', width: 16,
                                height: 16,
                                fit: BoxFit.fitHeight) : Container(),
                            SizedBox(width: 10,),
                            Container(
                                width:22,
                                height: 22,
                                margin: EdgeInsets.fromLTRB(10,0,10,0),
                                child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                          ]),
                      Container(
                        margin: EdgeInsets.fromLTRB(32,0,0,0),
                        alignment: Alignment.centerLeft,
                        child:Text('${_nFormBody['NForm']['airline']['airline_icao']}/${_vocabular['airline']['updated_at']}: Нет информации с сервера', style: st2,),
                      ),
                    ])
            )) : Container(),
            //основное воздушное судно
            Container(
              //key: aircraftMainKey,
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        partAircraft =!partAircraft;
                      });
                    }, child:Icon(partAircraft == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['form_n']['aircraft'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                    ),
                    GestureDetector(onTap:(){
                      showDialog(
                          context: context,
                          builder: (_) {
                            return commentDialog(title: _vocabular['form_n']['aircraft'], n_forms_id: _nFormBody['NForm']['n_forms_id'], id_pakus: _nFormBody['NForm']['id_pakus'], object_type: 'aircraft_main',object_id: objID());
                          }).then(onGoBack);


                      }, child:Container(
                        width:22,
                        height: 22,
                        margin: EdgeInsets.fromLTRB(10,0,10,0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                        ),
                        child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                  ],
                )
            ),
            partAircraft == true ? ListView.builder(
              key: aircraftMainKey,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _nFormBody['NForm']['aircrafts'].length,
                itemBuilder: (BuildContext context, int index) {
                  return _nFormBody['NForm']['aircrafts'][index]['is_main'] == 1 ? GestureDetector(
                      onTap:(){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][index]['n_form_aircrafts_global_id'], isReserv: false, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][index]],)));

                      },
                      child:Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      color: kBlueLight,
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Transform(
                                      alignment: FractionalOffset.center,
                                      transform: new Matrix4.identity()
                                        ..rotateZ(135 * 3.1415927 / 180),
                                      child:Icon(Icons.link_rounded, color:kYellow, size: 25)),
                                  SizedBox(width: 10,),
                                  Expanded( child:Text('${_nFormBody['NForm']['aircrafts'][index]['regno']}', style: st4,),),

                                  Container(
                                      width:22,
                                      height: 22,
                                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                                      child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(32,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${_nFormBody['NForm']['aircrafts'][index]['type_model']}/${_vocabular['airline']['updated_at']}: Нет информации с сервера', style: st2,),
                            ),
                          ])
                  ) ) : Container();
                }
            ) : Container(),
            //резервные воздушные суда
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        partReservAircraft =!partReservAircraft;
                      });
                    }, child:Icon(partReservAircraft == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['form_n']['aircraft_reserve'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                    ),

                  ],
                )
            ),
            partReservAircraft == true ? ListView.builder(
              key: aircraftReservKey,
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _nFormBody['NForm']['aircrafts'].length,
                itemBuilder: (BuildContext context, int index) {
                  return _nFormBody['NForm']['aircrafts'][index]['is_main'] == 0 ? GestureDetector(
                      onTap:(){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => readMainAircraft(object_id:_nFormBody['NForm']['aircrafts'][index]['n_form_aircrafts_global_id'], isReserv: false, n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['aircrafts'][index]],)));

                      },
                      child:Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      color: kBlueLight,
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Transform(
                                      alignment: FractionalOffset.center,
                                      transform: new Matrix4.identity()
                                        ..rotateZ(135 * 3.1415927 / 180),
                                      child:Icon(Icons.link_rounded, color:kYellow, size: 25)),
                                  SizedBox(width: 10,),
                                  Expanded( child:Text('${_nFormBody['NForm']['aircrafts'][index]['regno']}', style: st4,),),
                                  GestureDetector(onTap:(){
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return commentDialog(title: _vocabular['form_n']['aircraft_reserve'], n_forms_id: _nFormBody['NForm']['n_forms_id'], id_pakus: _nFormBody['NForm']['id_pakus'], object_type: 'aircraft_reserve', object_id: _nFormBody['NForm']['aircrafts'][index]['n_form_aircrafts_global_id']);
                                        }).then(onGoBack);


                                  }, child:Container(
                                      width:22,
                                      height: 22,
                                      margin: EdgeInsets.fromLTRB(10,0,0,0),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                                      ),
                                      child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14))),
                                  Container(
                                      width:22,
                                      height: 22,
                                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                                      child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(32,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${_nFormBody['NForm']['aircrafts'][index]['type_model']}/${_vocabular['airline']['updated_at']}: Нет информации с сервера', style: st2,),
                            ),
                          ])
                  ) ) : Container();
                }
            ) : Container(),
            //фильтр списка рейсов
            Container(
                margin: EdgeInsets.fromLTRB(30,0,40,0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Row(
                    children:[
                      Radio<bool>(
                        activeColor: kYellow,
                        value: false,
                        groupValue: rejectedFilter,
                        onChanged: (value) {
                          setState(() {
                            rejectedFilter = value;
                          });
                        },
                      ),
                      Text('${_vocabular['form_n']['route_obj']['topical']}: ${calculateTypeStatuses(_nFormBody['NForm']['flights'])[0]}', style: st4,)
                    ]
                  ),
                  Row(
                    children:[
                      Radio<bool>(
                        activeColor: kYellow,
                        value: true,
                        groupValue: rejectedFilter,
                        onChanged: (value) {
                          setState(() {
                            rejectedFilter = value;
                          });
                        },
                      ),
                      Text('${_vocabular['form_n']['route_obj']['canceled']}: ${calculateTypeStatuses(_nFormBody['NForm']['flights'])[1]}', style: st4,)
                    ]
                  )
                ]
              )
            ),
            //список рейсов
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _nFormBody['NForm']['flights'].length,
                itemBuilder: (BuildContext context, int index) {
                  return calculateStatus(_nFormBody['NForm']['flights'][index]['status']['id']) == (rejectedFilter == true ? false : true) ?  GestureDetector(
                      onTap:(){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => readRoute(comments:[_nFormBody['NForm']['comments']],n_forms_id:_nFormBody['NForm']['n_forms_id'] , id_pakus:_nFormBody['NForm']['id_pakus'] ,airlineList: [_nFormBody['NForm']['flights'][index]],)));

                      },
                      child:Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      color: kBlueLight,
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Expanded( child:Text('${_nFormBody['NForm']['flights'][index]['main_date']['date']} ${_nFormBody['NForm']['flights'][index]['flight_information']['flight_num']}', style: st4,),),
                                  Image.asset(
                                      comment(_nFormBody['NForm']['comments'])[1] > 0 ? 'icons/triangle_blue.png' : comment(_nFormBody['NForm']['comments'])[2] > 0 ? 'icons/triangle_red.png' : 'icons/triangle_yellow.png', width: 16,
                                      height: 16,
                                      fit: BoxFit.fitHeight),
                                  Container(
                                      width:22,
                                      height: 22,
                                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                                      child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                                ]),
                            Row(
                                children:[
                                  Expanded( child:Text('${_nFormBody['NForm']['flights'][index]['flight_information']['departure_airport_icao']} ${_nFormBody['NForm']['flights'][index]['flight_information']['departure_time']} → ${_nFormBody['NForm']['flights'][index]['flight_information']['landing_airport_icao']} ${_nFormBody['NForm']['flights'][index]['flight_information']['landing_time']}', style: st4,),),
                                ]),
                            Row(
                                children:[
                                  Expanded( child:Text('${_vocabular['form_n']['flight_crew']}: ${_nFormBody['NForm']['flights'][index]['crew']['crew_members_count'] != 0 && _nFormBody['NForm']['flights'][index]['crew']['crew_members_count'] != null ? _nFormBody['NForm']['flights'][index]['crew']['crew_members_count'] : _nFormBody['NForm']['flights'][index]['crew']['crew_groups_sum_quantity'] != 0 && _nFormBody['NForm']['flights'][index]['crew']['crew_groups_sum_quantity'] != null ? _nFormBody['NForm']['flights'][index]['crew']['crew_groups_sum_quantity'] : '0'}   ${_vocabular['form_n']['passengers']} ${_nFormBody['NForm']['flights'][index]['passengers']['quantity'] != 0 && _nFormBody['NForm']['flights'][index]['passengers']['quantity'] != null ? _nFormBody['NForm']['flights'][index]['passengers']['quantity'] : '0'}', style: st4,),),
                                ]),
                            Row(
                                children:[
                                  Expanded( child:Text('${_vocabular['form_n']['cargo']}: ${_nFormBody['NForm']['flights'][index]['cargos'].length}   ${_vocabular['form_n']['main_departure_date_obj']['repetitions']} ${_nFormBody['NForm']['flights'][index]['other_dates'].length + _nFormBody['NForm']['flights'][index]['period_dates'].length}', style: st4,),),

                                  Container(
                                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: kWhite3),
                                        borderRadius: BorderRadius.all(Radius.circular(12.5)),
                                        //color: kYellow,
                                      ),
                                      child: Text('${language == 'ru' ? _nFormBody['NForm']['flights'][index]['status']['name_rus'] : _nFormBody['NForm']['flights'][index]['status']['name_lat']}', style: TextStyle(fontSize: 14.0,fontFamily: 'AlS Hauss', color:  statusColor(_nFormBody['NForm']['flights'][index]['status']['id']),),textAlign: TextAlign.center,)
                                  ),
                                ])


                          ])
                  ) ): Container();
                }
            ),
            //лицо оплачивающее сборы
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        partPayer =!partPayer;
                      });
                    }, child:Icon(partPayer == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['form_n']['person_paying'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                    ),

                  ],
                )
            ),
            partPayer == true ? Row(
              key: payerKey,
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 70,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: kWhite3),
                      ),
                      child:Column(
                          children:[
                            Row(
                                children:[
                                  Expanded( child:Text('${_nFormBody['NForm']['airnav_payer']['fio']}', style: st4,),),
                                  Container(
                                      width:22,
                                      height: 22,
                                      margin: EdgeInsets.fromLTRB(10,0,10,0),
                                      child:Icon(Icons.arrow_forward_ios_sharp, color:kWhite3, size: 14))
                                ]),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,0,0,0),
                              alignment: Alignment.centerLeft,
                              child:Text('${_nFormBody['NForm']['airnav_payer']['email']} ${_vocabular['form_n']['general']['phone']}:${_nFormBody['NForm']['airnav_payer']['tel']} AFTN:${_nFormBody['NForm']['airnav_payer']['aftn']}', style: st2,),
                            ),
                          ])
                  ),
                  GestureDetector(onTap:(){
                    showDialog(
                        context: context,
                        builder: (_) {
                          return commentDialog(title: _vocabular['form_n']['person_paying'], n_forms_id: _nFormBody['NForm']['n_forms_id'], id_pakus: _nFormBody['NForm']['id_pakus'], object_type: 'airnav_payer', object_id: 0);
                        }).then(onGoBack);


                  }, child:Container(
                      width:22,
                      height: 22,
                      margin: EdgeInsets.fromLTRB(10,10,10,0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                      ),
                      child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                ]) : Container(),
            //комментарии
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap:(){
                      setState(() {
                        partComment =!partComment;
                      });
                    }, child:Icon(partComment == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                    Text(_vocabular['form_n']['comment'].toUpperCase(),style: st5,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Divider(height: 2,thickness: 2,color: kWhite1,),

                    ),
                  ])
            ),
            partComment == true ? Row(
              key: commentKey,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 70,
                      margin: EdgeInsets.fromLTRB(10,10,10,10),
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: kWhite3),
                      ),
                      child:Row(
                                children:[
                                  Expanded( child:Text('${_nFormBody['NForm']['n_form_remarks']}', style: st4,),),

                                ]),


                  ),
                  GestureDetector(onTap:(){
                    showDialog(
                        context: context,
                        builder: (_) {
                          return commentDialog(title: _vocabular['form_n']['comment'], n_forms_id: _nFormBody['NForm']['n_forms_id'], id_pakus: _nFormBody['NForm']['id_pakus'], object_type: 'n_form_remarks', object_id: 0);
                        }).then(onGoBack);


                  }, child:Container(
                      width:22,
                      height: 22,
                      margin: EdgeInsets.fromLTRB(10,10,10,0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Color(0xFF4378FF)),
                      ),
                      child:Icon(Icons.edit, color:Color(0xFF4378FF), size: 14)))
                ]) : Container(),
            //документы
            Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap:(){
                        setState(() {
                          partDoc =!partDoc;
                        });
                      }, child:Icon(partDoc == false ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 22, color: kWhite3),),
                      Text(_vocabular['airline']['docs'].toUpperCase(),style: st5,),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Divider(height: 2,thickness: 2,color: kWhite1,),

                      ),
                    ])
            ),
            partDoc == true  && _nFormBody['NForm']['documents'].length > 0 ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _nFormBody['NForm']['documents'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width -20 ,
                          margin: EdgeInsets.fromLTRB(10,10,10,10),
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: kWhite3),
                          ),
                          child:Column(
                              children:[
                                Row(
                                    children:[
                                      Expanded( child:Text('${_nFormBody['NForm']['documents'][index]['file_type_name']}', style: st6,),),
                                    ]),
                                SizedBox(height: 5,),
                                GestureDetector(onTap:()=>goToSite(_nFormBody['NForm']['documents'][index]['file_path']), child:Row(
                                    children:[
                                      Transform(
                                          alignment: FractionalOffset.center,
                                          transform: new Matrix4.identity()
                                            ..rotateZ(135 * 3.1415927 / 180),
                                          child:Icon(Icons.link_rounded, color:kYellow, size: 20)),
                                      SizedBox(width: 5,),
                                      Expanded( child:Text('${_nFormBody['NForm']['documents'][index]['file_name']}', style: st4,),),
                                    ]),),
                                SizedBox(height: 5,),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0,0,0,0),
                                  alignment: Alignment.centerLeft,
                                  child:Text('${_vocabular['form_n']['general']['loaded']}:${_nFormBody['NForm']['documents'][index]['created_at'].substring(0,10)}', style: st2,),
                                ),
                              ]),
                        ),
                      ]);
                }) : Container(),
            SizedBox(height: 100,)
          ],
        ),
      ):CircularProgressIndicator(),
    );
  }
}



