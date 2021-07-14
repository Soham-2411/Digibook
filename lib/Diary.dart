import 'package:digibook/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Homepage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

String _tempData;
String _tempTitleData;
DateTime _dateTime = DateTime.now();
String _date = _dateTime.day.toString() + ' ' + months[_dateTime.month - 1];
String diaryData;
String diaryTitleData;

class _DiaryPageState extends State<DiaryPage> {
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [HexColor('#6e45e1'), HexColor('#89d4cf')])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 30, left: 25, bottom: 30),
                              child: Text('Diary',
                                  style: TextStyle(
                                      fontSize: 35, color: Colors.white))),
                          Row(
                            children: [
                              Transform(
                                transform: Matrix4.translationValues(20, 0, 0),
                                child: IconButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.arrow_left,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _dateTime = _dateTime
                                          .subtract(new Duration(days: 1));
                                      _date = _dateTime.day.toString() +
                                          ' ' +
                                          months[_dateTime.month - 1];
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(_date,
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  final DateTime _pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    currentDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                  );
                                  if (_pickedDate != null &&
                                      _pickedDate != _dateTime) {
                                    setState(() {
                                      _dateTime = _pickedDate;
                                      _date = _dateTime.day.toString() +
                                          ' ' +
                                          months[_dateTime.month - 1];
                                    });
                                  }
                                },
                              ),
                              Transform(
                                transform: Matrix4.translationValues(-20, 0, 0),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _dateTime =
                                          _dateTime.add(new Duration(days: 1));
                                      _date = _dateTime.day.toString() +
                                          ' ' +
                                          months[_dateTime.month - 1];
                                    });
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 25),
                          child: Text(
                              (DateFormat('EEEE, d MMM yyyy')
                                  .format(_dateTime)),
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  color: Colors.blue[100],
                                  fontWeight: FontWeight.bold))),
                      Container(
                          height: height - 270,
                          width: width - 30,
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: FutureBuilder(
                                  builder: (context, _getData) {
                                    return Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    diaryTitleData == null
                                                        ? ''
                                                        : diaryTitleData,
                                                    style: TextStyle(
                                                        fontSize: width * 0.1,
                                                        color: Colors.white)),
                                                Text(
                                                  '\n' + diaryData == null
                                                      ? ''
                                                      : diaryData,
                                                  style: TextStyle(
                                                      fontSize: width * 0.04,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                  future: _getData(),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 120, right: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: HexColor('#6e45e1'),
                              shape: CircleBorder(),
                              primary: HexColor('#89d4cf'),
                              padding: EdgeInsets.all(15)),
                          child: Container(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onPressed: () {
                            print(
                                diaryData + '********' + diaryTitleData + '*');
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 400),
                                    child: EditText(
                                      textFieldData:
                                          (diaryData == '') ? null : diaryData,
                                      textFieldTitleData: (diaryTitleData == '')
                                          ? null
                                          : diaryTitleData,
                                    )));
                          },
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> _getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  diaryData = prefs.getString(_date + "diary") ?? ' ';
  diaryTitleData = prefs.getString(_date + "diaryTitle") ?? ' ';
  return diaryData;
}

class EditText extends StatefulWidget {
  final String textFieldData;
  final String textFieldTitleData;

  const EditText({Key key, this.textFieldData, this.textFieldTitleData})
      : super(key: key);
  @override
  EditTextState createState() => EditTextState();
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final RoundedLoadingButtonController _btnController =
        new RoundedLoadingButtonController();
    //String data;
    bool _saved = false;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 25, right: 20),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height - height / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                            child:
                                Text("Write", style: TextStyle(fontSize: 30))),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Title",
                          style: TextStyle(fontSize: width * 0.07),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            _tempTitleData = value;
                          },
                          initialValue: widget.textFieldTitleData == ' '
                              ? null
                              : widget.textFieldTitleData,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a title to this story",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Story",
                          style: TextStyle(fontSize: width * 0.07),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            _tempData = value;
                          },
                          initialValue: widget.textFieldData == ' '
                              ? null
                              : widget.textFieldData,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write anything",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: (!_saved)
                          ? RaisedButton(
                              color: Colors.blue,
                              elevation: 0,
                              child: Container(
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              onPressed: () {
                                setState(() async {
                                  _saved = true;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(_date + "diary", _tempData);
                                  prefs.setString(
                                      _date + "diaryTitle", _tempTitleData);
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: NavBar(index: 1)));
                                });
                              },
                            )
                          : Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
