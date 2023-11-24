extends Area2D

var Health = 100
@onready var timer = $Timer
@onready var fire_timer = $Timer_Fire


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
#decreases health and checks if the house is dead and if it is dead it queue_free and deletes it
func _on_timer_timeout():
	Health -= 5
	if Health <= 0:
		no_health.rpc()
		
	
func on_fire():
	pass
	
	#if the area the tree has entered is in the group bulldozer it will start a timer
func _on_area_entered(area):
	if area.is_in_group("bulldozer"):
		timer.start()
		



@rpc("any_peer","call_local")
func no_health():
	queue_free()


func _on_area_exited(area):
	if area.is_in_group("bulldozer"):
		timer.stop()
		
