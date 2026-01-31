import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../../data/task_model.dart';

class TaskBubble extends BodyComponent with TapCallbacks, DoubleTapCallbacks {
  final Task task;
  final Vector2 startPosition;

  final Function(Task) onOpened;

  TaskBubble({
    required this.task,
    required this.startPosition,
    required this.onOpened,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: startPosition,
      type: BodyType.dynamic,
      userData: this,
      linearDamping: 1.5,
      allowSleep: false,
    );

    final body = world.createBody(bodyDef);
    final radius = task.priority * 2.0;
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.7,
      density: 1.0,
      // friction: 0.1,
    );
    body.createFixture(fixtureDef);

    final randomForce = Vector2(
      Random().nextDouble() - 0.5 * 20,
      Random().nextDouble() - 0.5 * 20,
    );
    body.applyLinearImpulse(randomForce);
    return body;
  }

  @override
  void render(Canvas canvas) {
    final radius = task.priority * 2.0;
    final paint = Paint()
      ..color = _getPriorityColor(task.priority).withOpacity(0.3);
    canvas.drawCircle(Offset.zero, radius, paint);

    final borderPaint = Paint()
      ..color = _getPriorityColor(task.priority)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.1;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    final textConfig = TextPaint(
      style: TextStyle(
        color: Colors.white,
        fontSize: radius * 0.8,
        fontWeight: FontWeight.bold,
      ),
    );

    String label = "P${task.priority}";
    if (task.priority == 3) label = "!!!";

    textConfig.render(canvas, label, Vector2(0, 0), anchor: Anchor.center);
  }

  Color _getPriorityColor(int priority) {
    if (priority == 3) return Colors.redAccent;
    if (priority == 2) return Colors.orangeAccent;
    return Colors.blueAccent;
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    print("Bubble double tapped: ${task.title}");
    onOpened(task);
  }
}
