import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DoubleQuestion extends StatelessWidget {
  final question;
  final Function updatePositionCallback;
  final Function canUpdateCallback;
  final Function playSoundCallback;
  final items;
  final responseArea;

  DoubleQuestion({
    @required this.updatePositionCallback,
    @required this.question,
    @required this.items,
    @required this.responseArea,
    @required this.canUpdateCallback,
    @required this.playSoundCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...items.map((e) {
              return Draggable(
                data: items.indexOf(e),
                childWhenDragging: ElevatedButton(
                  onPressed: null,
                  child: Container(
                    width: 50,
                    height: 50,
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          CircleBorder(side: BorderSide(color: Colors.green))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey)),
                ),
                child: ElevatedButton(
                  onPressed: () => this.playSoundCallback(e['file']),
                  child: Container(
                    width: 50,
                    height: 50,
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          CircleBorder(side: BorderSide(color: Colors.green))),
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
                          CircleBorder(side: BorderSide(color: Colors.green))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(e['color'])),
                ),
              );
            }),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("Drag the sound into the box below"),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return ElevatedButton(
                    onPressed: null,
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                            CircleBorder(
                                side: BorderSide(color: Colors.black))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            responseArea['color'])),
                  );
                },
                onWillAccept: (data) {
                  return this.canUpdateCallback(data, 0, single: false);
                },
                onAccept: (data) {
                  this.updatePositionCallback(data, 0, single: false);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
