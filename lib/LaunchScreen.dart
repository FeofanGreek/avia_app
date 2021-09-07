import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'package:yaml/yaml.dart';


class launchScreen extends StatefulWidget {
  @override
  launchScreenState createState() => launchScreenState();
}

class launchScreenState extends State<launchScreen> {

  loadJson() async {
    if(language == 'ru'){
      String data = await rootBundle.loadString('vocabular/ru.json');
      vocabular = json.decode(data);} else {String data = await rootBundle.loadString('vocabular/en.json');
    vocabular = json.decode(data);}
    //print(vocabular);
    setState(() {

    });
  }

  readProfile() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File fileL = File('${directory.path}/profile.txt');
      var UfromFile = await fileL.readAsString();
      var nameUs = json.decode(UfromFile);
      regEmail = nameUs["regEmail"];
      passwordOld = nameUs["password"]; //старый пароль нужен для отображения при смене
      password = '';
      familia = nameUs["familia"];
      name = nameUs["name"];
      fatherName = nameUs["fatherName"];
      regPhone = nameUs["regPhone"];
      ikaoReg = nameUs["ikaoReg"];
      dopInfo = nameUs["dopInfo"];
      isPilot = nameUs["isPilot"] == 0 ? false : true;
      isExPilot = nameUs["isExPilot"] == 0 ? false : true;
      isExploer = nameUs["isExploer"] == 0 ? false : true;
      language = nameUs["language"];
      //language = 'en';
      sendCode = nameUs["sendCode"];
      senId = nameUs["senId"];
      delayReason = nameUs["delayReason"];
      tollUnit = nameUs["tollUnit"];
      distanceUnit = nameUs["distanceUnit"];
      coordinatUnit = nameUs["coordinatUnit"];
      dateFormat = nameUs["dateFormat"];
      speedHorisontUnit = nameUs["speedHorisontUnit"];
      speedVerticalUnit = nameUs["speedVerticalUnit"];
      costUnit = nameUs["costUnit"];
      presureUnit = nameUs["presureUnit"];
      temperatureUnit = nameUs["temperatureUnit"];
      minAllitude = nameUs["minAllitude"];
      maxAllitude = nameUs["maxAllitude"];
      darkTheme = nameUs["darkTheme"] == 0 ? false : true;
      emailNotif = nameUs["emailNotif"] == 0 ? false : true;
      smsNotif = nameUs["smsNotif"] == 0 ? false : true;
      autorouting = nameUs["autorouting"] == 0 ? false : true;
      nafanya = nameUs["nafanya"] == 0 ? false : true;
      oneTimePassword = nameUs["oneTimePassword"] == 0 ? false : true;
      showUTC = nameUs["showUTC"] == 0 ? false : true;
      showRegistryType = nameUs["showRegistryType"] == 0 ? false : true;
      accessToken = nameUs["accessToken"];
      tokenType = nameUs["tokenType"];
      expires = nameUs["expires"];
      userId = nameUs["userId"];
      accessRole = nameUs["accessRole"];
      //userId = '58';
     // print(userId);
     // print(accessToken);
      //запрашиваем сервер для главного экрана
      //идем на экран входа
      regSwitch = false;
      rulesAccepted = true;
      loadJson();
      const twentyMillis = const Duration(seconds:3);
      new Timer(twentyMillis, () => Navigator.pushNamed(context, '/regAuthPage'));
    } catch (error) {
      loadJson();
      //редиректимся на экран регистрации
      print('редиректимся на экран регистрации');
      regSwitch = true;
      rulesAccepted = false;
      const twentyMillis = const Duration(seconds:2);
      new Timer(twentyMillis, () => Navigator.pushNamed(context, '/regAuthPage'));
    }
  }

  @override
  void initState() {
    super.initState();
    //loadJson(); //загружаем русский словарь
    readProfile();
    //airlines();
    //fleet();
    //docTypes();
    //points();

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
        child: Stack(
            children: <Widget>[
              Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 3, width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      height: 53, width: 53,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/logoReg.png"),
                            fit:BoxFit.fitWidth, alignment: Alignment(0.0, 0.0)
                        ),
                      ),),
                    SizedBox(height: MediaQuery.of(context).size.height / 3, width: MediaQuery.of(context).size.width,
                    ),
                    FutureBuilder(
                        future: rootBundle.loadString("pubspec.yaml"),
                        builder: (context, snapshot) {
                          String version = "Unknown";
                          if (snapshot.hasData) {
                            var yaml = loadYaml(snapshot.data);
                            version = yaml["version"];
                          }

                          return Container(
                            child: Text(
                                'Версия: $version'
                            ),
                          );
                        }),
                  ]),

            ]),
      ),

    );
  }

}

