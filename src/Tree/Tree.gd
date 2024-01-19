extends Area2D


var Health : int = 100
@onready var timer = $Timer
signal tree_clicked(pos : Vector2)
@onready var area_2d = $Tree



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

func on_fire():
	$FireTimer.start()



func _on_fire_timer_timeout():
	Health -= 2.5
	if Health <=0:
		no_health.rpc()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tree_clicked.emit(area_2d.global_position)
		print("clicked")
	
