import 'package:hive/hive.dart';

import 'model/qrs.dart';

class Boxes {
  static Box<Qrs> getQrs() => 
      Hive.box<Qrs>('qr2');
}