import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:menus/mybasicwidget.dart';
import 'model/qrs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrsAdapter());
  await Hive.openBox<Qrs>('qr4');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.light, // don't use this
      systemNavigationBarColor: Colors.black.withOpacity(0.1),
    ),
  );
  runApp(HomePage());
  //runApp(DevicePreview(builder: (context) => HomePage(), enabled: !kReleaseMode,));
}
