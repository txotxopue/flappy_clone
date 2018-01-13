# Ground.gd

extends StaticBody2D

onready var bottom_right = get_node("BottomRight")
onready var camera = Utils.get_main_node().get_node("Camera")

#signal destroyed # We actually don't need this signal because "exit_tree" signal is emitted automatically.

func _ready():
    add_to_group(Game.GROUP_GROUNDS)
    pass

func _process(delta):
    if camera == null: return

    if bottom_right.global_position.x <= camera.get_total_position().x:
        queue_free() # Deletes the ground. FIXME: Try to use a pool of grounds instead.
#        emit_signal("destroyed")
    pass