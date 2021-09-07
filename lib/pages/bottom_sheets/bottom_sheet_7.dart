import 'dart:convert';
import 'dart:io';

import 'package:avia_app/widgets/dialoScreen.dart';
import 'package:avia_app/widgets/multipleselectforfilters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_8.dart';
import 'package:avia_app/text_styles.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import 'package:avia_app/widgets/custom_switch.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../homepage.dart';
int selectedTab = 1;
int align = 1;
String dropdownValue = s157;
bool switch1 = true;
String filterName = '';
var filters;
bool _readyReestr = false;
bool ascDesc = false;
String delFilterNum = '';

List permit_num =[], purpose = [], created_at = [], registration_number = [], aircraft_type_icao = [], aircraft_owner = [], is_paid =[], landing_type =[], flight_num = [];
String _permit_num ='-asc', _purpose = '-asc', _created_at = '-asc', _registration_number = '-asc', _aircraft_type_icao = '-asc', _aircraft_owner = '-asc', _is_paid ='-asc', _landing_type ='-asc', _flight_num = '-asc';
Map map = {
  "form": "form_n",
  "filter_name": filterName,
  "permit_num": { //номер разрешения
    "'params'":"${purpose.toString()}", //массив строковых параметров
    "'sort'": _permit_num,
  },
  "purpose":{ //цель выполнения перевозки
    "'params'":"${purpose.toString()}", //массив из чисел
    "'sort'": _purpose,
  },
  "created_at":{ //дата и время регистрации формы
    "'params'":"${created_at.toString()}", //массив, диапазон времени в timestamps
    "'sort'": _created_at,
  },
  "registration_number":{ //регистрационный номер основного ВС
    "'params'":"${registration_number.toString()}", //массив, строковых параметров
    "'sort'": _registration_number,
  },
  "aircraft_type_icao":{ //тип основного ВС
    "'params'":"${aircraft_type_icao.toString()}", //массив, строковых параметров
    "'sort'": _aircraft_type_icao,
  },
  "aircraft_owner":{ //владелец ВС
    "'params'":"${aircraft_owner.toString()}", //массив, строковых параметров
    "'sort'": _aircraft_owner,
  },
  "is_paid":{ //Опалата АНО
    "'params'":"${is_paid.toString()}", //1 или 0
    "'sort'": _is_paid,
  },
  "landing_type":{ //Тип посадки
    "'params'":"${landing_type.toString()}", //массив типов
    "'sort'": _landing_type,
  },
  "flight_num":{ //номер рейса
    "'params'":"${flight_num.toString()}", //массив строковых
    "'sort'": _flight_num,
  }
};

class BottomSheet7 extends StatefulWidget {
  @override
  _BottomSheet7State createState() => _BottomSheet7State();
}

int check = 0; //номер загружаемого фильтра

class _BottomSheet7State extends State<BottomSheet7> {

  arangeSet(String value){
    value == 'Номер разрешения' ? _permit_num = '${ascDesc == true ? 'asc':'-asc'}': value == 'Дата и время регистрации формы' ? _created_at = '${ascDesc == true ? 'asc':'-asc'}': value == 'Регистрационный номер основного ВС' ? _registration_number = '${ascDesc == true ? 'asc':'-asc'}'  : value == 'Тип основного ВС' ? _aircraft_type_icao = '${ascDesc == true ? 'asc':'-asc'}'  : value == 'Владелец ВС' ? _aircraft_owner= '${ascDesc == true ? 'asc':'-asc'}'  : value == 'Оплата АНО' ?_is_paid = '${ascDesc == true ? 'asc':'-asc'}' :value == 'Тип посадки' ?_landing_type = '${ascDesc == true ? 'asc':'-asc'}' : value == 'Номер рейса' ? _flight_num = '${ascDesc == true ? 'asc':'-asc'}' : _purpose = '${ascDesc == true ? 'asc':'-asc'}';
 setState(() {

 });
   }


