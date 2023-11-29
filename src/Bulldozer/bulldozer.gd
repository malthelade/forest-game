extends Node2D

var speed = 250
@export var move_target = Vector2.ZERO
var move = true
var baggrund = 1152.0
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if position.x > baggrund/2:
		sprite.flip_h = true

	if move == true:
		position += (move_target-position)/speed

func _on_area_2d_area_entered(area):
	if area.is_in_group("tree"):
		move = false
	if area.is_in_group("house"):
		move = false
	if area.is_in_group("rocket"):
		queue_free()



func _on_area_2d_area_exited(area):
	if area.is_in_group("tree"):
		move = true

func set_move_target(pos:Vector2):
	move_target = pos

