import 'dart:math';

import 'package:flutter/material.dart';

class Exercise {
  final _questions = const [
    {
      'title': 'Arrange in ascending order',
      'answer': ['a4', 'b4', 'c4', 'd4'], // question 1
    },
    {
      'title': 'Arrange in ascending order', // question 2
      'answer': ['f4', 'g4'],
    },
    {
      'title': 'Arrange in descending order', // question 3
      'answer': ['d4', 'c4', 'b4', 'a4']
    },
    {
      'title': 'Arrange in the order << do fa do soh >>', // question 4
      'answer': ['c4', 'f4', 'c4', 'g4']
    },
    {
      'title': 'Arrange in the order << la soh fa soh >>',
      'answer': ['a4', 'g4', 'f4', 'g4']
    },
    {
      'title': 'Arrange in descending order',
      'answer': ['c4', 'a4']
    },
    {
      'title': 'Arrange in ascending order',
      'answer': ['c4', 'c4', 'd4', 'e4', 'f4', 'f-4']
    }
  ];

  final _colors = [
    {'note': 'a4', 'color': Colors.green},
    {'note': 'a-4', 'color': Colors.red},
    {'note': 'b4', 'color': Colors.blue},
    {'note': 'c4', 'color': Colors.orange},
    {'note': 'c-4', 'color': Colors.indigo},
    {'note': 'd4', 'color': Colors.yellow},
    {'note': 'd-4', 'color': Colors.black},
    {'note': 'e4', 'color': Colors.brown},
    {'note': 'f4', 'color': Colors.pink},
    {'note': 'f-4', 'color': Colors.cyan},
    {'note': 'g4', 'color': Colors.purple},
    {'note': 'g-4', 'color': Colors.teal},
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
      ...{'title': question['title'], 'answer': answer},
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
