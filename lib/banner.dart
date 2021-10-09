import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/menu.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:spring_button/spring_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'model/qrs.dart';
import 'model/store.dart';
import 'utils/globals.dart' as globals;

// ignore: must_be_immutable
class MenuBanner extends StatefulWidget {
  MenuBanner({
    Key? key,
    required this.store,
    required this.brightness,
    required this.qr,
    required this.index,
  }) : super(key: key);

  final Store store;
  late Brightness brightness;
  final Qrs qr;
  final String index;

  @override
  _MenuBannerState createState() => _MenuBannerState();
}

class _MenuBannerState extends State<MenuBanner> with TickerProviderStateMixin {
  bool delete = false;

  final TextEditingController textController = TextEditingController();
  late AnimationController controller;
  var txt = TextEditingController();

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    txt.text = capitalize(widget.store.name);
    super.initState();
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String capitalize(name) {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  void deleteQr() {
    String name = widget.qr.name;
    widget.qr.delete();
    Menu.of(context)!.displayDeleteMotionToast(context, name);
    // launch a little snackbar
  }

  Widget row(String text, Color color, width) {
    return Padding(
      padding: EdgeInsets.all(12.5),
      child: Material(
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
        elevation: 10,
        child: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String maxThirteen(String myString) {
    if (myString.length > 13) {
      myString = myString.substring(0, 10) + '...';
    }
    return myString;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.padding),
          child: GestureDetector(
            onLongPress: () => {
              controller.forward(from: 0.0),
              Menu.of(context)!.notShow(),
              setState(() {
                globals.enabled = !globals.enabled;
                globals.delete = !globals.delete;
              })
            },
            onTap: () => {
              globals.delete
                  ? _launch(widget.store.url)
                  : showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            content: Container(
                              height: height * 0.43,
                              decoration: BoxDecoration(
                                  color: widget.brightness == Brightness.dark
                                      ? AppStyle.secondaryColorDark
                                      : AppStyle.secondaryColorLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(width * .1,
                                      height * .05, width * .1, height * .05),
                                  child: Column(children: [
                                    Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            widget.store.imageUrl,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                        width: width * .4,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: widget.brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                          controller: txt,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(3.0),
                                            isDense: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: widget.brightness ==
                                                          Brightness.dark
                                                      ? Colors.white70
                                                      : Colors.black87),
                                            ),
                                          ),
                                        )),
                                    SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SpringButton(
                                              SpringButtonType.OnlyScale,
                                              row("Cancel", Color(0xffDC2626),
                                                  width * 0.24),
                                              onTap: () =>
                                                  {Navigator.pop(context)}),
                                          SpringButton(
                                            SpringButtonType.OnlyScale,
                                            row("Save", Color(0xff059669),
                                                width * 0.24),
                                            onTap: () => {
                                              print(txt.text),
                                              widget.qr.name = txt.text,
                                              widget.qr.save(),
                                              Navigator.pop(context),
                                            },
                                          ),
                                        ])
                                  ])),
                            ));
                      },
                      animationType: DialogTransitionType.slideFromBottom,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 1),
                    )
            },
            child: ShakeAnimatedWidget(
              enabled: globals.enabled,
              duration: Duration(milliseconds: 300),
              shakeAngle: Rotation.deg(z: 2),
              curve: Curves.linear,
              child: Stack(children: [
                Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: widget.brightness == Brightness.dark
                                ? AppStyle.secondaryColorDark
                                : AppStyle.secondaryColorLight,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )),
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            widget.store.imageUrl,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                          ),
                        ),
                      ]),
                ),
                Positioned(
                    top: 95,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(capitalize(maxThirteen(widget.store.name)),
                                    style: TextStyle(
                                        color:
                                            widget.brightness == Brightness.dark
                                                ? AppStyle.textColorDark
                                                : AppStyle.textColorLight,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700))
                              ])
                        ])),
                Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text('Resturant/Bar',
                                    style: TextStyle(
                                        color:
                                            widget.brightness == Brightness.dark
                                                ? AppStyle.textAuxColorDark
                                                : AppStyle.textAuxColorLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ])
                        ])),
                globals.delete
                    ? Positioned(
                        top: 0,
                        left: 110,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => {
                            deleteQr(),
                          },
                          child: Transform.rotate(
                              angle: -math.pi / 4,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                radius: 15,
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 10,
                                  child: Icon(Icons.add),
                                ),
                              )),
                        ),
                      )
                    : SizedBox(),
              ]),
            ),
          )),
    );
  }
}


