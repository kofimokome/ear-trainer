import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameData();
  }
}

class _GameData extends State<Game> {
  bool _isSuccessful = false;
  var _items = [
    {'position': 1, 'id': 1, 'color': Colors.green},
    {'position': 2, 'id': 2, 'color': Colors.red},
    {'position': 4, 'id': 4, 'color': Colors.orange},
    {'position': 3, 'id': 3, 'color': Colors.blue},
  ];

  _updatePositions(from, to) {
    var fromPosition = _items[from]['position'];
    var toPosition = _items[to]['position'];

    setState(() {
      _items[from]['position'] = toPosition;
      _items[to]['position'] = fromPosition;
    });
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
                      data: e['id'],
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
                  onAccept: (data) {
                    setState(() {
                      _isSuccessful = true;
                    });
                  },
                );
              }),
            ],
          ),
        ]));
  }
}
