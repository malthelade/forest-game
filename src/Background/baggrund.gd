extends Node2D

@onready var bulldozer = load("res://Bulldozer/bulldozer.tscn")
@onready var house = $House
@onready var spawner = $MultiplayerSpawner
@onready var bullcursor = load("res://Bulldozer/BulldozerCursor.png")
var allowBullSpawn = false



# Called when the node enters the scene tree for the first time.
func _ready():
	var spawns = [$Spawnpoint, $Spawnpoint2, $Spawnpoint3, $Spawnpoint4]
	var attack = load("res://attacker_ui.tscn").instantiate()
	var defend = load("res://defender_ui.tscn").instantiate()
	if GameManager.Players[multiplayer.get_unique_id()]['team'] == 'b':
		get_tree().root.add_child(attack)
		var bullbutton = attack.get_node('BulldozeButton')
		bullbutton.button_down.connect(_on_bulldoze_button_button_down)
	else:
		get_tree().root.add_child(defend)
	
	for s in spawns:
		s.chosen.connect(_on_spawn_point_chosen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_bulldoze_button_button_down():
	allowBullSpawn = true
	Input.set_custom_mouse_cursor(bullcursor)

@rpc("any_peer", "call_local")
func spawn_bulldozer():
	pass

@rpc("any_peer", "call_local")
func _on_spawn_point_chosen(pos):
	if allowBullSpawn: 
		var bull = bulldozer.instantiate()
		bull.position = pos
		$SpawnRoot.add_child(bull, true)
		get_tree().call_group('bulldozer', 'set_move_target', house.position)
		Input.set_custom_mouse_cursor(null)
		allowBullSpawn = false
