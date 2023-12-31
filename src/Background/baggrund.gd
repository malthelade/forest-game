extends Node2D

@onready var bulldozer = load("res://Bulldozer/bulldozer.tscn")
@onready var house = $House
@onready var spawner = $MultiplayerSpawner
@onready var bullcursor = load("res://Bulldozer/BulldozerCursor.png")
@onready var rocketscene = load("res://Dynamit/rocket.tscn")
@onready var rocketcursor = load("res://Dynamit/rocket-cross.png")
@onready var attack = load("res://attacker_ui.tscn").instantiate()
@onready var defend = load("res://defender_ui.tscn").instantiate()
var allowBullSpawn = false
var allowRocketSpawn = false



# Called when the node enters the scene tree for the first time.
func _ready():
	var spawns = [$Spawnpoint, $Spawnpoint2, $Spawnpoint3, $Spawnpoint4]
	if GameManager.Players[multiplayer.get_unique_id()]['team'] == 'b':
		add_child(attack)
		var bullbutton = attack.get_node('BulldozeButton')
		bullbutton.button_down.connect(_on_bulldoze_button_button_down)
	else:
		add_child(defend)
		var rocketbutton = defend.get_node('RocketButton')
		rocketbutton.button_down.connect(_on_rocket_button_button_down)
	
	for s in spawns:
		s.chosen.connect(_on_spawn_point_chosen)


func _on_bulldoze_button_button_down():
	allowBullSpawn = true
	Input.set_custom_mouse_cursor(bullcursor)

@rpc("any_peer", "call_local")
func _on_spawn_point_chosen(pos):
	if allowBullSpawn: 
		var bull = bulldozer.instantiate()
		bull.position = pos
		$SpawnRoot.add_child(bull, true)
		get_tree().call_group('bulldozer', 'set_move_target', house.position)
		Input.set_custom_mouse_cursor(null)
		allowBullSpawn = false

func _on_rocket_button_button_down():
	allowRocketSpawn = true
	Input.set_custom_mouse_cursor(rocketcursor)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if allowRocketSpawn:
			var mouse_pos = get_viewport().get_mouse_position()
			Input.set_custom_mouse_cursor(null)
			rocket_direction_chosen.rpc(mouse_pos)

@rpc("call_local", "any_peer")
func rocket_direction_chosen(direction : Vector2):
	var rocket = rocketscene.instantiate()
	rocket.position = house.global_position
	$SpawnRoot.add_child(rocket, true)
	rocket.fly_to_target(rocket.position.direction_to(direction))
	allowRocketSpawn = false





func _on_house_gameover():
	var end = load("res://win-loss-screens/win_loss_screen.tscn").instantiate()
	if GameManager.Players[multiplayer.get_unique_id()]['team'] == 'b':
		end.texture = load("res://win-loss-screens/bamse taber.png")
	else:
		end.texture = load("res://win-loss-screens/corpoman wins-2.png")
	get_parent().add_child(end)
