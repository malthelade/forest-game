extends Node2D

var Health = 100
@onready var timer = $Timer
@onready var sprite =$Area2D/Sprite2D
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Health <= 0:
		sprite.visible = not sprite.visible
		area.monitorable = not area.monitorable
		area.moniterng = not area.monitering
		#Delete or make tree invisible and turn off hitbox/monitering of collision with other areas



func _on_area_2d_area_entered(area):
	timer.start()





func _on_timer_timeout():
	Health -= 50
