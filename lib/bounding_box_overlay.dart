import 'dart:math';
import 'package:bounding_box/bounding_box_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that provides a bounding box with resize and rotate handles.
/// It allows users to drag, resize, and rotate the widget within a full-screen overlay.
class BoundingBoxOverlay extends StatefulWidget {
  const BoundingBoxOverlay({
    super.key,
    required this.builder,
    required this.controller,
    this.onTap,
  });

  /// Builder for the content widget inside the bounding box.
  final Widget Function(Size size, Offset position, double rotation) builder;

  final BoundingBoxController? controller;

  final void Function()? onTap;

  @override
  State<BoundingBoxOverlay> createState() => _BoundingBoxOverlayState();
}

class _BoundingBoxOverlayState extends State<BoundingBoxOverlay> {
  late BoundingBoxController _controller;

  Offset? rotateStart;
  Offset? dragStart;
  Offset? dragBase;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller!;
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Offset get center =>
      _controller.position +
      Offset(_controller.size.width / 2, _controller.size.height / 2);

  List<Offset> getHandlePositions() {
    final w = _controller.size.width;
    final h = _controller.size.height;
    final localPoints = [
      Offset(0, 0),
      Offset(w / 2, 0),
      Offset(w, 0),
      Offset(0, h / 2),
      Offset(w, h / 2),
      Offset(0, h),
      Offset(w / 2, h),
      Offset(w, h),
    ];
    return localPoints.map((local) {
      final rotated = _rotate(
        local - Offset(w / 2, h / 2),
        _controller.rotation,
      );
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
    final dx = details.delta.dx;
    final dy = details.delta.dy;
    double newW = _controller.size.width;
    double newH = _controller.size.height;
    Offset newPos = _controller.position;

    switch (index) {
      case 0:
        newW -= dx;
        newH -= dy;
        newPos += Offset(dx, dy);
        break;
      case 1:
        newH -= dy;
        newPos += Offset(0, dy);
        break;
      case 2:
        newW += dx;
        newH -= dy;
        newPos += Offset(0, dy);
        break;
      case 3:
        newW -= dx;
        newPos += Offset(dx, 0);
        break;
      case 4:
        newW += dx;
        break;
      case 5:
        newW -= dx;
        newH += dy;
        newPos += Offset(dx, 0);
        break;
      case 6:
        newH += dy;
        break;
      case 7:
        newW += dx;
        newH += dy;
        break;
    }

    setState(() {
      _controller.update(
        newPosition: newPos,
        newSize: Size(max(30, newW), max(30, newH)),
      );
    });
  }

  SystemMouseCursor _mouseSizeTranslation(int index) {
    switch (index) {
      case 0: // Top-Left
        return SystemMouseCursors.resizeUpLeftDownRight;
      case 1: // Top-Center
        return SystemMouseCursors.resizeUpDown;
      case 2: // Top-Right
        return SystemMouseCursors.resizeUpRightDownLeft;
      case 3: // Center-Left
        return SystemMouseCursors.resizeLeftRight;
      case 4: // Center-Right
        return SystemMouseCursors.resizeLeftRight;
      case 5: // Bottom-Left
        return SystemMouseCursors.resizeUpRightDownLeft;
      case 6: // Bottom-Center
        return SystemMouseCursors.resizeUpDown;
      case 7: // Bottom-Right
        return SystemMouseCursors.resizeUpLeftDownRight;
      default:
        return SystemMouseCursors.basic;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();

    super.dispose();
  }

  void _onRotateStart(DragStartDetails details) {
    rotateStart = details.globalPosition;
  }

  Size calculateRotatedSize(Size originalSize, double rotation) {
    final width = originalSize.width;
    final height = originalSize.height;

    final rotatedWidth =
        (width * cos(rotation)).abs() + (height * sin(rotation)).abs();
    final rotatedHeight =
        (width * sin(rotation)).abs() + (height * cos(rotation)).abs();

    return Size(rotatedWidth, rotatedHeight);
  }

  void _onRotateUpdate(DragUpdateDetails details) {
    if (rotateStart == null) return;
    final prev = rotateStart!;
    final curr = details.globalPosition;
    final a = atan2(prev.dy - center.dy, prev.dx - center.dx);
    final b = atan2(curr.dy - center.dy, curr.dx - center.dx);
    setState(() {
      // _controller.rotation += b - a;
      _controller.update(newRotation: _controller.rotation += b - a);
      rotateStart = curr;
    });
  }

  List actionWidget() {
    return [
      if (_controller.enableRotate == true) ...[
        MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: GestureDetector(
            onPanStart: _onRotateStart,
            onPanUpdate: _onRotateUpdate,
            onTap: widget.onTap,
            child:
                _controller.customHandleRotate ??
                Container(
                  width: widget.controller?.actionSize ?? defaultActionSize,
                  height: widget.controller?.actionSize ?? defaultActionSize,
                  decoration: BoxDecoration(
                    color:
                        _controller.handleRotateBackgroundColor ?? Colors.white,
                    border: Border.all(
                      color: _controller.handleRotateStrokeColor ?? Colors.blue,
                      width: _controller.handleRotateStrokeWidth ?? 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child:
                        _controller.rotateIcon ??
                        const Icon(
                          Icons.rotate_right,
                          size: 12,
                          color: Colors.blue,
                        ),
                  ),
                ),
          ),
        ),
      ],
      if (_controller.enableMove == true) ...[
        SizedBox(width: 5),
        MouseRegion(
          cursor: SystemMouseCursors.move,
          child: GestureDetector(
            onPanStart: (d) {
              dragStart = d.globalPosition;
              dragBase = _controller.position;
            },
            onPanUpdate: (d) {
              if (dragStart == null || dragBase == null) return;
              setState(() {
                _controller.update(
                  newPosition: dragBase! + (d.globalPosition - dragStart!),
                );
              });
            },
            child:
                _controller.customHandleMove ??
                Container(
                  width: widget.controller?.actionSize ?? defaultActionSize,
                  height: widget.controller?.actionSize ?? defaultActionSize,
                  decoration: BoxDecoration(
                    color:
                        _controller.handleMoveBackgroundColor ?? Colors.white,
                    border: Border.all(
                      color: _controller.handleMoveStrokeColor ?? Colors.blue,
                      width: _controller.handleMoveStrokeWidth ?? 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child:
                        _controller.moveIcon ??
                        const Icon(
                          Icons.drag_indicator_rounded,
                          size: 12,
                          color: Colors.blue,
                        ),
                  ),
                ),
          ),
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final handles = getHandlePositions();
    final actionSize = widget.controller?.actionSize ?? defaultActionSize;

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Draggable content with corrected drag logic
          Positioned(
            left: _controller.position.dx,
            top: _controller.position.dy,
            child: Transform.rotate(
              angle: _controller.rotation,
              child: GestureDetector(
                onPanStart: (d) {
                  if (widget.onTap != null) widget.onTap!();
                  dragStart = d.globalPosition;
                  dragBase = _controller.position;
                },
                onPanUpdate: (d) {
                  if (dragStart == null || dragBase == null) return;
                  setState(() {
                    _controller.update(
                      newPosition: dragBase! + (d.globalPosition - dragStart!),
                    );
                  });
                },
                onTap: widget.onTap,
                child: widget.builder(
                  _controller.size,
                  _controller.position,
                  _controller.rotation,
                ),
              ),
            ),
          ),

          if (_controller.enable) ...[
            // Border overlay can't catch gesture
            Positioned(
              left: _controller.position.dx,
              top: _controller.position.dy,
              child: IgnorePointer(
                ignoring: true,
                child: Transform.rotate(
                  angle: _controller.rotation,
                  alignment: Alignment.center,
                  child: Container(
                    width: _controller.size.width,
                    height: _controller.size.height,
                    decoration:
                        _controller.customDecoration ??
                        BoxDecoration(
                          border: Border.all(
                            color: _controller.strokeColor ?? Colors.blue,
                            width: _controller.strokeWidth ?? 2,
                          ),
                        ),
                  ),
                ),
              ),
            ),

            // Resize handles
            for (int i = 0; i < handles.length; i++)
              Positioned(
                left: handles[i].dx - actionSize / 2,
                top: handles[i].dy - actionSize / 2,
                child: MouseRegion(
                  cursor: _mouseSizeTranslation(i),
                  child: GestureDetector(
                    onPanUpdate: (d) => _resizeFromHandle(i, d),
                    child:
                        _controller.customHandleResize ??
                        Container(
                          width: actionSize,
                          height: actionSize,
                          decoration: BoxDecoration(
                            color:
                                _controller.handleResizeBackgroundColor ??
                                Colors.white,
                            border: Border.all(
                              color:
                                  _controller.handleResizeStrokeColor ??
                                  Colors.blue,
                              width: _controller.handleResizeStrokeWidth ?? 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                  ),
                ),
              ),

            // Rotate handle
            Positioned(
              left:
                  center.dx -
                  ((_controller.enableRotate == true ? actionSize : 0) +
                          (_controller.enableMove == true
                              ? actionSize + 5
                              : 0)) /
                      2,
              top:
                  center.dy -
                  _controller.size.height / 2 -
                  (_controller.handlePosition ?? 40),
              child: Row(children: [...actionWidget()]),
            ),
          ],
        ],
      ),
    );
  }
}
