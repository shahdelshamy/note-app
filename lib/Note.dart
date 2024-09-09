
import 'package:hive_flutter/hive_flutter.dart';
part 'Note.g.dart';

@HiveType(typeId: 0)
class Note{

  @HiveField(0)
  String containt;

  @HiveField(1)
  String date;

  Note({required this.containt,required this.date});

  @override
  String toString() {
    return 'Note{containt: $containt, date: $date}';
  }


}