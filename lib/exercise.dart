import 'dart:math';

import 'package:flutter/material.dart';

class Exercise {
  final _questions = [
    {
      'title': 'Arrange in ascending order',
      'answer': ['a4', 'b4', 'c4', 'd4'],
    },
    {
      'title': 'Arrange in descending order',
      'answer': ['d4', 'c4', 'b4', 'a4']
    }
  ];

  // see how to fix the issue of answer changing after sorting from game.dart file
  final _answers = [
    ['a4', 'b4', 'c4', 'd4'],
    ['d4', 'c4', 'b4', 'a4']
  ];

  final _colors = [
    {'note': 'a4', 'color': Colors.green},
    {'note': 'a-4', 'color': Colors.red},
    {'note': 'b4', 'color': Colors.blue},
    {'note': 'c4', 'color': Colors.orange},
    {'note': 'c-4', 'color': Colors.indigo},
    {'note': 'd4', 'color': Colors.yellow},
    {'note': 'd-4', 'color': Colors.black},
    {'note': 'e4', 'color': Colors.indigoAccent},
    {'note': 'f4', 'color': Colors.pink},
    {'note': 'f-4', 'color': Colors.cyan},
    {'note': 'g4', 'color': Colors.purple},
    {'note': 'g-4', 'color': Colors.tealAccent},
  ];

  MaterialColor colorOf(String note) {
    for (var i = 0; i < _colors.length; i++) {
      if (_colors[i]['note'] == note) {
        return _colors[i]['color'];
      }
    }
    return Colors.green;
  }

  Object get getQuestion {
    Random random = new Random();
    var index = random.nextInt(_questions.length);
    var question = _questions[index];
    return {
      ...{'id': index},
      ...question
    };
  }

  bool verifyAnswer(index, answer) {
    print(answer);
    print(_answers[index]);
    return _areListsEqual(answer, _answers[index]);
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
