import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/store.dart';

// ignore: must_be_immutable
class MenuBanner extends StatefulWidget {
  MenuBanner({Key? key, required this.store, required this.brightness}) : super(key: key);

  final Store store;
  late Brightness brightness;

  @override
  _MenuBannerState createState() => _MenuBannerState();
}

class _MenuBannerState extends State<MenuBanner> {

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.padding),
          child: GestureDetector(
            onTap: () => {_launch(widget.store.url)},
            child: Container(
              child: Stack(children: [
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color:  widget.brightness == Brightness.dark ? AppStyle.secondaryColorDark : AppStyle.secondaryColorLight,
                        boxShadow: [
                          BoxShadow(
                            color: widget.brightness == Brightness.dark ? Colors.black.withOpacity(0.8) : Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 5), // changes position of shadow
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
                            color:  widget.brightness == Brightness.dark ? AppStyle.secondaryColorDark : AppStyle.secondaryColorLight,
                            width: 10,
                          ),
                          color:  widget.brightness == Brightness.dark ? AppStyle.secondaryColorDark : AppStyle.secondaryColorLight,
                        ),
                        child: Image.network(widget.store.url,
                            width: 40.0, height: 40.0, fit: BoxFit.cover),),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ])
                  ]),
                ),
                Positioned(
                  top: 0,
                  left: 120,
                  right: 0,
                  child: Container(
                    
                  ),
                )
              ]),
            ),
          )),
    );
  }
}
