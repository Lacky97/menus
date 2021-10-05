import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/menu.dart';
import 'package:menus/utils/containerWrapper.dart';
import 'package:menus/utils/inkWell.dart';
import 'package:menus/utils/singleTile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'model/qrs.dart';
import 'model/store.dart';
import 'utils/globals.dart' as globals;

const double _fabDimension = 56.0;

// ignore: must_be_immutable
class MenuBanner extends StatefulWidget {
  MenuBanner({
    Key? key,
    required this.openContainer,
    required this.store,
    required this.brightness,
    required this.qr,
    required this.index,
  }) : super(key: key);

  final VoidCallback openContainer;
  final Store store;
  late Brightness brightness;
  final Qrs qr;
  final String index;

  @override
  _MenuBannerState createState() => _MenuBannerState();
}

class _MenuBannerState extends State<MenuBanner> with TickerProviderStateMixin {
  bool delete = false;
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

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
              color: Color(0xFFDBEAFE),
              offset: Offset(-5, 5),
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

  void _showMarkedAsDoneSnackbar(bool? isMarkedAsDone) {
    if (isMarkedAsDone ?? false)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
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
            globals.delete ? _launch(widget.store.url) : widget.openContainer
          },
          child: InkWellOverlay(
            openContainer: widget.openContainer,
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
                              color: Color(0xFFDBEAFE),
                              offset: Offset(-5, 5),
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
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFDBEAFE),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(-0, 0),
                              ),
                            ],
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(capitalize(widget.store.name),
                                style: TextStyle(
                                    color: AppStyle.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700))
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

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({this.includeMarkAsDoneButton = true});

  final bool includeMarkAsDoneButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details page'),
        actions: <Widget>[
          if (includeMarkAsDoneButton)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => Navigator.pop(context, true),
              tooltip: 'Mark as done',
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(70.0),
              child: Image.asset(
                'assets/placeholder_image.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black54,
                        fontSize: 30.0,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'ciao',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 16.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

























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

