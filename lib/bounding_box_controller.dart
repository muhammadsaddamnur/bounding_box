import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bounding_box_controller.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BoundingBoxController extends ChangeNotifier with EquatableMixin {
  // Core properties
  @OffsetConverter()
  Offset position;
  @SizeConverter()
  Size size;
  double rotation;
  bool enable;

  // Handles and customization
  bool? enableRotate;
  bool? enableMove;
  double? handleResizeSize;
  double? handleRotateSize;
  double? handleMoveSize;

  // Colors
  @ColorConverter()
  Color? handleResizeBackgroundColor;
  @ColorConverter()
  Color? handleResizeStrokeColor;
  @ColorConverter()
  Color? handleRotateBackgroundColor;
  @ColorConverter()
  Color? handleRotateStrokeColor;
  @ColorConverter()
  Color? handleMoveBackgroundColor;
  @ColorConverter()
  Color? handleMoveStrokeColor;
  @ColorConverter()
  Color? strokeColor;

  // Stroke widths
  double? strokeWidth;
  double? handleResizeStrokeWidth;
  double? handleRotateStrokeWidth;
  double? handleMoveStrokeWidth;

  // Custom widgets
  @JsonKey(includeToJson: false, includeFromJson: false)
  Widget? rotateIcon;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Widget? moveIcon;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Widget? customHandleResize;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Widget? customHandleRotate;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Widget? customHandleMove;

  // Decoration
  double? handlePosition;
  @JsonKey(includeToJson: false, includeFromJson: false)
  BoxDecoration? customDecoration;

  BoundingBoxController({
    required this.position,
    required this.size,
    this.rotation = 0,
    this.enable = false,
    this.enableRotate = true,
    this.enableMove = true,
    this.handleResizeSize,
    this.handleRotateSize,
    this.handleMoveSize,
    this.handleResizeBackgroundColor,
    this.handleResizeStrokeColor,
    this.handleRotateBackgroundColor,
    this.handleRotateStrokeColor,
    this.handleMoveBackgroundColor,
    this.handleMoveStrokeColor,
    this.strokeColor,
    this.strokeWidth,
    this.handleResizeStrokeWidth,
    this.handleRotateStrokeWidth,
    this.handleMoveStrokeWidth,
    this.rotateIcon,
    this.moveIcon,
    this.customHandleResize,
    this.customHandleRotate,
    this.customHandleMove,
    this.handlePosition,
    this.customDecoration,
  });

  /// Update any property
  void update({
    Offset? newPosition,
    Size? newSize,
    double? newRotation,
    bool? newEnable,
    bool? newEnableRotate,
    bool? newEnableMove,
    double? newHandleResizeSize,
    double? newHandleRotateSize,
    double? newHandleMoveSize,
    Color? newHandleResizeBackgroundColor,
    Color? newHandleResizeStrokeColor,
    Color? newHandleRotateBackgroundColor,
    Color? newHandleRotateStrokeColor,
    Color? newHandleMoveBackgroundColor,
    Color? newHandleMoveStrokeColor,
    Color? newStrokeColor,
    double? newStrokeWidth,
    double? newHandleResizeStrokeWidth,
    double? newHandleRotateStrokeWidth,
    double? newHandleMoveStrokeWidth,
    Widget? newRotateIcon,
    Widget? newMoveIcon,
    Widget? newCustomHandleResize,
    Widget? newCustomHandleRotate,
    Widget? newCustomHandleMove,
    double? newHandlePosition,
    BoxDecoration? newCustomDecoration,
  }) {
    bool changed = false;

    if (newPosition != null && newPosition != position) {
      position = newPosition;
      changed = true;
    }
    if (newSize != null && newSize != size) {
      size = newSize;
      changed = true;
    }
    if (newRotation != null && newRotation != rotation) {
      rotation = newRotation;
      changed = true;
    }
    if (newEnable != null && newEnable != enable) {
      enable = newEnable;
      changed = true;
    }
    if (newEnableRotate != null && newEnableRotate != enableRotate) {
      enableRotate = newEnableRotate;
      changed = true;
    }
    if (newEnableMove != null && newEnableMove != enableMove) {
      enableMove = newEnableMove;
      changed = true;
    }
    if (newHandleResizeSize != null &&
        newHandleResizeSize != handleResizeSize) {
      handleResizeSize = newHandleResizeSize;
      changed = true;
    }
    if (newHandleRotateSize != null &&
        newHandleRotateSize != handleRotateSize) {
      handleRotateSize = newHandleRotateSize;
      changed = true;
    }
    if (newHandleMoveSize != null && newHandleMoveSize != handleMoveSize) {
      handleMoveSize = newHandleMoveSize;
      changed = true;
    }
    if (newHandleResizeBackgroundColor != null &&
        newHandleResizeBackgroundColor != handleResizeBackgroundColor) {
      handleResizeBackgroundColor = newHandleResizeBackgroundColor;
      changed = true;
    }
    if (newHandleResizeStrokeColor != null &&
        newHandleResizeStrokeColor != handleResizeStrokeColor) {
      handleResizeStrokeColor = newHandleResizeStrokeColor;
      changed = true;
    }
    if (newHandleRotateBackgroundColor != null &&
        newHandleRotateBackgroundColor != handleRotateBackgroundColor) {
      handleRotateBackgroundColor = newHandleRotateBackgroundColor;
      changed = true;
    }
    if (newHandleRotateStrokeColor != null &&
        newHandleRotateStrokeColor != handleRotateStrokeColor) {
      handleRotateStrokeColor = newHandleRotateStrokeColor;
      changed = true;
    }
    if (newHandleMoveBackgroundColor != null &&
        newHandleMoveBackgroundColor != handleMoveBackgroundColor) {
      handleMoveBackgroundColor = newHandleMoveBackgroundColor;
      changed = true;
    }
    if (newHandleMoveStrokeColor != null &&
        newHandleMoveStrokeColor != handleMoveStrokeColor) {
      handleMoveStrokeColor = newHandleMoveStrokeColor;
      changed = true;
    }
    if (newStrokeColor != null && newStrokeColor != strokeColor) {
      strokeColor = newStrokeColor;
      changed = true;
    }
    if (newStrokeWidth != null && newStrokeWidth != strokeWidth) {
      strokeWidth = newStrokeWidth;
      changed = true;
    }
    if (newHandleResizeStrokeWidth != null &&
        newHandleResizeStrokeWidth != handleResizeStrokeWidth) {
      handleResizeStrokeWidth = newHandleResizeStrokeWidth;
      changed = true;
    }
    if (newHandleRotateStrokeWidth != null &&
        newHandleRotateStrokeWidth != handleRotateStrokeWidth) {
      handleRotateStrokeWidth = newHandleRotateStrokeWidth;
      changed = true;
    }
    if (newHandleMoveStrokeWidth != null &&
        newHandleMoveStrokeWidth != handleMoveStrokeWidth) {
      handleMoveStrokeWidth = newHandleMoveStrokeWidth;
      changed = true;
    }
    if (newRotateIcon != null && newRotateIcon != rotateIcon) {
      rotateIcon = newRotateIcon;
      changed = true;
    }
    if (newMoveIcon != null && newMoveIcon != moveIcon) {
      moveIcon = newMoveIcon;
      changed = true;
    }
    if (newCustomHandleResize != null &&
        newCustomHandleResize != customHandleResize) {
      customHandleResize = newCustomHandleResize;
      changed = true;
    }
    if (newCustomHandleRotate != null &&
        newCustomHandleRotate != customHandleRotate) {
      customHandleRotate = newCustomHandleRotate;
      changed = true;
    }
    if (newCustomHandleMove != null &&
        newCustomHandleMove != customHandleMove) {
      customHandleMove = newCustomHandleMove;
      changed = true;
    }
    if (newHandlePosition != null && newHandlePosition != handlePosition) {
      handlePosition = newHandlePosition;
      changed = true;
    }
    if (newCustomDecoration != null &&
        newCustomDecoration != customDecoration) {
      customDecoration = newCustomDecoration;
      changed = true;
    }

    if (changed) notifyListeners();
  }

  // Add toJson and fromJson methods
  factory BoundingBoxController.fromJson(Map<String, dynamic> json) =>
      _$BoundingBoxControllerFromJson(json);

  Map<String, dynamic> toJson() => _$BoundingBoxControllerToJson(this);

  @override
  List<Object?> get props => [
    position,
    size,
    rotation,
    enable,
    enableRotate,
    enableMove,
    handleResizeSize,
    handleRotateSize,
    handleMoveSize,
    handleResizeBackgroundColor,
    handleResizeStrokeColor,
    handleRotateBackgroundColor,
    handleRotateStrokeColor,
    handleMoveBackgroundColor,
    handleMoveStrokeColor,
    strokeColor,
    strokeWidth,
    handleResizeStrokeWidth,
    handleRotateStrokeWidth,
    handleMoveStrokeWidth,
    handlePosition,
  ];
}

class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      (json['dx'] as num).toDouble(),
      (json['dy'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset object) => {
    'dx': object.dx,
    'dy': object.dy,
  };
}

class SizeConverter implements JsonConverter<Size, Map<String, dynamic>> {
  const SizeConverter();

  @override
  Size fromJson(Map<String, dynamic> json) {
    return Size(
      (json['width'] as num).toDouble(),
      (json['height'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Size object) => {
    'width': object.width,
    'height': object.height,
  };
}

class ColorConverter implements JsonConverter<Color?, int?> {
  const ColorConverter();

  @override
  Color? fromJson(int? json) => json == null ? null : Color(json);

  @override
  int? toJson(Color? object) => object?.toARGB32();
}
