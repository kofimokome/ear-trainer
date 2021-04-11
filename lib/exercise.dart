import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exercise {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _questions = [
    {
      'title': 'Arrange the notes in descending order',
      'answer': ['c4', 'a4']
    },
    {
      'title': 'Arrange the notes in ascending order',
      'answer': ['f4', 'g4'],
    },
    {
      'title': 'Arrange the notes in ascending order',
      'answer': ['f4', 'g4', 'a5'],
    },
    {
      'title': 'Arrange the notes in descending order',
      'answer': ['f4', 'e4', 'd4'],
    },
    {
      'title': 'Arrange the notes in descending order',
      'answer': ['f4', 'e4', 'd4', 'c4'],
    },
    {
      'title': 'Arrange the notes in descending order',
      'answer': ['d4', 'c4', 'b4', 'a4']
    },
    {
      'title': 'Arrange the notes in ascending order',
      'answer': ['a4', 'b4', 'c4', 'd4'],
    },
    {
      'title': 'Arrange the notes in ascending order',
      'answer': ['c4', 'c4', 'd4', 'e4', 'f4', 'f-4', 'f-4']
    },
    {
      'title': 'Arrange the notes in descending order',
      'answer': ['c4', 'c4', 'd4', 'e4', 'f4', 'f-4', 'f-4'].reversed.toList()
    },
    {
      'title': 'Arrange the notes in the order << do fa soh >>',
      'answer': ['c4', 'f4', 'g4']
    },
    {
      'title': 'Arrange the notes in the order << do fa soh la >>',
      'answer': ['c4', 'f4', 'g4', 'a5']
    },
    {
      'title': 'Arrange the notes in the order << do fa do soh >>',
      'answer': ['c4', 'f4', 'c4', 'g4']
    },
    {
      'title': 'Arrange the notes in the order << la soh fa soh >>',
      'answer': ['a5', 'g4', 'f4', 'g4']
    },
    {
      'title':
          'Arrange the 1st 2 notes in ascending order and the last 2 notes in descending order',
      'answer': ['e5', 'f5', 'e4', 'd4']
    },
    {
      'title':
          'Arrange the 1st 4 notes in ascending order and the last 4 notes in descending order',
      'answer': ['e5', 'f5', 'g5', 'a5', 'g4', 'f4', 'e4', 'd4']
    },
  ];

  final _colors = [
    {'note': 'a4', 'color': Colors.green},
    {'note': 'a-4', 'color': Colors.red},
    {'note': 'b4', 'color': Colors.blue},
    {'note': 'c4', 'color': Colors.orange},
    {'note': 'c-4', 'color': Colors.indigo},
    {'note': 'd4', 'color': Colors.yellow},
    {'note': 'd-4', 'color': Colors.lime},
    {'note': 'e4', 'color': Colors.brown},
    {'note': 'f4', 'color': Colors.pink},
    {'note': 'f-4', 'color': Colors.cyan},
    {'note': 'g4', 'color': Colors.purple},
    {'note': 'g-4', 'color': Colors.teal},

    {'note': 'a5', 'color': Colors.green.shade300},
    {'note': 'a-5', 'color': Colors.red.shade300},
    {'note': 'b5', 'color': Colors.blue.shade300},
    {'note': 'c5', 'color': Colors.orange.shade300},
    {'note': 'c-5', 'color': Colors.indigo.shade300},
    {'note': 'd5', 'color': Colors.yellow.shade300},
    {'note': 'd-5', 'color': Colors.lime.shade300},
    {'note': 'e5', 'color': Colors.brown.shade300},
    {'note': 'f5', 'color': Colors.pink.shade300},
    {'note': 'f-5', 'color': Colors.cyan.shade300},
    {'note': 'g5', 'color': Colors.purple.shade300},
    {'note': 'g-5', 'color': Colors.teal.shade300},
  ];

   colorOf(String note) {
    for (var i = 0; i < _colors.length; i++) {
      if (_colors[i]['note'] == note) {
        return _colors[i]['color'];
      }
    }
    return Colors.green;
  }

  Future<Object> getQuestion(int lvl) async {
    final SharedPreferences prefs = await _prefs;
    int level = 1;
    int index;
    Random random = new Random();
    if (lvl > 0) {
      level = lvl;
    } else if (prefs.containsKey('level')) {
      level = prefs.getInt('level');
      print('question level ' + level.toString());
    }
    if (level <= _questions.length) {
      index = level - 1;
    } else {
      index = random.nextInt(_questions.length);
    }
    var question = _questions[index];
    List temp = question['answer'];
    var answer = [];
    for (var i = 0; i < temp.length; i++) {
      answer.add(temp[i]);
    }
    /*Set a = {}..addAll(question['answer']);
    return {
      ...{'id': index},
      ...{'title': question['title'], 'answer': a.toList()}
    };*/
    return {
      ...{'id': index},
      ...{
        'title': (index + 1).toString() + ': ' + question['title'],
        'answer': answer
      },
    };
  }

  bool verifyAnswer(index, answer) {
    print(answer);
    print(_questions[index]['answer']);
    return _areListsEqual(answer, _questions[index]['answer']);
  }

  bool _areListsEqual(var list1, var list2) {
    // check if both are lists
    if (!(list1 is List && list2 is List)
        // check if both have same length
        ||
        list1.length != list2.length) {
      return false;
    }

    // check if elements are equal
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }
}
