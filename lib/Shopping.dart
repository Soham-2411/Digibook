import 'package:digibook/Navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String newItem;

List<String> shoppingListItems = [''];
List<bool> shoppingListItemsBool = [];

class ShowShoppingList extends StatefulWidget {
  @override
  _ShowShoppingListState createState() => _ShowShoppingListState();
}

void _setData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('Shopping List', shoppingListItems);
}

Future<String> _getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  shoppingListItems = prefs.getStringList('Shopping List');
  if (shoppingListItems == null) {
    shoppingListItems = [''];
    return null;
  }
  for (int c = 0; c < shoppingListItems.length; c++) {
    shoppingListItemsBool.add(false);
  }
  return shoppingListItems[0];
}

void destroyData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('Shopping List', ['']);
}

class _ShowShoppingListState extends State<ShowShoppingList> {
  void initState() {
    super.initState();
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
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [HexColor('#fbd72b'), HexColor('#f9484a')])),
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
            child: Stack(
          children: [
            Container(
                height: height - 200,
                width: width - 30,
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Stack(
                      children: [
                        (shoppingListItems == null)
                            ? Container()
                            : Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text("Shopping List",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold)),
                                )),
                        Padding(
                          padding: EdgeInsets.only(top: 120, left: 20),
                          child: Container(
                            child: ListView.builder(
                              itemCount: shoppingListItems == null
                                  ? 0
                                  : shoppingListItems.length - 1,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Theme(
                                      child: Checkbox(
                                        focusColor: Colors.white,
                                        activeColor: Colors.yellow[900],
                                        value: shoppingListItemsBool[index + 1],
                                        onChanged: (value) {
                                          setState(() {
                                            shoppingListItemsBool[index + 1] =
                                                value;
                                          });
                                        },
                                      ),
                                      data: ThemeData(
                                        primarySwatch: Colors.blue,
                                        unselectedWidgetColor: Colors.black,
                                      )),
                                  title: Text(
                                    shoppingListItems[index + 1].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.06,
                                      decoration:
                                          (shoppingListItemsBool[index + 1] ==
                                                  true)
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  future: _getData(),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ButtonTheme(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.yellow[900],
                        shape: CircleBorder(),
                        primary: Colors.orange,
                        padding: EdgeInsets.all(15)),
                    onPressed: () async {
                      showAlertDialog(context);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 28.0, right: 5),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () async {
                        showAlertDialogDelete(
                            context,
                            "Are you sure you want to delete all the items?",
                            "Delete Shopping List",
                            Colors.amber);
                      })),
            ),
          ],
        )),
      )),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        setState(() {
          if (newItem != null && newItem != '') {
            shoppingListItems.add(newItem);
            shoppingListItemsBool.add(false);
            newItem = null;
          }
        });
        print(shoppingListItems);
        _setData();
        Navigator.pop(context);
      },
    );
    Widget textField = TextFormField(
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: Colors.black),
      onChanged: (value) {
        newItem = value;
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add an item", style: TextStyle(color: Colors.white)),
      content: textField,
      actions: [
        okButton,
      ],
      backgroundColor: Colors.yellow[800],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: true,
    );
  }
}

showAlertDialogDelete(
    BuildContext context, String message, String title, Color color) {
  // set up the button
  Widget yesButton = FlatButton(
    child: Text("Yes",
        style: TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      destroyData();
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: NavBar(
                index: 2,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 400)));
    },
  );
  Widget noButton = FlatButton(
    child: Text("No",
        style: TextStyle(
          color: Colors.white,
        )),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: color,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    title: Text(title,
        style: TextStyle(
          color: Colors.white,
        )),
    content: Text(message,
        style: TextStyle(
          color: Colors.white,
        )),
    actions: [noButton, yesButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
