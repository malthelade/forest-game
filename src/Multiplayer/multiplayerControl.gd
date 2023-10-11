extends Control

@export var address = '127.0.0.1'
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Kaldes på både server og client
func peer_connected(id):
	print('Player Connected ' + str(id))

# Kaldes på både server og client
func peer_disconnected(id):
	print('Player Disconnected ' + str(id))

# Kaldes på client
func connected_to_server():
	print('Connected to server!')

# Kaldes på client
func connection_failed():
	print('Connection failed')

@rpc("any_peer", "call_local")

func StartGame():
	var scene = load("res://Tree.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print('cannot host: ' + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print('Waiting For Players')
	pass


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass


func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.
