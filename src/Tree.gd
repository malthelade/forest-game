extends Node2D

var Health = 100
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	



func _on_area_2d_area_entered(area):
	timer.start()





func _on_timer_timeout():
	Health -= 50
