import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet5 extends StatefulWidget {
  @override
  _BottomSheet5State createState() => _BottomSheet5State();
}

class _BottomSheet5State extends State<BottomSheet5> {
  String dropdownValue = 'Swiss International Air Lines Ltd_4';
  String dropdownValue1 = '1234567';
  String dropdownValue3 = 'LSZH';
  String dropdownValue4 = 'ZSPD';
  bool e1 = false,
      e2 = false,
      e3 = false,
      e4 = false,
      e5 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: kBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      margin: EdgeInsets.only(top: 80),
      child: ListView(
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
          Text(
            s105,
            style: st8,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              children: [
                SizedBox(width: 10,),
                Text(s106,style: st8,),
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(height: 2,
                    thickness: 2,
                    color: kWhite1,),
                )
              ],
            ),
            children: [
              SizedBox(height: 12,),
              CustomBorderTitleContainer(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down,color: kWhite2,),
                  iconSize: 24,
                  elevation: 16,
                  style: st1,
                  underline: Container(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Swiss International Air Lines Ltd_4', s50, s20, s52]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,),
                    );
                  }).toList(),
                ),
                title: s107,
              ),
              SizedBox(height: 12,),
              CustomBorderTitleContainer(
                title: s108,
                child: ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                      hintText: s109,
                      hintStyle: st8,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                    child: CustomBorderTitleContainer(
                      title: s110,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(bottom: 14,left: 8,right: 5),
                        title: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: '1.06.2020',
                              hintStyle: st8
                          ),
                        ),
                        trailing: Container(
                          margin: EdgeInsets.only(bottom: 7),
                          height: 17,
                          width: 14,
                          child: Image.asset('icons/calendar.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomBorderTitleContainer(
                      title: s111,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(bottom: 14,left: 8,right: 5),
                        title: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: '30.6.2020',
                              hintStyle: st8
                          ),
                        ),
                        trailing: Container(
                          margin: EdgeInsets.only(bottom: 7),
                          height: 17,
                          width: 14,
                          child: Image.asset('icons/calendar.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              CustomBorderTitleContainer(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue1,
                  icon: Icon(Icons.keyboard_arrow_down,color: kWhite2,),
                  iconSize: 24,
                  elevation: 16,
                  style: st1,
                  underline: Container(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue1 = newValue;
                    });
                  },
                  items: <String>['1234567', s50, s20, s52]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,),
                    );
                  }).toList(),
                ),
                title: s112,
              ),
            ],
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              children: [
                SizedBox(width: 10,),
                Text(s113,style: st8,),
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(height: 2,
                    thickness: 2,
                    color: kWhite1,),
                )
              ],
            ),
            children: [
              SizedBox(height: 12,),
              CustomBorderTitleContainer(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue3,
                  icon: Icon(Icons.keyboard_arrow_down,color: kWhite2,),
                  iconSize: 24,
                  elevation: 16,
                  style: st1,
                  underline: Container(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue3 = newValue;
                    });
                  },
                  items: <String>['LSZH', s50, s20, s52]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,),
                    );
                  }).toList(),
                ),
                title: s114,
              ),
              SizedBox(height: 12,),
              CustomBorderTitleContainer(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue4,
                  icon: Icon(Icons.keyboard_arrow_down,color: kWhite2,),
                  iconSize: 24,
                  elevation: 16,
                  style: st1,
                  underline: Container(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue4 = newValue;
                    });
                  },
                  items: <String>['ZSPD', s50, s20, s52]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,),
                    );
                  }).toList(),
                ),
                title: s115,
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                    child: CustomBorderTitleContainer(
                      title: s116,
                      child: ListTile(
                        title: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: '11:30',
                              hintStyle: st8
                          ),
                        ),
                        trailing:Container(
                          height: 14,
                          width: 14,
                          child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomBorderTitleContainer(
                      title: s94,
                      child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                hintText: '20:30',
                                hintStyle: st8
                            ),
                          ),
                          trailing:Container(
                            height: 14,
                            width: 14,
                            child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12,),
          CustomButton1(
            text: s118,
            color: kYellow,
          ),
          SizedBox(height: 12,),
          CustomButton1(
            text: s119,
            color: kYellow,
          ),
          SizedBox(height: 12,),
          CustomButton1(
            text: s120,
            color: kYellow,
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              children: [
                SizedBox(width: 10,),
                Text(s121,style: st8,),
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(height: 2,
                    thickness: 2,
                    color: kWhite1,),
                )
              ],
            ),
            children: [
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ExpansionTile(
                  title: Text(s122,style: st8,),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ListTile(
                  title: Text(s123,style: st8,),
                ),
              ),
              SizedBox(height: 12,),
              CustomButton1(
                text: s124,
                color: kYellow,
              )
            ],
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              children: [
                SizedBox(width: 10,),
                Text(s125,style: st8,),
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(height: 2,
                    thickness: 2,
                    color: kWhite1,),
                )
              ],
            ),
            children: [
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ExpansionTile(
                  title: Text(s126,style: st8,),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ExpansionTile(
                  title: Text(s127,style: st8,),
                ),
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration:
                      BoxDecoration(border: Border.all(color: kWhite1)),
                      child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                hintText: s128,
                                hintStyle: st9
                            ),
                          ),
                          trailing: Container(
                            height: 14,
                            width: 14,
                            child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration:
                      BoxDecoration(border: Border.all(color: kWhite1)),
                      child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: s129,
                              hintStyle: st9,
                            ),
                          ),
                          trailing: Container(
                            height: 14,
                            width: 14,
                            child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        hintText: s130,
                        hintStyle: st8
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        hintText: s131,
                        hintStyle: st8
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration:
                BoxDecoration(border: Border.all(color: kWhite1)),
                child: ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        hintText: s132,
                        hintStyle: st8
                    ),
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            title: Row(
              children: [
                SizedBox(width: 10,),
                Text(s133,style: st8,),
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(height: 2,
                    thickness: 2,
                    color: kWhite1,),
                )
              ],
            ),
            children: [
              SizedBox(height: 12,),
              CustomButton1(
                text: s134,
                color: kYellow,
              )
            ],
          ),
          SizedBox(height: 20,),
          Container(
            height: 45,
            child: FlatButton(
              color: kWhite3,
              child: Text(
                s104,
                style: st1,
              ),
              onPressed: () {
              },
            ),
          )
        ],
      ),
    );
  }
}


