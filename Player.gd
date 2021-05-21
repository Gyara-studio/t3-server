extends Node

var room = null
var id: int
var is_me: bool = false
var player_name: String = "Unknown"

func _ready():
    pass

func is_gameing() -> bool:
    if room != null:
        return true
    return false

func join(room_id: int) -> bool:
    # panic when already in a room
    if is_gameing():
        return false
    room = room_id
    return true

func game_stop(msg: String) -> void:
    room = null
    rpc_id(id, "game_stop", msg)

func game_start(first: bool, another_player: String) -> void:
    is_me = first
    rpc_id(id, "game_start", first, another_player)

func reponse(po: String) -> bool:
    if rpc_id(id, "reponse", po):
        is_me = true
        return true
    else:
        return false

remote func move(po) -> bool:
    if room == null:
        return false
    if is_me == false:
        return false
    is_me = false
    return get_node("/root/Rooms/" + str(room)).move(po)

remote func game_end():
    get_node("/root/Rooms/" + str(room)).end()

remote func set_player_name(name: String):
    player_name = name
