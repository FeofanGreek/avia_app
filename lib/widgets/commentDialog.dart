//import 'package:avia_app/FormaN/formaNFromReestrNew.dart';
import 'dart:convert';
import 'dart:io';

import 'package:avia_app/pages/homepage.dart';
import 'package:avia_app/regauth/regAuthScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'custom_border_title_container.dart';


List <String> _commentTypes = ['Примечание','Запрос информации','Комментарий для ГЦ', 'Комментарий для согласующих', 'Ошибка'];
String _typeComment = 'Ошибка', _valueComment = '';
var _vocabular;
var _status;
bool dialogReady = false;

//commentDialog(var context, int formaNum, String commentTypeNum, String commentSubType){
  class commentDialog extends StatefulWidget {
    final String title;
    final int n_forms_id;
    final int id_pakus;
    final String object_type;
    final int object_id;


    commentDialog({
      this.title,
      this.n_forms_id,
      this.id_pakus,
      this.object_type,
      this.object_id,

    });


  @override
  _MyDialogState createState() => new _MyDialogState();
  }

  class _MyDialogState extends State<commentDialog> {
    //подгрузили словари из файла
    void loadJsonLanguage() async {
      if (language == 'ru') {
        String data = await rootBundle.loadString('vocNew/ru.json');
        _vocabular = json.decode(data);
      } else {
        String data = await rootBundle.loadString('vocNew/en.json');
        _vocabular = json.decode(data);
      }
      setState(() {
        _commentTypes = [_vocabular['form_n']['flight_information_obj']['note'],_vocabular['form_n']['flight_information_obj']['information_request'],_vocabular['form_n']['flight_information_obj']['commentary_hz'], _vocabular['form_n']['flight_information_obj']['commentary_approvers'], _vocabular['form_n']['flight_information_obj']['fault']];
        _typeComment = _vocabular['form_n']['flight_information_obj']['fault'];
        dialogReady = true;
      });
    }

    @override
    void initState() {
      loadJsonLanguage();
      super.initState();
    }



    @override
  Widget build(BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
          insetPadding: EdgeInsets.all(0),
          elevation: 0.0,
          content:dialogReady == true ? Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                margin: EdgeInsets.fromLTRB(20,20,20,20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kWhite3,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: kBlue,
                ),
                padding: EdgeInsets.fromLTRB(20,20,20,20),
                child:  Column(
                    children: <Widget>[
                      Row(
                        children:[
                          Text(widget.title),
                          Spacer(),
                          GestureDetector( onTap: (){
                            Navigator.of(context).pop();
                          }, child:Icon(Icons.clear, color: kWhite, size: 16,))
                        ]
                      ),
                      SizedBox(height:20,),
                      CustomBorderTitleContainer(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _typeComment,
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
                                _status = _commentTypes.indexOf(newValue);
                                _typeComment = newValue;
                              });
                          },
                          items: _commentTypes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                children: [
                                  Image.asset(
                                value == _commentTypes[4] ? 'icons/triangle_red.png' : value == _commentTypes[1] ? 'icons/triangle_blue.png' : 'icons/triangle_yellow.png', width: 16,
                                      height: 16,
                                      fit: BoxFit.fitHeight),
                                SizedBox(width: 5,),
                                Text(
                                    value, style: st4
                                )
                                ])
                            );
                          }).toList(),
                        ),
                        title: _vocabular['form_n']['flight_information_obj']['type_note'],
                      ),
                      Stack(
                        children: <Widget>[
                          Container(width: MediaQuery.of(context).size.width , height: 160,margin: EdgeInsets.fromLTRB(0, 20, 0, 10),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                            child: TextFormField(maxLines: 5, minLines:1, decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'Комментарий к заявке',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                              onChanged: (value){_valueComment = value;},),),
                          Positioned( left: 10, top: 12,
                              child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                                child: Text(_vocabular['form_n']['flight_information_obj']['comment_text'],style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 14),),)), ],),

                      SizedBox(height: 10,),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.fromLTRB(0,10,0,0),
                        child: TextButton(
                          onPressed:()async{
                            setState(() {
                              dialogReady = false;
                            });
                            Map _body = {
                              "n_forms_id": widget.n_forms_id,
                              "id_pakus": widget.id_pakus,
                              "comment": {
                                //"comment_id": null,
                                //"parent_comment_id": null,
                                "object_type": widget.object_type,
                                "object_id": widget.object_id,
                                "comment_type_id": _status+1,
                                "comment_text": "${_valueComment}",
                                "author": {
                                  "author_id": int.parse(userId),
                                  "role_id": accessRole
                                },
                                //"created_at": "8/25/2021",
                                /*"document": {
                                  "file_type_id": 0,
                                  //"file_path": null,
                                  "file_name": "Screenshot 2021-08-19 155604.png",
                                  "file_body": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGUAAABDCAYAAACFicvkAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3g=yjR9+69G/+1KQEVgpmqGiRVEQLYqCaFEURIuiIFoUBdGiKIgWRUG0KAqiRVEQLYqCaFEURIuiIFoUBflG/0evuTXcVBTN6KHLl4JoURREi6IgWhQF0aIoB/wXg1NCTA9IBREAAAAASUVORK5CYII=",
                                  "document_id": null,
                                  "file_type_name": "Screenshot.png",
                                  //"created_at": null,
                                  //"required_attributes_json": null
                                }*/
                              }
                            };
print(_body);
                            try{
                              HttpClient client = new HttpClient();
                              client.badCertificateCallback =
                              ((X509Certificate cert, String host, int port) => true);
                              String url = '${serverURL}api/api/v1/saveNFormComment';
                              HttpClientRequest request = await client.postUrl(Uri.parse(url));
                              request.headers.set('content-type', 'application/json');
                              request.headers.set('Mobile', 'true');
                              request.headers.set('Authorization', 'Bearer $accessToken');
                              request.add(utf8.encode(json.encode(_body)));
                              HttpClientResponse response = await request.close();
                              String reply = await response.transform(utf8.decoder).join();
                              print(reply);
                              setState(() {
                                dialogReady = true;
                              });
                            Navigator.of(context).pop();
                            }catch(e){
                              print('ошибка тут 3$e');
                            }


                            //Navigator.of(context).pop();
                          } ,
                          child: Text(_vocabular['form_n']['flight_information_obj']['send'], style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                          style: ElevatedButton.styleFrom(
                            primary: kYellow,
                            minimumSize: Size(MediaQuery.of(context).size.width, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                      ),

                    ])

            ),
          ) : Container()
      );}

}