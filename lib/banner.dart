import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';

import 'model/store.dart';

class MenuBanner extends StatefulWidget {
  MenuBanner({Key? key, required this.store}) : super(key: key);

  final Store store;

  @override
  _MenuBannerState createState() => _MenuBannerState();
}

class _MenuBannerState extends State<MenuBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.padding),
          child: Container(
            child: Stack(children: [
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: AppStyle.secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
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
                          color: AppStyle.secondaryColor,
                          width: 10,
                        ),
                        color: AppStyle.secondaryColor,
                      ),
                      child: Image.network(widget.store.url,
                          width: 50.0, height: 50.0, fit: BoxFit.cover)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text(widget.store.name,
                            style: TextStyle(
                                color: AppStyle.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600))
                      ])
                ]),
              )
            ]),
          )),
    );
  }
}
