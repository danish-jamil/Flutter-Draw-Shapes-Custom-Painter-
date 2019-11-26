import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MultipleCanvas extends StatefulWidget {
  MultipleCanvas({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MultipleCanvasState createState() => _MultipleCanvasState();
}

class _MultipleCanvasState extends State<MultipleCanvas> {
  Offset _startPoint = Offset(0, 0);
  Offset _endPoint = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  _endPoint = details.localPosition;
                  print('OnPanUpdate End Point: $_endPoint');
                });
              },
              onPanStart: (DragStartDetails details) {
                setState(() {
                  // RenderBox object = context.findRenderObject();
                  // _startPoint = object.globalToLocal(details.globalPosition);
                  _startPoint = details.localPosition;
                  print('On Start: $_startPoint');
                });
              },
              onPanEnd: (DragEndDetails details) {
                setState(() {
                  print("On End: ");
                  print(_startPoint);
                  print(_endPoint);
                });
              },
              child: CustomPaint(size: Size.infinite))),
    );
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}
