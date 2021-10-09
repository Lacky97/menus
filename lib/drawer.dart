import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/themebuilder.dart';

// ignore: must_be_immutable
class NavigatorDrawer extends StatefulWidget {
  NavigatorDrawer({Key? key, required this.brightness}) : super(key: key);

  late Brightness brightness;

  @override
  _NavigatorDrawerState createState() => _NavigatorDrawerState();
}

class _NavigatorDrawerState extends State<NavigatorDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
          color: widget.brightness == Brightness.dark
              ? AppStyle.thirdColorDark
              : AppStyle.thirdColorLight,
          child: ListView(
            padding: padding,
            children: <Widget>[
              const SizedBox(height: 50),
              buildMenuItem(
                text: 'People',
                icon: Icons.people,
              ),
              buildRemoveItem(
                text: 'Remove Elements',
                icon: Icons.remove,
              ),
            ],
          )),
    );
  }

  Widget buildRemoveItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: () => {
              Navigator.of(context).pop(),
            });
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: () => {

              print(widget.brightness.toString()),
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor: widget.brightness == Brightness.dark ?  Colors.black.withOpacity(0.1) : Colors.black
                ),
              ),
              ThemeBuilder.of(context)!.changeTheme(),
              Navigator.of(context).pop(),
            });
  }
}
