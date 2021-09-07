import 'package:avia_app/pages/bottom_sheets/bottom_sheet_7.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'custom_button_1.dart';



multipleSelectForFilter(var context, String message, List values){
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        var countSelected = message == 'Номер разрешения' ? purpose.length : message ==
            'Дата и время регистрации формы'
            ? created_at.length
            : message == 'Регистрационный номер основного ВС' ?
        registration_number.length : message == 'Тип основного ВС' ?
        aircraft_type_icao.length : message == 'Владелец ВС' ?
        aircraft_owner.length : message == 'Оплата АНО'
            ? is_paid.length
            : message == 'Тип посадки'
            ? landing_type.length
            : flight_num.length;
        //выстроим все по алфавиту
        values.sort((a, b) => a["value"].compareTo(b["value"]));
        //удалим все повторяющиеся элементы
        for(int i = 0; i < values.length; i++){
          i > 0 ? values[i]['value'] == values[i-1]['value'] ? values.removeAt(i) : null : null;
        }
        //поставим где надо тру
        for(int i= 0; i < values.length; i++){
          for(int ii=0; ii< countSelected; ii++){
            countSelected > 0 ? values[i]['value'] == (message == 'Номер разрешения' ? purpose[ii] : message ==
                'Дата и время регистрации формы'
                ? created_at[ii]
                : message == 'Регистрационный номер основного ВС' ?
            registration_number[ii] : message == 'Тип основного ВС' ?
            aircraft_type_icao[ii] : message == 'Владелец ВС' ?
            aircraft_owner[ii] : message == 'Оплата АНО'
                ? is_paid[ii]
                : message == 'Тип посадки'
                ? landing_type[ii]
                : flight_num[ii]) ? values[i]['selected'] = true : null : null;
          }
        }
        return StatefulBuilder(
            builder: (context, setState) {

              return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0 , 0),
            insetPadding: EdgeInsets.all(0),
            elevation: 0.0,
            content:Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 400,
                  margin: EdgeInsets.fromLTRB(20,20,20,20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kWhite3,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16.5),
                    color: kBlue,
                  ),
                  padding: EdgeInsets.fromLTRB(20,20,20,20),
                  child:  Column(
                      children: <Widget>[
                        //Text('У лукоморья дуб зеленый златая цепь на дубе том и днем и ночью кот ученый все ходи', textAlign: TextAlign.center, style: st17,),
                        Text(message, textAlign: TextAlign.center,style: st1,),
                        Container(
                          padding: EdgeInsets.fromLTRB(10,20,10,20),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {

                                return index > 0 ? values[index]['value'] != values[index - 1]['value'] ? GestureDetector(onTap:(){
                                  setState(() {
                                    values[index]['selected'] = !values[index]['selected'];
                                  });

                                }, child:Text(values[index]['value'], style: values[index]['selected'] == false ? st1 : st10,)) : Container() : GestureDetector(onTap:(){
                                  setState(() {
                                    values[index]['selected'] = !values[index]['selected'];
                                  });

                                }, child:Text(values[index]['value'], style: values[index]['selected'] == false ? st1 : st10,));
                              }),
                        ),
                        SizedBox(height: 10,),
                        Row(children:[
                          Expanded(
                            child: CustomButton1(
                              text: s169,
                              color: kYellow,
                              onPressed:(){
                                message == 'Номер разрешения' ? purpose.clear() : message ==
                                    'Дата и время регистрации формы'
                                    ? created_at.clear()
                                    : message == 'Регистрационный номер основного ВС' ?
                                registration_number.clear()  : message == 'Тип основного ВС' ?
                                aircraft_type_icao.clear()  : message == 'Владелец ВС' ?
                                aircraft_owner.clear()  : message == 'Оплата АНО'
                                    ? is_paid.clear()
                                    : message == 'Тип посадки'
                                    ? landing_type.clear()
                                    : flight_num.clear() ;
                                //setState(() {});
                                for(int i = 0; i < values.length; i++){
                                  values[i]['selected'] == true ? message == 'Номер разрешения' ? purpose.add('${values[i]['value']}') : message == 'Дата и время регистрации формы' ? created_at.add('${values[i]['value']}') : message == 'Регистрационный номер основного ВС' ? registration_number.add('${values[i]['value']}') : message == 'Тип основного ВС' ? aircraft_type_icao.add('${values[i]['value'].trim()}') : message == 'Владелец ВС' ? aircraft_owner.add('${values[i]['value']}') : message == 'Оплата АНО' ? is_paid.add('${values[i]['value']}') : message == 'Тип посадки' ? landing_type.add('${values[i]['value']}') : flight_num.add('${values[i]['value']}') : null;
                                }
                                values.clear();
                                //setState(() {});
                                Navigator.of(context).pop();
                              }  ,
                            ),
                          ),
                          Expanded(
                            child: CustomButton1(
                              text: s170,
                              color: kYellow,
                              onPressed:(){
                                Navigator.of(context).pop();
                              }  ,
                            ),
                          ),

                        ])

                      ])

              ),
            )
              );}
        );
      });
}