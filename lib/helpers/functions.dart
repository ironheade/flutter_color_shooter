import 'dart:math';

import 'package:color_shooter_game/enums_and_constants/directions.dart';
import 'package:flame/components.dart';

double getPlayerAngle(Direction direction) {
  double calculatedAngleLeft = atan(direction.leftY / direction.leftX);
  double calculatedAngleRight = atan(direction.rightY / direction.rightX);
  double angle = 0;
  if (Vector2(direction.rightX, direction.rightY).length != 0) {
    if (direction.rightX < 0) {
      angle = calculatedAngleRight + pi;
    } else if (direction.rightX > 0) {
      angle = calculatedAngleRight;
    }
  } else {
    if (direction.leftX < 0) {
      angle = calculatedAngleLeft + pi;
    } else if (direction.leftX > 0) {
      angle = calculatedAngleLeft;
    }
  }
  return angle;
}
