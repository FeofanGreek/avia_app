import 'dart:convert';
import 'dart:io';

import 'package:avia_app/profile/mainProfile.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:avia_app/regauth/rules.dart';
import 'package:avia_app/strings.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/constants.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/pages2/homepage_other.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'FormaN/fomaNfish.dart';
import 'LaunchScreen.dart';
import 'downloadVocabulare/downloadProcedure.dart';
import 'newN/nformreadmode.dart';

void main() {
  runApp(MyApp());
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' :'tablet';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String device = getDeviceType();
    /*device == 'phone' ? SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]) : SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);*/
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', ''),

      ],
      //theme: ThemeData(textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'AlS Hauss',color: Colors.white,))),
      theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'AlS Hauss',color: Colors.white,)),
        scaffoldBackgroundColor: kBlue
      ),
      //home: profileMainPage(),
      routes: {
        '/HomePage' : (context) => HomePage(),//Форма Н
        '/HomePageOther' : (context) => HomePageOther(),//Форма Р
        '/regAuthPage' : (context) => regAuthPage(),
        '/rules' : (context) => rulesPage(),
        '/profile' :  (context) => profileMainPage(),
        '/launchScreen' :  (context) => launchScreen(),
        //'/webview' :  (context) => PlayWithComputer(),
        '/fomaN' :  (context) => formaNFishPage(),
        '/newN' : (context) => formNreadMode(),
        '/vocabulary' : (context) => loadVocabulary(),
      },
      //initialRoute: '/vocabulary', //загрузка справочников
      initialRoute: '/launchScreen',
    );
  }
}



logOut() async{
  //отправляем запрос на сервер о выходе

  //удаляем файл профиля
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/profile.txt');
  await file.delete();
  //обнуляем переменные
  regEmail = '';
  password = '';
  passwordR = '';
  familia ='';
  name ='';
  fatherName = '';
  regPhone = '';
  reciveMessage = '';
  accessToken = '';
  tokenType = '';
  expires = '';
  ikaoReg = '';
  passwordOld = '';
  dopInfo = '';
  passFieldVisible = true;
  lockField = true;
  isPilot = false;
  isExPilot = false;
  isExploer = false;
  language = 'en';
  sendCode = '';
  senId = '';
  delayReason = 'Не выбрана';
  tollUnit = 'Метры';
  distanceUnit = 'Километры';
  coordinatUnit = 'ГГММ N/S ГГГMM E/W';
  dateFormat = 'ДД/ММ/ГГГГ';
  speedHorisontUnit = 'км/ч';
  speedVerticalUnit = 'м/с';
  costUnit = 'Р/литр';
  presureUnit = 'мм.рт.ст.';
  temperatureUnit = 'Градусы Цельсия';
  minAllitude = 0;
  maxAllitude = 10000;
  darkTheme = true;
  emailNotif = true;
  smsNotif = true;
  autorouting = true;
  nafanya = true;
  oneTimePassword = true;
  showUTC = false;
  passwordOld = '';
  userId = '';
}



