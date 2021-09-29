import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/menu.dart';
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

  Widget row(String text, Color color) {
    return Padding(
      padding: EdgeInsets.all(12.5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : Colors.black.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
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
    );
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
                : EmojiAlert(
                    background: widget.brightness == Brightness.dark
                        ? AppStyle.secondaryColorDark
                        : AppStyle.secondaryColorLight,
                    alertTitle: Text("Angry Alert",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    description: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: widget.brightness == Brightness.dark
                                      ? Colors.black.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.8),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      -5, 3), // changes position of shadow
                                ),
                              ],
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              controller: txt,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(3.0),
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                    enableMainButton: true,
                    enableSecondaryButton: true,
                    mainButtonColor: Colors.red,
                    onMainButtonPressed: () {
                      widget.qr.name = txt.text;
                      widget.qr.save();
                      Navigator.pop(context);
                    },
                    onSecondaryButtonPressed: () {
                      Navigator.pop(context);
                    },
                    cancelable: true,
                    emojiType: EMOJI_TYPE.JOYFUL,
                    height: height * .55,
                  ).displayAlert(context)
          },
          child: ShakeAnimatedWidget(
            enabled: globals.enabled,
            duration: Duration(milliseconds: 300),
            shakeAngle: Rotation.deg(z: 2),
            curve: Curves.linear,
            child: Container(
              child: Stack(children: [
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: widget.brightness == Brightness.dark
                            ? AppStyle.secondaryColorDark
                            : AppStyle.secondaryColorLight,
                        boxShadow: [
                          BoxShadow(
                            color: widget.brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : Colors.black.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(-5, 5), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  right: 0,
                  child: Row(children: [
                    Container(
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
                  left: 25,
                  right: 0,
                  child: Row(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(height: 20),
                      Text(capitalize(widget.store.name),
                          style: TextStyle(
                              color: AppStyle.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))
                    ])
                  ]),
                ),
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
          ),
        ),
      ),
    );
  }
}


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