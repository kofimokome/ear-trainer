import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exercise.dart';
import '../components/singleQuestion.dart';
import '../components/doubleQuestion.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameData();
  }
}

class _GameData extends State<Game> {
  static AudioCache player = new AudioCache(fixedPlayer: AudioPlayer());
  Exercise _exercise = Exercise();
  var _question;
  var _isCorrect;
  int _level = 10;
  int _currentQuestion = 0;
  bool _loading = true;
  final _highestLevel = 8;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var _items = [];
  var _responseArea = {'position': 0, 'color': Colors.black54, 'note': '0'};

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
      _level = _level > _highestLevel ? _highestLevel : _level;
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

    var temp = _question['shuffle']
        ? _shuffle(_question['answer'])
        : _question['answer'];
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

  _updatePositions(from, to, {single: true}) {
    if (single) {
      print(from.toString() + ' ' + to.toString());
      var fromPosition = _items[from]['position'];
      var toPosition = _items[to]['position'];
      _items[from]['position'] = toPosition;
      _items[to]['position'] = fromPosition;

      setState(() {
        _items.sort((a, b) =>
            a['position'].toString().compareTo(b['position'].toString()));
      });
    } else {
      setState(() {
        _responseArea['color'] = _items[from]['color'];
        _responseArea['note'] = _items[from]['note'];
      });
    }
  }

  _canUpdatePosition(from, to, {single: true}) {
    if (single) {
      return from != to;
    } else {
      setState(() {
        _responseArea['color'] = Colors.black54;
        _responseArea['note'] = '0';
      });
      return true;
    }
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
    player.fixedPlayer.stop().then((value) => {
          player.fixedPlayer.release().then((value) => {
                player.fixedPlayer.play(file, isLocal: true)
                //.then((value) => player.fixedPlayer.resume())
              })
        });
    // await player.fixedPlayer.resume();
  }

  _checkAnswer() async {
    var responses;
    if (_question['single']) {
      responses = _items.map((e) {
        return e['note'];
      });
    } else {
      responses = {_responseArea['note']};
    }
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
                            ...{
                              _question['single']
                                  ? SingleQuestion(
                                      canUpdateCallback: _canUpdatePosition,
                                      question: _question,
                                      items: _items,
                                      updatePositionCallback: _updatePositions,
                                      playSoundCallback: playLocal)
                                  : DoubleQuestion(
                                      canUpdateCallback: _canUpdatePosition,
                                      question: _question,
                                      items: _items,
                                      updatePositionCallback: _updatePositions,
                                      responseArea: _responseArea,
                                      playSoundCallback: playLocal)
                            },
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
