import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:menus/mybasicwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/qrs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrsAdapter());
  await Hive.openBox<Qrs>('qr12');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();
  final color = prefs.getInt("Theme3");

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.light, // don't use this
      systemNavigationBarColor: color == 1 ? Colors.black :  Colors.black.withOpacity(0.1),
    ),
  );
  runApp(HomePage());
  //runApp(DevicePreview(builder: (context) => HomePage(), enabled: !kReleaseMode,));
}
