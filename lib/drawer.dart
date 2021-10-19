import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:menus/constant/app_style.dart';
import 'package:menus/themebuilder.dart';
import 'package:url_launcher/url_launcher.dart';

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
    var height = MediaQuery.of(context).size.height;
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
                text: 'Cambia tema',
                icon: Icons.wb_sunny_outlined,
              ),
              SizedBox(height: height*0.6),
              buildFeedback(
                text: 'Dammi un consiglio!',
                icon: Icons.message_outlined,
              ),
              buildCopyright(
                text: 'Copyright',
                icon: Icons.copyright,
              ),
              buildNorme(
                text: 'Norme sulla privacy',
                icon: Icons.privacy_tip_outlined ,
              ),

              /*buildRemoveItem(
                text: 'Remove Elements',
                icon: Icons.remove,
              ),*/
            ],
          )),
    );
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

    Widget buildNorme({
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
          _launch('https://www.termsfeed.com/live/bd54490b-6d47-4fc2-81c2-5939446a4752'),
              Navigator.of(context).pop(),
            });
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

  Widget buildCopyright({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: () => {
              Navigator.of(context).pop(),
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        height: height * 0.6,
                        decoration: BoxDecoration(
                            color: widget.brightness == Brightness.dark
                                ? AppStyle.secondaryColorDark
                                : AppStyle.secondaryColorLight,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(width * .1,
                                height * .03, width * .1, height * .03),
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Librerie',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                    Text(
                                        'cupertino_icons \n qr_code_scanner \n url_launcher \n http \n hive \n hive_flutter \n favicon \n network_to_file_image \n flutter_staggered_animations \n animated_widgets \n motion_toast \n modals \n spring_button \n modal_bottom_sheet \n backdrop_modal_route \n emoji_alert \n rflutter_alert \n device_preview \n animations \n flutter_animated_dialog \n shared_preferences \n animated_splash_screen \n splashscreen \n select_form_field \n line_icons \n flutter_advanced_drawer \n build_runner \n hive_generator \n flutter_native_splash \n flutter_launcher_icons \n flutter_icons',
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: widget.brightness ==
                                                    Brightness.dark
                                                ? Colors.white70
                                                : Colors.black87)),
                                    SizedBox(height: 20),
                                    Text('Icone',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                    Text('Autore delle icone : Smashicons',
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: widget.brightness ==
                                                    Brightness.dark
                                                ? Colors.white70
                                                : Colors.black87)),
                                    SizedBox(height: 20),
                                    Text('Copyright © 2021 luca bonasera',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: widget.brightness ==
                                                    Brightness.dark
                                                ? Colors.white38
                                                : Colors.black38)),
                                  ]),
                            )),
                      ));
                },
                animationType: DialogTransitionType.slideFromBottom,
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 1),
              )
            });
  }

  Widget buildFeedback({
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
              _launch('https://1lbwruq8s34.typeform.com/to/ubU5ErwT'),
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
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                    systemNavigationBarColor:
                        widget.brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.1)
                            : Colors.black),
              ),
              ThemeBuilder.of(context)!.changeTheme(),
              Navigator.of(context).pop(),
            });
  }
}
