// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bounding_box_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoundingBoxController _$BoundingBoxControllerFromJson(
  Map<String, dynamic> json,
) => BoundingBoxController(
  position: const OffsetConverter().fromJson(
    json['position'] as Map<String, dynamic>,
  ),
  size: const SizeConverter().fromJson(json['size'] as Map<String, dynamic>),
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
  enable: json['enable'] as bool? ?? false,
  enableRotate: json['enable_rotate'] as bool? ?? true,
  enableMove: json['enable_move'] as bool? ?? true,
  handleResizeSize: (json['handle_resize_size'] as num?)?.toDouble(),
  handleRotateSize: (json['handle_rotate_size'] as num?)?.toDouble(),
  handleMoveSize: (json['handle_move_size'] as num?)?.toDouble(),
  handleResizeBackgroundColor: const ColorConverter().fromJson(
    (json['handle_resize_background_color'] as num?)?.toInt(),
  ),
  handleResizeStrokeColor: const ColorConverter().fromJson(
    (json['handle_resize_stroke_color'] as num?)?.toInt(),
  ),
  handleRotateBackgroundColor: const ColorConverter().fromJson(
    (json['handle_rotate_background_color'] as num?)?.toInt(),
  ),
  handleRotateStrokeColor: const ColorConverter().fromJson(
    (json['handle_rotate_stroke_color'] as num?)?.toInt(),
  ),
  handleMoveBackgroundColor: const ColorConverter().fromJson(
    (json['handle_move_background_color'] as num?)?.toInt(),
  ),
  handleMoveStrokeColor: const ColorConverter().fromJson(
    (json['handle_move_stroke_color'] as num?)?.toInt(),
  ),
  strokeColor: const ColorConverter().fromJson(
    (json['stroke_color'] as num?)?.toInt(),
  ),
  strokeWidth: (json['stroke_width'] as num?)?.toDouble(),
  handleResizeStrokeWidth:
      (json['handle_resize_stroke_width'] as num?)?.toDouble(),
  handleRotateStrokeWidth:
      (json['handle_rotate_stroke_width'] as num?)?.toDouble(),
  handleMoveStrokeWidth: (json['handle_move_stroke_width'] as num?)?.toDouble(),
  handlePosition: (json['handle_position'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BoundingBoxControllerToJson(
  BoundingBoxController instance,
) => <String, dynamic>{
  'position': const OffsetConverter().toJson(instance.position),
  'size': const SizeConverter().toJson(instance.size),
  'rotation': instance.rotation,
  'enable': instance.enable,
  'enable_rotate': instance.enableRotate,
  'enable_move': instance.enableMove,
  'handle_resize_size': instance.handleResizeSize,
  'handle_rotate_size': instance.handleRotateSize,
  'handle_move_size': instance.handleMoveSize,
  'handle_resize_background_color': const ColorConverter().toJson(
    instance.handleResizeBackgroundColor,
  ),
  'handle_resize_stroke_color': const ColorConverter().toJson(
    instance.handleResizeStrokeColor,
  ),
  'handle_rotate_background_color': const ColorConverter().toJson(
    instance.handleRotateBackgroundColor,
  ),
  'handle_rotate_stroke_color': const ColorConverter().toJson(
    instance.handleRotateStrokeColor,
  ),
  'handle_move_background_color': const ColorConverter().toJson(
    instance.handleMoveBackgroundColor,
  ),
  'handle_move_stroke_color': const ColorConverter().toJson(
    instance.handleMoveStrokeColor,
  ),
  'stroke_color': const ColorConverter().toJson(instance.strokeColor),
  'stroke_width': instance.strokeWidth,
  'handle_resize_stroke_width': instance.handleResizeStrokeWidth,
  'handle_rotate_stroke_width': instance.handleRotateStrokeWidth,
  'handle_move_stroke_width': instance.handleMoveStrokeWidth,
  'handle_position': instance.handlePosition,
};
