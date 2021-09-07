import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../strings.dart';



class aboutPage extends StatefulWidget {
  @override
  _aboutPageScreenState createState() => _aboutPageScreenState();
}

class _aboutPageScreenState extends State<aboutPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        elevation: 0.0,
        title: Text(
          s175,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'AlS Hauss',
              fontSize: 16.0,
              height: 1.5
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
        backgroundColor: kBlue.withOpacity(0.6),
        brightness: Brightness.dark,
        leading: Container(
            padding: EdgeInsets.fromLTRB(9,8,0,0),
            child: SizedBox(
                width: 45,
                height: 45,
                child: Image.asset('images/logoReg.png',
                    fit: BoxFit.fitWidth)
            )
        ),
        actions: [
          Container(
              width: 67,
              height: 40,
              margin: EdgeInsets.fromLTRB(0,8,9,0),
              padding: EdgeInsets.fromLTRB(8,3,0,3),
              decoration: BoxDecoration(
                  border: Border.all(color: kWhite.withOpacity(0.2), width: 2)
              ),
              child: DropdownButton<String>(
                value: language,
                icon: const Icon(Icons.keyboard_arrow_down, color: kWhite),
                iconSize: 30,
                elevation: 10,
                underline: Container(
                  height: 0,
                  color: kBlueLight,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    language = newValue;
                  });
                },
                items: languages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 23,
                      height: 15,
                      child: Image.asset(value == 'ru' ? 'images/rfFlag.png' : 'images/enFlag.png',
                          fit: BoxFit.fitWidth),
                    ),
                  );
                }).toList(),
              )
          )
        ],
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue.withOpacity(0.6),
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            //child:Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(10,40,10,0),
                      child:Text('Раздел о системе программе приложении',
                        style: TextStyle(
                          color: kWhite,
                          fontFamily: 'AlS Hauss',
                          fontSize: 28.0,
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10,20,10,0),
                      child:Text('Вставить текст',
                        style: TextStyle(
                          color: kWhite,
                          fontFamily: 'AlS Hauss',
                          fontSize: 21.0,
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),

                  //кнопка принимаю
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.fromLTRB(10,30,10,50),
                    child: TextButton(
                      onPressed:(){
                        Navigator.pushNamed(context, '/profile');
                      } ,
                      child: Text(s170, style: TextStyle(fontSize: 16.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                      style: ElevatedButton.styleFrom(
                        primary: kYellow ,
                        minimumSize: Size(MediaQuery.of(context).size.width, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}