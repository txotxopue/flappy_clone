# Pipe.gd

extends StaticBody2D

onready var right = get_node("Right")
onready var camera = Utils.get_main_node().get_node("Camera")

func _ready():
    add_to_group(Game.GROUP_PIPES)
    pass

func _process(delta):
    if camera == null: return

    if right.global_position.x <= camera.get_total_position().x:
        queue_free()
    pass
