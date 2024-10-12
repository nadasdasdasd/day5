import 'package:hive/hive.dart';

part 'todolist.g.dart';

@HiveType(typeId: 0)
class Todolist extends HiveObject {
  @HiveField(0)
  final String task;

  Todolist({required this.task});
}
