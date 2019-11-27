import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomPainterDraggable extends StatefulWidget {
  @override
  _CustomPainterDraggableState createState() => _CustomPainterDraggableState();
}

class CustomRect {
  Offset startPoint;
  double width;
  double height;
  CustomRect({this.startPoint, this.width, this.height});
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
  var xPos = 100.0;
  var yPos = 100.0;
  final width = 100.0;
  final height = 100.0;
  bool _dragging = false;
  SelectedMode mode = SelectedMode.Shape;
  int _currentIndex = 0;
  final _rectangles = <CustomRect>[];
  CustomRect _selectedRect;

  /// Is the point (x, y) inside the rect?
  CustomRect _insideRect(double x, double y) {
    for (var rect in _rectangles) {
      if (x >= rect.startPoint.dx &&
          x <= rect.startPoint.dx + rect.width &&
          y >= rect.startPoint.dy &&
          y <= rect.startPoint.dy + rect.height) {
        return rect;
      }
      // return x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Move custom shape",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onPanStart: (details) {
          if (mode == SelectedMode.Move) {
            _selectedRect = _insideRect(
              details.localPosition.dx,
              details.localPosition.dy,
            );
          } else {}
        },
        onPanEnd: (details) {
          _dragging = false;
        },
        onPanUpdate: (details) {
          if (mode == SelectedMode.Move) {
            if (_selectedRect != null) {
              setState(() {
                _selectedRect.startPoint +=
                    Offset(details.delta.dx, details.delta.dy);
                // yPos += details.delta.dy;
              });
            }
          }
        },
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: RectanglePainter(_rectangles),
            child: Container(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shapes), title: Text('Draw Shape')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.arrowsAlt),
              title: Text('Move Shape')),
        ],
      ),
    );
  }
}

enum SelectedMode { Shape, Move }

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rectangles);
  // final Rect rect;
  final List<CustomRect> rectangles;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    paint.color = Colors.red;
    paint.strokeWidth = 5.0;
    // canvas.drawRect(Rect.fromLTWH(xPos, yPos, width, height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
