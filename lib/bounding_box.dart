import 'dart:math';

import 'package:flutter/material.dart';

class BoundingBox extends StatefulWidget {
  /// A widget that provides a bounding box with resize and rotate handles.
  /// It allows users to drag, resize, and rotate the widget within the bounding box.
  const BoundingBox({
    super.key,
    required this.builder,
    required this.initialPosition,
    required this.initialSize,
    this.initialRotation,
    this.enable = true,
    this.handleResizeSize,
    this.handleRotateSize,
    this.handleResizeBackgroundColor,
    this.handleResizeStrokeColor,
    this.handleRotateBackgroundColor,
    this.handleRotateStrokeColor,
    this.strokeWidth,
    this.strokeColor,
    this.handleResizeStrokeWidth,
    this.handleRotateStrokeWidth,
    this.rotateIcon,
    this.customHandleResize,
    this.customHandleRotate,
    this.handleRotatePosition,
    this.customDecoration,
  });

  /// A required builder function that takes the current size and returns a widget.
  final Widget Function(Size size, Offset position, double rotation) builder;

  /// Whether the bouding_box functionalities are enabled.
  final bool enable;

  /// The initial position of the widget on the screen.
  final Offset initialPosition;

  /// The initial size of the widget (width and height).
  final Size initialSize;

  /// The initial rotation of the widget.
  final double? initialRotation;

  /// The size (diameter) of the resize handle.
  final double? handleResizeSize;

  /// The size (diameter) of the rotate handle.
  final double? handleRotateSize;

  /// Background color of the resize handle.
  final Color? handleResizeBackgroundColor;

  /// Stroke (border) color of the resize handle.
  final Color? handleResizeStrokeColor;

  /// Background color of the rotate handle.
  final Color? handleRotateBackgroundColor;

  /// Stroke (border) color of the rotate handle.
  final Color? handleRotateStrokeColor;

  /// Border color of the main widget (bounding box).
  final Color? strokeColor;

  /// Thickness of the main widget (bounding box) border stroke.
  final double? strokeWidth;

  /// Thickness of the resize handle's stroke.
  final double? handleResizeStrokeWidth;

  /// Thickness of the rotate handle's stroke.
  final double? handleRotateStrokeWidth;

  /// A custom icon widget placed inside the rotate handle.
  final Widget? rotateIcon;

  /// Custom widget that replaces the default resize handle.
  final Widget? customHandleResize;

  /// Custom widget that replaces the default rotate handle.
  final Widget? customHandleRotate;

  /// Distance from the main widget to the rotate handle.
  final double? handleRotatePosition;

  /// A custom widget that replaces the default main widget (bounding box).
  final BoxDecoration? customDecoration;

  @override
  State<BoundingBox> createState() => _BoundingBoxState();
}

class _BoundingBoxState extends State<BoundingBox> {
  late Offset position;
  late Size size;
  double rotation = 0;
  double handleSize = 14;
  Offset? rotateStart;

  @override
  void initState() {
    position = widget.initialPosition;
    size = widget.initialSize;
    rotation = widget.initialRotation ?? 0;
    if (widget.handleResizeSize != null) handleSize = widget.handleResizeSize!;
    super.initState();
  }

  Offset get center => position + Offset(size.width / 2, size.height / 2);

  List<Offset> getHandlePositions() {
    final w = size.width;
    final h = size.height;

    final List<Offset> localPoints = [
      Offset(0, 0), // topLeft
      Offset(w / 2, 0), // topCenter
      Offset(w, 0), // topRight
      Offset(0, h / 2), // centerLeft
      Offset(w, h / 2), // centerRight
      Offset(0, h), // bottomLeft
      Offset(w / 2, h), // bottomCenter
      Offset(w, h), // bottomRight
    ];

    return localPoints.map((local) {
      final rotated = _rotate(local - Offset(w / 2, h / 2), rotation);
      return center + rotated;
    }).toList();
  }

  Offset _rotate(Offset point, double angle) {
    final cosA = cos(angle);
    final sinA = sin(angle);
    return Offset(
      point.dx * cosA - point.dy * sinA,
      point.dx * sinA + point.dy * cosA,
    );
  }

