extends Node2D

@onready var bulldozer = load("res://Bulldozer/bulldozer.tscn")
@onready var house = $House
@onready var spawner = $MultiplayerSpawner
@onready var bullcursor = load("res://Bulldozer/BulldozerCursor.png")
@onready var firecursor = load("res://ildcursor.png")
@onready var rocketscene = load("res://Dynamit/rocket.tscn")
@onready var rocketcursor = load("res://Dynamit/rocket-cross.png")
@onready var firescene = load("res://Fire/fire.tscn")
@onready var attack = load("res://attacker_ui.tscn").instantiate()
@onready var defend = load("res://defender_ui.tscn").instantiate()
@onready var music = $BackgroundMusic
@onready var winscreen = $Winscreen
@onready var lossscreen = $Loss
var allowBullSpawn = false
var allowRocketSpawn = false
var allowFireSpawn = false
var allowFireStop = false



# Called when the node enters the scene tree for the first time.
func _ready():
	var spawns = [$Spawnpoint, $Spawnpoint2, $Spawnpoint3, $Spawnpoint4]
	var trees = [$Tree, $Tree2, $Tree3, $Tree4, $Tree5, $Tree6, $Tree7, $Tree8]
	if GameManager.Players[multiplayer.get_unique_id()]['team'] == 'b':
		add_child(attack)
		var bullbutton = attack.get_node('BulldozeButton')
		bullbutton.button_down.connect(_on_bulldoze_button_button_down)
		var firebutton = attack.get_node('FireButton')
		firebutton.button_down.connect(_on_fire_button_button_down)
	else:
		add_child(defend)
		var rocketbutton = defend.get_node('RocketButton')
		rocketbutton.button_down.connect(_on_rocket_button_button_down)
		var exbutton = defend.get_node('FireExButton')
		exbutton.button_down.connect(_on_fire_ex_button_button_down)
	for s in spawns:
		s.chosen.connect(_on_spawn_point_chosen)
	for s in trees:
		s.tree_clicked.connect(_on_tree_clicked)
		
		music.play()


func _on_bulldoze_button_button_down():
	allowBullSpawn = true
	Input.set_custom_mouse_cursor(bullcursor, 0, Vector2(49,29.5))
	
func _on_fire_ex_button_button_down():
	allowFireStop = true

func _on_fire_button_button_down():
	allowFireSpawn = true
	Input.set_custom_mouse_cursor(firecursor, 0, Vector2(22.5,29.5))

func _on_spawn_point_chosen(pos):
	if allowBullSpawn: 
		spawn_bulldozer.rpc(pos)
	
@rpc("any_peer", "call_local")
func spawn_fire(tree_node_name : String):
	var fire = firescene.instantiate()
	var tree = get_node(tree_node_name)
	fire.position.y -= 50
	tree.add_child(fire, true)
	tree.ignite_fire()
	Input.set_custom_mouse_cursor(null)
	allowFireSpawn = false
	
func _on_tree_clicked(tree_node_name : String):
	if allowFireSpawn:
		spawn_fire.rpc(tree_node_name)
	var tree = get_node(tree_node_name)
	if tree.on_fire and allowFireStop:
		tree.kill_fire.rpc()
		allowFireStop = false

@rpc("any_peer", "call_local")
func spawn_bulldozer(pos):
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
		end.texture = load("res://win-loss-screens/corpoman wins-2.png")
		winscreen.play()
	else:
		end.texture = load("res://win-loss-screens/bamse taber.png")
		lossscreen.play()
	get_parent().add_child(end)
