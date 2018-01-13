# SpawnPipe.gd

extends Node2D

const scn_pipe = preload("res://prefabs/Pipe.tscn")
const PIPE_WIDTH          = 26
const OFFSET_Y            = 55
const GROUND_HEIGHT       = 56
const OFFSET_X            = 65
const AMOUNT_TO_FILL_VIEW = 3

func _ready():
    var bird = Utils.get_main_node().get_node("Bird")
    if bird:
        bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)
    pass

func _on_bird_state_changed(bird):
    if bird.get_state() == bird.STATE_FLAPPING:
        start()
    pass

func start():
    go_init_position()
    for i in range(AMOUNT_TO_FILL_VIEW):
        spawn_and_move()
    pass

func go_init_position():
    randomize() # Changes the seed. Otherwise, calls to rand_range with the same parameters will output the same number.

    var init_position = Vector2()
    init_position.x = get_viewport_rect().size.x + PIPE_WIDTH/2
    var top_threshold = 0 + OFFSET_Y
    var bottom_threshold = get_viewport_rect().size.y - GROUND_HEIGHT - OFFSET_Y
    init_position.y = rand_range(top_threshold, bottom_threshold)

    var camera = Utils.get_main_node().get_node("Camera")
    if camera:
        init_position.x += camera.get_total_position().x

    position = init_position
    pass

func spawn_and_move():
    spawn_pipe()
    go_next_position()
    pass

func spawn_pipe():
    var new_pipe = scn_pipe.instance()
    new_pipe.position = position
    new_pipe.connect("tree_exited", self, "spawn_and_move")
    get_node("Container").add_child(new_pipe)
    pass

func go_next_position():
    randomize() # Changes the seed. Otherwise, calls to rand_range with the same parameters will output the same number.

    var next_position = position
    next_position.x += PIPE_WIDTH/2 + OFFSET_X + PIPE_WIDTH/2
    var top_threshold = 0 + OFFSET_Y
    var bottom_threshold = get_viewport_rect().size.y - GROUND_HEIGHT - OFFSET_Y
    next_position.y = rand_range(top_threshold, bottom_threshold)
    position = next_position
    pass