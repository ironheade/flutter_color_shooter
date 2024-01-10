import 'dart:math';

import 'package:color_shooter_game/Map.dart';
import 'package:color_shooter_game/Player.dart';
import 'package:color_shooter_game/enums_and_constants/directions.dart';
import 'package:color_shooter_game/helpers/functions.dart';
import 'package:color_shooter_game/helpers/mover.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';

class ColorGame extends FlameGame with HasCollisionDetection {
  final _player = Player();
  final _map = Map();
  List<Mover> _mover = [];
  double playerAngle = 0;
  List<Color> fishColor = [
    Color.fromARGB(222, 246, 110, 6),
    Color.fromARGB(222, 46, 246, 6),
    Color.fromARGB(222, 246, 6, 202),
    Color.fromARGB(222, 40, 188, 238),
    Color.fromARGB(222, 192, 188, 59),
    Color.fromARGB(222, 246, 6, 6),
  ];

  @override
  void onLoad() async {
    // TODO: implement onMount

    await add(_map);
    for (int i = 0; i < 200; i++) {
      if (i % 4 == 0) {
        Mover mover = Mover(
            moverColor: fishColor[Random().nextInt(fishColor.length)],
            moverPosition: Vector2(Random().nextInt(1000).toDouble(),
                Random().nextInt(1000).toDouble()),
            player: _player,
            velocity: Vector2.random(Random()) - Vector2.all(0.5),
            otherMover: _mover);
        _mover.add(mover);
        await add(mover);
      } else {
        Mover mover = Mover(
            follower: false,
            maxSpeed: 2,
            moverColor: Color.fromARGB(255, 123, 116, 116),
            moverPosition: Vector2(Random().nextInt(1000).toDouble(),
                Random().nextInt(1000).toDouble()),
            player: _player,
            velocity: Vector2.random(Random()) - Vector2.all(0.5),
            otherMover: _mover);

        _mover.add(mover);
        await add(mover);
      }
    }
    await add(_player..position = Vector2.all(90));

    //await add(Mover(moverPosition: Vector2.all(100), player: _player));

    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _map.size.x, _map.size.y));
    super.onLoad();
  }

  onDirectionChanged(Direction direction) {
    _player.direction = direction;
    camera.update(20);
  }
}
