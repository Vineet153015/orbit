import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;

  //1: small, 2: Medium, 3:Large
  late int priority;

  late bool isCompleted;

  late DateTime createdAt;
}
