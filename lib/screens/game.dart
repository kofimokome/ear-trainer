import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameData();
  }
}

class _GameData extends State<Game> {
  AudioCache player = new AudioCache(fixedPlayer: AudioPlayer());

  var _items = [
    {'position': 1, 'id': 1, 'color': Colors.green, 'file': 'c4.mp3'},
    {'position': 2, 'id': 2, 'color': Colors.red, 'file': 'g4.mp3'},
    {'position': 4, 'id': 4, 'color': Colors.orange, 'file': 'g4.mp3'},
    {'position': 3, 'id': 3, 'color': Colors.blue, 'file': 'c4.mp3'},
  ];

  _updatePositions(from, to) {
    var fromPosition = _items[from]['position'];
    var toPosition = _items[to]['position'];
    _items[from]['position'] = toPosition;
    _items[to]['position'] = fromPosition;

    setState(() {
      _items.sort((a, b) =>
          a['position'].toString().compareTo(b['position'].toString()));
      print(_items);
    });
  }

  _canUpdatePosition(from, to) {
    return from != to;
  }

  playLocal(file) async {
    await player.play(file);
    await player.fixedPlayer.resume();
    print(player.fixedPlayer.state);
    //int result = await audioPlayer.play("assets/c4.mp3", isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Text(
            "Arrange the sounds in ascending order",
            style: TextStyle(fontSize: 25),
          ),
          Row(
            children: [
              ..._items.map((e) {
                return DragTarget(
                  builder: (context, candidateData, rejectedData) {
                    return Draggable(
                      data: _items.indexOf(e),
                      childWhenDragging: ElevatedButton(
                        onPressed: null,
                        child: Container(
                          width: 50,
                          height: 50,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(
                                    side: BorderSide(color: Colors.green))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                      ),
                      child: ElevatedButton(
                        onPressed: () => playLocal(e['file']),
                        child: Container(
                          width: 50,
                          height: 50,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(
                                    side: BorderSide(color: Colors.green))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(e['color'])),
                      ),
                      feedback: ElevatedButton(
                        onPressed: null,
                        child: Container(
                          width: 50,
                          height: 50,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(
                                    side: BorderSide(color: Colors.green))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(e['color'])),
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    return _canUpdatePosition(data, _items.indexOf(e));
                  },
                  onAccept: (data) {
                    _updatePositions(data, _items.indexOf(e));
                  },
                );
              }),
            ],
          ),
        ]));
  }
}
