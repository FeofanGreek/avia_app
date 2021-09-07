import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import 'package:avia_app/widgets/custom_switch.dart';
import 'package:avia_app/widgets/expanded_section.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet4 extends StatefulWidget {
  @override
  _BottomSheet4State createState() => _BottomSheet4State();
}

class _BottomSheet4State extends State<BottomSheet4> {
  String dropdownValue = s71;
  bool e1=false,e2=false,e3=false,e4=false,e5=false,e6=false,e7=false,e8=false,e9=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.001),
        child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), topRight: Radius.circular(8),),),
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
                    Text(
                      s53,
                      style: st8,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e1 = !e1;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s54,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  s174,
                                  style: st3,
                                ),
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e1,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s55,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s56,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s57,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s58,style: st8,),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e2 = !e2;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e2 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s59,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e2,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s60,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s61,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s62,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: kWhite2
                                      ),
                                      child: Text('КГ',style: st4,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s63,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: kWhite2
                                      ),
                                      child: Text('КГ',style: st4,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s64,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: kWhite2
                                      ),
                                      child: Text('КГ',style: st4,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e3 = !e3;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e3 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s65,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e3,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s66,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s67,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                      title: TextField(
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            hintText: s68,
                                            hintStyle: st8
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e4 = !e4;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e4 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s69,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e4,
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  height: 40,
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Row(
                                          children: [
                                            Text(s72,style: st1),
                                            SizedBox(width: 10,),
                                            CustomSwitch(
                                              value: true,
                                              onChanged: (value){},
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
                                    items: <String>[s71, s50, s20, s52]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,),
                                      );
                                    }).toList(),
                                  ),
                                  title: s70,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e5 = !e5;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e5 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s73,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e5,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s74,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s75,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                CustomButton1(
                                  text: '+  $s76',
                                  color: kYellow,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e6 = !e6;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e6 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s77,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e6,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s74,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s75,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                CustomButton1(
                                  text: '+  $s76',
                                  color: kYellow,
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s78,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s79,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s80,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s81,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e7 = !e7;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e7 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
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
                          ),
                          ExpandedSection(
                            expand: e7,
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  height: 40,
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 1,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Row(
                                          children: [
                                            Text(s95,style: st1),
                                            SizedBox(width: 10,),
                                            CustomSwitch(
                                              value: true,
                                              onChanged: (value){},
                                            ),
                                            SizedBox(width: 10,),
                                            Text(s96,style: st2),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s83,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 17,
                                      width: 14,
                                      child: Image.asset('icons/calendar.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s84,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s85,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s116,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 14,
                                      width: 14,
                                      child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s87,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s88,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 14,
                                      width: 14,
                                      child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s89,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s90,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 14,
                                      width: 14,
                                      child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s91,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 17,
                                      width: 14,
                                      child: Image.asset('icons/calendar.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s92,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(s85,style: st8,),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s94,
                                          hintStyle: st8
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      height: 14,
                                      width: 14,
                                      child: Image.asset('icons/clock.png',fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e8 = !e8;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(e8 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Flexible(child: Text(s97,style: st8,)),
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e8,
                            child: Column(
                              children: [
                                SizedBox(height: 12,),
                                Container(
                                  height: 40,
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 1,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Row(
                                          children: [
                                            Text(s95,style: st1),
                                            SizedBox(width: 10,),
                                            CustomSwitch(
                                              value: true,
                                              onChanged: (value){},
                                            ),
                                            SizedBox(width: 10,),
                                            Text(s96,style: st2),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s98,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s99,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                  BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),
                                          hintText: s100,
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
                                          hintText: s101,
                                          hintStyle: st8
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                e9 = !e9;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(e9 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: kWhite2,),
                                SizedBox(width: 10,),
                                Text(s44,style: st8,),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Divider(height: 2,
                                    thickness: 2,
                                    color: kWhite1,),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e9,
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                CustomButton1(
                                  text: s103,
                                  color: kYellow,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 45,
                      child: FlatButton(
                        color: Color(0xff2F3542),
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
            },
          ),
      ),
    );
  }
}


