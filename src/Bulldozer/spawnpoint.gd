extends Sprite2D
@onready var area_2d = $Area2D

signal chosen(pos : Vector2)

func _on_area_2d_input_event(_viewport : Node, event : InputEvent, _shape_idx : int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		chosen.emit(area_2d.global_position)
		print('clicked')
