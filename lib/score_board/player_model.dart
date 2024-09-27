import 'package:hive_flutter/adapters.dart';
part 'player_model.g.dart';

@HiveType(typeId: 0)
class Player {
  @HiveField(0)
  String name;

  @HiveField(1)
  int colorValue;

  @HiveField(2)
  int score = 0;

  Player({required this.name, required this.colorValue, required this.score});
}
