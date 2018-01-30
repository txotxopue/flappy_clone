# StageManager.gd

extends CanvasLayer

const STAGE_GAME = "res://scenes/Game.tscn"
const STAGE_MENU = "res://scenes/MainMenu.tscn"

var is_changing = false

signal stage_changed

func _ready():
    pass

func change_stage(stage_path):
    if is_changing: return

    # Set a flag to ignore further calls to this function.
    # Also disable user input while we perform the reload.
    is_changing = true
    get_tree().get_root().set_disable_input(true)

    # Fade to black.
    get_node("AnimationPlayer").play("fade_in")
    AudioPlayer.play_stream(AudioPlayer.SWOOSHING_STREAM)
    yield(get_node("AnimationPlayer"), "animation_finished")

    # Change stage.
    get_tree().change_scene(stage_path)
    emit_signal("stage_changed")

    # Fade from black.
    get_node("AnimationPlayer").play("fade_out")
    yield(get_node("AnimationPlayer"), "animation_finished")

    # Unset the flag, and reenable user input.
    is_changing = false
    get_tree().get_root().set_disable_input(false)
    pass