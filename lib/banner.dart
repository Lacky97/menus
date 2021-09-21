import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'model/qrs.dart';
import 'model/store.dart';
import 'utils/globals.dart' as globals;

// ignore: must_be_immutable
class MenuBanner extends StatefulWidget {
  MenuBanner(
      {Key? key,
      required this.store,
      required this.brightness,
      required this.qr})
      : super(key: key);

  final Store store;
  late Brightness brightness;
  final Qrs qr;

  @override
  _MenuBannerState createState() => _MenuBannerState();
}

class _MenuBannerState extends State<MenuBanner>
    with SingleTickerProviderStateMixin {
  bool delete = false;

  final TextEditingController textController = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
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
    widget.qr.delete();

    // launch a little snackbar
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.padding),
          child: GestureDetector(
            onLongPress: () => {
              controller.forward(from: 0.0),
              Menu.of(context)!.ciao(),
              setState(() {
                globals.enabled = !globals.enabled;
                globals.delete = !globals.delete;
              })
            },
            onTap: () => {!globals.delete ? _launch(widget.store.url) : null},
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
                                  : Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 5), // changes position of shadow
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
                        child: Image.network(widget.store.url,
                            width: 40.0, height: 40.0, fit: BoxFit.cover),
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
          )),
    );
  }
}
