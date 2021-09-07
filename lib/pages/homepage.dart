import 'dart:convert';
import 'dart:io';

import 'package:avia_app/FormaN/fomaNfish.dart';
import 'package:avia_app/FormaN/formaNFromReestrNew.dart';
import 'package:avia_app/newN/nformreadmode.dart';
import 'package:avia_app/pages2/bottom_sheets/bottom_sheet1_other.dart';
import 'package:avia_app/pages2/homepage_other.dart';
import 'package:avia_app/profile/tuneProfile.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/constants.dart';
import 'package:avia_app/text_styles.dart';
import 'package:intl/intl.dart';
import '../strings.dart';
import 'bottom_sheets/bottom_sheet_7.dart';

bool filterFavorite = false;
int favoritId = 0;

List statuses = []; //массив для отображения статусов в верхней колонке
List statusesTypes = []; //массив с числовыми типами статусов в массиве stasuses
List statusesTypesText = ['All']; //массив с текстовыми значениями типов статусов рейсов
String selectedStatus = 'All'; //Переменная селектора типа статуса

List dispetcherComments = [];
var reestrFormsN, reestrFormNBackUp;
int formId = 0;
int formInListNum = 0;
bool readyReestr = false, speedFilterReady = false;
List speedFilter = [vocabular['registry']['top_filters']['all_forms'],vocabular['myPhrases']['draft'],vocabular['registry']['top_filters']['processing'],vocabular['registry']['top_filters']['postponed'],vocabular['registry']['top_filters']['rejected'],vocabular['registry']['top_filters']['agreed']];
//int fish=0; //индикаторы в быстрые фильты

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  var _controllerSearchRegion = TextEditingController();

  countStatusType(String type){
    int num = 0;
    for(int i = 0; i < statuses.length; i++){
      language == 'ru' ? statuses[i]['name_rus'] == type ? num++ : null : statuses[i]['name_lat'] == type ? num++ : null;
    }

    return num;
  }

  getListFormN() async{
    readyReestr = false;
    //reestrFormsN.clear();
    //reestrFormNBackUp.clear();
    statuses.clear();
    statusesTypes.clear();
    statusesTypesText.clear();
    statusesTypesText = ['All'];
    setState(() {

    });
    print("освежаем реестр$showRegistryType");
    //fish = 0;
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      //String url = '${serverURL}/api/api/v1/getRegistry?n_forms_id[\'sort\']=desc';
      String url = "${serverURL}api/api/v1/getRegistry?n_forms_id[\'sort\']=${ascDesc == false ? 'desc' : 'asc'}";//${permit_num.length > 0  ? '&permit_num[\'params\']=${permit_num.toString()}': ''}${purpose.length > 0 ? '&purpose[\'params\']=${purpose.toString()}' : ''}${registration_number.length > 0 ? '&registration_number[\'params\']=${registration_number.toString()}':''}${aircraft_type_icao.length > 0 ? '&aircraft_type_icao[\'params\']=${aircraft_type_icao.toString()}' : ''}${aircraft_owner.length > 0 ? '&aircraft_owner[\'params\']=${aircraft_owner.toString()}': ''}${created_at.length > 0 ? '&created_at[\'params\']=${created_at.toString()}':''}${flight_num.length > 0 ? '&flight_num[\'params\']=${flight_num.toString()}': ''}${landing_type.length > 0 ? '&landing_type[\'params\']=${landing_type.toString()}':''}${is_paid.length >0 ? '&is_paid[\'params\']=${is_paid.toString()}':''}
      print(url);
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //debugPrint(reply, wrapWidth: 1024);
      //final Directory directory = await getApplicationDocumentsDirectory();
      //final File file = File('${directory.path}/reestrformN.json');
      //await file.writeAsString(reply);
      reestrFormsN = json.decode(reply);
      reestrFormNBackUp = json.decode(reply); // для сортировок и восстановления первоисточника
      //print(reestrFormsN["NForms"]["data"][0]['flights']);
      //debugPrint(reestrFormsN["NForms"]["data"][0]['flights'].toString(), wrapWidth: 1024);
      //добавляем массив для комментов
      for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
        reestrFormsN["NForms"]["data"][i]['flights'].length > 0 ? statuses.add(reestrFormsN["NForms"]["data"][i]['flights'][0]['status']) : null;
        dispetcherComments.add({'formaNum' : i,
          'formaComment': {'aviacompany': [], 'aviacompanyDoc':[], 'aviacompanyPerson': [], 'aviacompanyMajorFleet': [], 'aviacompanyMajorFleetParams':[],'aviacompanyMajorFleetOner' :[], 'aviacompanyReservFleets':[], 'dateFlight': [], 'repeats': [], 'crew' : [], 'pasengers':[], 'cargoItems':[], 'payer': [], 'comment': []}});
      }

     for(int i =0; i < statuses.length; i++){
        if(!statusesTypes.contains(statuses[i]['id'])){
          statusesTypes.add(statuses[i]['id']);
          statusesTypesText.add(language == 'ru' ? statuses[i]['name_rus'] : statuses[i]['name_lat']);
          print(statusesTypesText);
        }

    //print(statusesTypes);
      }
      readyReestr = true;
      setState(() {});
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {

    super.initState();
    getListFormN();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        //extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBlue,
        leading: GestureDetector(
        onTap: (){setState(() {});},
    child: Container(
            padding: EdgeInsets.fromLTRB(9,15,0,0),
            child: Text(vocabular['registry']['status_panel']['select'], style: st12,))
        ),
        title: GestureDetector(
          onTap: (){},
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s1, style: st1),
                ],
              ),
              Text(
                readyReestr == true ? '${reestrFormsN["NForms"]["data"].length} ${reestrFormsN["NForms"]["data"].length.toString()[reestrFormsN["NForms"]["data"].length.toString().length-1] == '1' ? 'заявка' : reestrFormsN["NForms"]["data"].length.toString()[reestrFormsN["NForms"]["data"].length.toString().length-1] == '2' ? 'заявки'  : reestrFormsN["NForms"]["data"].length.toString()[reestrFormsN["NForms"]["data"].length.toString().length-1] == '3' ? 'заявки' : reestrFormsN["NForms"]["data"].length.toString()[reestrFormsN["NForms"]["data"].length.toString().length -1] == '4' ? 'заявки' : 'заявок'}' : 'Загрузка...', //это должно подставляться из JSON
                style: st2,
              )
            ],
          ),
        ),
        actions: [
          accessRole == 3 ? Container(
            height: 40,
            //alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(10,0,10,0),
            child:TextButton(
              onPressed:(){
                headerValue = s251;
                menuShow = false;
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) =>formaNFishPage()));
              },
              child: Text('+', style: TextStyle(fontSize: 30,fontFamily: 'AlS Hauss',color: kYellow),textAlign: TextAlign.center,),
              style: ElevatedButton.styleFrom(
                primary: kBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ) : Container(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          //поиск заявок
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 137,
                  height: 51,
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                      //hintText: vocabular['myPhrases']['hintAeroportName'],
                      hintStyle: st8,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10.0),
                      prefixIcon: Icon(Icons.search, color: kWhite, size: 18,),
                      suffixIcon: !_controllerSearchRegion.text.contains('n1') ? IconButton(
                        onPressed: () { _controllerSearchRegion.clear(); reestrFormsN = reestrFormNBackUp; setState(() {});},
                        icon: Icon(Icons.clear, color: kWhite, size: 18,),
                      ) : IconButton(
                        onPressed: () { Navigator.pushNamed(context, '/fomaN');},
                        icon: Icon(Icons.done, color: Colors.green, size: 18,),
                      ),
                    ),
                    onChanged: (value){
                      reestrFormsN = reestrFormNBackUp;
                      var tempList = json.decode('{"NForms":{"data":[]}}');
                      for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                        reestrFormsN["NForms"]["data"][i].toString().toLowerCase().contains(value.toLowerCase()) ? tempList["NForms"]["data"].add(reestrFormsN["NForms"]["data"][i]) : null;
                      }
                      reestrFormsN = tempList;
                      setState(() {});
                    },
                    autovalidateMode: AutovalidateMode.always,
                    controller: _controllerSearchRegion,
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      filterFavorite = !filterFavorite;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    child: Icon(
                      filterFavorite ? Icons.star : Icons.star_border,
                      color: kWhite,
                    ),
                  ),
                ),
                  InkWell(
                    onTap: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: kTrans,
                          context: context,
                          builder: (context) {
                            return BottomSheet7();
                          });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                      child: Icon(
                        Icons.filter_alt,
                        color: kWhite,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          //фильтры воронки поиска заявок
          Container(
            height: 34,
            width: size.width,
            // color: Colors.green,
            child: readyReestr == true ? ListView.builder(
              padding: EdgeInsets.only(left: 8),
              scrollDirection: Axis.horizontal,
              itemCount: statusesTypesText.length,
              itemBuilder: (context, index) {
                return GestureDetector(onTap: (){
                  setState(() {
                    selectedStatus = statusesTypesText[index];
                  });
                }, child:Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.only(left: 12, right: 5),
                  decoration: BoxDecoration(
                      color: kWhite2, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      Text(
                        statusesTypesText[index],
                        style: st4,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        height: 24,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kYellow),
                        child: Center(
                            child: Text(
                              '${statusesTypesText[index] == 'All' ? statuses.length : countStatusType(statusesTypesText[index])}', //это должно подставляться из JSON
                          style: st4,
                        )),
                      )
                    ]),
                ));
              },
            ):Container(),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  readyReestr ? ListView.builder(
                      physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reestrFormsN["NForms"]["data"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return selectedStatus == (reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ? language == 'ru' ? reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_rus'] : reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_lat'] : 'All') || selectedStatus == 'All' ? Column(
                            children: [
                              showRegistryType == false ? GestureDetector(onTap: (){
                                fromReestr = reestrFormsN["NForms"]["data"][index];
                                formInListNum = index;
                                formId = reestrFormsN["NForms"]["data"][index]["n_forms_id"];
                                formBootReady = false;
                                //selectUserRole(context);
                                isDispetcher = true;
                                //Navigator.pushReplacement(context,
                                //    CupertinoPageRoute(builder: (context) =>formaNFromReestrPage()));
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) =>formNreadMode()));
                                }, child:Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                          Expanded( child: Text(
                                              '${reestrFormsN["NForms"]["data"][index]['airline'] != null ? language == 'ru' ? reestrFormsN["NForms"]["data"][index]['airline']['airline_namelat'] : reestrFormsN["NForms"]["data"][index]['airline']['airline_namerus'] : 'No name'} - ${reestrFormsN["NForms"]["data"][index]['airline'] != null ? reestrFormsN["NForms"]["data"][index]['airline']['AIRLINE_ICAO'] : 'No ICAO'}',
                                              style: st1,
                                            )),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text('${DateFormat.MMMMEEEEd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]["created_at"])) == DateFormat.MMMMEEEEd(language).format(DateTime.now()) ? vocabular['registry']['datepicker_filters']['today'] : DateFormat.yMd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]["created_at"])).toString()}', style: st5,),
                                        ]),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Stack(
                                          children:[
                                          Container( alignment: Alignment.centerLeft,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                            Padding(padding: EdgeInsets.fromLTRB(0,0,40,0),
                                                child:Text(
                                                  '${reestrFormsN["NForms"]["data"][index]['aircrafts'].length > 0 ? reestrFormsN["NForms"]["data"][index]['aircrafts'][0]['registration_number'] : 'No number'} / ${reestrFormsN["NForms"]["data"][index]['aircrafts'].length > 0 ? reestrFormsN["NForms"]["data"][index]['aircrafts'][0]['aircraft_type_icao'] : 'No airplane'} / ${reestrFormsN["NForms"]["data"][index]['airline'] != null ? language == 'ru' ? reestrFormsN["NForms"]["data"][index]['airline']['airline_namelat'] : reestrFormsN["NForms"]["data"][index]['airline']['airline_namerus'] : 'No name'}',
                                                  style: st5,
                                                ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text('${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ?  language == 'ru' ? reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_rus'] : reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_lat']: 'No status'}', style: st6),

                                          ]),),
                                            Container( alignment: Alignment.centerRight, child:IconButton(
                                                icon: Icon(
                                                //Icons.info,
                                                    CupertinoIcons.info,
                                                      color: kYellow,
                                                      size: 35,
                                                    ),
                                                onPressed: () {
                                                  print(reestrFormsN["NForms"]['data'][index]['id_pakus']);
                                                  setState(() {
                                                    favoritId = reestrFormsN["NForms"]['data'][index]['id_pakus'];
                                                    fromReestr = reestrFormsN["NForms"]["data"][index];
                                                    formInListNum = index;
                                                    formId = reestrFormsN["NForms"]["data"][index]["n_forms_id"];
                                                    formBootReady = false;
                                                    //selectUserRole(context);
                                                    isDispetcher = true;
                                                  });

                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor: kTrans,
                                                      context: context,
                                                      builder: (context) {
                                                        return BottomSheet1Other();
                                                      });
                                                }),)
                                            ]),
                                      ])
                                  ),
                              ) :GestureDetector(onTap: (){
                                fromReestr = reestrFormsN["NForms"]["data"][index];
                                formInListNum = index;
                                formId = reestrFormsN["NForms"]["data"][index]["n_forms_id"];
                                formBootReady = false;
                                //selectUserRole(context);
                                isDispetcher = true;
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) =>formNreadMode()));
                              }, child:Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Expanded( child: Text(
                                                '${reestrFormsN["NForms"]["data"][index]['departure_dates'].length > 0 && reestrFormsN["NForms"]["data"][index]['departure_dates'][0]['date'] != null ? DateFormat.MMMMEEEEd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]['departure_dates'][0]['date'])) == DateFormat.MMMMEEEEd(language).format(DateTime.now()) ? vocabular['registry']['datepicker_filters']['today'] : DateFormat.yMd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]['departure_dates'][0]['date'])).toString() : 'No departure date'} - ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ? reestrFormsN["NForms"]["data"][index]['flights'][0]['flight_num'] : 'No number'}',
                                                style: st1,
                                              )),
                                              Text('${DateFormat.MMMMEEEEd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]["created_at"])) == DateFormat.MMMMEEEEd(language).format(DateTime.now()) ? vocabular['registry']['datepicker_filters']['today'] : DateFormat.yMd(language).format(DateTime.parse(reestrFormsN["NForms"]["data"][index]["created_at"])).toString()}', style: st5,),
                                            ]),
                                        SizedBox(
                                          height: 4,
                                        ),
                                                      Row(
                                                        children: [
                                                      Expanded( child: Text(
                                                          '${reestrFormsN["NForms"]["data"][index]['aircrafts'].length > 0 ? reestrFormsN["NForms"]["data"][index]['aircrafts'][0]['registration_number'] : 'No number'} / ${reestrFormsN["NForms"]["data"][index]['aircrafts'].length > 0 ? reestrFormsN["NForms"]["data"][index]['aircrafts'][0]['aircraft_type_icao'] : 'No airplane'} / ${reestrFormsN["NForms"]["data"][index]['airline'] != null ? language == 'ru' ? reestrFormsN["NForms"]["data"][index]['airline']['airline_namelat'] : reestrFormsN["NForms"]["data"][index]['airline']['airline_namerus'] : 'No name'} \n${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ? reestrFormsN["NForms"]["data"][index]['flights'][0]['departure_airport_icao'] : 'No dep. ICAO'} ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 && reestrFormsN["NForms"]["data"][index]['flights'][0]['departure_time'] != null ? reestrFormsN["NForms"]["data"][index]['flights'][0]['departure_time'] : 'No dep. time'} → ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ? reestrFormsN["NForms"]["data"][index]['flights'][0]['landing_airport_icao'] : 'No land. ICAO'} ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ? reestrFormsN["NForms"]["data"][index]['flights'][0]['landing_time'] : 'No land. time'} ${vocabular['form_n']['flight_crew']}: ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 && reestrFormsN["NForms"]["data"][index]['flights'] != null ? (reestrFormsN["NForms"]["data"][index]['flights'][0]['crew'] != null ? reestrFormsN["NForms"]["data"][index]['flights'][0]['crew']['crew_members_count']  : 0 )  : '0'}\n${vocabular['form_n']['passengers']}: ${reestrFormsN["NForms"]["data"][index]['passengers_quantity'] != null ? reestrFormsN["NForms"]["data"][index]['passengers_quantity']['quantity'] : 0 } ${vocabular['form_n']['cargo']}: ${reestrFormsN["NForms"]["data"][index]['flights'].length > 0  ? reestrFormsN["NForms"]["data"][index]['flights'][0]['cargos'].length > 0 && reestrFormsN["NForms"]["data"][index]['flights'][0]['cargos'][0]['weight'] !=null ? int.parse(reestrFormsN["NForms"]["data"][index]['flights'][0]['cargos'][0]['weight']) / 1000 : 0 : 0 }т ${vocabular['form_n']['main_departure_date_obj']['repetitions']}: ${reestrFormsN["NForms"]["data"][index]['flights'].length}',
                                                          style: st5,
                                                        ),),
                                                          SizedBox(width:40)
                                                      ]),
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                     Text('${reestrFormsN["NForms"]["data"][index]['flights'].length > 0 ?  language == 'ru' ? reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_rus'] : reestrFormsN["NForms"]["data"][index]['flights'][0]['status']['name_lat']: 'No status'}', style: st6),
                                                     IconButton(
                                                        icon: Icon(
                                                            CupertinoIcons.info,
                                                             color: kYellow,
                                                              size: 35,
                                                                ),
                                                                onPressed: () {
                                                                  print(reestrFormsN["NForms"]['data'][index]['id_pakus']);
                                                                  setState(() {
                                                                    favoritId = reestrFormsN["NForms"]['data'][index]['id_pakus'];
                                                                    fromReestr = reestrFormsN["NForms"]["data"][index];
                                                                    formInListNum = index;
                                                                    formId = reestrFormsN["NForms"]["data"][index]["n_forms_id"];
                                                                    formBootReady = false;
                                                                    //selectUserRole(context);
                                                                    isDispetcher = true;
                                                                  });

                                                                  showModalBottomSheet(
                                                                      isScrollControlled: true,
                                                                      backgroundColor: kTrans,
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return BottomSheet1Other();
                                                                      });
                                                                }),
                                                        ])
                                      ])
                              ),
                              ) ,
                              Divider(height: 2,thickness: 2,color: kWhite1,),
                            ]) : Container();
                        }) : Container( child:Column( children: [ Text('${vocabular['myPhrases']['loadingList']}\n'),CircularProgressIndicator()])),

                ],
              ),
            ),
          ),
        ],
      ),
        bottomNavigationBar: BottomAppBar(
          elevation: 20.0,
            color: Colors.transparent,
            shape: CircularNotchedRectangle(),
            child: Container(
              color: Colors.transparent,
              height: 60,
              //alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                  children: [
                    Divider(height: 2,thickness: 2,color: kWhite1,),

                Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  //Spacer(),
                  GestureDetector(onTap:(){
                    dialogScreen(context, 'Раздел находится в разработке');
                  }, child:Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 18.0, top:15, right: 0),
                    child:Column(
                      children:[
                      Container(
                        width:20,
                        height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: kWhite3 , width:2),
                              borderRadius: BorderRadius.circular(4.0),
                              //color: kBlue,
                          ),
                        child: Text('A',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kWhite3))
                                                ),
                        Text(vocabular['myPhrases']['aviacompany'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                    ]),
                  )),
                  GestureDetector(onTap:(){
                    headerValue = s191;
                    menuShow = false;
                    //Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) =>HomePage()));
                  }, child:Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 0.0, top:15),
                    child:Column(
                        children:[
                          Container(
                              width:20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: kYellow , width:2),
                                borderRadius: BorderRadius.circular(4.0),
                                //color: kBlue,
                              ),
                              child: Text('H',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kYellow))
                          ),
                          Text(vocabular['form_n']['general']['forms_n'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kYellow))
                        ]),
                  )),
                  GestureDetector(onTap:(){
                    headerValue = s191;
                    menuShow = false;
                    //Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) =>HomePageOther()));
                  }, child:Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 0.0, top:15),
                    child:Column(
                        children:[
                          Container(
                              width:20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: kWhite3 , width:2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text('Р',style:TextStyle(fontSize: 12,fontFamily: 'AlS Hauss',color: kWhite3))
                          ),
                          Text(vocabular['form_n']['general']['forms_r'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                        ]),
                  )),
                  //Spacer(),
                GestureDetector(onTap:(){
                  headerValue = s191;
                  menuShow = false;
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => tuneProfilePage()));
                }, child:Container(
                  height: 50,
                  padding: EdgeInsets.only(right: 25.0, top:15),
                  child:Column(
                      children:[
                        Container(
                            width:10,
                            height: 10,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: kWhite3 , width:2),
                              borderRadius: BorderRadius.circular(5.0),
                              //color: kBlue,
                            ),

                        ),
                        Container(
                          width:18,
                          height: 11,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite3 , width:2),
                            borderRadius: BorderRadius.all(Radius.elliptical(10, 5),
                            //color: kBlue,
                          ),

                        ),),
                        Text(vocabular['header']['profile'],style:TextStyle(fontSize: 10,fontFamily: 'AlS Hauss',color: kWhite3))
                      ]),
                    )),
                ]),
            ]))
        )
    );
  }

 }




