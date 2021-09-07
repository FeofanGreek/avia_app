import 'dart:convert';
import 'dart:io';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../strings.dart';



class rulesPage extends StatefulWidget {
  @override
  _rulesPageScreenState createState() => _rulesPageScreenState();
}

class _rulesPageScreenState extends State<rulesPage> {

  @override
  void initState() {

    super.initState();
  }

  loadJson() async {
    if(language == 'ru'){
      String data = await rootBundle.loadString('vocabular/ru.json');
      vocabular = json.decode(data);} else {String data = await rootBundle.loadString('vocabular/en.json');
    vocabular = json.decode(data);}
    reloadLanguage();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        elevation: 0.0,
        title: Text(
          s175,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'AlS Hauss',
              fontSize: 12.8,
              height: 1.5
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
        backgroundColor: kBlue.withOpacity(0.6),
        brightness: Brightness.dark,
        leading: Container(
            padding: EdgeInsets.fromLTRB(9,8,0,0),
            child: SizedBox(
                width: 45,
                height: 45,
                child: Image.asset('images/logoReg.png',
                    fit: BoxFit.fitWidth)
            )
        ),
        actions: [
          Container(
              width: 67,
              height: 40,
              margin: EdgeInsets.fromLTRB(0,8,9,0),
              padding: EdgeInsets.fromLTRB(8,3,0,3),
              decoration: BoxDecoration(
                  border: Border.all(color: kWhite.withOpacity(0.2), width: 2)
              ),
              child: DropdownButton<String>(
                value: language,
                icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                iconSize: 30,
                elevation: 10,
                underline: Container(
                  height: 0,
                  color: kBlueLight,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    language = newValue;
                  });
                  loadJson();
                },
                items: languages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 23,
                      height: 15,
                      child: Image.asset(value == 'ru' ? 'images/rfFlag.png' : 'images/enFlag.png',
                          fit: BoxFit.fitWidth),
                    ),
                  );
                }).toList(),
              )
          )
        ],
      ),
      body:Container(
          width:MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: kBlue.withOpacity(0.6),
          ),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            //child:Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(10,40,10,0),
                          child:Text(vocabular['auth']['user_agreement']['agreement_determines'],
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 28.0,
                            ),
                            textAlign: TextAlign.left,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text(vocabular['auth']['user_agreement']['general_terms'],
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 21.0,
                            ),
                            textAlign: TextAlign.left,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['use_of_materials']}\n\n' +
                              '${vocabular['auth']['user_agreement']['this_agreement']}\n\n'+
                              '${vocabular['auth']['user_agreement']['site_administration']}',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.justify,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['obligations_user']}',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 21.0,
                            ),
                            textAlign: TextAlign.left,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['user_agrees']}\n\n' +
                              '${vocabular['auth']['user_agreement']['using_materials']}\n\n'+
                              '${vocabular['auth']['user_agreement']['citing_materials']}\n\n'+
                              '${vocabular['auth']['user_agreement']['comments_and_other']}\n\n'+
                              '${vocabular['auth']['user_agreement']['user_warned']}\n\n'+
                              '${vocabular['auth']['user_agreement']['administration_is_not_responsible']}\n\n'+
                              '${vocabular['auth']['user_agreement']['user_accepts']}',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.justify,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['other_conditions']}',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 21.0,
                            ),
                            textAlign: TextAlign.left,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['possible_disputes']}\n\n' +
                              '${vocabular['auth']['user_agreement']['nothing_agreement']}\n\n'+
                              '${vocabular['auth']['user_agreement']['recognition_court']}\n\n'+
                              '${vocabular['auth']['user_agreement']['inaction_part']}',
                              style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.justify,
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,0),
                          child:Text('${vocabular['auth']['user_agreement']['user_confirms']}',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'AlS Hauss',
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.justify,
                          )
                      ),
                      //кнопка принимаю
        rulesAccepted == false ? Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.fromLTRB(10,30,10,10),
                        child: TextButton(
                          onPressed:(){
                            setState(() {
                              rulesAccepted = true;
                              regSwitch = false;
                            });
                            newUserRegistration();
                            dialogScreen(context, 'Ссылка активации аккаунта выслана на емайл');
                            Navigator.pushNamed(context, '/regAuthPage');
                          } ,
                          child: Text(vocabular['auth']['register'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                          style: ElevatedButton.styleFrom(
                            primary: kYellow ,
                            minimumSize: Size(MediaQuery.of(context).size.width, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                      ): Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.fromLTRB(10,30,10,10),
          child: TextButton(
            onPressed:(){
              setState(() {
                //rulesAccepted = true;
                regSwitch = false;
              });
              //newUserRegistration();
              Navigator.pushNamed(context, '/regAuthPage');
            } ,
            child: Text(vocabular['registry']['user_profile']['back'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
            style: ElevatedButton.styleFrom(
              primary: kYellow ,
              minimumSize: Size(MediaQuery.of(context).size.width, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
        ),
        rulesAccepted == false ? Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.fromLTRB(10,0,10,50),
                        child: TextButton(
                          onPressed:(){
                            //newUserRegistration();
                            setState(() {
                              rulesAccepted = false;
                            });
                            Navigator.pushNamed(context, '/regAuthPage');
                          } ,
                          child: Text(vocabular['myPhrases']['notAccept'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                          style: ElevatedButton.styleFrom(
                            primary: kWhite1 ,
                            minimumSize: Size(MediaQuery.of(context).size.width, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                      ) : Container(),
                    ]
                )
          ),
        ),
    );
  }

  newUserRegistration() async{
    String phone = regPhone.trim();
    phone = phone.replaceAll(' ','');
    phone = phone.replaceAll('-','');
    phone = phone.replaceAll('(','');
    phone = phone.replaceAll(')','');
    dialogScreen(context, '${vocabular['auth']['verify']['sent_to_mail.']}');
    //Navigator.pushNamed(context, '/HomePage');
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}api/api/auth/register';
      Map map = {
        "name": "$name",
        "surname": "$familia",
        "patronymic": "$fatherName",
        "email": "$regEmail",
        "phone": "$phone",
        "password": "$password",
        "password_confirmation": "$passwordR"
      };
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      var parsedList = json.decode(reply);
      if(reply.contains('message')){
        //print(parsedList["message"]);
        reciveMessage = parsedList["message"];
        //получили сообщение, что такой пользователь уже есть, пока всеравно запишем файл профиля
        try {
          //записали в файл номер пользователя
          final Directory directory = await getApplicationDocumentsDirectory();
          final File file = File('${directory.path}/profile.txt');
          var profile = jsonEncode(<String, dynamic>{
            //переменные для настройки пользователя
            "regEmail" : "$regEmail",
            "password" : "$password",
            "familia" : "$familia",
            "name" : "$name",
            "fatherName" : "$fatherName",
            "regPhone" : "$regPhone",
            "ikaoReg" : "$ikaoReg",
            "dopInfo" : "$dopInfo",
            "isPilot" : 0,
            "isExPilot" : 0,
            "isExploer" : 0,
            "language" : "ru",
            "sendCode" : "",
            "senId" : "",
            "delayReason" : "Не выбрана",
            "tollUnit" : "Метры",
            "distanceUnit" : "Километры",
            "coordinatUnit" : "ГГММ N/S ГГГMM E/W",
            "dateFormat" : "ДД/ММ/ГГГГ",
            "speedHorisontUnit" : "км/ч",
            "speedVerticalUnit" : "м/с",
            "costUnit" : "Р/литр",
            "presureUnit" : "мм.рт.ст.",
            "temperatureUnit" : "Градусы Цельсия",
            "minAllitude" : 0,
            "maxAllitude" : 10000,
            "darkTheme" : 1,
            "emailNotif" : 1,
            "smsNotif" : 1,
            "autorouting" : 1,
            "nafanya" : 1,
            "oneTimePassword" : 1,
            "showUTC" : 0,
            "accessToken" : "",
            "tokenType" : "",
            "expires" : "",
            "userId" : ""
          });
          await file.writeAsString(profile);
          //print("Записали файл");
        }catch(e) {
          showDialog(context: context, builder: (BuildContext context) {
            return Dialog(
                child: new Text('Не удалось записать файл $e'));
          });
        }
      }else{
        setState(() {
          regSwitch = false;
          reciveMessage = '${vocabular['auth']['verify']['sent_to_mail.']}';
        });
        //записываем файл профиля
        try {
          //записали в файл номер пользователя
          final Directory directory = await getApplicationDocumentsDirectory();
          final File file = File('${directory.path}/profile.txt');
          var profile = jsonEncode(<String, dynamic>{
            //переменные для настройки пользователя
            "regEmail" : "$regEmail",
            "password" : "$password",
            "familia" : "$familia",
            "name" : "$name",
            "fatherName" : "$fatherName",
            "regPhone" : "$regPhone",
            "ikaoReg" : "$ikaoReg",
            "dopInfo" : "$dopInfo",
            "isPilot" : 0,
            "isExPilot" : 0,
            "isExploer" : 0,
            "language" : "ru",
            "sendCode" : "",
            "senId" : "",
            "delayReason" : "Не выбрана",
            "tollUnit" : "Метры",
            "distanceUnit" : "Километры",
            "coordinatUnit" : "ГГММ N/S ГГГMM E/W",
            "dateFormat" : "ДД/ММ/ГГГГ",
            "speedHorisontUnit" : "км/ч",
            "speedVerticalUnit" : "м/с",
            "costUnit" : "Р/литр",
            "presureUnit" : "мм.рт.ст.",
            "temperatureUnit" : "Градусы Цельсия",
            "minAllitude" : 0,
            "maxAllitude" : 10000,
            "darkTheme" : 1,
            "emailNotif" : 1,
            "smsNotif" : 1,
            "autorouting" : 1,
            "nafanya" : 1,
            "oneTimePassword" : 1,
            "showUTC" : 0,
            "accessToken" : "",
            "tokenType" : "",
            "expires" : "",
            "userId" : "${parsedList["user_id"]}"
          });
          //print(parsedList["user_id"]);
          await file.writeAsString(profile);
          //print("Записали файл");
        }catch(e) {
          showDialog(context: context, builder: (BuildContext context) {
            return Dialog(
                child: new Text('Не удалось записать файл $e'));
          });
        }
      }


    }catch(e){
      setState(() {
        regSwitch = false;
        reciveMessage = '${vocabular['myPhrases']['serverError']}';
      });
      //print('Ошибка обращения к серверу $e');
      print(e);
    }

    /*try{
      String phone = regPhone.trim();
      phone = phone.replaceAll(' ','');
      phone = phone.replaceAll('-','');
      phone = phone.replaceAll('(','');
      phone = phone.replaceAll(')','');
      var response = await http.post(
          Uri.parse('https://10.95.0.65/api/auth/register'),
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "surname": "$familia",
            "patronymic": "$fatherName",
            "email": "$regEmail",
            "phone": "$phone",
            "password": "$password",
            "password_confirmation": "$passwordR"
          })
      );
      print(response.body);
      //получили значение ID и Status для данного пользователя
      var jsonList = response.body;
      var parsedList = json.decode(jsonList);
      reciveMessage = parsedList[0]["message"];
      regSwitch = false;
      setState(() {});
    } catch (error) {
      setState(() {
        regSwitch = false;
        reciveMessage = 'При обращении к серверу произошла ошибка';
      });
      print('Ошибка обращения к серверу $error');
    }*/
  }



}