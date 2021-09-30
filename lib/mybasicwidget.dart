import 'package:flutter/material.dart';
import 'package:menus/menu.dart';
import 'package:menus/themebuilder.dart';

import 'constant/app_style.dart';

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
        defaultBrightness: Brightness.dark,
        builder: (context, _brightness) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: AppStyle.primaryColor, brightness: _brightness),
            title: 'Flutter Demo',
            home: Menu(brightness: _brightness),
          );
        });
  }
}
