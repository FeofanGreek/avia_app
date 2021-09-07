import 'dart:convert';
import 'dart:io';

import 'package:avia_app/FormaN/formaNFromReestrNew.dart';
import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_3_1.dart';
import 'package:avia_app/pages2/bottom_sheets/bottom_sheet2_other.dart';
import 'package:avia_app/pages2/bottom_sheets/bottom_sheet3_other.dart';
import 'package:avia_app/pages2/bottom_sheets/bottom_sheet3_other_copy.dart';
import 'package:avia_app/widgets/custom_button_1.dart';

import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet1Other extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: kBlueLight,
          borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton1(
              text: s19, //approve
              color: kGreen,
              onPressed: () async{

                  for (int ii = 0; ii <
                      reestrFormsN["NForms"]["data"][formInListNum]['flights']
                          .length; ii++) {
                    List toApprove = [{
                      "approval_group_id": approvalGroup,
                      "role_id": accessRole,
                      //- Роль согласующего если это Условная или Назначенная группа //3 Заявитель 4 Сотрудник ГЦ 5 Начальник РА 6 Сотрудник РА
                      "n_form_flight_id": reestrFormsN["NForms"]["data"][formInListNum]['flights'][ii]['n_form_flight_id'],
                      //- id Рейса
                      "n_form_flight_sign_id": 2,
                      //- отклонить
                    }
                    ];
                    try {
                      HttpClient client = new HttpClient();
                      client.badCertificateCallback =
                      ((X509Certificate cert, String host, int port) => true);
                      String url = '${serverURL}api/api/v1/nFormAgreement';
                      HttpClientRequest request = await client.postUrl(
                          Uri.parse(url));
                      request.headers.set('content-type', 'application/json');
                      request.headers.set('Mobile', 'true');
                      request.headers.set(
                          'Authorization', 'Bearer $accessToken');
                      request.add(
                          utf8.encode(json.encode(toApprove))); //ручная форма
                      HttpClientResponse response = await request.close();
                      String reply = await response.transform(utf8.decoder)
                          .join();
                      print(reply);
                      //debugPrint(reply, wrapWidth: 1024);
                    } catch (e) {
                      print(e);
                    }
                  }
                }

          ),
          SizedBox(height: 8,),
          CustomButton1(
              text: s20, //hold
              color: kYellow,
                onPressed: () async{

                    for (int ii = 0; ii <
                        reestrFormsN["NForms"]["data"][formInListNum]['flights']
                            .length; ii++) {
                      List toApprove = [{
                        "approval_group_id": approvalGroup,
                        "role_id": accessRole,
                        //- Роль согласующего если это Условная или Назначенная группа //3 Заявитель 4 Сотрудник ГЦ 5 Начальник РА 6 Сотрудник РА
                        "n_form_flight_id": reestrFormsN["NForms"]["data"][formInListNum]['flights'][ii]['n_form_flight_id'],
                        //- id Рейса
                        "n_form_flight_sign_id": 6,
                        //- отклонить
                      }
                      ];
                      try {
                        HttpClient client = new HttpClient();
                        client.badCertificateCallback =
                        ((X509Certificate cert, String host, int port) => true);
                        String url = '${serverURL}api/api/v1/nFormAgreement';
                        HttpClientRequest request = await client.postUrl(
                            Uri.parse(url));
                        request.headers.set('content-type', 'application/json');
                        request.headers.set('Mobile', 'true');
                        request.headers.set(
                            'Authorization', 'Bearer $accessToken');
                        request.add(
                            utf8.encode(json.encode(toApprove))); //ручная форма
                        HttpClientResponse response = await request.close();
                        String reply = await response.transform(utf8.decoder)
                            .join();
                        print(reply);
                        //debugPrint(reply, wrapWidth: 1024);
                      } catch (e) {
                        print(e);
                      }
                    }
                  }

          ),
          SizedBox(height: 8,),
          CustomButton1(
              text: s21, //redject
              color: kRed,
              onPressed: () async{

                  for (int ii = 0; ii <
                      reestrFormsN["NForms"]["data"][formInListNum]['flights'].length; ii++) {
                    List toApprove = [{
                      "approval_group_id": approvalGroup,
                      "role_id": accessRole,
                      //- Роль согласующего если это Условная или Назначенная группа //3 Заявитель 4 Сотрудник ГЦ 5 Начальник РА 6 Сотрудник РА
                      "n_form_flight_id": reestrFormsN["NForms"]["data"][formInListNum]['flights'][ii]['n_form_flight_id'],
                      //n_form_flight_id
                      //- id Рейса
                      "n_form_flight_sign_id": 7,
                      //- отклонить
                    }
                    ];
                    try {
                      HttpClient client = new HttpClient();
                      client.badCertificateCallback =
                      ((X509Certificate cert, String host, int port) => true);
                      String url = '${serverURL}api/api/v1/nFormAgreement';
                      HttpClientRequest request = await client.postUrl(
                          Uri.parse(url));
                      request.headers.set('content-type', 'application/json');
                      request.headers.set('Mobile', 'true');
                      request.headers.set(
                          'Authorization', 'Bearer $accessToken');
                      request.add(
                          utf8.encode(json.encode(toApprove))); //ручная форма
                      HttpClientResponse response = await request.close();
                      String reply = await response.transform(utf8.decoder)
                          .join();
                      print(reply);
                      //debugPrint(reply, wrapWidth: 1024);
                    } catch (e) {
                      print(e);
                    }
                  }
                }

          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(s13,style: st1,),
          ),
          accessRole == 3 ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(onTap:()async{
              try{
                HttpClient client = new HttpClient();
                client.badCertificateCallback =
                ((X509Certificate cert, String host, int port) => true);
                String url = '${serverURL}api/api/v1/duplicateNForm/$favoritId';
                HttpClientRequest request = await client.getUrl(Uri.parse(url));
                request.headers.set('content-type', 'application/json');
                request.headers.set('Mobile', 'true');
                request.headers.set('Authorization', 'Bearer $accessToken');
                HttpClientResponse response = await request.close();
                String reply = await response.transform(utf8.decoder).join();
                print(reply);
              }catch(e){
                print(e);
              }
            }, child:Text(s15,style: st1,)),
          ) : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(onTap:()async{
              print(favoritId);
              try{
                HttpClient client = new HttpClient();
                client.badCertificateCallback =
                ((X509Certificate cert, String host, int port) => true);
                String url = '${serverURL}api/api/v1/form-n/addToFavorites/$favoritId';
                HttpClientRequest request = await client.getUrl(Uri.parse(url));
                request.headers.set('content-type', 'application/json');
                request.headers.set('Mobile', 'true');
                request.headers.set('Authorization', 'Bearer $accessToken');
                HttpClientResponse response = await request.close();
                String reply = await response.transform(utf8.decoder).join();
                print(reply);
              }catch(e){
                print(e);
              }
            }, child:Text(s17,style: st1,)),
          ),
          SizedBox(height: 6,),
          GestureDetector(onTap:(){
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) =>formaNFromReestrPage()));
          }, child:CustomButton1(
            text: s18,
            color: kYellow,
          )),
        ],
      ),
    );
  }
}
