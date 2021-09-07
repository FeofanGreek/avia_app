import 'dart:convert';
import 'dart:io';

import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/constants.dart';
import 'package:avia_app/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../strings.dart';

String routesToProcess = '[{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отложить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Передать в УЛЭРА"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Отклонить"},{"rout" : "LFPG → UUEE ", "option" : "SU1306 / 09.04.2021 в 11:00 → 09.04.2021 в 16:00", "status" : "Согласовать"}]';
List routToProcess = json.decode(routesToProcess);
List <String> statuses = ['1','2', '3', '4', '5', '6','7','8','9','10','11','12','13' ]; //Черновик, Отложить, Передать в УЛЭРА, Отклонить, Согласовать
int senderStatus = 0;
List switchToRoute = [];
bool sendProcess = false;

class proceedScreenN extends StatefulWidget {

  const proceedScreenN({Key key, @required this.routes}) : super(key: key);
  final Map routes;


  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<proceedScreenN > {
  var _controllerSearchRegion = TextEditingController();

textStatus(int id){
  String value = '';
  //id == 1 ? value = 'Черновик' : id == 2 ? value = 'Отменено' : id == 3 ? value = 'Отправлено' : id == 4 ? value = 'Принято' : id == 5 ? value = 'Ожидает обработки' : id == 6 ? value = 'Передано в' : id == 7 ? value = 'Согласовано' : id == 8 ? value = 'Ответ' : id == 9 ? value = 'Возвращено' : id == 10 ? value = 'Отклонено' : id == 11 ? value = 'Утверждено' : id == 12 ? value = 'Скорректировано': value = 'Запрос информации';
  id == 1 ? value = 'Отправить' : id == 2 ? value = 'Согласовать' : id == 3 ? value = 'Ответить' : id == 4 ? value = 'Скорректировать' : id == 5 ? value = 'Аннулировать' : id == 6 ? value = 'Вернуть' : id == 7 ? value = 'Отклонить' : id == 8 ? value = 'Утвердить' : value = 'Отклонить';

  return value;
}

  @override
  void initState() {
    super.initState();
    print(widget.routes);
    for(int i = 0; i < routToProcess.length; i++){
      switchToRoute.add(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      //extendBody: true,

        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: kBlue,
          automaticallyImplyLeading: false,
          title:Container(
              padding: EdgeInsets.fromLTRB(0,8,0,0),
              child:Text('Отправить форму?', style: st5)
          ) ,
          actions: [
            Container(
              height: 40,
              //alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(10,0,10,0),
              child:TextButton(
                onPressed:(){
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) =>HomePage()));
                },
                child: Icon(CupertinoIcons.clear, size: 20, color: kWhite3,),
                style: ElevatedButton.styleFrom(
                  primary: kBlue,
                  //minimumSize: Size(MediaQuery.of(context).size.width, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 3,
                    groupValue: widget.routes['NForm']['selected_role_id'],
                    onChanged: (value) {
                      setState(() {
                        widget.routes['NForm']['selected_role_id'] = value;
                      });
                    },
                  ),
                  Text('ФАВТ')
                ]),
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 15,
                    groupValue: widget.routes['NForm']['selected_role_id'],
                    onChanged: (value) {
                      setState(() {
                        widget.routes['NForm']['selected_role_id'] = value;
                      });
                    },
                  ),
                  Text('МИД')
                ]),
            Row(
                children: [
                  Radio<int>(
                    activeColor: kYellow,
                    value: 16,
                    groupValue: widget.routes['NForm']['selected_role_id'],
                    onChanged: (value) {
                      setState(() {
                        widget.routes['NForm']['selected_role_id'] = value;
                      });
                    },
                  ),
                  Text('МИнпромторг')
                ]),
            Container(
                padding: EdgeInsets.fromLTRB(10,10,0,0),
                child:Text('Выберите рейсы', style: st11)
            ) ,
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.routes['NForm']['flights'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                              children: [
                                Row(
                                  children:[
                                    GestureDetector( onTap: (){setState(() {
                                      switchToRoute[index] = !switchToRoute[index];
                                    });},
                                      child:Container(
                                        color: !switchToRoute[index] ? kWhite1 : kWhite3,
                                        width: MediaQuery.of(context).size.width/3*2-12,
                                        margin: EdgeInsets.fromLTRB(5,5,5,5),
                                        padding: EdgeInsets.fromLTRB(5,5,5,5),
                                        child: Row(
                                          children:[
                                            Image.asset(
                                                widget.routes['NForm']['flights'][index]['status']['id'] == 0 ?  'icons/plane_grey.png' : widget.routes['NForm']['flights'][index]['status']['id'] == 1 ? 'icons/plane_red.png' : widget.routes['NForm']['flights'][index]['status']['id'] == 2 ? 'icons/plane_yellow.png' : 'icons/plane_blue.png', width: 16,
                                                height: 16,
                                                fit: BoxFit.fitHeight),
                                            SizedBox(width: 5,),
                                            Text('${widget.routes['NForm']['flights'][index]['flight_information']['departure_airport_icao']} → ${widget.routes['NForm']['flights'][index]['flight_information']['landing_airport_icao']}', style: st4,),
                                            SizedBox(width: 5,),
                                            Expanded( child:Text('${widget.routes['NForm']['flights'][index]['flight_information']['flight_num']} / ${widget.routes['NForm']['flights'][index]['main_date']['date']} в ${widget.routes['NForm']['flights'][index]['flight_information']['departure_time']} → ${widget.routes['NForm']['flights'][index]['main_date']['landing_date']} в ${widget.routes['NForm']['flights'][index]['flight_information']['landing_time']}', style: st9,),),
                                            ])),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width/3,
                                        height: 40,
                                        //margin: EdgeInsets.fromLTRB(0,8,9,0),
                                        //padding: EdgeInsets.fromLTRB(8,3,0,3),
                                        //decoration: BoxDecoration(
                                        //    border: Border.all(color: kWhite.withOpacity(0.2), width: 2)
                                        //),
                                        child: DropdownButton<String>(
                                          //menuMaxHeight: 67,
                                          isExpanded: true,
                                          value: widget.routes['NForm']['flights'][index]['status']['id'].toString(),
                                          icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                                          iconSize: 30,
                                          elevation: 10,
                                          underline: Container(
                                            height: 0,
                                            color: kBlueLight,
                                          ),
                                          onChanged: (String newValue){
                                            setState(() {
                                              routToProcess[index]['status'] = newValue;
                                              //widget.routes['NForm']['flights'][index]['status']['id'] = newValue;
                                              //widget.routes['NForm']['flights'][index]['status']['name_rus'] = textStatus(int.parse(newValue));
                                            });
                                            approveFormN(widget.routes['NForm']['flights'][index]['n_form_flight_id'], int.parse(newValue));
                                          },
                                          items: statuses.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(textStatus(int.parse(value)), style: st4,),
                                              //value: textStatus(int.parse(value)),
                                              //child: Text(textStatus(int.parse(value)), style: st4,),
                                            );
                                          }).toList(),
                                        )
                                    )
                                  ])
                              ]);
                        }) ,

                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:BottomAppBar(
          color: Colors.transparent,
          child:Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(10,0,10,10),
            child:TextButton(
              onPressed:(){
                updateFormN();
              } ,
              child: sendProcess == false ? Text('Применить', style: st17,textAlign: TextAlign.center,) : CircularProgressIndicator(),
              style: ElevatedButton.styleFrom(
                primary: kYellow,
                minimumSize: Size(MediaQuery.of(context).size.width , 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          elevation: 0,
        )
    );
  }

  approveFormN(int rout, int approveType)async{
    setState(() {
      sendProcess = true;
    });
List toApprove = [{
  "approval_group_id": approvalGroup,
  "role_id": accessRole,
  "n_form_flight_id": rout, //- id Рейса
    "n_form_flight_sign_id": approveType, //- Знак согласования
}];
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/nFormAgreement';
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      request.add(utf8.encode(json.encode(toApprove))); //ручная форма
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

  updateFormN()async{
    setState(() {
      sendProcess = true;
    });

    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/v1/updateNForm';
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      request.add(utf8.encode(json.encode(widget.routes))); //ручная форма
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




