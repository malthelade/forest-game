extends Area2D
@onready var timer = $Timer
var entered = true
var eksplosion = preload("res://Dynamit/eksplosion.tscn").instantiate()
@onready var sprite = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered == true:
		position.y += 2
	
	
func _on_area_entered(area):
	if area.is_in_group("bulldozer"):
		entered = false
		sprite.hide()
		add_child(eksplosion)
		timer.start()





func _on_timer_timeout():
	queue_free()
