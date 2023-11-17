extends Node2D


@export var Health = 100
@onready var timer = $Timer
@onready var sprite =$Area2D/Sprite2D
@onready var area = $Area2D
@onready var fire_timer = $Timer_Fire


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Health <= 0:
		
		queue_free()


func _on_area_2d_area_entered(area):
	timer.start()
	if area.is_in_group("bulldozer"):
		timer.start()
		





func _on_timer_timeout():
	Health -= 20
	if Health <= 0:
		queue_free()
	
	
	
	
func on_fire():
	pass
	
	



