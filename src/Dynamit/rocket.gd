extends Node2D
@onready var timer = $Timer
var entered = true
var eksplosion = preload("res://Dynamit/eksplosion.tscn").instantiate()
@onready var sprite = $Sprite2D
var speed = 10
var flying = false
var fly_direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		position += fly_direction*speed
		rotation = fly_direction.angle()

func _on_area_2d_area_entered(area):
	if area.is_in_group("bulldozer"):
		entered = false
		sprite.hide()
		add_child(eksplosion)
		timer.start()

func _on_timer_timeout():
	queue_free()

func fly_to_target(direction):
	fly_direction = direction
	flying = true