  dalFilter()async{
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}/api/api/v1/filter/remove?id=$delFilterNum';
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      setState(() {});
    }catch(e){
      print(e);
    }
  }

  saveFilter()async{
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}/api/api/v1/filter/create';//?form=form_n&filter_name=test&main_aircraft_registration_mark[\'params\']=[1,150]&search_value[\'params\']=[val1,val2]
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      setState(() {});
    }catch(e){
      print(e);
    }
  }

  getFilterList()async{
    try{
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String url = '${serverURL}/api/api/v1/filter';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Mobile', 'true');
      request.headers.set('Authorization', 'Bearer $accessToken');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);
      filters = json.decode(reply);
      filters['status'] == false ? filters = [{'name' : 'The user has no filters'}] : null;
      filters['data'].length > 0 ? print(filters['data'][0]) : null;
      _readyReestr = true;
      setState(() {});
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.001),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (_, controller) {
              return Container(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                padding: MediaQuery.of(context).viewInsets,
                decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                margin: EdgeInsets.only(top: 80),
                child: ListView(
                  //physics: ScrollPhysics(),
                  //shrinkWrap: true,
                  controller: controller,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Divider(
                          height: 4,
                          thickness: 4,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    selectedTab != 3 ? Text(
                      s154,
                      style: st8,
                      textAlign: TextAlign.center,
                    ) : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          GestureDetector(onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          }, child: Text('Назад', style: st6,),),
                          Text('Новый фильтр'),
                        GestureDetector(onTap: () {
                          saveFilter();
                          setState(() {
                            selectedTab = 1;
                          });
                        }, child: Text('Сохранить', style: st6,),),
                      ]),
                    filterName != '' || selectedTab == 3 ? Stack(
                      children: <Widget>[
                        Container(width: MediaQuery.of(context).size.width , height: 40,margin: EdgeInsets.fromLTRB(0, 20, 0, 0),padding:EdgeInsets.fromLTRB(5,0,0,0),decoration: BoxDecoration(border: Border.all(color: kWhite1),),
                          child: TextFormField(decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none), hintText: 'Название фильтра',hintStyle: st8,contentPadding: new EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                            onChanged: (value){ filterName = value;},),),
                        Positioned( left: 15, top: 12,
                            child: Container(padding:EdgeInsets.only(bottom: 0, left: 10, right:10), color: kBlue,
                              child: Text('Название фильтра',style: TextStyle(color: kWhite.withOpacity(0.3),fontFamily: 'AlS Hauss', fontSize: 12),),)), ],) : Container(),

                    SizedBox(
                      height: 20,
                    ),
                    selectedTab != 3 ? Container(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                selectedTab = 1;
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30)),
                                    border: Border.all(color: kWhite1),
                                    color: selectedTab == 1 ? kYellow : kTrans),
                                child: Center(
                                  child: Text(
                                    s155,
                                    style: st1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                getFilterList();
                                setState(() {
                                  selectedTab = 2;
                                });
                                print('мои фильтры');
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    border: Border.all(color: kWhite1),
                                    color: selectedTab == 2 ? kYellow : kTrans),
                                child: Center(
                                  child: Text(
                                    s156,
                                    style: st1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                    SizedBox(
                      height: 14,
                    ),
                    selectedTab == 1 ? Column(
              children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomBorderTitleContainer(
                            title: s157,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
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
                                  dropdownValue = newValue;
                                });
                                arangeSet(dropdownValue);
                              },
                              items: <String>[s157, 'Номер разрешения', 'Дата и время регистрации формы', 'Регистрационный номер основного ВС','Тип основного ВС','Владелец ВС','Оплата АНО','Тип посадки','Номер рейса','Цель выполнения перевозки']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            ascDesc = true;
                              align = 1;
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
                            decoration: BoxDecoration(
                                border: align == 1
                                    ? Border.all(color: kYellow)
                                    : Border.all(color: kWhite1)),
                            child: Image.asset('icons/align1.png'),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            ascDesc = false;
                              align = 2;
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
                            decoration: BoxDecoration(
                                border: align == 2
                                    ? Border.all(color: kYellow)
                                    : Border.all(color: kWhite1)),
                            child: Image.asset('icons/align2.png'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            s159,
                            style: st1,
                          ),
                          CustomSwitch(
                              value: switch1,
                              onChanged: (value) {
                                setState(() {
                                  switch1 = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]["purpose"] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]["purpose"]}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Номер разрешения',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Номер разрешения',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${permit_num.length > 0 ? permit_num.toString() : ''}',
                                  style: st3,
                                ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]["created_at"] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]["created_at"]}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Дата и время регистрации формы',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Дата и время регистрации формы',
                              style: st1,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                    Expanded( child:
                                    Text(
                                      '${created_at.length > 0 ? created_at.toString() : ''}',
                                      style: st3,
                                    ),
                    ),

                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['aircrafts'].length > 0 && reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['registration_number'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['registration_number']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Регистрационный номер основного ВС',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Регистрационный номер основного ВС',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${registration_number.length > 0 ? registration_number.toString() : ''}',
                                  style: st3,
                                ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['aircrafts'].length > 0 && reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['aircraft_type_icao'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['aircraft_type_icao']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Тип основного ВС',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Тип основного ВС',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${aircraft_type_icao.length > 0 ? aircraft_type_icao.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['aircrafts'].length > 0  && reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['aircraft_owner'] != null  ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['aircrafts'][0]['aircraft_type_icao']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Владелец ВС',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Владелец ВС',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${aircraft_owner.length > 0 ? aircraft_owner.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['airline'] != null && reestrFormsN["NForms"]["data"][i]['airline']['ano_is_paid'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['airline']['ano_is_paid']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Оплата АНО',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Оплата АНО',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${is_paid.length > 0 ? is_paid.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['landing_type'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['landing_type']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Тип посадки',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Тип посадки',
                              style: st1, textAlign: TextAlign.left,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${landing_type.length > 0 ? landing_type.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['flight_num'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['flight_num']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Номер рейса',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Номер рейса',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${flight_num.length > 0 ? flight_num.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List values = [];
                        for(int i = 0; i < reestrFormsN["NForms"]["data"].length; i++){
                          reestrFormsN["NForms"]["data"][i]['transportation_categories_id'] != null ? values.add({'selected':false, 'value' : reestrFormsN["NForms"]["data"][i]['transportation_categories_id']}) : null;
                        }
                        values.length > 0 ? multipleSelectForFilter(context, 'Цель выполнения перевозки',values) : dialogScreen(context, 'Нет данных для построения фильтра');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Цель выполнения перевозки',
                              style: st1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded( child:
                                Text(
                                  '${purpose.length > 0 ? purpose.toString() : ''}',
                                  style: st3,
                                ),
                    ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: kWhite2,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: kWhite1,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                        Row(
                          children: [
                            GestureDetector(onTap: (){
                              setState(() {
                                selectedTab = 3;
                              });
                              }, child:Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: Center(
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      child: Image.asset('icons/save.png'),
                                    ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomButton1(
                                text: s169,
                                color: kYellow,
                                onPressed: (){
                                  setState(() {
                                    /*permit_num = json.decode(filters['data'][check]['filter_parameters'][0]['idx']);
                                    purpose = json.decode(filters['data'][check]['filter_parameters'][1]['idx']);
                                    created_at = filters['data'][check]['filter_parameters'][2]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    registration_number = filters['data'][check]['filter_parameters'][3]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    aircraft_type_icao = filters['data'][check]['filter_parameters'][4]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    aircraft_owner = filters['data'][check]['filter_parameters'][5]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    is_paid =filters['data'][check]['filter_parameters'][6]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    landing_type =filters['data'][check]['filter_parameters'][7]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    flight_num = filters['data'][check]['filter_parameters'][8]['idx'].replaceAll(']','').replaceAll('[','').split(',');*/
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(onTap:()=>dalFilter(), child:Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                              child: Center(
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset('icons/delete.png'),
                                ),
                              ),
                            ),),
                          ],
                        )
                  ]) : selectedTab == 2 ? Column(
                        children: [
                          _readyReestr == true ? ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filters['data'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                  children: [
                                  Row(
                                            children: [
                                              Radio<int>(
                                                activeColor: kYellow,
                                                value: index,
                                                groupValue: check,
                                                onChanged: (value) {
                                                  setState(() {
                                                    check = value;
                                                    delFilterNum = filters['data'][index]['id'].toString();
                                                  });
                                                },
                                              ),
                                              Text(filters['data'][index]['name'], style: st1,),
                                              Spacer(),
                                              Text('Редактировать', style: st6,),
                                  ]),
                                    Row(
                                      children:[
                                      SizedBox(width: 50,),
                                      //Expanded( child:Text('E лукоморья дуб зеленый, златая цепь на дубе том', style: st9),),
                                        SizedBox(width: 80,),
                                      ]),
                                    ]);
                            }): CircularProgressIndicator(),
                            Container(alignment: Alignment.bottomCenter, child: CustomButton1(
                                text: s169,
                                color: kYellow,
                              onPressed: (){
                                setState(() {
                                  selectedTab = 1;
                                  permit_num = json.decode(filters['data'][check]['filter_parameters'][0]['idx']);
                                    purpose = json.decode(filters['data'][check]['filter_parameters'][1]['idx']);
                                    created_at = filters['data'][check]['filter_parameters'][2]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    registration_number = filters['data'][check]['filter_parameters'][3]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    aircraft_type_icao = filters['data'][check]['filter_parameters'][4]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    aircraft_owner = filters['data'][check]['filter_parameters'][5]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    is_paid =filters['data'][check]['filter_parameters'][6]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    landing_type =filters['data'][check]['filter_parameters'][7]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                    flight_num = filters['data'][check]['filter_parameters'][8]['idx'].replaceAll(']','').replaceAll('[','').split(',');
                                });
                              },
                              ),
                            ),
                          SizedBox(height: 50,),
                          ]):Container()

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
