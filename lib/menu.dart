import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:menus/boxes.dart';
import 'package:menus/drawer.dart';
import 'package:menus/model/store.dart';
import 'package:menus/utils/containerWrapper.dart';
import 'package:menus/utils/qr_scanner.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'banner.dart';
import 'constant/app_style.dart';
import 'model/qrs.dart';

import 'package:motion_toast/motion_toast.dart';

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  Menu({Key? key, required this.brightness}) : super(key: key);

  late Brightness brightness;

  @override
  _MenuState createState() => _MenuState();
  static _MenuState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MenuState>();
  }
}

class _MenuState extends State<Menu> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool toShow = false;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  displayDeleteMotionToast(BuildContext context, String name) {
    MotionToast.warning(
      title: "Elemento eliminato",
      titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      description: "Hai eleminato l'elemento " + name,
      animationType: ANIMATION.FROM_BOTTOM,
      position: MOTION_TOAST_POSITION.BOTTOM,
    ).show(context);
  }

  notShow() {
    setState(() {
      toShow = !toShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavigatorDrawer(brightness: widget.brightness),
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
                  color: Color(0xFFDBEAFE),
                  offset: Offset(-5, 3),
                ),
              ],
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Menus", style: TextStyle(color: Colors.white)))),
      ),
      body: ValueListenableBuilder<Box<Qrs>>(
          valueListenable: Boxes.getQrs().listenable(),
          builder: (context, box, _) {
            final qrs = box.values.toList().cast<Qrs>();

            return AnimationLimiter(
              child: qrs.length == 0
                  ? Image.asset(
                      'assets/click/Clicca_per_aggiungere_' +
                          (widget.brightness == Brightness.dark
                              ? 'dark'
                              : 'light') +
                          '.png',
                      height: 900.0,
                      width: 900.0,
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 15,
                      ),
                      padding: EdgeInsets.all(8),
                      itemCount: qrs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final qr = qrs[index];
                        // ignore: unnecessary_statements
                        toShow ? print('ciao da menu') : null;
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 1500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: Hero(
                                      tag: 'bhoo' + index.toString(),
                                      child: _buildCard(
                                          qr, 'bhoo' + index.toString())))),
                        );
                      },
                    ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QRScanner(boxes: Boxes.getQrs())),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: widget.brightness == Brightness.dark
            ? AppStyle.thirdColorDark
            : AppStyle.thirdColorLight,
        tooltip: 'Add Element',
        child: Icon(Icons.add),
      ),
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  void _showMarkedAsDoneSnackbar(bool? isMarkedAsDone) {
    if (isMarkedAsDone ?? false)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
  }

  Widget _buildCard(qr, index) {
    return OpenContainerWrapper(
      transitionType: _transitionType,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return MenuBanner(
            openContainer: openContainer,
            store: Store(qr.name, qr.url, qr.imageUrl),
            brightness: widget.brightness,
            qr: qr,
            index: index);
      },
      onClosed: _showMarkedAsDoneSnackbar,
    );
  }
}
