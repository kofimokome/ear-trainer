import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import '../exercise.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameData();
  }
}

class _GameData extends State<Game> {
  AudioCache player = new AudioCache(fixedPlayer: AudioPlayer());
  Exercise _exercise = Exercise();
  var _question;
  var _isCorrect = null;

  var _items = [];

  _GameData() {
    _question = _exercise.getQuestion;
    print(_question['answer']);
    var temp = _shuffle(_question['answer']);
    for (var i = 0; i < temp.length; i++) {
      _items.add({
        'position': i + 1,
        'color': _exercise.colorOf(temp[i]),
        'file': temp[i] + '.mp3',
        'note': temp[i]
      });
    }
  }

  _updatePositions(from, to) {
    print(from.toString() + ' ' + to.toString());
    var fromPosition = _items[from]['position'];
    var toPosition = _items[to]['position'];
    _items[from]['position'] = toPosition;
    _items[to]['position'] = fromPosition;

    setState(() {
      _items.sort((a, b) =>
          a['position'].toString().compareTo(b['position'].toString()));
    });
  }

  _canUpdatePosition(from, to) {
    return from != to;
  }

  _showResult() {
    if (_isCorrect == null) {
      return Container();
    } else if (_isCorrect) {
      return Container(
        child: Text(
          'Correct',
          style: TextStyle(color: Colors.green, fontSize: 28),
        ),
      );
    } else {
      return Container(
        child: Text(
          'Incorrect',
          style: TextStyle(color: Colors.red, fontSize: 28),
        ),
      );
    }
  }

  playLocal(file) async {
    await player.play(file);
    await player.fixedPlayer.resume();
  }

  _checkAnswer() {
    print("correct");
    var responses = _items.map((e) {
      return e['note'];
    });
    var result = _exercise.verifyAnswer(_question['id'], responses.toList());
    print(result);
    setState(() {
      _isCorrect = result;
    });
    if (result) {
    } else {
      HapticFeedback.vibrate();
    }
    //print(responses.toList());
    print('and');
  }

  List _shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(children: [
          Text(
            _question['title'],
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
          ElevatedButton(
              onPressed: _checkAnswer,
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 28),
              )),
          _showResult(),
        ])));
  }
}
