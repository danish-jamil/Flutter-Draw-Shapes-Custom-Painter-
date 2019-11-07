import 'dart:ui';

import 'package:custom_shapes/draw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> _points = <Offset>[];
  Offset _startPoint = Offset(0, 0);
  Offset _endPoint = Offset(0, 0);

  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  List<RectanglePoints> rectangles = List<RectanglePoints>();
  List<Offset> _rects = <Offset>[];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Theme.of(context).accentColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        shape: CircleBorder(),
                        child: Icon(Icons.album, color: Colors.orange),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.StrokeWidth)
                              showBottomList = !showBottomList;
                            selectedMode = SelectedMode.StrokeWidth;
                          });
                        },
                      ),
                      MaterialButton(
                          shape: CircleBorder(),
                          child: Icon(FontAwesomeIcons.shapes,
                              color: Colors.green),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.Shape)
                                showBottomList = !showBottomList;
                              selectedMode = SelectedMode.Shape;
                            });
                          }),
                      MaterialButton(
                          shape: CircleBorder(),
                          child: Icon(Icons.color_lens, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.Color)
                                showBottomList = !showBottomList;
                              selectedMode = SelectedMode.Color;
                            });
                          }),
                      MaterialButton(
                          shape: CircleBorder(),
                          child: Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              showBottomList = false;
                              points.clear();
                              _startPoint = Offset(0, 0);
                              _endPoint = Offset(0, 0);
                              rectangles.clear();
                            });
                          }),
                    ],
                  ),
                  Visibility(
                    child: (selectedMode == SelectedMode.Color)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getColorList(),
                          )
                        : (selectedMode == SelectedMode.Shape)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  MaterialButton(
                                    shape: CircleBorder(),
                                    child: Icon(Icons.check_box_outline_blank,
                                        color: Colors.pink),
                                    onPressed: () {},
                                  ),
                                  Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.check_circle_outline,
                                          color: Colors.green),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              )
                            : Slider(
                                value: strokeWidth,
                                max: 50.0,
                                min: 0.0,
                                onChanged: (val) {
                                  setState(() {
                                    strokeWidth = val;
                                  });
                                }),
                    visible: showBottomList,
                    replacement: SizedBox.shrink(),
                  ),
                ],
              ),
            )),
      ),
      body: Container(
          child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  RenderBox object = context.findRenderObject();
                  Offset _localPosition =
                      object.globalToLocal(details.globalPosition);
                  _points = new List.from(_points)..add(_localPosition);
                  // _endPoint = _localPosition;
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
              onTapDown: (TapDownDetails details) {
                setState(() {
                  _startPoint = details.localPosition;
                  print('On Tap down: $_startPoint');
                });
              },
              onPanEnd: (DragEndDetails details) {
                setState(() {
                  _points.add(null);
                  rectangles = new List.from(rectangles)
                    ..add(RectanglePoints(
                        startPoint: _startPoint,
                        endPoint: _endPoint,
                        color: selectedColor,
                        strokeWidth: strokeWidth));
                  print("On End: ");
                  print(_startPoint);
                  print(_endPoint);
                });
              },
              child: CustomPaint(
                  painter: ShapesPainter(
                      points: _points,
                      startPoint: _startPoint,
                      endPoint: _endPoint,
                      selectedColor: selectedColor,
                      strokeWidth: strokeWidth,
                      rectangles: rectangles,
                      rects: _rects),
                  size: Size.infinite))),
      // body: Padding(
      //     padding: EdgeInsets.all(8.0),
      //     child: CustomPaint(
      //         painter: ShapesPainter(), child: Container(height: 700))),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.clear_all),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Draw()));
      //   },
      // ),
    );
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
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

class ShapesPainter extends CustomPainter {
  List<Offset> points;
  Offset startPoint = Offset(0, 0);
  Offset endPoint = Offset(0, 0);
  Color selectedColor = Colors.black;
  double strokeWidth;
  List<RectanglePoints> rectangles = List<RectanglePoints>();
  List<Offset> rects = List<Offset>();

  ShapesPainter(
      {this.points,
      this.startPoint,
      this.endPoint,
      this.selectedColor,
      this.strokeWidth,
      this.rectangles,
      this.rects});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    // Draw full size rectangle
    paint.color = selectedColor;
    paint.strokeWidth = strokeWidth;
    // double radius = endPoint.dx - startPoint.dx > endPoint.dy - startPoint.dy
    //     ? endPoint.dx - startPoint.dx
    //     : endPoint.dy - startPoint.dy;
    // canvas.drawCircle(startPoint, radius, paint);

    for (var rectPoints in rectangles) {
      paint.color = rectPoints.color;
      paint.strokeWidth = rectPoints.strokeWidth;
      var rect = Rect.fromLTWH(
          rectPoints.startPoint.dx,
          rectPoints.startPoint.dy,
          rectPoints.endPoint.dx - rectPoints.startPoint.dx,
          rectPoints.endPoint.dy - rectPoints.startPoint.dy);
      canvas.drawRect(rect, paint);
    }

    var rect = Rect.fromLTWH(startPoint.dx, startPoint.dy,
        endPoint.dx - startPoint.dx, endPoint.dy - startPoint.dy);
    canvas.drawRect(rect, paint);

    // for (int i = 0; i < rects.length - 1; i++) {
    //   var rect = Rect.fromLTWH(rects[i].dx, rects[i].dy,
    //       rects[i + 1].dx - rects[i].dx, rects[i + 1].dy - rects[i].dy);
    //   canvas.drawRect(rect, paint);
    // }

    // Draw path
    // paint.color = Colors.yellow;
    // var path = Path();
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, 0);
    // path.close();
    // paint.strokeWidth = 5;
    // canvas.drawPath(path, paint);
    // // Draw circle in the middle
    // paint.color = Colors.deepOrange;
    // var center = Offset(size.width / 2, size.height / 2);
    // paint.style = PaintingStyle.fill;
    // canvas.drawCircle(center, 75.0, paint);

    // paint.color = Colors.black;
    // paint.strokeCap = StrokeCap.round;
    // if (points.length > 0) {
    //   for (int i = 0; i < points.length - 1; i++) {
    //     if (points[i] != null && points[i + 1] != null) {
    //       canvas.drawLine(points[i], points[i + 1], paint);
    //     }
    //   }
    // }
  }

  @override
  bool shouldRepaint(ShapesPainter oldDelegate) => true;
}

class RectanglePoints {
  Offset startPoint;
  Offset endPoint;
  Color color;
  double strokeWidth;
  RectanglePoints(
      {this.startPoint, this.endPoint, this.color, this.strokeWidth});
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color, Shape }
