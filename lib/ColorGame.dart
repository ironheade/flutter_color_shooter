import 'dart:math';

import 'package:color_shooter_game/Map.dart';
import 'package:color_shooter_game/Player.dart';
import 'package:color_shooter_game/enums_and_constants/directions.dart';
import 'package:color_shooter_game/helpers/functions.dart';
import 'package:color_shooter_game/helpers/mover.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';

class ColorGame extends FlameGame {
  final _player = Player();
  final _map = Map();
  List<Mover> _mover = [];
  double playerAngle = 0;

  @override
  void onLoad() async {
    // TODO: implement onMount

    await add(_map);
    for (int i = 0; i < 500; i++) {
      if (i % 2 == 0) {
        await add(Mover(
            follower: false,
            moverPosition: Vector2(Random().nextInt(1000).toDouble(),
                Random().nextInt(1000).toDouble()),
            player: _player,
            velocity: Vector2.random(Random())));
      } else {
        await add(Mover(
            moverColor: Color.fromARGB(255, 123, 116, 116),
            moverPosition: Vector2(Random().nextInt(1000).toDouble(),
                Random().nextInt(1000).toDouble()),
            player: _player,
            velocity: Vector2.random(Random())));
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
