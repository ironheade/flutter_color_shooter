import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class Map extends RectangleComponent {
  static double mapWidth = 1000;
  static double mapHeight = 500;
  Map()
      : super(
            size: Vector2(mapWidth, mapHeight),
            paint: Paint()
              ..shader = RadialGradient(colors: [
                Color.fromARGB(238, 10, 56, 126),
                Color.fromARGB(110, 10, 56, 126)
              ]).createShader(Rect.fromCenter(
                  center: Vector2(mapWidth / 2, mapHeight / 2).toOffset(),
                  width: mapWidth,
                  height: mapHeight))
              ..style = PaintingStyle.fill);

  @override
  void onLoad() async {
    await add(RectangleComponent(
        size: Vector2(mapWidth, mapHeight),
        paint: Paint()
          ..color = Color.fromARGB(237, 126, 25, 10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 40));
  }
}
