import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SingleQuestion extends StatelessWidget {
  final question;
  final Function updatePositionCallback;
  final Function canUpdateCallback;
  final items;

  SingleQuestion({
    @required this.updatePositionCallback,
    @required this.question,
    @required this.items,
    @required this.canUpdateCallback,
  });

  final AudioCache player = new AudioCache(fixedPlayer: AudioPlayer());

  playLocal(file) async {
    await player.play(file);
    await player.fixedPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...items.map((e) {
          return DragTarget(
            builder: (context, candidateData, rejectedData) {
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
                  onPressed: () => playLocal(e['file']),
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
            },
            onWillAccept: (data) {
              return this.canUpdateCallback(data, items.indexOf(e));
            },
            onAccept: (data) {
              this.updatePositionCallback(data, items.indexOf(e));
            },
          );
        }),
      ],
    );
  }
}
