extends Control

@export var address : String
@export var port = 8910
var peer 
var team_a = 0
var team_b = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Kaldes på både server og client
func peer_connected(id):
	print('Player Connected ' + str(id))

# Kaldes på både server og client
func peer_disconnected(id):
	print('Player Disconnected ' + str(id))

# Kaldes på client
func connected_to_server():
	print('Connected to server!')
	SendPlayerInformation.rpc_id(1, $NameLineEdit.text, multiplayer.get_unique_id())

# Kaldes på client
func connection_failed():
	print('Connection failed')

@rpc("any_peer")
func SendPlayerInformation(playname, id):
	if !GameManager.Players.has(id):
		var team = assign_team()
		GameManager.Players[id] ={
			"name" : playname,
			"id" : id,
			"score" : 0,
			"team" : team,
			
		}
	if multiplayer.is_server():
		
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
			
		
	
	$PlayerList.clear()
	for i in GameManager.Players:
		$PlayerList.add_item(GameManager.Players[i].name)
	
	

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Background/Level.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()



func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print('cannot host: ' + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	@warning_ignore("int_as_enum_without_cast")
	address = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	$IPlabel.text = address
	print('Waiting For Players')
	SendPlayerInformation($NameLineEdit.text, multiplayer.get_unique_id())
	

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client($IPLineEdit.text, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	

func _on_start_game_button_down():
	StartGame.rpc()

func assign_team():
	if team_a >= team_b:
		team_b += 1
		return 'b'
	else:
		team_a += 1
		return 'a'
