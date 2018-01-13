# Camera2D.gd

extends Camera2D

onready var bird = Utils.get_main_node().get_node("Bird") # onready assigns the reference when the scene is loaded.

func _ready():
    # You can make the assignation of bird here too.
    # bird = get_node("../Bird")
    pass

func _physics_process(delta):
    position = Vector2(bird.position.x, position.y)
    pass

func get_total_position():
    return global_position + offset
    pass