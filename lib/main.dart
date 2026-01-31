import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbit/features/orbit/data/database_services.dart';
import 'package:orbit/features/orbit/data/task_model.dart';
import 'features/orbit/presentation/orbit_game.dart';

final dbService = DatabaseServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dbService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const OrbitScreen(),
    );
  }
}

class OrbitScreen extends StatefulWidget {
  const OrbitScreen({super.key});

  @override
  State<OrbitScreen> createState() => _OrbitScreenState();
}

class _OrbitScreenState extends State<OrbitScreen> {
  late final OrbitGame _game;

  @override
  void initState() {
    _game = OrbitGame(
      onTaskOpened: (task) {
        _showTaskDetails(task);
      },
    );
  }

  void _showTaskDetails(dynamic task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(task.title, style: const TextStyle(color: Colors.white)),
        content: Text(
          "Priority: ${task.priority}\nCreated: ${task.createdAt.toString().substring(0, 10)}",
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _addNewTak() async {
    String title = "";
    int priority = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create New Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      onChanged: (val) => title = val,
                      decoration: const InputDecoration(
                        labelText: "Task Title",
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<int>(
                      value: priority,
                      dropdownColor: const Color(0xFF2C2C2E),
                      style: const TextStyle(color: Colors.white),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Low Priority (P1)"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Medium Priority (P2)"),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text("High Priority (P3)"),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => priority = val);
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (title.isNotEmpty) {
                          final newTask = Task()
                            ..title = title
                            ..priority = priority
                            ..isCompleted = false
                            ..createdAt = DateTime.now();

                          await dbService.addTask(newTask);

                          _game.spawnNewTask(newTask);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Add Task"),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: _game),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTak,
        child: const Icon(Icons.add),
      ),
    );
  }
}
