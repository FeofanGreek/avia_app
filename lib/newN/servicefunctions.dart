//определение статуса показывать/не показывать
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avia_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../strings.dart';

calculateStatus(int id){
  if(id == 1 || id ==  2 || id == 10){
    return false;
  } else {
    return true;
  }
}

//подсчет статусов рейсов для фильтра/переключателя
calculateTypeStatuses(List routes){
  int approve = 0;
  int reject = 0;
  for(int i = 0; i < routes.length; i++){
    routes[i]['status']['id'] == 1 || routes[i]['status']['id'] == 2 || routes[i]['status']['id'] == 10 ? reject++ : approve++;
  }
  return [approve, reject];
}

//определение цвета комментария
statusColor(int id){
  if(id == 4 || id == 8){
    return kYellow;
  }else if(id == 2 || id == 10){
    return kRed;
  }else if(id == 11){
    return kGreen;
  }else if(id == 13 || id == 4){
    return Colors.blue;
  }
  else{
    return kWhite3;
  }
}

//подсчет какого типа коментариев сколько
comment(List comments){
  var comment = 0;
  var reqest = 0;
  var error = 0;
  for(int i = 0; i < comments.length; i++){
    //print(comments[i]['comment_type_id']);
    comments[i]['comment_type_id'] == 5 ? error++ : comments[i]['comment_type_id'] == 2 ? reqest++ : comment++;
    if(comments[i]['child_comments'].length > 0){
      for(int ii=0; ii< comments[i]['child_comments'].length; ii++){
        //print(comments[i]['child_comments'][ii]['comment_type_id']);
        comments[i]['child_comments'][ii]['comment_type_id'] == 5 ? error++ : comments[i]['child_comments'][ii]['comment_type_id'] == 2 ? reqest++ : comment++;
      }
    }
  }
  return [comment, reqest, error];
}

//переходим к просмотру документа в браузере
goToSite(url) async {
  if (await canLaunch('$url')) {
    await launch('$url');
  } else {
    throw 'Невозможно набрать номер $url';
  }
  print('пробуем позвонить');
}

//проблеваем занятие формы
addTime()async{
  print('добавили время');
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = '${serverURL}api/api/v1/extendTimeNForm?id=$formId&user_id=$userId';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    request.headers.set('Authorization', 'Bearer $accessToken');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
  }catch(e){
    print('ошибка тут $e');
  }
}

//освобождаем форму
workComplite()async{
  print('освободили форму');
  try{
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String url = '${serverURL}api/api/v1/extendTimeNForm?id=$formId&user_id=$userId&exempt=true';
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Mobile', 'true');
    request.headers.set('Authorization', 'Bearer $accessToken');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
  }catch(e){
    print('ошибка тут $e');
  }
}