  void _resizeFromHandle(int index, DragUpdateDetails details) {
    final delta = details.delta;

    double dx = delta.dx;
    double dy = delta.dy;

    double newWidth = size.width;
    double newHeight = size.height;
    Offset newPos = position;

    switch (index) {
      case 0: // topLeft
        newWidth -= dx;
        newHeight -= dy;
        newPos += Offset(dx, dy);
        break;
      case 1: // topCenter
        newHeight -= dy;
        newPos += Offset(0, dy);
        break;
      case 2: // topRight
        newWidth += dx;
        newHeight -= dy;
        newPos += Offset(0, dy);
        break;
      case 3: // centerLeft
        newWidth -= dx;
        newPos += Offset(dx, 0);
        break;
      case 4: // centerRight
        newWidth += dx;
        break;
      case 5: // bottomLeft
        newWidth -= dx;
        newHeight += dy;
        newPos += Offset(dx, 0);
        break;
      case 6: // bottomCenter
        newHeight += dy;
        break;
      case 7: // bottomRight
        newWidth += dx;
        newHeight += dy;
        break;
    }

    setState(() {
      size = Size(max(30, newWidth), max(30, newHeight));
      position = newPos;
    });
  }

  void _onRotateStart(DragStartDetails details) {
    rotateStart = details.globalPosition;
  }

  void _onRotateUpdate(DragUpdateDetails details) {
    if (rotateStart == null) return;

    final prev = rotateStart!;
    final next = details.globalPosition;

    final centerOffset = center;
    final a = atan2(prev.dy - centerOffset.dy, prev.dx - centerOffset.dx);
    final b = atan2(next.dy - centerOffset.dy, next.dx - centerOffset.dx);

    setState(() {
      rotation += b - a;
      rotateStart = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable == false) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: center.dx - size.width / 2,
              top: center.dy - size.height / 2,
              child: Transform.rotate(
                angle: rotation,
                child: widget.builder(size, position, rotation),
              ),
            ),
          ],
        ),
      );
    }

    final handles = getHandlePositions();

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => position += details.delta),
        child: Stack(
          children: [
            // Rotated box
            Positioned(
              left: center.dx - size.width / 2,
              top: center.dy - size.height / 2,
              child: Transform.rotate(
                angle: rotation,
                child: widget.builder(size, position, rotation),
              ),
            ),

            // Bounding box
            Positioned(
              left: center.dx - size.width / 2,
              top: center.dy - size.height / 2,
              child: Transform.rotate(
                angle: rotation,
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration:
                      widget.customDecoration ??
                      BoxDecoration(
                        border: Border.all(
                          color: widget.strokeColor ?? Colors.blue,
                          width: widget.strokeWidth ?? 2,
                        ),
                      ),
                ),
              ),
            ),

            // Resize handles
            for (int i = 0; i < handles.length; i++)
              Positioned(
                left: handles[i].dx - handleSize / 2,
                top: handles[i].dy - handleSize / 2,
                child: GestureDetector(
                  onPanUpdate: (details) => _resizeFromHandle(i, details),
                  child:
                      widget.customHandleResize != null
                          ? SizedBox(
                            width: handleSize,
                            height: handleSize,
                            child: widget.customHandleResize,
                          )
                          : Container(
                            width: handleSize,
                            height: handleSize,
                            decoration: BoxDecoration(
                              color:
                                  widget.handleRotateBackgroundColor ??
                                  Colors.white,
                              border: Border.all(
                                color:
                                    widget.handleResizeStrokeColor ??
                                    Colors.blue,
                                width: widget.handleResizeStrokeWidth ?? 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                ),
              ),

            // Rotate handle (topCenter, 40px above)
            Positioned(
              left: center.dx - (widget.handleRotateSize ?? handleSize) / 2,
              top:
                  center.dy -
                  size.height / 2 -
                  (widget.handleRotatePosition ?? 40),
              child: GestureDetector(
                onPanStart: _onRotateStart,
                onPanUpdate: _onRotateUpdate,
                child:
                    widget.customHandleRotate != null
                        ? SizedBox(
                          width: handleSize,
                          height: handleSize,
                          child: widget.customHandleRotate,
                        )
                        : Container(
                          width: widget.handleRotateSize ?? handleSize,
                          height: widget.handleRotateSize ?? handleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                widget.handleRotateBackgroundColor ??
                                Colors.white,
                            border: Border.all(
                              color:
                                  widget.handleRotateStrokeColor ?? Colors.blue,
                              width: widget.handleRotateStrokeWidth ?? 1,
                            ),
                          ),
                          child:
                              widget.rotateIcon ??
                              const Icon(
                                Icons.rotate_right,
                                size: 12,
                                color: Colors.blue,
                              ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
