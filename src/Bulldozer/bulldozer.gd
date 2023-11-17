extends Node2D

var speed = 250
@export var move_target = Vector2.ZERO
var move = true
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move == true:
		position += (move_target-position)/speed



func _on_area_2d_area_entered(area):
	
	if area.is_in_group("tree"):
		move = false
	
	
func _on_area_2d_area_exited(area):
	
	if area.is_in_group("tree"):
		move = true
	
	
