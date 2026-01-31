import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:orbit/features/orbit/data/task_model.dart';
import 'package:orbit/features/orbit/presentation/Components/screen_boundaries.dart';
import 'package:orbit/features/orbit/presentation/Components/task_bubble.dart';
import '../../../main.dart';
import 'dart:math';

class OrbitGame extends Forge2DGame with TapCallbacks, DoubleTapCallbacks {
  @override
  bool get debugMode => false;

  final Function(Task) onTaskOpened;

  OrbitGame({required this.onTaskOpened}) : super(gravity: Vector2(0, 0));

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    final tapPosition = screenToWorld(event.localPosition);

    for (final child in world.children) {
      if (child is TaskBubble) {
        final vectorToBubble = child.body.position - tapPosition;
        final distance = vectorToBubble.length;
        double power = 300.0 / (distance + 1);

        if (distance < (child.task.priority * 2.0)) {
          power *= 2;
        }
        final direction = vectorToBubble.normalized();
        // final direction = child.body.position - tapPosition;
        // direction.normalize();
        // final force = direction * 150.0;
        child.body.applyLinearImpulse(direction * power);
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // camera.viewfinder.zoom = 40;
    // camera.viewfinder.anchor = Anchor.center;

    final tasks = await dbService.getAllTasks();
    await world.add(ScreenBoundaries());

    if (tasks.isEmpty) {
      await _seedInitialTasks();
    } else {
      for (var task in tasks) {
        _spawnBubble(task);
      }
    }
  }

  Future<void> _seedInitialTasks() async {
    final initialTasks = [
      Task()
        ..title = "Build Orbit"
        ..priority = 3
        ..isCompleted = false
        ..createdAt = DateTime.now(),
      Task()
        ..title = "Master Flutter"
        ..priority = 2
        ..isCompleted = false
        ..createdAt = DateTime.now(),
      Task()
        ..title = "Push to Play Store"
        ..priority = 1
        ..isCompleted = false
        ..createdAt = DateTime.now(),
    ];

    for (var task in initialTasks) {
      await dbService.addTask(task);
      _spawnBubble(task);
    }
  }

  void _spawnBubble(Task task) {
    world.add(
      TaskBubble(
        task: task,
        startPosition: Vector2.random(),
        onOpened: onTaskOpened,
      ),
    );
    print("Game recived request");
  }

  void spawnNewTask(Task task) {
    _spawnBubble(task);
  }
}
