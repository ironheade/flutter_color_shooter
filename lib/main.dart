import 'package:color_shooter_game/ColorGame.dart';
import 'package:color_shooter_game/helpers/navigation.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  final game = ColorGame();
  runApp(
    NewGame(game: game),
  );
}

class NewGame extends StatelessWidget {
  const NewGame({
    Key? key,
    required this.game,
  }) : super(key: key);

  final ColorGame game;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Navigation(
                onDirectionChanged: game.onDirectionChanged,
              ),
            )
          ],
        ),
        //
        //NewGame(game: ShooterGame()),
      ),
    );
  }
}
