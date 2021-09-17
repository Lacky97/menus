
import 'package:flutter/material.dart';
import 'package:menus/constant/app_style.dart';

class NavigatorDrawer extends StatefulWidget {
  NavigatorDrawer({Key? key}) : super(key: key);

  @override
  _NavigatorDrawerState createState() => _NavigatorDrawerState();
}

class _NavigatorDrawerState extends State<NavigatorDrawer> {

  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: AppStyle.thirdColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 50),
            buildMenuItem(
              text: 'People',
              icon: Icons.people,
            ),
          ],
          )
      ),
    );
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
      onTap: () => {}
    );
  }

}