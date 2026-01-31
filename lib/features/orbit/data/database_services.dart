import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'task_model.dart';

class DatabaseServices {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([TaskSchema], directory: dir.path);
  }

  Future<void> addTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<List<Task>> getAllTasks() async {
    return await isar.tasks.where().findAll();
  }
}
