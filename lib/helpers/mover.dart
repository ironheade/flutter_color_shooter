import 'dart:math';

import 'package:color_shooter_game/ColorGame.dart';
import 'package:color_shooter_game/Player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class Mover extends PolygonComponent
    with HasGameRef<ColorGame>, CollisionCallbacks {
  Vector2 moverPosition;
  Vector2 velocity;
  Vector2 acceleration = Vector2.all(0);
  double wanderTheta = 0;
  double maxSpeed;
  double moverScale = 1;
  double maxForce = 0.05;
  double radius = 100;
  double brakeRadius = 10;
  double detectionRadius = 60;
  double fieldOfVision = 120;
  Player player;
  Color moverColor;
  bool follower;
  late List<Mover> otherMover;
  List<Mover> moverInView = [];

  Mover({
    required this.moverPosition,
    required this.player,
    required this.velocity,
    required this.otherMover,
    this.moverColor = const Color.fromARGB(222, 246, 110, 6),
    this.follower = true,
    this.maxSpeed = 2,
  }) : super([
          Vector2(0, 25),
          Vector2(0, 0),
          Vector2(50, 12.5),
        ],
            paint: Paint()..color = moverColor,
            position: moverPosition,
            scale: Vector2.all(0.5),
            anchor: Anchor.topLeft);

  @override
  void onLoad() async {
    //applyForce(Vector2(0.1, 0));
    add(CircleHitbox(
        radius: detectionRadius, anchor: Anchor.center, isSolid: true));

    await add(PolygonComponent([
      Vector2(0, 25),
      Vector2(0, 0),
      Vector2(50, 12.5),
    ],
        paint: Paint()
          ..color = Color.fromARGB(255, 0, 0, 0)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
        anchor: Anchor.center));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    moverInView.add(
        otherMover.firstWhere((element) => element.hashCode == other.hashCode));

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    moverInView.removeWhere((element) => element.hashCode == other.hashCode);

    super.onCollisionEnd(other);
  }

  void align() {
    var sum = Vector2.all(0);
    var sumPosition = Vector2.all(0);
    var count = 0;
    if (moverInView.isNotEmpty) {
      for (var mover in moverInView) {
        if (position.distanceTo(mover.position) < detectionRadius / 1.5 &&
            (angleTo(mover.velocity) * 180 / pi).abs() < fieldOfVision) {
          sum.add(mover.velocity);

          count += 1;
        } else {
          sum.add(Vector2.all(0));
          count += 1;
        }
      }
      sum = sum / count.toDouble();
      sumPosition = sumPosition / count.toDouble();

      applyForce(sum);
    }
  }

  void separation() {
    for (var mover in otherMover) {
      if (position.distanceTo(mover.position) < detectionRadius / 1.5) {
        avoid(mover.position);
      }
    }
  }

  void cohesion() {
    var sum = Vector2.all(0);
    var sumPosition = Vector2.all(0);
    var count = 0;
    if (moverInView.isNotEmpty) {
      for (var mover in moverInView) {
        if (position.distanceTo(mover.position) < detectionRadius &&
            (angleTo(mover.velocity) * 180 / pi).abs() < fieldOfVision) {
          sum.add(mover.position);
          count += 1;
        }
      }
      sum = sum / count.toDouble();
      sumPosition = sumPosition / count.toDouble();
      if (count > 1) {
        seek(sum);
      }
    }
  }

  @override
  void update(double dt) {
    velocity += acceleration;
    velocity.clampLength(0, maxSpeed);
    position += velocity;
    acceleration = acceleration * 0;
    resetPosition();
    acceleration.clampLength(0, maxForce);
    angle = atan2(velocity.y, velocity.x);

    if (position.distanceTo(player.position) < radius) {
      avoid(player.position);
    } else {
      align();
      cohesion();
      separation();
      wander();
    }
    super.update(dt);
  }

  void resetPosition() {
    if (position.y > 500) {
      position.y = 0;
    } else if (position.y < 0) {
      position.y = 500;
    }

    if (position.x > 1000) {
      position.x = 0;
    } else if (position.x < 0) {
      position.x = 1000;
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

  void avoid(Vector2 target) {
    Vector2 desired = target - position;
    desired.normalize();
    desired = -desired * maxSpeed;
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
