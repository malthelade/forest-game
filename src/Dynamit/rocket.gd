extends Node2D
@onready var timer = $Timer
var eksplosion = load("res://Dynamit/explosion3.png")
@onready var sprite = $Sprite2D
var speed = 10
var flying = false
var fly_direction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if flying:
		position += fly_direction*speed
		rotation = fly_direction.angle()

func _on_area_2d_area_entered(area):
	if area.is_in_group("bulldozer"):
		$Area2D.set_deferred("monitorable", false)
		$Area2D.set_deferred("monitoring", false)
		flying = false
		sprite.scale = Vector2(0.5,0.5)
		sprite.texture = eksplosion
		timer.start()

func _on_timer_timeout():
	queue_free()

func fly_to_target(direction):
	fly_direction = direction
	flying = true
