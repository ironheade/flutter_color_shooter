import 'dart:math';
import 'dart:ui';

import 'package:color_shooter_game/enums_and_constants/directions.dart';
import 'package:color_shooter_game/helpers/functions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class Player extends PolygonComponent {
  double playerAngle = 0;
  final effect = GlowEffect(
    10.0,
    EffectController(duration: 3),
  );
  Player()
      : super([
          Vector2(0, 100),
          Vector2(50, 100),
          Vector2(25, 0),
        ],
            paint: Paint()
              ..color = Color.fromARGB(222, 255, 255, 0)
              ..style = PaintingStyle.fill,
            anchor: Anchor.center);

  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);

  @override
  void onLoad() async {
    //await add(effect);
    await add(PolygonComponent([
      Vector2(0, 100),
      Vector2(50, 100),
      Vector2(25, 0),
    ],
        paint: Paint()
          ..color = Color.fromARGB(250, 1, 0, 0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4));
    super.onLoad();
  }

  @override
  void update(double dt) {
    updatePosition(dt);
    super.update(dt);
  }

  updatePosition(double dt) {
    if (direction.leftX != 0 || direction.leftY != 0) {
      angle = atan2(direction.leftY, direction.leftX) + pi / 2;

      position = position + Vector2(direction.leftX, direction.leftY) * 4;
    }
  }
}