/* 


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.padding),
          child: GestureDetector(
            onLongPress: () => {
              controller.forward(from: 0.0),
              Menu.of(context)!.notShow(),
              setState(() {
                globals.enabled = !globals.enabled;
                globals.delete = !globals.delete;
              })
            },
            onTap: () => {
              globals.delete
                  ? _launch(widget.store.url)
                  : showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            content: Container(
                              height: height * 0.4,
                              decoration: BoxDecoration(
                                  color: widget.brightness == Brightness.dark
                                      ? AppStyle.secondaryColorDark
                                      : AppStyle.secondaryColorLight,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(width * .1,
                                      height * .05, width * .1, height * .05),
                                  child: Column(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        child: Image.network(
                                          widget.store.imageUrl,
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                        width: width * .7,
                                        child: TextField(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                          controller: txt,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(3.0),
                                            isDense: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                    SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SpringButton(
                                              SpringButtonType.OnlyScale,
                                              row("Cancel", Colors.red.shade400,
                                                  width * 0.24),
                                              onTap: () =>
                                                  {Navigator.pop(context)}),
                                          SpringButton(
                                            SpringButtonType.OnlyScale,
                                            row("Save", Colors.green.shade400,
                                                width * 0.24),
                                            onTap: () => {
                                              print(txt.text),
                                              widget.qr.name = txt.text,
                                              widget.qr.save(),
                                              Navigator.pop(context),
                                            },
                                          ),
                                        ])
                                  ])),
                            ));
                      },
                      animationType: DialogTransitionType.slideFromBottom,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 1),
                    )
            },
            child: ShakeAnimatedWidget(
              enabled: globals.enabled,
              duration: Duration(milliseconds: 300),
              shakeAngle: Rotation.deg(z: 2),
              curve: Curves.linear,
              child: Stack(children: [
                Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 10,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: widget.brightness == Brightness.dark
                                ? AppStyle.secondaryColorDark
                                : AppStyle.secondaryColorLight,
                            
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    )),
                Positioned(
                  top: 25,
                  left: 15,
                  right: 0,
                  child: Row(children: [
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      
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
                    top: 80,
                    left: 15,
                    right: 0,
                    child: Row(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(capitalize(widget.store.name),
                                style: TextStyle(
                                    color: AppStyle.textColorLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700))
                          ])
                    ])),
                globals.delete
                    ? Positioned(
                        top: 0,
                        left: 140,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => {
                            deleteQr(),
                          },
                          child: Container(
                            height: 30,
                            child: Transform.rotate(
                                angle: -math.pi / 4,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  radius: 30,
                                  child: Icon(Icons.add),
                                )),
                          ),
                        ),
                      )
                    : SizedBox(),
              ]),
            ),
          )),
    );
  }

*/

// for animation container with animation when color change use:
// AnimatedContainer(duration: Duration(seconds: 1),

/* showFloatingModalBottomSheet(
                              context: context,
                    builder: (BuildContext context) => SingleChildScrollView(
                            child: Container(
                          height: height * 0.55,
                          decoration: BoxDecoration(
                              color: widget.brightness == Brightness.dark
                                  ? AppStyle.secondaryColorDark
                                  : AppStyle.secondaryColorLight,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              )),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(width * .15,
                                  height * .05, width * .15, height * .05),
                              child: Column(children: [
                                Align(
                                  alignment: Alignment.centerLeft,
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
                                      width: 60.0,
                                      height: 60.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                    width: width * .7,
                                    child: TextField(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      controller: txt,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(3.0),
                                        isDense: true,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 20),
                                SpringButton(
                                  SpringButtonType.OnlyScale,
                                  row(
                                    "Save",
                                    Colors.green.shade400,
                                  ),
                                  onTap: () => {
                                    print(txt.text),
                                    widget.qr.name = txt.text,
                                    widget.qr.save(),
                                    Navigator.pop(context),
                                    },
                                ),
                                SpringButton(
                                  SpringButtonType.OnlyScale,
                                  row(
                                    "Cancel",
                                    Colors.red.shade400,
                                  ),
                                  onTap: () => {Navigator.pop(context)}
                                ),
                              ]) //widget.store.name,

                              ),
                        ))) */

/*  Alert(
      alertAnimation: ,
        style: AlertStyle(
          backgroundColor: widget.brightness == Brightness.dark
              ? AppStyle.secondaryColorDark
              : AppStyle.secondaryColorLight,
          overlayColor: Colors.black54,
          isCloseButton: false,
          isOverlayTapDismiss: true,
          titleStyle: TextStyle(
              shadows: [
                Shadow(
                  color: Color(0xFFDBEAFE),
                  offset: Offset(-5, 5),
                  blurRadius: 8.0,
                ),
              ],
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          animationDuration: Duration(milliseconds: 400),
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            alertAlignment: Alignment.center,
          ),
          context: context,
          content: 
          buttons: [
            DialogButton(
              splashColor: Colors.red.shade400,
              child: Text(
                "Cancel",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        color: Color(0xFFDBEAFE),
                        offset: Offset(-5, 5),
                        blurRadius: 8.0,
                      ),
                    ],
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
              color: Color.fromRGBO(239, 83, 80, 1),
            ),
            DialogButton(
              child: Text(
                "Save",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        color: Color(0xFFDBEAFE),
                        offset: Offset(-5, 5),
                        blurRadius: 8.0,
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              widget.qr.name = txt.text;
              widget.qr.save();
              Navigator.pop(context);
            },
            width: 120,
            color: Color.fromRGBO(102, 187, 106, 1),
          )
        ],
      ).show()*/

