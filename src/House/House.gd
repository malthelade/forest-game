extends Area2D

var Health = 250
@onready var timer = $Timer

signal gameover

#When the timer stops the house will lose health
func _on_timer_timeout():
	Health -= 10
	if Health <= 0:
		no_health.rpc()

func _on_area_entered(area):
	if area.is_in_group("bulldozer"):
		timer.start()
		

@rpc("any_peer","call_local")
func no_health():
	gameover.emit()
	queue_free()
