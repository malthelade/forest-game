extends Node2D

@onready var bulldozer = $Bulldozer
@onready var hys = $Hys


# Called when the node enters the scene tree for the first time.
func _ready():
	bulldozer.move_target = hys.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


