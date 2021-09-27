import 'package:flutter/material.dart';

import 'constant/app_style.dart';
import 'model/store.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key? key, required this.store, required this.brightness})
      : super(key: key);
  Store store;
  late Brightness brightness;
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: AppStyle.thirdColorLight,
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
                  child:
                      Text("Menu's", style: TextStyle(color: Colors.white)))),
        ),
        body: Container(
            decoration: BoxDecoration(color: Colors.blue),
            child: Hero(
              tag: 'myimage',
              child: Image.network(
                widget.store.imageUrl,
                width: 40.0,
                height: 40.0,
              ),
            )),
      ),
    );
  }
}
