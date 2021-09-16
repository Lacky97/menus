import 'package:hive/hive.dart';

part 'qrs.g.dart';

@HiveType(typeId: 0)
class Qrs extends HiveObject{

  @HiveField(0)
  late String name;

//  @HiveField(1)
//  late String url;

//  @HiveField(2)
//  late String imageUrl;

}