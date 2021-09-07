import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avia_app/widgets/custom_border_title_container.dart';
import 'package:avia_app/widgets/custom_button_1.dart';
import 'package:avia_app/widgets/expanded_section.dart';
import '../../constants.dart';
import '../../strings.dart';
import '../../text_styles.dart';

class BottomSheet6 extends StatefulWidget {
  @override
  _BottomSheet6State createState() => _BottomSheet6State();
}

class _BottomSheet6State extends State<BottomSheet6> {
  String dropdownValue = 'Swiss International Air Lines Ltd_4';
  String dropdownValue1 = '1234567';
  String dropdownValue3 = 'LSZH';
  String dropdownValue4 = 'ZSPD';
  bool e1 = false,
      e2 = false,
      e3 = false,
      e4 = false,
      e5 = false,
      e6 = false,
      e7 = false,
      e8 = false;

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
                decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), topRight: Radius.circular(8))),
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
                      s105,
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
                            onTap: () {
                              setState(() {
                                e1 = !e1;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e1
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s106,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
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
                                SizedBox(
                                  height: 24,
                                ),
                                CustomBorderTitleContainer(
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
                                    items: <String>[
                                      'Swiss International Air Lines Ltd_4',
                                      s50,
                                      s20,
                                      s52
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  title: s107,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                CustomBorderTitleContainer(
                                  title: s108,
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                                        hintText: s109,
                                        hintStyle: st8,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBorderTitleContainer(
                                        title: s110,
                                        child: ListTile(
                                          contentPadding:
                                          EdgeInsets.only(bottom: 14, left: 8, right: 5),
                                          title: TextField(
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                hintText: '1.06.2020',
                                                hintStyle: st8),
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: CustomBorderTitleContainer(
                                        title: s111,
                                        child: ListTile(
                                          contentPadding:
                                          EdgeInsets.only(bottom: 14, left: 8, right: 5),
                                          title: TextField(
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                hintText: '30.6.2020',
                                                hintStyle: st8),
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
                                SizedBox(
                                  height: 12,
                                ),
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue1,
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
                                        dropdownValue1 = newValue;
                                      });
                                    },
                                    items: <String>['1234567', s50, s20, s52]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  title: s112,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s106,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomBorderTitleContainer(
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: dropdownValue,
                    //         icon: Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: kWhite2,
                    //         ),
                    //         iconSize: 24,
                    //         elevation: 16,
                    //         style: st1,
                    //         underline: Container(),
                    //         onChanged: (String newValue) {
                    //           setState(() {
                    //             dropdownValue = newValue;
                    //           });
                    //         },
                    //         items: <String>[
                    //           'Swiss International Air Lines Ltd_4',
                    //           s50,
                    //           s51,
                    //           s52
                    //         ].map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(
                    //               value,
                    //             ),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       title: s107,
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomBorderTitleContainer(
                    //       title: s108,
                    //       child: ListTile(
                    //         title: TextField(
                    //           decoration: InputDecoration(
                    //             border: UnderlineInputBorder(borderSide: BorderSide.none),
                    //             hintText: s109,
                    //             hintStyle: st8,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: CustomBorderTitleContainer(
                    //             title: s110,
                    //             child: ListTile(
                    //               contentPadding:
                    //                   EdgeInsets.only(bottom: 14, left: 8, right: 5),
                    //               title: TextField(
                    //                 decoration: InputDecoration(
                    //                     border: UnderlineInputBorder(
                    //                         borderSide: BorderSide.none),
                    //                     hintText: '1.06.2020',
                    //                     hintStyle: st8),
                    //               ),
                    //               trailing: Container(
                    //                 margin: EdgeInsets.only(bottom: 7),
                    //                 height: 17,
                    //                 width: 14,
                    //                 child: Image.asset('icons/calendar.png'),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Expanded(
                    //           child: CustomBorderTitleContainer(
                    //             title: s111,
                    //             child: ListTile(
                    //               contentPadding:
                    //                   EdgeInsets.only(bottom: 14, left: 8, right: 5),
                    //               title: TextField(
                    //                 decoration: InputDecoration(
                    //                     border: UnderlineInputBorder(
                    //                         borderSide: BorderSide.none),
                    //                     hintText: '30.6.2020',
                    //                     hintStyle: st8),
                    //               ),
                    //               trailing: Container(
                    //                 margin: EdgeInsets.only(bottom: 7),
                    //                 height: 17,
                    //                 width: 14,
                    //                 child: Image.asset('icons/calendar.png'),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomBorderTitleContainer(
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: dropdownValue1,
                    //         icon: Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: kWhite2,
                    //         ),
                    //         iconSize: 24,
                    //         elevation: 16,
                    //         style: st1,
                    //         underline: Container(),
                    //         onChanged: (String newValue) {
                    //           setState(() {
                    //             dropdownValue1 = newValue;
                    //           });
                    //         },
                    //         items: <String>['1234567', s50, s51, s52]
                    //             .map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(
                    //               value,
                    //             ),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       title: s112,
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e2 = !e2;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e2
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s113,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue3,
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
                                        dropdownValue3 = newValue;
                                      });
                                    },
                                    items: <String>['LSZH', s50, s20, s52]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  title: s114,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                CustomBorderTitleContainer(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue4,
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
                                        dropdownValue4 = newValue;
                                      });
                                    },
                                    items: <String>['ZSPD', s50, s20, s52]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  title: s115,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBorderTitleContainer(
                                        title: s116,
                                        child: ListTile(
                                          title: TextField(
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                hintText: '11:30',
                                                hintStyle: st8),
                                          ),
                                          trailing: Container(
                                            height: 14,
                                            width: 14,
                                            child: Image.asset(
                                              'icons/clock.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: CustomBorderTitleContainer(
                                        title: s20,
                                        child: ListTile(
                                            title: TextField(
                                              decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                      borderSide: BorderSide.none),
                                                  hintText: '20:30',
                                                  hintStyle: st8),
                                            ),
                                            trailing: Container(
                                              height: 14,
                                              width: 14,
                                              child: Image.asset(
                                                'icons/clock.png',
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s113,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomBorderTitleContainer(
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: dropdownValue3,
                    //         icon: Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: kWhite2,
                    //         ),
                    //         iconSize: 24,
                    //         elevation: 16,
                    //         style: st1,
                    //         underline: Container(),
                    //         onChanged: (String newValue) {
                    //           setState(() {
                    //             dropdownValue3 = newValue;
                    //           });
                    //         },
                    //         items: <String>['LSZH', s50, s51, s52]
                    //             .map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(
                    //               value,
                    //             ),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       title: s114,
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomBorderTitleContainer(
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: dropdownValue4,
                    //         icon: Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: kWhite2,
                    //         ),
                    //         iconSize: 24,
                    //         elevation: 16,
                    //         style: st1,
                    //         underline: Container(),
                    //         onChanged: (String newValue) {
                    //           setState(() {
                    //             dropdownValue4 = newValue;
                    //           });
                    //         },
                    //         items: <String>['ZSPD', s50, s51, s52]
                    //             .map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(
                    //               value,
                    //             ),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       title: s115,
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: CustomBorderTitleContainer(
                    //             title: s116,
                    //             child: ListTile(
                    //               title: TextField(
                    //                 decoration: InputDecoration(
                    //                     border: UnderlineInputBorder(
                    //                         borderSide: BorderSide.none),
                    //                     hintText: '11:30',
                    //                     hintStyle: st8),
                    //               ),
                    //               trailing: Container(
                    //                 height: 14,
                    //                 width: 14,
                    //                 child: Image.asset(
                    //                   'icons/clock.png',
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Expanded(
                    //           child: CustomBorderTitleContainer(
                    //             title: s117,
                    //             child: ListTile(
                    //                 title: TextField(
                    //                   decoration: InputDecoration(
                    //                       border: UnderlineInputBorder(
                    //                           borderSide: BorderSide.none),
                    //                       hintText: '20:30',
                    //                       hintStyle: st8),
                    //                 ),
                    //                 trailing: Container(
                    //                   height: 14,
                    //                   width: 14,
                    //                   child: Image.asset(
                    //                     'icons/clock.png',
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 )),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e3 = !e3;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e3
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: FittedBox(
                                      child: Text(
                                        s136,
                                        style: st8,
                                      ),
                                      fit: BoxFit.contain,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e3,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  height: 130,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: kWhite1)),
                                              child: ExpansionTile(
                                                title: Text(
                                                  s137,
                                                  style: st8,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      height: 58,
                                                      padding:
                                                      EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: kWhite1)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: s94,
                                                                hintStyle: st9,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 14,
                                                            width: 14,
                                                            child: Image.asset(
                                                              'icons/clock.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 58,
                                                      padding:
                                                      EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: kWhite1)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: s94,
                                                                hintStyle: st9,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 14,
                                                            width: 14,
                                                            child: Image.asset(
                                                              'icons/clock.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        height: 130,
                                        width: 50,
                                        decoration:
                                        BoxDecoration(border: Border.all(color: kWhite1)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 35,
                                                width: 33,
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Image.asset('icons/delete.png')),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Expanded(
                    //           child: FittedBox(
                    //         child: Text(
                    //           s136,
                    //           style: st8,
                    //         ),
                    //         fit: BoxFit.contain,
                    //       )),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 130,
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Container(
                    //                   padding: EdgeInsets.symmetric(horizontal: 8),
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(color: kWhite1)),
                    //                   child: ExpansionTile(
                    //                     title: Text(
                    //                       s137,
                    //                       style: st8,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Expanded(
                    //                       child: Container(
                    //                           height: 58,
                    //                           padding:
                    //                               EdgeInsets.symmetric(horizontal: 8),
                    //                           decoration: BoxDecoration(
                    //                               border: Border.all(color: kWhite1)),
                    //                           child: Row(
                    //                             children: [
                    //                               Expanded(
                    //                                 child: TextField(
                    //                                   decoration: InputDecoration(
                    //                                     border: UnderlineInputBorder(
                    //                                         borderSide: BorderSide.none),
                    //                                     hintText: s138,
                    //                                     hintStyle: st9,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 14,
                    //                                 width: 14,
                    //                                 child: Image.asset(
                    //                                   'icons/clock.png',
                    //                                   fit: BoxFit.cover,
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           )),
                    //                     ),
                    //                     SizedBox(
                    //                       width: 10,
                    //                     ),
                    //                     Expanded(
                    //                       child: Container(
                    //                           height: 58,
                    //                           padding:
                    //                               EdgeInsets.symmetric(horizontal: 8),
                    //                           decoration: BoxDecoration(
                    //                               border: Border.all(color: kWhite1)),
                    //                           child: Row(
                    //                             children: [
                    //                               Expanded(
                    //                                 child: TextField(
                    //                                   decoration: InputDecoration(
                    //                                     border: UnderlineInputBorder(
                    //                                         borderSide: BorderSide.none),
                    //                                     hintText: s139,
                    //                                     hintStyle: st9,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 14,
                    //                                 width: 14,
                    //                                 child: Image.asset(
                    //                                   'icons/clock.png',
                    //                                   fit: BoxFit.cover,
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           )),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 12,
                    //           ),
                    //           Container(
                    //             height: 130,
                    //             width: 50,
                    //             decoration:
                    //                 BoxDecoration(border: Border.all(color: kWhite1)),
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Container(
                    //                     height: 35,
                    //                     width: 33,
                    //                     padding: EdgeInsets.symmetric(horizontal: 8),
                    //                     child: Image.asset('icons/delete.png')),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e4 = !e4;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e4
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s140,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e4,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 130,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: kWhite1)),
                                              child: ExpansionTile(
                                                tilePadding: EdgeInsets.all(0),
                                                title: Text(
                                                  s141,
                                                  style: st8,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      height: 58,
                                                      padding:
                                                      EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: kWhite1)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: s116,
                                                                hintStyle: st9,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 14,
                                                            width: 14,
                                                            child: Image.asset(
                                                              'icons/clock.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 58,
                                                      padding:
                                                      EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: kWhite1)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                border: UnderlineInputBorder(
                                                                    borderSide: BorderSide.none),
                                                                hintText: s94,
                                                                hintStyle: st9,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 14,
                                                            width: 14,
                                                            child: Image.asset(
                                                              'icons/clock.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        height: 130,
                                        width: 50,
                                        decoration:
                                        BoxDecoration(border: Border.all(color: kWhite1)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 35,
                                                width: 33,
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Image.asset('icons/delete.png')),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s140,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 130,
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   padding: EdgeInsets.symmetric(horizontal: 8),
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(color: kWhite1)),
                    //                   child: ExpansionTile(
                    //                     tilePadding: EdgeInsets.all(0),
                    //                     title: Text(
                    //                       s141,
                    //                       style: st8,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   height: 12,
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Expanded(
                    //                       child: Container(
                    //                           height: 58,
                    //                           padding:
                    //                               EdgeInsets.symmetric(horizontal: 8),
                    //                           decoration: BoxDecoration(
                    //                               border: Border.all(color: kWhite1)),
                    //                           child: Row(
                    //                             children: [
                    //                               Expanded(
                    //                                 child: TextField(
                    //                                   decoration: InputDecoration(
                    //                                     border: UnderlineInputBorder(
                    //                                         borderSide: BorderSide.none),
                    //                                     hintText: s142,
                    //                                     hintStyle: st9,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 14,
                    //                                 width: 14,
                    //                                 child: Image.asset(
                    //                                   'icons/clock.png',
                    //                                   fit: BoxFit.cover,
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           )),
                    //                     ),
                    //                     SizedBox(
                    //                       width: 10,
                    //                     ),
                    //                     Expanded(
                    //                       child: Container(
                    //                           height: 58,
                    //                           padding:
                    //                               EdgeInsets.symmetric(horizontal: 8),
                    //                           decoration: BoxDecoration(
                    //                               border: Border.all(color: kWhite1)),
                    //                           child: Row(
                    //                             children: [
                    //                               Expanded(
                    //                                 child: TextField(
                    //                                   decoration: InputDecoration(
                    //                                     border: UnderlineInputBorder(
                    //                                         borderSide: BorderSide.none),
                    //                                     hintText: s143,
                    //                                     hintStyle: st9,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 14,
                    //                                 width: 14,
                    //                                 child: Image.asset(
                    //                                   'icons/clock.png',
                    //                                   fit: BoxFit.cover,
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           )),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 12,
                    //           ),
                    //           Container(
                    //             height: 130,
                    //             width: 50,
                    //             decoration:
                    //                 BoxDecoration(border: Border.all(color: kWhite1)),
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Container(
                    //                     height: 35,
                    //                     width: 33,
                    //                     padding: EdgeInsets.symmetric(horizontal: 8),
                    //                     child: Image.asset('icons/delete.png')),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e5 = !e5;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e5
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s144,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e5,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  height: 130,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomBorderTitleContainer(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: dropdownValue3,
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
                                                    dropdownValue3 = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  'LSZH',
                                                  s50,
                                                  s20,
                                                  s52
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              title: s114,
                                            ),
                                            CustomBorderTitleContainer(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: dropdownValue4,
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
                                                    dropdownValue4 = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  'ZSPD',
                                                  s50,
                                                  s20,
                                                  s52
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              title: s115,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        height: 121,
                                        width: 50,
                                        decoration:
                                        BoxDecoration(border: Border.all(color: kWhite1)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 35,
                                                width: 33,
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Image.asset('icons/delete.png')),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s144,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 130,
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           Expanded(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 CustomBorderTitleContainer(
                    //                   child: DropdownButton<String>(
                    //                     isExpanded: true,
                    //                     value: dropdownValue3,
                    //                     icon: Icon(
                    //                       Icons.keyboard_arrow_down,
                    //                       color: kWhite2,
                    //                     ),
                    //                     iconSize: 24,
                    //                     elevation: 16,
                    //                     style: st1,
                    //                     underline: Container(),
                    //                     onChanged: (String newValue) {
                    //                       setState(() {
                    //                         dropdownValue3 = newValue;
                    //                       });
                    //                     },
                    //                     items: <String>[
                    //                       'LSZH',
                    //                       s50,
                    //                       s51,
                    //                       s52
                    //                     ].map<DropdownMenuItem<String>>((String value) {
                    //                       return DropdownMenuItem<String>(
                    //                         value: value,
                    //                         child: Text(
                    //                           value,
                    //                         ),
                    //                       );
                    //                     }).toList(),
                    //                   ),
                    //                   title: s114,
                    //                 ),
                    //                 CustomBorderTitleContainer(
                    //                   child: DropdownButton<String>(
                    //                     isExpanded: true,
                    //                     value: dropdownValue4,
                    //                     icon: Icon(
                    //                       Icons.keyboard_arrow_down,
                    //                       color: kWhite2,
                    //                     ),
                    //                     iconSize: 24,
                    //                     elevation: 16,
                    //                     style: st1,
                    //                     underline: Container(),
                    //                     onChanged: (String newValue) {
                    //                       setState(() {
                    //                         dropdownValue4 = newValue;
                    //                       });
                    //                     },
                    //                     items: <String>[
                    //                       'ZSPD',
                    //                       s50,
                    //                       s51,
                    //                       s52
                    //                     ].map<DropdownMenuItem<String>>((String value) {
                    //                       return DropdownMenuItem<String>(
                    //                         value: value,
                    //                         child: Text(
                    //                           value,
                    //                         ),
                    //                       );
                    //                     }).toList(),
                    //                   ),
                    //                   title: s115,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 12,
                    //           ),
                    //           Container(
                    //             height: 121,
                    //             width: 50,
                    //             decoration:
                    //                 BoxDecoration(border: Border.all(color: kWhite1)),
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Container(
                    //                     height: 35,
                    //                     width: 33,
                    //                     padding: EdgeInsets.symmetric(horizontal: 8),
                    //                     child: Image.asset('icons/delete.png')),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton1(
                      text: s118,
                      color: kYellow,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton1(
                      text: s119,
                      color: kYellow,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton1(
                      text: s120,
                      color: kYellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e6 = !e6;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e6
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s121,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e6,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(
                                      s122,
                                      style: st8,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border:
                                          UnderlineInputBorder(borderSide: BorderSide.none),
                                          hintText: s123,
                                          hintStyle: st8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                CustomButton1(
                                  text: s124,
                                  color: kYellow,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s121,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ExpansionTile(
                    //         title: Text(
                    //           s122,
                    //           style: st8,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ListTile(
                    //         title: TextField(
                    //           decoration: InputDecoration(
                    //               border:
                    //                   UnderlineInputBorder(borderSide: BorderSide.none),
                    //               hintText: s123,
                    //               hintStyle: st8),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomButton1(
                    //       text: s124,
                    //       color: kYellow,
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e7 = !e7;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e7
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s125,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e7,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(
                                      s126,
                                      style: st8,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ExpansionTile(
                                    title: Text(
                                      s127,
                                      style: st8,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
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
                                                      borderSide: BorderSide.none),
                                                  hintText: s128,
                                                  hintStyle: st9),
                                            ),
                                            trailing: Container(
                                              height: 14,
                                              width: 14,
                                              child: Image.asset(
                                                'icons/clock.png',
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                        decoration:
                                        BoxDecoration(border: Border.all(color: kWhite1)),
                                        child: ListTile(
                                            title: TextField(
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                hintText: s129,
                                                hintStyle: st9,
                                              ),
                                            ),
                                            trailing: Container(
                                              height: 14,
                                              width: 14,
                                              child: Image.asset(
                                                'icons/clock.png',
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border:
                                          UnderlineInputBorder(borderSide: BorderSide.none),
                                          hintText: s130,
                                          hintStyle: st8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border:
                                          UnderlineInputBorder(borderSide: BorderSide.none),
                                          hintText: s131,
                                          hintStyle: st8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                                  child: ListTile(
                                    title: TextField(
                                      decoration: InputDecoration(
                                          border:
                                          UnderlineInputBorder(borderSide: BorderSide.none),
                                          hintText: s132,
                                          hintStyle: st8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s125,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ExpansionTile(
                    //         title: Text(
                    //           s126,
                    //           style: st8,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ExpansionTile(
                    //         title: Text(
                    //           s127,
                    //           style: st8,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(horizontal: 0),
                    //             decoration:
                    //                 BoxDecoration(border: Border.all(color: kWhite1)),
                    //             child: ListTile(
                    //                 title: TextField(
                    //                   decoration: InputDecoration(
                    //                       border: UnderlineInputBorder(
                    //                           borderSide: BorderSide.none),
                    //                       hintText: s128,
                    //                       hintStyle: st9),
                    //                 ),
                    //                 trailing: Container(
                    //                   height: 14,
                    //                   width: 14,
                    //                   child: Image.asset(
                    //                     'icons/clock.png',
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 )),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Expanded(
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(horizontal: 0),
                    //             decoration:
                    //                 BoxDecoration(border: Border.all(color: kWhite1)),
                    //             child: ListTile(
                    //                 title: TextField(
                    //                   decoration: InputDecoration(
                    //                     border: UnderlineInputBorder(
                    //                         borderSide: BorderSide.none),
                    //                     hintText: s129,
                    //                     hintStyle: st9,
                    //                   ),
                    //                 ),
                    //                 trailing: Container(
                    //                   height: 14,
                    //                   width: 14,
                    //                   child: Image.asset(
                    //                     'icons/clock.png',
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 )),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ListTile(
                    //         title: TextField(
                    //           decoration: InputDecoration(
                    //               border:
                    //                   UnderlineInputBorder(borderSide: BorderSide.none),
                    //               hintText: s130,
                    //               hintStyle: st8),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ListTile(
                    //         title: TextField(
                    //           decoration: InputDecoration(
                    //               border:
                    //                   UnderlineInputBorder(borderSide: BorderSide.none),
                    //               hintText: s131,
                    //               hintStyle: st8),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Container(
                    //       height: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       decoration: BoxDecoration(border: Border.all(color: kWhite1)),
                    //       child: ListTile(
                    //         title: TextField(
                    //           decoration: InputDecoration(
                    //               border:
                    //                   UnderlineInputBorder(borderSide: BorderSide.none),
                    //               hintText: s132,
                    //               hintStyle: st8),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                e8 = !e8;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  e8
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: kWhite2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  s133,
                                  style: st8,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: kWhite1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpandedSection(
                            expand: e8,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                CustomButton1(
                                  text: s134,
                                  color: kYellow,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         s133,
                    //         style: st8,
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 2,
                    //           thickness: 2,
                    //           color: kWhite1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   children: [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     CustomButton1(
                    //       text: s134,
                    //       color: kYellow,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      child: FlatButton(
                        color: Color(0xff2F3542),
                        child: Text(
                          s104,
                          style: st1,
                        ),
                        onPressed: () {},
                      ),
                    )
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
