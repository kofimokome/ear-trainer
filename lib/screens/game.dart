import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var _isCorrect;
  int _level = 10;
  int _currentQuestion = 0;
  bool _loading = true;
  final _highestLevel = 8;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var _items = [];

  _GameData() {
    _getQuestion();
  }

  init() async {
    await _getQuestion();
    return this;
  }

  _getQuestion() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey('level')) {
      _level = prefs.getInt('level');
    } else {
      prefs.setInt('level', 1);
    }
    if (prefs.containsKey('currentQuestion')) {
      _currentQuestion = prefs.getInt('currentQuestion');
    }
    if (_level >= _highestLevel) {
      final currentQuestion = prefs.getInt('currentQuestion');
      print(currentQuestion);
      if (_currentQuestion > 0) {
        _question = await _exercise.getQuestion(currentQuestion);
      } else {
        _question = await _exercise.getQuestion(currentQuestion, skip: true);
      }
      print("here");
    } else {
      print('not here');
      _question = await _exercise.getQuestion(_level);
    }
    _currentQuestion = _question['id'] + 1;
    prefs.setInt('currentQuestion', _currentQuestion);

    var temp = _shuffle(_question['answer']);
    _items = [];
    for (var i = 0; i < temp.length; i++) {
      _items.add({
        'position': i + 1,
        'color': _exercise.colorOf(temp[i]),
        'file': temp[i] + '.mp3',
        'note': temp[i]
      });
    }
    setState(() {
      _loading = false;
      if (_isCorrect != null) {
        _isCorrect = null;
      }
    });
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
          'Try Again!',
          style: TextStyle(color: Colors.red, fontSize: 28),
        ),
      );
    }
  }

  playLocal(file) async {
    await player.play(file);
    await player.fixedPlayer.resume();
  }

  _checkAnswer() async {
    var responses = _items.map((e) {
      return e['note'];
    });
    var result = _exercise.verifyAnswer(_question['id'], responses.toList());
    print(result);
    setState(() {
      _isCorrect = result;
    });
    if (result) {
      final SharedPreferences prefs = await _prefs;
      if (_level < _highestLevel) {
        _level = _level + 1;
        prefs.setInt('level', 15);
      } else {
        _currentQuestion = 0;
        prefs.setInt('currentQuestion', 0);
      }

      print('level');
      print(prefs.getInt('level'));
      player.play('tada.mp3');
    } else {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }
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
    return _loading
        ? Scaffold(
            body: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.audiotrack_rounded,
                      size: 28,
                    ),
                    Text(
                      'loading...',
                      style: TextStyle(fontSize: 28),
                    ),
                  ]),
            ),
          )
        : Scaffold(
            body: Center(
                child: (_isCorrect != null && _isCorrect)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Congratulations !!!',
                            style: TextStyle(color: Colors.green, fontSize: 40),
                          ),
                          ElevatedButton(
                              onPressed: _getQuestion,
                              child: Text(
                                'Next Exercise',
                                style: TextStyle(fontSize: 28),
                              ))
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                _question['title'],
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ..._items.map((e) {
                                  return DragTarget(
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Draggable(
                                        data: _items.indexOf(e),
                                        childWhenDragging: ElevatedButton(
                                          onPressed: null,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      CircleBorder>(
                                                  CircleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.green))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey)),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => playLocal(e['file']),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      CircleBorder>(
                                                  CircleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.green))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(e['color'])),
                                        ),
                                        feedback: ElevatedButton(
                                          onPressed: null,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      CircleBorder>(
                                                  CircleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.green))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(e['color'])),
                                        ),
                                      );
                                    },
                                    onWillAccept: (data) {
                                      return _canUpdatePosition(
                                          data, _items.indexOf(e));
                                    },
                                    onAccept: (data) {
                                      _updatePositions(data, _items.indexOf(e));
                                    },
                                  );
                                }),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ElevatedButton(
                                  onPressed: _checkAnswer,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 28),
                                  )),
                            ),
                            _showResult(),
                          ])));
  }
}
