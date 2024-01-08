import 'dart:math';

import 'package:color_shooter_game/ColorGame.dart';
import 'package:color_shooter_game/Player.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class Mover extends PolygonComponent with HasGameRef<ColorGame> {
  Vector2 moverPosition;
  Vector2 velocity;
  Vector2 acceleration = Vector2.all(0);
  double wanderTheta = 0;
  double maxSpeed = 1;
  double moverScale = 1;
  double maxForce = 0.05;
  double radius = 200;
  double brakeRadius = 100;
  Player player;
  Color moverColor;
  bool follower;

  Mover({
    required this.moverPosition,
    required this.player,
    required this.velocity,
    this.moverColor = const Color.fromARGB(222, 246, 110, 6),
    this.follower = true,
  }) : super([
          Vector2(0, 25),
          Vector2(0, 0),
          Vector2(50, 12.5),
        ],
            paint: Paint()..color = moverColor,
            position: moverPosition,
            scale: Vector2.all(0.5),
            anchor: Anchor.bottomLeft);

  @override
  void onLoad() async {
    //applyForce(Vector2(0.1, 0));

    await add(PolygonComponent([
      Vector2(0, 25),
      Vector2(0, 0),
      Vector2(50, 12.5),
    ],
        paint: Paint()
          ..color = Color.fromARGB(255, 0, 0, 0)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
        anchor: Anchor.bottomLeft));
  }

  @override
  void update(double dt) {
    velocity += acceleration;
    velocity.clampLength(0, maxSpeed);
    position += velocity;
    acceleration = acceleration * 0;

    acceleration.clampLength(0, maxForce);
    angle = atan2(velocity.y, velocity.x);
    super.update(dt);
    if (position.y > 1000) {
      position.y = 0;
    } else if (position.y < 0) {
      position.y = 1000;
    }

    if (position.x > 2000) {
      position.x = 0;
    } else if (position.x < 0) {
      position.x = 2000;
    }
    if ((position - player.position).length < radius) {
      arrive(player.position, follower);
    } else {
      wander();
    }
  }

  void wander() {
    double wanderDistance = 140;
    double wanderRadius = 4;

    Vector2 future = position + velocity.normalized() * wanderDistance;

    double theta = wanderTheta + angle;

    double x = wanderRadius * cos(theta + angle);
    double y = wanderRadius * sin(theta + angle);

    Vector2 target = future + Vector2(x, y);
    Vector2 desired = target - position;

    desired.normalize();
    desired = desired * maxSpeed;
    Vector2 steer = desired - velocity;
    steer.clampLength(0, maxForce);

    applyForce(steer);
    wanderTheta += (Random().nextDouble()) - 0.5;
  }

  void seek(Vector2 target) {
    Vector2 desired = target - position;
    desired.normalize();
    desired = desired * maxSpeed;
    Vector2 steer = desired - velocity;
    steer.clampLength(0, maxForce);
    applyForce(steer);
  }

  void arrive(Vector2 target, bool follower) {
    Vector2 desired = target - position;
    double d = desired.length;
    desired.normalize();
    double follow = follower ? 1 : -1;
    if (d < brakeRadius) {
      double m = maxSpeed * d / brakeRadius;
      desired = desired * m * follow;
    } else {
      desired = desired * maxSpeed * follow;
    }
    Vector2 steer = desired - velocity;
    steer.clampLength(0, maxForce);
    applyForce(steer);
  }

  void applyForce(Vector2 force) {
    acceleration += force;
  }
}
