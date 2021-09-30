import 'package:flutter/material.dart';
import 'constant/app_style.dart';
import 'model/store.dart';

// ignore: must_be_immutable
class SecondPage extends StatefulWidget {
  SecondPage(
      {Key? key,
      required this.store,
      required this.brightness,
      required this.index})
      : super(key: key);
  Store store;
  final String index;
  late Brightness brightness;
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
              decoration: BoxDecoration(
                color: widget.brightness == Brightness.dark
                    ? AppStyle.thirdColorDark
                    : AppStyle.thirdColorLight,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: widget.brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Menus", style: TextStyle(color: Colors.white)))),
        ),
        body: Hero(
          tag: widget.index,
          child: Stack(children: [
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 100),
                child: Container(
                  height: height * 0.8,
                  decoration: BoxDecoration(
                      color: widget.brightness == Brightness.dark
                          ? AppStyle.secondaryColorDark
                          : AppStyle.secondaryColorLight,
                      boxShadow: [
                        BoxShadow(
                          color: widget.brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.8)
                              : Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 50,
              right: 0,
              child: Row(children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.brightness == Brightness.dark
                          ? AppStyle.secondaryColorDark
                          : AppStyle.secondaryColorLight,
                      width: 10,
                    ),
                    color: widget.brightness == Brightness.dark
                        ? AppStyle.secondaryColorDark
                        : AppStyle.secondaryColorLight,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Image.network(
                      widget.store.imageUrl,
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
              ]),
            ),
            Positioned(
              top: 65,
              left: 55,
              right: 0,
              child: Row(children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(height: 20),
                  Text(widget.store.name,
                      style: TextStyle(
                          color: AppStyle.primaryColor,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                          fontSize: 20,
                          fontWeight: FontWeight.w600))
                ])
              ]),
            ),
            /*Positioned(
                  top: 65,
                  left: 55,
                  right: 0,
                  child: Row(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(height: 20),
                      Text(widget.store.name,
                          style: TextStyle(
                              color: AppStyle.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))
                    ])
                  ]),
                ),*/
          ]),
        ),
      ),
    );
  }
}
