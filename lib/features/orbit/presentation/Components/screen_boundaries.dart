import 'package:flame/image_composition.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class ScreenBoundaries extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.static);

    final body = world.createBody(bodyDef);

    final rect = game.camera.visibleWorldRect;

    // final visibleRect = game.camera.visibleWorldRect;

    final topLeft = rect.topLeft.toVector2();
    final topRight = rect.topRight.toVector2();
    final bottomRight = rect.bottomRight.toVector2();
    final bottomLeft = rect.bottomLeft.toVector2();

    void addWall(Vector2 start, Vector2 end) {
      final shape = EdgeShape()..set(start, end);
      body.createFixture(FixtureDef(shape, restitution: 0.8));
    }

    addWall(topLeft, topRight);
    addWall(topRight, bottomRight);
    addWall(bottomRight, bottomLeft);
    addWall(bottomLeft, topLeft);

    // final chain = [topLeft, topRight, bottomLeft, bottomRight];

    // for (int i = 0; i < chain.length; i++) {
    //   final start = chain[i];
    //   final end = chain[(i + 1) % chain.length];

    //   final shape = EdgeShape()..set(start, end);
    //   body.createFixture(FixtureDef(shape, restitution: 0.8));
    // }
    return body;
  }
}
