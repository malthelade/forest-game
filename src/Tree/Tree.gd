extends Area2D


var Health : int = 100
@onready var timer = $Timer

#decreases health and checks if the house is dead and if it is dead it queue_free and deletes it
func _on_timer_timeout():
	Health -= 5
	if Health <= 0:
		no_health.rpc()

	#if the area the tree has entered is in the group bulldozer it will start a timer
func _on_area_entered(area):
	if area.is_in_group("bulldozer"):
		timer.start()

func _on_area_exited(area):
	if area.is_in_group("bulldozer"):
		timer.stop()

@rpc("any_peer","call_local")
func no_health():
	queue_free()
