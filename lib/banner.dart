import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/menu.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:spring_button/spring_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'model/qrs.dart';
import 'model/store.dart';
import 'package:select_form_field/select_form_field.dart';
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
  var type = TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Sushi',
      'label': 'Sushi',
      'icon': Image(
          image: AssetImage('assets/icons/sushi.png'), height: 30, width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'FastFood',
      'label': 'FastFood',
      'icon': Image(
          image: AssetImage('assets/icons/hamburguer.png'),
          height: 30,
          width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Bar',
      'label': 'Bar',
      'icon': Image(
          image: AssetImage('assets/icons/pancakes.png'),
          height: 30,
          width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Pub',
      'label': 'Pub',
      'icon': Image(
          image: AssetImage('assets/icons/pint.png'), height: 30, width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Gelateria',
      'label': 'Gelateria',
      'icon': Image(
          image: AssetImage('assets/icons/ice-cream.png'),
          height: 30,
          width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Pizzeria',
      'label': 'Pizzeria',
      'icon': Image(
          image: AssetImage('assets/icons/pizza.png'), height: 30, width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Steakhouse',
      'label': 'Steakhouse',
      'icon': Image(
          image: AssetImage('assets/icons/steak.png'), height: 30, width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
    {
      'value': 'Other',
      'label': 'Other',
      'icon': Image(
          image: AssetImage('assets/icons/menus.png'), height: 30, width: 30),
      'textStyle': TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    },
  ];

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    txt.text = capitalize(widget.store.name);
    txt.selection =
        TextSelection.fromPosition(TextPosition(offset: txt.text.length));
    type.text = widget.qr.category;
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
    if (myString.length > 14) {
      myString = myString.substring(0, 11) + '...';
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
              !globals.delete
                  ? _launch(widget.store.url)
                  : showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            content: Container(
                              height: height * 0.51,
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
                                              BorderRadius.circular(10),
                                          color: widget.store.imageUrl == ''
                                              ? Color(int.parse(
                                                  widget.qr.randomColor))
                                              : Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: widget.store.imageUrl == ''
                                              ? Image(
                                                  image: AssetImage(
                                                      'assets/logo/logo.png'),
                                                  height: 80,
                                                  width: 80)
                                              : Image.network(
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
                                        width: width * .545,
                                        child: TextField(
                                          onTap: () => {
                                            txt.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            txt.text.length)),
                                          },
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
                                              contentPadding:
                                                  EdgeInsets.all(3.0),
                                              isDense: true,
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: widget.brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ))),
                                        )),
                                    SizedBox(height: 20),
                                    Container(
                                        width: width * .545,
                                        child: SelectFormField(
                                          brightness: widget.brightness,
                                          controller: type,
                                          scrollPhysics:
                                              const BouncingScrollPhysics(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: widget.brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                          type: SelectFormFieldType.dropdown,
                                          items: _items,
                                          onChanged: (val) => {type.text = val},
                                          onSaved: (val) => print(val),
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
                                              widget.qr.name = txt.text,
                                              widget.qr.category = type.text,
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
                        height: height * 0.15,
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
                              color: widget.store.imageUrl == ''
                                  ? Color(int.parse(widget.qr.randomColor))
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: widget.store.imageUrl == ''
                                  ? Image(
                                      image: AssetImage('assets/logo/logo.png'),
                                      height: height * 0.07,
                                      width: height * 0.07)
                                  : Image.network(
                                      widget.store.imageUrl,
                                      height: height * 0.055,
                                      width: height * 0.055,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Positioned(
                    top: height * 0.105,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                    top: height * 0.135,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(widget.qr.category,
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
