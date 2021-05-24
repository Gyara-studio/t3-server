extends Node

var players: Array = []
enum Status {Started, Waiting}
var status: int = Status.Waiting
var room_name: String
var now: int

func join(player_id: int) -> bool:
    if len(players) >= 2:
        return false
    players.push_back(player_id)
    if len(players) == 2:
        start_game()
    return true

func leave(player: int) -> void:
    # there is only one player in room
    # so if he/she leave, room should be destroyed
    if status == Status.Waiting:
        $".".queue_free()
    else:
        # gameing
        # should notice another player to quit
        var pos_x: int = players.find(player)
        if pos_x != -1:
            players.remove((pos_x))
        var another = players[0]
        get_node("/root/Players/" + str(another)).game_stop("Another player leave the game")

var end_count = 0
func end():
    end_count += 1
    if end_count == 2:
        $".".queue_free()

var rng = RandomNumberGenerator.new()
func decide_first():
    rng.randomize()
    now = rng.randi_range(0, 1)

func get_now() -> int:
    return players[now]

func flip_now() -> int:
    if now == 0:
        now = 1
    else:
        now = 0
    return get_now()

func start_game():
    status = Status.Started
    decide_first()
    for i in range(0, 2):
        var player = players[i]
        var another_player = get_node("/root/Players" + str(players[1-i])).player_name
        get_node("/root/Players/" + str(player)).start_game(player == get_now(), another_player)

func move(po: String) -> bool:
    var next: int = flip_now()
    return get_node("/root/Players/" + str(next)).resonse(po)

func _ready():
    pass
