import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:menus/boxes.dart';
import 'package:menus/drawer.dart';
import 'package:menus/model/store.dart';
import 'package:menus/utils/qr_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'banner.dart';
import 'constant/app_style.dart';
import 'model/qrs.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      endDrawer: NavigatorDrawer(),
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
            decoration: BoxDecoration(
              color: AppStyle.thirdColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Menu's", style: TextStyle(color: Colors.white)))),
      ),
      body: ValueListenableBuilder<Box<Qrs>>(
          valueListenable: Boxes.getQrs().listenable(),
          builder: (context, box, _) {
            final qrs = box.values.toList().cast<Qrs>();

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 15,
                ),
                padding: EdgeInsets.all(8),
                itemCount: qrs.length,
                itemBuilder: (BuildContext context, int index) {
                  final qr = qrs[index];

                  return _buildCard(qr.name);
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
        },
        backgroundColor: AppStyle.thirdColor,
        tooltip: 'Add Element',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(name) {
    //var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;

    return MenuBanner(
        store: Store(name, 'https://it.m.wikipedia.org/favicon.ico'));
    /*Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            padding: EdgeInsets.all(25.0),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(5),
                child: Container(
                  width:20,
                  height:20,
                  child: Image.network('https://it.m.wikipedia.org/favicon.ico')
                )),
                Text(name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            )));
  }*/
  }
}
