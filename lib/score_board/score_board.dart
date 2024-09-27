import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'player_model.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  String teamName = '';
  Color selectedColor = Colors.blue;
  late Box playerBox;
  int totalQuestions = 15;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    playerBox = Hive.box('players');
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bg.gif',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 2,
            left: 5,
            right: 5,
            child: Container(
              margin: const EdgeInsets.all(15),
              height: hei * 0.1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Namma Score Board",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        SizedBox(
                          width: wid * 0.5,
                        ),
                        Row(
                          children: [
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isHovered = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: _isHovered ? 150 : 50,
                                height: 30,
                                child: FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                        if (_isHovered) {
                                          return Colors.blue.withOpacity(0.3);
                                        }
                                        return Colors.transparent;
                                      },
                                    ),
                                  ),
                                  onPressed: addDialog,
                                  child: _isHovered
                                      ? const Text('Add Player')
                                      : const Center(
                                          child: Icon(Icons.add),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                                onPressed: () {
                                  settingsDialog();
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: playerBox.listenable(),
            builder: (context, Box box, _) {
              if (box.isEmpty) {
                return const Center(
                  child: Text(''),
                );
              } else {
                List<Player> players = box.values.cast<Player>().toList();
                players.sort((a, b) => b.score.compareTo(a.score));

                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(box.length, (index) {
                            final player = box.getAt(index) as Player;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: SfSlider.vertical(
                                      min: 0.0,
                                      max: totalQuestions.toDouble(),
                                      value: player.score.toDouble(),
                                      interval: 1,
                                      showDividers: false,
                                      enableTooltip: true,
                                      thumbIcon: ImageIcon(
                                        const AssetImage("assets/dash.png"),
                                        color: Color(player.colorValue),
                                        size: 40,
                                      ),
                                      activeColor: Color(player.colorValue),
                                      inactiveColor: Colors.grey.shade500,
                                      onChanged: (newValue) {
                                        setState(() {
                                          playerBox.putAt(
                                            index,
                                            Player(
                                              name: player.name,
                                              colorValue: player.colorValue,
                                              score: newValue.toInt(),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 150,
                                    ),
                                    child: Text(
                                      player.name,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Score: ${player.score}',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 61, 61, 61),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: hei * 0.7,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(player.colorValue),
                                  ),
                                  title: Text(player.name),
                                  trailing: Text(
                                    player.score.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> addDialog() async {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        List<Color> colorOptions = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.yellow,
          Colors.cyan,
          Colors.pink,
          Colors.teal,
          Colors.indigo,
          Colors.brown,
          Colors.lime,
          Colors.amber,
          Colors.deepOrange,
          Colors.grey,
          Colors.lightBlue,
          Colors.lightGreen,
          Colors.deepPurple,
          Colors.blueGrey,
          Colors.black
        ];

        List usedColors =
            playerBox.values.map((player) => player.colorValue).toList();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Player'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: colorOptions.map((color) {
                      bool isUsed = usedColors.contains(color.value);
                      return GestureDetector(
                        onTap: isUsed
                            ? null
                            : () {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: isUsed
                              ? const Icon(
                                  Icons.block,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: nameController.text.trim().isEmpty
                      ? null
                      : () {
                          playerBox.add(Player(
                            name: nameController.text.trim(),
                            colorValue: selectedColor.value,
                            score: 0,
                          ));
                          Navigator.of(context).pop();
                        },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> settingsDialog() async {
    TextEditingController questionController = TextEditingController(
      text: totalQuestions.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Total Questions'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  playerBox.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear All Players'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  totalQuestions = int.parse(questionController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
