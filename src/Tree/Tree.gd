extends Sprite2D


var Health : int = 100
@onready var timer = $Timer
signal tree_clicked(pos : Vector2)
@onready var area_2d = $Area2D
@onready var tree_die = $Tree_die




#decreases health and checks if the house is dead and if it is dead it queue_free and deletes it
func _on_timer_timeout():
	Health -= 5
	if Health <= 0:
		no_health.rpc()
	if Health == 50:
		tree_die.play()

	#if the area the tree has entered is in the group bulldozer it will start a timer
func _on_area_2d_area_entered(area):
	if area.is_in_group("bulldozer"):
		timer.start()

func _on_area_2d_area_exited(area):
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

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tree_clicked.emit(global_position)
		print("clicked")
		
	


