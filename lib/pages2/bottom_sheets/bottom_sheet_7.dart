import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/pages/bottom_sheets/bottom_sheet_8.dart';
import 'package:avia_app/text_styles.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import 'package:avia_app/widgets/custom_switch.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../homepage_other.dart';
int selectedTab = 1;
int align = 1;
String dropdownValue = s157;
bool switch1 = true;
String filterName = '';

class BottomSheet7 extends StatefulWidget {
  @override
  _BottomSheet7State createState() => _BottomSheet7State();
}

int check = 0;

class _BottomSheet7State extends State<BottomSheet7> {

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
                                setState(() {
                                  selectedTab = 1;
                                });
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
                              },
                              items: <String>[s157, 'Two', 'Free', 'Four']
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
                            //переворачиваем лист чтоб свежие даты были вверху
                            var tempList = json.decode('{"NForms":{"data":[]}}');
                            for(int i = reestrFormsN["NForms"]["data"].length - 1; i > -1; i--){
                              tempList["NForms"]["data"].add(reestrFormsN["NForms"]["data"][i]);
                            }
                            reestrFormsN = tempList;
                              print('по убывающей');
                              align = 1;
                            setState(() {});
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) =>HomePageOther()));
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
                            reestrFormsN = reestrFormNBackUp;
                            print('по возрастающей');
                              align = 2;
                            setState(() {});
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) =>HomePageOther()));
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
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Номер разрешения',
                              style: st1,
                            ),
                            Row(
                              children: [
                                Text(
                                  '12345',
                                  style: st3,
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
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Дата и время регистрации формы',
                              style: st1,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '',
                                      style: st3,
                                    ),
                                  ],
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
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Регистрационный номер основного ВС',
                              style: st1,
                            ),
                            Row(
                              children: [
                                Text(
                                  '',
                                  style: st3,
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
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Тип основного ВС',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: kTrans,
                            context: context,
                            builder: (context) {
                              return BottomSheet8();
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Владелец ВС',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Оплата АНО',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Тип посадки',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Номер рейса',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Цель выполнения перевозки',
                              style: st1,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kWhite2,
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
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
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
                            ),
                          ],
                        )
                  ]) : selectedTab == 2 ? Column(
                        children: [
                            ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 5,
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
                                                  });
                                                },
                                              ),
                                              Text('Фильтр ${index+1}', style: st1,),
                                              Spacer(),
                                              Text('Редактировать', style: st6,),
                                  ]),
                                    Row(
                                      children:[
                                      SizedBox(width: 50,),
                                      Expanded( child:Text('E лукоморья дуб зеленый, златая цепь на дубе том', style: st9),),
                                        SizedBox(width: 80,),
                                      ]),
                                    ]);
                            }),
                            Container(alignment: Alignment.bottomCenter, child: CustomButton1(
                                text: s169,
                                color: kYellow,
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
