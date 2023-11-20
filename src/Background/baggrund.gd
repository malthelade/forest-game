extends Node2D

@onready var bulldozer = load("res://Bulldozer/bulldozer.tscn")
@onready var house = $House
@onready var spawner = $MultiplayerSpawner





# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group('bulldozer', 'set_move_target', house.position)
	var attack = load("res://attacker_ui.tscn").instantiate()
	var defend = load("res://defender_ui.tscn").instantiate()
	if GameManager.Players[multiplayer.get_unique_id()]['team'] == 'b':
		get_tree().root.add_child(attack)
		var bullbutton = attack.get_node('BulldozeButton')
		bullbutton.button_down.connect(_on_bulldoze_button_button_down)
	else:
		get_tree().root.add_child(defend)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_bulldoze_button_button_down():
	spawn_bulldozer.rpc()

@rpc("any_peer", "call_local")
func spawn_bulldozer():
	$SpawnRoot.add_child(bulldozer.instantiate())
