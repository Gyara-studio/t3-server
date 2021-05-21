extends Node

var PORT: int = 5000
const MAX_PLAYERS: int = 200
var _ok
var game_count: int = 0

func new_game_id() -> int:
    game_count += 1
    return game_count

func _ready():
    var env_port = OS.get_environment("PORT")
    if env_port != "":
        PORT = int(env_port)
    var server = NetworkedMultiplayerENet.new()
    server.create_server(PORT, MAX_PLAYERS)
    get_tree().set_network_peer(server)
    _ok = get_tree().connect("network_peer_connected", self, "on_client_connected"   )
    _ok = get_tree().connect("network_peer_disconnected", self, "on_client_disconnected")

const Player = preload("res://Player.tscn")
func on_client_connected(id: int) -> void:
    print("Player ", str(id), " connected")
    var player = Player.instance()
    player.set_name(str(id))
    player.id = id
    $Players.add_child(player)

func on_client_disconnected(id: int) -> void:
    var player = get_node("Players/" + str(id))
    if player.is_gaming():
        # clean game
        var room: int = player.room
        get_node("/root/Rooms/" + str(room)).leave(room)
        pass
    player.queue_free()

const Room = preload("res://Room.tscn")
func new_game_room(create_player: int) -> int:
    var id: int = new_game_id()
    var room := Room.instance()
    room.set_name(str(id))
    room.join(create_player)
    get_node("/room/Players/" + str(create_player)).join(id)
    $Rooms.add_child(room)
    return id
